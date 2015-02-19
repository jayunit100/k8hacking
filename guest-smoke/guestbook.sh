o "WRITING KUBE FILES , will overwrite the jsons, then testing pods. is kube clean ready to go?"
read x

cat << EOF > fe-rc.json
{
  "id": "frontend-controller",
  "kind": "ReplicationController",
  "apiVersion": "v1beta1",
  "desiredState": {
    "replicas": 3,
    "replicaSelector": {"name": "frontend"},
    "podTemplate": {
      "desiredState": {
         "manifest": {
           "version": "v1beta1",
           "id": "frontend-controller",
           "containers": [{
             "name": "php-redis",
             "image": "kubernetes/example-guestbook-php-redis",
             "cpu": 100,
             "memory": 50000000,
             "ports": [{"containerPort": 80, "hostPort": 8000}]
           }]
         }
       },
       "labels": {
         "name": "frontend",
         "uses": "redisslave,redis-master"
       }
      }},
  "labels": {"name": "frontend"}
}
EOF

cat << EOF > fe-s.json
{
  "id": "frontend",
  "kind": "Service",
  "apiVersion": "v1beta1",
  "port": 80,
  "containerPort": 80,
  "selector": {
    "name": "frontend"
  },
  "labels": {
    "name": "frontend"
  }
}
EOF

cat << EOF > rm.json
{
  "id": "redis-master",
  "kind": "Pod",
  "apiVersion": "v1beta1",
  "desiredState": {
    "manifest": {
      "version": "v1beta1",
      "id": "redis-master",
      "containers": [{
        "name": "master",
        "image": "dockerfile/redis",
        "cpu": 100,
        "ports": [{
          "containerPort": 6379,
          "hostPort": 6379
        }]
      }]
    }
  },
  "labels": {
    "name": "redis-master"
  }
}
EOF

cat << EOF > rm-s.json
{
  "id": "redis-master",
  "kind": "Service",
  "apiVersion": "v1beta1",
  "port": 6379,
  "containerPort": 6379,
  "selector": {
    "name": "redis-master"
  },
  "labels": {
    "name": "redis-master"
  }
}
EOF

cat << EOF > rs-s.json
{
  "id": "redisslave",
  "kind": "Service",
  "apiVersion": "v1beta1",
  "port": 6379,
  "containerPort": 6379,
  "labels": {
    "name": "redisslave"
  },
  "selector": {
    "name": "redisslave"
  }
}
EOF

cat << EOF > slave-rc.json
{
  "id": "redis-slave-controller",
  "kind": "ReplicationController",
  "apiVersion": "v1beta1",
  "desiredState": {
    "replicas": 2,
    "replicaSelector": {"name": "redisslave"},
    "podTemplate": {
      "desiredState": {
         "manifest": {
           "version": "v1beta1",
           "id": "redis-slave-controller",
           "containers": [{
             "name": "slave",
             "image": "brendanburns/redis-slave",
             "cpu": 200,
             "ports": [{"containerPort": 6379, "hostPort": 6380}]
           }]
         }
      },
      "labels": {
        "name": "redisslave",
        "uses": "redis-master"
      }
    }
  },
  "labels": {"name": "redisslave"}
}
EOF

kubectl create -f rm.json 
kubectl create -f rm-s.json 
kubectl create -f slave-rc.json 
kubectl create -f rs-s.json
kubectl create -f fe-rc.json 
kubectl create -f fe-s.json 

# wait 60 seconds, this should be sufficient if containers are downloaded on the system.
sleep 60 

### Loop through and keep trying.
for ((i=1;i<=100;i++));
do
    echo "Trying curl ... $i . expect a few failures while pulling images... " 
    curl "localhost:8000/index.php?cmd=set&key=messages&value=jayunit100" > result
    cat result
    cat result | grep -q "Updated"
    if [ $? -eq 0 ]; then
        echo "TEST PASSED"
        i=1000
    fi 
    echo "RESULT $i"
    sleep 5
done

cat result

if [ $? -eq 1000 ]; then
    echo "TEST PASSED."
else
    echo "TEST FAILED"
    exit 1
fi 

### Kill the test.
kubectl delete -f rm.json 
kubectl delete -f rm-s.json 
kubectl delete -f rs-rc.json 
kubectl delete -f slave-rc.json 
kubectl delete -f rs-s.json
kubectl delete -f fe-rc.json 
kubectl delete -f fe-s.json 
