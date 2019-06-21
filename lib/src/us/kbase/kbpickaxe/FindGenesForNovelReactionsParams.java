
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
 * <p>Original spec-file type: find_genes_for_novel_reactions_params</p>
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
    "blast_score_floor",
    "query_genome_ref",
    "query_model_ref",
    "feature_set_prefix",
    "number_of_hits_to_report"
})
public class FindGenesForNovelReactionsParams {

    @JsonProperty("workspace_name")
    private java.lang.String workspaceName;
    @JsonProperty("reaction_set")
    private List<String> reactionSet;
    @JsonProperty("structural_similarity_floor")
    private Double structuralSimilarityFloor;
    @JsonProperty("difference_similarity_floor")
    private Double differenceSimilarityFloor;
    @JsonProperty("blast_score_floor")
    private Double blastScoreFloor;
    @JsonProperty("query_genome_ref")
    private java.lang.String queryGenomeRef;
    @JsonProperty("query_model_ref")
    private java.lang.String queryModelRef;
    @JsonProperty("feature_set_prefix")
    private java.lang.String featureSetPrefix;
    @JsonProperty("number_of_hits_to_report")
    private Long numberOfHitsToReport;
    private Map<java.lang.String, Object> additionalProperties = new HashMap<java.lang.String, Object>();

    @JsonProperty("workspace_name")
    public java.lang.String getWorkspaceName() {
        return workspaceName;
    }

    @JsonProperty("workspace_name")
    public void setWorkspaceName(java.lang.String workspaceName) {
        this.workspaceName = workspaceName;
    }

    public FindGenesForNovelReactionsParams withWorkspaceName(java.lang.String workspaceName) {
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

    public FindGenesForNovelReactionsParams withReactionSet(List<String> reactionSet) {
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

    public FindGenesForNovelReactionsParams withStructuralSimilarityFloor(Double structuralSimilarityFloor) {
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

    public FindGenesForNovelReactionsParams withDifferenceSimilarityFloor(Double differenceSimilarityFloor) {
        this.differenceSimilarityFloor = differenceSimilarityFloor;
        return this;
    }

    @JsonProperty("blast_score_floor")
    public Double getBlastScoreFloor() {
        return blastScoreFloor;
    }

    @JsonProperty("blast_score_floor")
    public void setBlastScoreFloor(Double blastScoreFloor) {
        this.blastScoreFloor = blastScoreFloor;
    }

    public FindGenesForNovelReactionsParams withBlastScoreFloor(Double blastScoreFloor) {
        this.blastScoreFloor = blastScoreFloor;
        return this;
    }

    @JsonProperty("query_genome_ref")
    public java.lang.String getQueryGenomeRef() {
        return queryGenomeRef;
    }

    @JsonProperty("query_genome_ref")
    public void setQueryGenomeRef(java.lang.String queryGenomeRef) {
        this.queryGenomeRef = queryGenomeRef;
    }

    public FindGenesForNovelReactionsParams withQueryGenomeRef(java.lang.String queryGenomeRef) {
        this.queryGenomeRef = queryGenomeRef;
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

    public FindGenesForNovelReactionsParams withQueryModelRef(java.lang.String queryModelRef) {
        this.queryModelRef = queryModelRef;
        return this;
    }

    @JsonProperty("feature_set_prefix")
    public java.lang.String getFeatureSetPrefix() {
        return featureSetPrefix;
    }

    @JsonProperty("feature_set_prefix")
    public void setFeatureSetPrefix(java.lang.String featureSetPrefix) {
        this.featureSetPrefix = featureSetPrefix;
    }

    public FindGenesForNovelReactionsParams withFeatureSetPrefix(java.lang.String featureSetPrefix) {
        this.featureSetPrefix = featureSetPrefix;
        return this;
    }

    @JsonProperty("number_of_hits_to_report")
    public Long getNumberOfHitsToReport() {
        return numberOfHitsToReport;
    }

    @JsonProperty("number_of_hits_to_report")
    public void setNumberOfHitsToReport(Long numberOfHitsToReport) {
        this.numberOfHitsToReport = numberOfHitsToReport;
    }

    public FindGenesForNovelReactionsParams withNumberOfHitsToReport(Long numberOfHitsToReport) {
        this.numberOfHitsToReport = numberOfHitsToReport;
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
        return ((((((((((((((((((((("FindGenesForNovelReactionsParams"+" [workspaceName=")+ workspaceName)+", reactionSet=")+ reactionSet)+", structuralSimilarityFloor=")+ structuralSimilarityFloor)+", differenceSimilarityFloor=")+ differenceSimilarityFloor)+", blastScoreFloor=")+ blastScoreFloor)+", queryGenomeRef=")+ queryGenomeRef)+", queryModelRef=")+ queryModelRef)+", featureSetPrefix=")+ featureSetPrefix)+", numberOfHitsToReport=")+ numberOfHitsToReport)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
