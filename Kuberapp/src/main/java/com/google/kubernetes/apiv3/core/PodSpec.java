package com.google.kubernetes.apiv3.core;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by jayunit100 on 3/4/15.
 */
public class PodSpec {

    public Integer replicas;
    public Selector selector;
    public Template template;

    public Integer getReplicas() {
        return replicas;
    }

    public void setReplicas(Integer replicas) {
        this.replicas = replicas;
    }

    public Selector getSelector() {
        return selector;
    }

    public void setSelector(Selector selector) {
        this.selector = selector;
    }

    public Template getTemplate() {
        return template;
    }

    public void setTemplate(Template template) {
        this.template = template;
    }



}

