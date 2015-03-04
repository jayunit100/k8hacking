package com.google.kubernetes.apiv3;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by jayunit100 on 3/4/15.
 */
public class Template {

    private Metadata metadata;
    private PodSpec podSpec;
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    /**
     *
     * @return
     * The metadata
     */
    public Metadata getMetadata() {
        return metadata;
    }

    /**
     *
     * @param metadata
     * The metadata
     */
    public void setMetadata(Metadata metadata) {
        this.metadata = metadata;
    }

    /**
     *
     * @return
     * The spec
     */
    public PodSpec getPodSpec() {
        return podSpec;
    }

    /**
     *
     * @param podSpec
     * The spec
     */
    public void setPodSpec(PodSpec podSpec) {
        this.podSpec = podSpec;
    }

    public Map<String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    public void setAdditionalProperty(String name, Object value) {
        this.additionalProperties.put(name, value);
    }

}
