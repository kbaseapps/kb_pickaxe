import binascii
import logging
from rdkit.Chem import AllChem
from rdkit.DataStructs import UIntSparseIntVect # diff
from rdkit.DataStructs import ExplicitBitVect   # stru
from rdkit.DataStructs import FingerprintSimilarity
from rdkit.DataStructs.cDataStructs import TanimotoSimilarity
from rdkit import DataStructs

logger = logging.getLogger(__name__)

def make_rxn_smarts1(stoich):
    l = []
    r = []
    for smi in stoich:
        #print(c)
        mult = int(stoich[smi])
        for i in range(abs(mult)):
            if mult < 0:
                l.append(smi)
            else:
                
                r.append(smi)
            #print(mult, c)
    return '.'.join(l) + ">>" + '.'.join(r)

def make_rxn_smarts(stoich, compounds):
    l = []
    r = []
    for c in stoich:
        if not c in compounds:
            return None
        #print(c)
        mult = int(stoich[c])
        for i in range(abs(mult)):
            if mult < 0:
                l.append(compounds[c]['smiles'])
            else:
                
                r.append(compounds[c]['smiles'])
            #print(mult, c)
    return '.'.join(l) + ">>" + '.'.join(r)

def make_fingerprints(rxn_smarts):
    rxn = AllChem.ReactionFromSmarts(rxn_smarts)
    stru_fingerprints = AllChem.CreateStructuralFingerprintForReaction(rxn)
    diff_fingerprints = AllChem.CreateDifferenceFingerprintForReaction(rxn)
    return (stru_fingerprints, diff_fingerprints)

def build_from_mongo(biochem_modelseed):
    rxn_fingerprints = {}

    for document in biochem_modelseed.find():
        #print(rxn_id)
        rxn_id = document['_id']
        #stoich = document['neutral_smiles_stoich']
        if 'diff' in document and 'stru' in document:
            #print(stoich)
            diff_bytes = document['diff']
            stru_bytes = document['stru']
            #print(len(diff_bytes), len(stru_bytes))
            #smarts = make_rxn_smarts(stoich)
            #print(smarts)
            #stru_bytes2, diff_bytes2 = make_fingerprints(smarts)
            #print(len(diff_bytes2.ToBinary()), len(stru_bytes2.ToBinary()))
            diff_fingerprints = UIntSparseIntVect(diff_bytes)
            stru_fingerprints = ExplicitBitVect(stru_bytes)
            rxn_fingerprints[rxn_id] = (stru_fingerprints, diff_fingerprints)
    
    matcher = FingerprintMatcher()
    matcher.fingerprints = rxn_fingerprints
    return matcher

