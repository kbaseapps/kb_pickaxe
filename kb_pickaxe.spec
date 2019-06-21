/*
A KBase module: kb_picaxe
This method wraps the PicAxe tool.
*/

module kb_pickaxe {
    /*
        A string representing a model id.
    */

    typedef string model_id;

    /*
        A string representing a workspace name.
    */

    typedef string workspace_name;

    typedef structure {
        string compound_id;
        string compound_name;
    }EachCompound;

    typedef structure {
        workspace_name workspace;
        model_id model_id;
        string model_ref;
        string rule_set;
        int generations;
        string prune;
        int add_transport;
        model_id out_model_id;
        list <EachCompound> compounds;
    } RunPickAxe;

    typedef structure {
        string model_ref;
    }  PickAxeResults;
	
	typedef structure {
        string workspace_name;
        list<string> reaction_set;
        float structural_similarity_floor;
        float difference_similarity_floor;
        float blast_score_floor;
        string query_genome_ref;
        string query_model_ref;
        string feature_set_prefix;
        int number_of_hits_to_report;
    } find_genes_for_novel_reactions_params;
    
    typedef structure {
        string report_name;
		string report_ref;
    } find_genes_for_novel_reactions_results;
    
    funcdef runpickaxe(RunPickAxe params) returns (PickAxeResults) authentication required;
    funcdef find_genes_for_novel_reactions(find_genes_for_novel_reactions_params params) returns (find_genes_for_novel_reactions_results) authentication required;
};
