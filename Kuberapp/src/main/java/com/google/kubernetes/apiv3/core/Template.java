package com.google.kubernetes.apiv3.core;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by jayunit100 on 3/4/15.
 */
public class Template {

    private Metadata metadata;
    private TemplateSpec podSpec;
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

    public Container findContainer(String cname) {
        if(this.getTmplSpec()==null || this.getTmplSpec().containers.length==0)
            throw new RuntimeException();
        for(Container c : this.getTmplSpec().containers){
            if(c.getName().equals(cname)){
                return c;
            }
        }
        throw new RuntimeException("Couldnt find container  " + cname + ".  If you're trying to create a service.");
    }

    /**
     *
     * @return
     * The spec
     */
    public TemplateSpec getTmplSpec() {
        return podSpec;
    }

    /**
     *
     * @param podSpec
     * The spec
     */
    public void setPodSpec(TemplateSpec podSpec) {
        this.podSpec = podSpec;
    }

    public Map<String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    public void setAdditionalProperty(String name, Object value) {
        this.additionalProperties.put(name, value);
    }

}
