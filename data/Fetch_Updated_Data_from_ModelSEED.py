#!/usr/bin/env python
from urllib.request import urlopen
import sys,json

MSD_git_url = "https://raw.githubusercontent.com/ModelSEED/ModelSEEDDatabase/"
MSD_commit = "v1.0"

remote_file = urlopen(MSD_git_url+MSD_commit+"/Biochemistry/compounds.json")
compounds = json.load(remote_file)

with open("Compounds.json",'w') as local_file:
    json.dump(compounds, local_file, indent=4, sort_keys=True)

remote_file = urlopen(MSD_git_url+MSD_commit+"/Biochemistry/reactions.json")
reactions = json.load(remote_file)

for reaction in reactions:
    cpd_ids = reaction['compound_ids'].split(';')
    reaction['compound_ids']=cpd_ids

with open("Reactions.json",'w') as local_file:
    json.dump(reactions, local_file, indent=4, sort_keys=True)
