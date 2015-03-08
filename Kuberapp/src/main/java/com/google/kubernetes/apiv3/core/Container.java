package com.google.kubernetes.apiv3.core;

import javax.annotation.Generated;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Generated("org.jsonschema2pojo")
public class Container {

    public String name;
    public String image;
    public Integer cpu;
    public List<String> command = new ArrayList<String>();
    List<Port> ports = new ArrayList<Port>();

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
    public List<String> getCommand() {
        return command;
    }

    /**
     *
     * @param command
     * The command
     */
    public void setCommand(List<String> command) {
        this.command = command;
    }

}