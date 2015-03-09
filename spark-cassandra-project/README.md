## Deploying spark on kubernetes

*NOTE THAT TO DO THIS, YOU CANT ACTUALLY LEVERAGE KUBE SERVICES, SO THIS IS A HACK, MAKE SURE TO READ THE WHOLE DOC CAREFULLY, THE HACKAROUND FOR RUNNING SPARK ON K8 IS AT THE BOTTOM !*

This repository contains everything for deploying spark on kubernetes.  

Cassandra coming soon - if I keep this up to date.
## Spark deployment
This README file will explain whats in the scripts.  I've found that sometimes is
better than writing all the directions down, since code is often self describing, and 
docs go stale so fast.
## setup and reproducing your own version of the docker containers
This step is optional if you want to build docker images from scratch, to learn how it works. 

The dockerimages curated by me (jayunit100/spark...) work well and dont need modification. 

First, build the base docker image.  This image has java and nothing else installed.

First, run ``` setup.sh. ```  Read that script to see what its doing.  

It builds a base docker container and pulls down spark and cassandra tarballs. 

Then, build the spark container 

```docker build -t spark100 ./spark```

This action will create a locally stored docker image.  Now you will need to push it to dockerhub... ```docker push yourname/spark100```.  

At that point, you can replace the "image" names  in the kubernetes yaml and json files with your own.

## time to launch the containers 
Note that if you *really* want to run spark jobs, this won't work unless DNS is working.  If you want to run jobs for real, go to the bottom of this doc where we have a workaround to run in service-less mode.  This allows for static IP on the master.

Okay ! now lets launch these guys in kubernetes.

First, take a look at the yaml and json files.  Each describes either a *pod* a *service* or a *replicatoinController*.  

If you don't understand the difference between these, then read the guestbook example on https://github.com/GoogleCloudPlatform/kubernetes/tree/master/examples/guestbook . 

To run this stuff, now, you will want to launch , in this order, masters and slaves.---

- launch the spark master pod
- launch the spark master service 
- launch the spark slave controller 
- launch the spark slave service (note  im not sure this is really even required yet).

This is done for you in the kube-deploy.sh script.

## finally... clean up!

Once your done ( you should seelots of running spark slaves !), you can kill everything off like this.

```kubectl delete -f ./spark-slave-controller.json```

```kubectl delete -f spark-master-pod.yaml ```

```kubectl delete -f spark-master-service.json ```

== fancy one liner to kill all pods. ==

```for line in $(kubectl get pods | grep 1 | cut -d' ' -f 1 | grep 1); do kubectl delete pod $line ; done;```

## Hackaround for running w/o master service

note: *ip* command is not necessary here, its just for debugging.

```docker run -e HOSTNAME=192.168.20.78 -e SPARK_LOCAL_IP=192.168.20.78 -e SPARK_LOCAL_DNS=192.168.20.78 -t -i jayunit100/spark7 /bin/bash -c "ip addr && cat /etc/hosts | grep -v 192 > /etc/hosts2 && cat /etc/hosts2 > /etc/hosts && env && /opt/spark-1.2.0-bin-hadoop2.4/sbin/start-master.sh -i 192.168.20.76 && tailf /opt/spark-1.2.0-bin-hadoop2.4/logs/*"```

*Explanation*

1) Eliminate any possibility of spark trying to use a hostname (eliminate the HOSTNAME variable, kill /etc/hosts entries)  
2) Set Environment vars for SPARK_LOCAL_IP and SPARK_LOCAL_DNS to be the exact IP of running container (this can be automated w/ cut in ip addr).
3) start up spark with a hardcoded ip address (note either -i or -ip may work, will see how they differ).

After this, b/c The docker containers in k8 are all on a shared 192 subnet, they all see each other, and can join the master. To test the jobs, u just do a docker exec like this:  And reference the masters port...

```docker exec -t -i 832204f7da04 /bin/bash /opt/spark-1.2.0-bin-hadoop2.4/bin/spark-submit --class org.apache.spark.examples.SparkPi --master spark://192.168.20.78:7077 /opt/spark-1.2.0-bin-hadoop2.4/lib/spark-examples-1.2.0-hadoop2.4.0.jar 10 ```

## Thats it! 
Contact jay@apache.org for questions.
