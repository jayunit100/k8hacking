package com.google.kubernetes.apiv3.core;

/**
 * One replication controller
 * consists of pods, containers and so on.
 *
 */
public class ReplicationController {
    public String id;
    public String kind;
    public String apiVersion;
    public Metadata metadata;
    public PodSpec podSpec;
}
