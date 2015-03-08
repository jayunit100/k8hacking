package com.google.kubernetes.apiv3.core;

import sun.font.GlyphLayout;

import java.awt.*;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;

/**
 * "spec":{
 *      "port":6379,
 *      "containerPort":6379,
 *      "protocol":"TCP",
 *      "selector":{
 *          "name":"redis-slave"
 *       }
 *   }
 */
public class ServiceSpec {

    enum PROTOCOL{TCP};
    /**
     * Input: The selector which this service will bind to.
     * @param selector1
     */
    public ServiceSpec(Selector selector1, Container container, int port, int containerPort, PROTOCOL p){
        if(! container.ports.contains(port)){
            System.err.println("WARNING " + container.ports + " Doesnt container the port you selected for this service!" + port);
            System.err.println("USUALLY ... this would be the same thing for simple k8 apps");
        }
        selectorMap.put("name",selector1.getName());
        protocol=p.name();
    }
    public int port, containerPort;
    public String protocol="TCP";
    public Map<String,String> selectorMap = new HashMap<String,String>();

}