class FingerprintMatcher:
    
    def __init__(self):
        self.fingerprints = {}
    
    def get_best_structural_score(self, target_fp, metric):
        scores = {}
        for rxn_id in self.fingerprints:
            stru_comp, diff_comp = self.fingerprints[rxn_id]
            score = FingerprintSimilarity(fp1=target_fp, fp2=stru_comp, metric=metric)
            scores[rxn_id] = score
        return scores
    
    def get_best_structural_score_by_id(self, target_id, metric):
        scores = {}
        target_fp, _ = self.fingerprints[target_id]
        return self.get_best_structural_score(target_fp, metric)

    def get_best_difference_score(self, target_fp, metric):
        scores = {}
        for rxn_id in self.fingerprints:
            _, comp_fp = self.fingerprints[rxn_id]
            score = TanimotoSimilarity(target_fp, comp_fp)
            #score = FingerprintSimilarity(fp1=target_fp, fp2=comp_fp, metric=metric)
            scores[rxn_id] = score
        return scores
    
    def get_best_difference_score_by_id(self, target_id, metric):
        scores = {}
        _, target_fp = self.fingerprints[target_id]
        return self.get_best_difference_score(target_fp, metric)
    
    def find_matches_by_id(self, target_id, cut):
        stru_scores = self.get_best_structural_score(target_id, DataStructs.TanimotoSimilarity)
        diff_scores = self.get_best_difference_score(target_id, DataStructs.TanimotoSimilarity)
        best_stru_scores = set()
        best_diff_scores = set()
        for rxn_id in stru_scores:
            if stru_scores[rxn_id] > cut:
                best_stru_scores.add(rxn_id)
        for rxn_id in diff_scores:
            if diff_scores[rxn_id] > cut:
                best_diff_scores.add(rxn_id)
        print('cut >', cut, 'stru', len(best_stru_scores), 'diff', len(best_diff_scores))
        both = best_stru_scores & best_diff_scores
        print('both', len(both))

        for rxn_id in both:
            if not rxn_id == target_id:
                print(rxn_id, stru_scores[rxn_id], diff_scores[rxn_id])

        return both
    
        print('target: ', target_id)
        draw_reaction(reactions.find_one({'_id' : target_id}))
        for rxn_id in (best_stru_scores & best_diff_scores):
            if not rxn_id == target_id:
                print(rxn_id, stru_scores[rxn_id], diff_scores[rxn_id])
                draw_reaction(reactions.find_one({'_id' : rxn_id}))

    def find_matches(self, stru_fp, diff_fp, cut):
        stru_scores = self.get_best_structural_score(stru_fp, DataStructs.TanimotoSimilarity)
        diff_scores = self.get_best_difference_score(diff_fp, DataStructs.TanimotoSimilarity)
        best_stru_scores = set()
        best_diff_scores = set()
        for rxn_id in stru_scores:
            if stru_scores[rxn_id] > cut:
                best_stru_scores.add(rxn_id)
        for rxn_id in diff_scores:
            if diff_scores[rxn_id] > cut:
                best_diff_scores.add(rxn_id)
        #print('cut >', cut, 'stru', len(best_stru_scores), 'diff', len(best_diff_scores))
        both = best_stru_scores & best_diff_scores
        #print('both', len(both))
        scores = {}
        stru_high = 0
        diff_high = 0
        for rxn_id in both:
            stru_score = stru_scores[rxn_id]
            diff_score = diff_scores[rxn_id]
            if stru_score > stru_high:
                stru_high = stru_score
            if diff_score > diff_high:
                diff_high = diff_score
            scores[rxn_id] = (stru_score, diff_score)

        return scores, stru_high, diff_high
    
