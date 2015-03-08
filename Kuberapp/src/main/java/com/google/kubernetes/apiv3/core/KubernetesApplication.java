package com.google.kubernetes.apiv3.core;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by jayunit100 on 3/4/15.
 */
public abstract class KubernetesApplication {

    static final String API = "v1apibeta3";

    public abstract Map<Service, ReplicationController> replicationControllerList();
}
