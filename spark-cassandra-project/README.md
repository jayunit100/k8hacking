== Deploying spark and cassandra on kubernetes ==

This repository contains everything for deploying spark on kubernetes.  

Cassandra coming soon - if I keep this up to date.


== Spark deployment == 

This README file will explain whats in the scripts.  I've found that sometimes is

better than writing all the directions down, since code is often self describing, and 

docs go stale so fast.


=== setup and reproducing your own version of the docker containers === 

This step is optional if you want to build docker images from scratch, to learn how it works. 

The dockerimages curated by me (jayunit100/spark...) work well and dont need modification. 

First, build the base docker image.  This image has java and nothing else installed.

First, run ``` setup.sh. ```  Read that script to see what its doing.  

It builds a base docker container and pulls down spark and cassandra tarballs. 

Then, build the spark container 

```docker build -t spark100 ./spark```

This action will create a locally stored docker image.  Now you will need to push it to dockerhub... ```docker push yourname/spark100```.  

At that point, you can replace the "image" names  in the kubernetes yaml and json files with your own.

== time to launch the containers  == 

Okay ! now lets launch these guys in kubernetes.

First, take a look at the yaml and json files.  Each describes either a *pod* a *service* or a *replicatoinController*.  

If you don't understand the difference between these, then read the guestbook example on https://github.com/GoogleCloudPlatform/kubernetes/tree/master/examples/guestbook . 

To run this stuff, now, you will want to launch , in this order, masters and slaves.

- launch the spark master pod
- launch the spark master service 
- launch the spark slave controller 
- launch the spark slave service (note  im not sure this is really even required yet).

This is done for you in the kube-deploy.sh script.

== finally... clean up! ==

Once your done ( you should seelots of running spark slaves !), you can kill everything off like this.

```kubectl delete -f ./spark-slave-controller.json```
```kubectl delete -f spark-master-pod.yaml ```
```kubectl delete -f spark-master-service.json ```
### fancy one liner to kill all pods.
```for line in $(kubectl get pods | grep 1 | cut -d' ' -f 1 | grep 1); do kubectl delete pod $line ; done;```























