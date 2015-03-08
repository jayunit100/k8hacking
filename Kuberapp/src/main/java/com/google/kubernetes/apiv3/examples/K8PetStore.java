package com.google.kubernetes.apiv3.examples;

import com.google.kubernetes.apiv3.core.KubernetesApplication;
import com.google.kubernetes.apiv3.core.ReplicationController;
import com.google.kubernetes.apiv3.core.Service;

import java.util.HashMap;
import java.util.Map;

/**
 * An example of a strongly typed
 * constructor for a kubernetes application.
 */
public class K8PetStore extends KubernetesApplication {

    public K8PetStore(){
        super();
    }

    /**
     * Service and Replication controllers are all that is going to be output.
     * @return
     */
    @Override
    public Map<Service, ReplicationController> replicationControllerList() {
        final Map<Service,ReplicationController> srp = new HashMap<Service, ReplicationController>();

        Service redisMaster = new Service();
        Service redisSlave = new Service();
        Service redis = new Service();


        return srp;
    }
}
