package com.google.kubernetes.apiv3;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Generated;

@Generated("org.jsonschema2pojo")
public class Container {

    public String name;
    public String image;
    public Integer cpu;
    public List<Object> command = new ArrayList<Object>();
    public Map<String, Object> additionalProperties = new HashMap<String, Object>();

    /**
     *
     * @return
     * The name
     */
    public String getName() {
        return name;
    }

    /**
     *
     * @param name
     * The name
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     *
     * @return
     * The image
     */
    public String getImage() {
        return image;
    }

    /**
     *
     * @param image
     * The image
     */
    public void setImage(String image) {
        this.image = image;
    }

    /**
     *
     * @return
     * The cpu
     */
    public Integer getCpu() {
        return cpu;
    }

    /**
     *
     * @param cpu
     * The cpu
     */
    public void setCpu(Integer cpu) {
        this.cpu = cpu;
    }

    /**
     *
     * @return
     * The command
     */
    public List<Object> getCommand() {
        return command;
    }

    /**
     *
     * @param command
     * The command
     */
    public void setCommand(List<Object> command) {
        this.command = command;
    }

    public Map<String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    public void setAdditionalProperty(String name, Object value) {
        this.additionalProperties.put(name, value);
    }
}