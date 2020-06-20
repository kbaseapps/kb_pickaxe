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
		string report_name;
		string report_ref;
    }  PickAxeResults;
	
	typedef structure {
        workspace_name workspace;
        list<string> reaction_set;
        float structural_similarity_floor;
        float difference_similarity_floor;
        string query_model_ref;
    } find_similar_modelseed_reactions_params;
    
    typedef structure {
        list<tuple<string similar_id,string query_id,float structural_similarity,float reactive_similarity>> similar_reactions;
		string report_name;
		string report_ref;
    } find_similar_modelseed_reactions_results;
    
    funcdef runpickaxe(RunPickAxe params) returns (PickAxeResults) authentication required;
    funcdef find_similar_modelseed_reactions(find_similar_modelseed_reactions_params params) returns (find_similar_modelseed_reactions_results) authentication required;
};
