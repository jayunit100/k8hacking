package com.google.kubernetes.apiv3.core;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by jayunit100 on 3/4/15.
 */
public class Selector {

    public static final Map<String, Selector> ALL = new HashMap<String, Selector>();

    public Selector(){
        ALL.put(this.getName(),this);
    }

    public String name;

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


}
