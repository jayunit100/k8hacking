package com.google.kubernetes.apiv3.core;

/**
 * Created by jayunit100 on 3/4/15.
 */
public class Service {

    String kind;
    String apiVersion;
    Metadata metadata;
    ServiceSpec spec;

    /**
     * Every service points to a replication controller by pointing to its labels.
     * @param repController
     */
    public Service(ReplicationController repController, String containerToBind ) {
        if(containerToBind==null)
            throw new RuntimeException("Need a valid container name." + containerToBind);
        String rcname = repController.metadata.getLabels().getName();
        Container cont = repController.podSpec.getTemplate().findContainer(containerToBind);
        ServiceSpec sSpec =
                new
                  ServiceSpec(
                        Selector.ALL.get(repController.metadata.labels.getName()),
                        cont,
                        cont.ports.get(0).containerPort,
                        cont.ports.get(0).containerPort,
                        ServiceSpec.PROTOCOL.TCP
                );


    }




}