class ReactionFingerprintMatcher:
    
    def __init__(self, ms, fp_dict = {}):
        self.ms = ms
        self.fingerprints = fp_dict
    
    def make_rxn_smarts(self, stoich):
        l = []
        r = []
        for t in stoich:
            cpd_id = t[0]
            cpd = self.ms.get_seed_compound(cpd_id)
            smiles = cpd.smiles
            if smiles == None:
                return None
            value = int(stoich[t])
            for i in range(abs(value)):
                if value < 0:
                    l.append(smiles)
                else:
                    r.append(smiles)
                #print(mult, c)
        return '.'.join(l) + ">>" + '.'.join(r)

    def make_fingerprints(rxn_smarts):
        rxn = AllChem.ReactionFromSmarts(rxn_smarts)
        stru_fingerprints = AllChem.CreateStructuralFingerprintForReaction(rxn)
        diff_fingerprints = AllChem.CreateDifferenceFingerprintForReaction(rxn)
        return (stru_fingerprints, diff_fingerprints)
    
    def get_best_structural_score(self, smarts, metric):
        scores = {}
        stru_score_high = 0
        target_fp, _ = ReactionFingerprintMatcher.make_fingerprints(smarts)
        for rxn_id in self.fingerprints:
            stru_comp, _ = self.fingerprints[rxn_id]
            score = FingerprintSimilarity(fp1=target_fp, fp2=stru_comp, metric=metric)
            scores[rxn_id] = score
            if score > stru_score_high:
                stru_score_high = score
        return scores, stru_score_high
    
    def get_best_difference_score(self, smarts, metric):
        scores = {}
        diff_score_high = 0
        _, target_fp = ReactionFingerprintMatcher.make_fingerprints(smarts)
        for rxn_id in self.fingerprints:
            _, comp_fp = self.fingerprints[rxn_id]
            score = TanimotoSimilarity(target_fp, comp_fp)
            scores[rxn_id] = score
            if score > diff_score_high:
                diff_score_high = score
        return scores, diff_score_high
    
    def match(self, smarts, cut, max_results=None):
        stru_scores, stru_score_high = self.get_best_structural_score(smarts, DataStructs.TanimotoSimilarity)
        diff_scores, diff_score_high = self.get_best_difference_score(smarts, DataStructs.TanimotoSimilarity)
        best_stru_scores = {}
        best_diff_scores = {}
        
        for rxn_id in stru_scores:
            if stru_scores[rxn_id] > cut:
                best_stru_scores[rxn_id] = stru_scores[rxn_id]
        for rxn_id in diff_scores:
            if diff_scores[rxn_id] > cut:
                best_diff_scores[rxn_id] = diff_scores[rxn_id]
        both = set(best_stru_scores) & set(best_diff_scores)
        
        logger.debug('stru: %f, diff: %f', stru_score_high, diff_score_high)
        
        logger.debug('cut > %f, stru: %d, diff: %d, both: %d', cut, len(best_stru_scores), len(best_diff_scores), len(both))

        #for rxn_id in both:
        #    print(rxn_id, best_stru_scores[rxn_id], best_diff_scores[rxn_id])

        logger.debug('smarts: %s', smarts)
        
        #draw_reaction(reactions.find_one({'_id' : target_id}))
        return self.filter_scores(best_stru_scores, best_diff_scores, cut, max_results)
    
    def filter_scores(self, stru, diff, min_score, max_results):
        both = set(stru) & set(diff)
        #print(min_score, max_results, len(both))
        rxn_score = {}
        for k in both:
            score = min(stru[k], diff[k])
            if score >= min_score:
                rxn_score[k] = min(stru[k], diff[k])
        rxn_score = sorted(((v, k) for (k, v) in rxn_score.items()), reverse=True)
        if not max_results == None and max_results > 0:
            return rxn_score[:max_results]
        return rxn_score

def hex_to_stru_fingerprints(hex_str):
    bts = binascii.unhexlify(hex_str)
    fp = ExplicitBitVect(bts)
    return fp

def hex_to_diff_fingerprints(hex_str):
    bts = binascii.unhexlify(hex_str)
    fp = UIntSparseIntVect(bts)
    return fp

def fp_dict_to_hex(fp_dict):
    fp_hex_dict = {}
    for id in fp_dict:
        stru_bytes, diff_bytes = fp_dict[id]
        fp_hex_dict[id] = (
            binascii.hexlify(stru_bytes.ToBinary()).decode('utf-8'), 
            binascii.hexlify(diff_bytes.ToBinary()).decode('utf-8'))
    return fp_hex_dict

def fp_hex_to_dict(fp_hex_dict):
    fp_dict = {}
    for id in fp_hex_dict:
        stru_hex, diff_hex = fp_hex_dict[id]
        fp_dict[id] = (
            hex_to_stru_fingerprints(stru_hex), 
            hex_to_diff_fingerprints(diff_hex))
    return fp_dict

fp_dict = None
filename = sys.argv[1]+'/data/fingerprints/modelseed_reactions.json';
with open(filename, 'r') as f:
    fp_dict = fp_hex_to_dict(json.loads(f.read()))

matcher = ReactionFingerprintMatcher(None, fp_dict)

# args: SMARTS (str), min_score (float), max_results (int)
file = open(sys.argv[2], 'r') 
lines = file.readlines()
results = {}
for line in lines:
	items = string.split()
	results[items[0]] = matcher.match(items[1],  sys.argv[4],  sys.argv[5])

outfile = open(sys.argv[3],'w')
for id in results:
	for oid in results[id]:
		print(id+"\t"+oid+"\t"+results[id][oid])
outfile.close() 