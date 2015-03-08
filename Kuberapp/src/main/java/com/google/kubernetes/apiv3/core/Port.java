package com.google.kubernetes.apiv3.core;

/**
 * Created by jayunit100 on 3/4/15.
 */
public class Port {
    int containerPort;
    ServiceSpec.PROTOCOL protocol;

    public Port(int c, ServiceSpec.PROTOCOL p){
        containerPort=c;
        protocol=p;
    }
}
