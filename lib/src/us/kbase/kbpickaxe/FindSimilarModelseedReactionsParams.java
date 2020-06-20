
package us.kbase.kbpickaxe;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Generated;
import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;


/**
 * <p>Original spec-file type: find_similar_modelseed_reactions_params</p>
 * 
 * 
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("com.googlecode.jsonschema2pojo")
@JsonPropertyOrder({
    "workspace_name",
    "reaction_set",
    "structural_similarity_floor",
    "difference_similarity_floor",
    "query_model_ref"
})
public class FindSimilarModelseedReactionsParams {

    @JsonProperty("workspace_name")
    private java.lang.String workspaceName;
    @JsonProperty("reaction_set")
    private List<String> reactionSet;
    @JsonProperty("structural_similarity_floor")
    private Double structuralSimilarityFloor;
    @JsonProperty("difference_similarity_floor")
    private Double differenceSimilarityFloor;
    @JsonProperty("query_model_ref")
    private java.lang.String queryModelRef;
    private Map<java.lang.String, Object> additionalProperties = new HashMap<java.lang.String, Object>();

    @JsonProperty("workspace_name")
    public java.lang.String getWorkspaceName() {
        return workspaceName;
    }

    @JsonProperty("workspace_name")
    public void setWorkspaceName(java.lang.String workspaceName) {
        this.workspaceName = workspaceName;
    }

    public FindSimilarModelseedReactionsParams withWorkspaceName(java.lang.String workspaceName) {
        this.workspaceName = workspaceName;
        return this;
    }

    @JsonProperty("reaction_set")
    public List<String> getReactionSet() {
        return reactionSet;
    }

    @JsonProperty("reaction_set")
    public void setReactionSet(List<String> reactionSet) {
        this.reactionSet = reactionSet;
    }

    public FindSimilarModelseedReactionsParams withReactionSet(List<String> reactionSet) {
        this.reactionSet = reactionSet;
        return this;
    }

    @JsonProperty("structural_similarity_floor")
    public Double getStructuralSimilarityFloor() {
        return structuralSimilarityFloor;
    }

    @JsonProperty("structural_similarity_floor")
    public void setStructuralSimilarityFloor(Double structuralSimilarityFloor) {
        this.structuralSimilarityFloor = structuralSimilarityFloor;
    }

    public FindSimilarModelseedReactionsParams withStructuralSimilarityFloor(Double structuralSimilarityFloor) {
        this.structuralSimilarityFloor = structuralSimilarityFloor;
        return this;
    }

    @JsonProperty("difference_similarity_floor")
    public Double getDifferenceSimilarityFloor() {
        return differenceSimilarityFloor;
    }

    @JsonProperty("difference_similarity_floor")
    public void setDifferenceSimilarityFloor(Double differenceSimilarityFloor) {
        this.differenceSimilarityFloor = differenceSimilarityFloor;
    }

    public FindSimilarModelseedReactionsParams withDifferenceSimilarityFloor(Double differenceSimilarityFloor) {
        this.differenceSimilarityFloor = differenceSimilarityFloor;
        return this;
    }

    @JsonProperty("query_model_ref")
    public java.lang.String getQueryModelRef() {
        return queryModelRef;
    }

    @JsonProperty("query_model_ref")
    public void setQueryModelRef(java.lang.String queryModelRef) {
        this.queryModelRef = queryModelRef;
    }

    public FindSimilarModelseedReactionsParams withQueryModelRef(java.lang.String queryModelRef) {
        this.queryModelRef = queryModelRef;
        return this;
    }

    @JsonAnyGetter
    public Map<java.lang.String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    @JsonAnySetter
    public void setAdditionalProperties(java.lang.String name, Object value) {
        this.additionalProperties.put(name, value);
    }

    @Override
    public java.lang.String toString() {
        return ((((((((((((("FindSimilarModelseedReactionsParams"+" [workspaceName=")+ workspaceName)+", reactionSet=")+ reactionSet)+", structuralSimilarityFloor=")+ structuralSimilarityFloor)+", differenceSimilarityFloor=")+ differenceSimilarityFloor)+", queryModelRef=")+ queryModelRef)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
