
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
import us.kbase.common.service.Tuple4;


/**
 * <p>Original spec-file type: find_similar_modelseed_reactions_results</p>
 * 
 * 
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("com.googlecode.jsonschema2pojo")
@JsonPropertyOrder({
    "similar_reactions",
    "report_name",
    "report_ref"
})
public class FindSimilarModelseedReactionsResults {

    @JsonProperty("similar_reactions")
    private List<Tuple4 <String, String, Double, Double>> similarReactions;
    @JsonProperty("report_name")
    private java.lang.String reportName;
    @JsonProperty("report_ref")
    private java.lang.String reportRef;
    private Map<java.lang.String, Object> additionalProperties = new HashMap<java.lang.String, Object>();

    @JsonProperty("similar_reactions")
    public List<Tuple4 <String, String, Double, Double>> getSimilarReactions() {
        return similarReactions;
    }

    @JsonProperty("similar_reactions")
    public void setSimilarReactions(List<Tuple4 <String, String, Double, Double>> similarReactions) {
        this.similarReactions = similarReactions;
    }

    public FindSimilarModelseedReactionsResults withSimilarReactions(List<Tuple4 <String, String, Double, Double>> similarReactions) {
        this.similarReactions = similarReactions;
        return this;
    }

    @JsonProperty("report_name")
    public java.lang.String getReportName() {
        return reportName;
    }

    @JsonProperty("report_name")
    public void setReportName(java.lang.String reportName) {
        this.reportName = reportName;
    }

    public FindSimilarModelseedReactionsResults withReportName(java.lang.String reportName) {
        this.reportName = reportName;
        return this;
    }

    @JsonProperty("report_ref")
    public java.lang.String getReportRef() {
        return reportRef;
    }

    @JsonProperty("report_ref")
    public void setReportRef(java.lang.String reportRef) {
        this.reportRef = reportRef;
    }

    public FindSimilarModelseedReactionsResults withReportRef(java.lang.String reportRef) {
        this.reportRef = reportRef;
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
        return ((((((((("FindSimilarModelseedReactionsResults"+" [similarReactions=")+ similarReactions)+", reportName=")+ reportName)+", reportRef=")+ reportRef)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
