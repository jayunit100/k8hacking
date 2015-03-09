echo "WRITING KUBE FILES , will overwrite the jsons, then testing pods. is kube clean ready to go?"

PUBLIC_IP="10.1.4.89"

cat << EOF > fe-rc.json
{
  "id": "frontend-controller",
  "kind": "ReplicationController",
  "apiVersion": "v1beta1",
  "desiredState": {
    "replicas": 30,
    "replicaSelector": {"name": "frontend"},
    "podTemplate": {
      "desiredState": {
         "manifest": {
           "version": "v1beta1",
           "id": "frontend-controller",
           "containers": [{
             "name": "frontend-go-restapi",
             "image": "jayunit100/k8petstore",
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

cat << EOF > bps-load-gen-rc.json
{
  "id": "bps-load-gen-controller",
  "kind": "ReplicationController",
  "apiVersion": "v1beta1",
  "desiredState": {
    "replicas": 1,
    "replicaSelector": {"name": "bps"},
    "podTemplate": {
      "desiredState": {
         "manifest": {
           "version": "v1beta1",
           "id": "bps-load-gen-controller",
           "containers": [{
             "name": "bps",
             "image": "jayunit100/bigpetstore-load-generator",
             "command": ["sh","-c","/opt/PetStoreLoadGenerator-1.0/bin/PetStoreLoadGenerator http://\$FRONTEND_SERVICE_HOST:3000/rpush/guestbook/ 4 4 1000 123"]
         }]
         }
       },
       "labels": {
         "name": "bps",
         "uses": "frontend"
        }
      }},
  "labels": {"name": "bps-load-gen-controller"}
}
EOF

cat << EOF > fe-s.json
{
  "id": "frontend",
  "kind": "Service",
  "apiVersion": "v1beta1",
  "port": 3000,
  "containerPort": 3000,
  "publicIPs":["$PUBLIC_IP","10.1.4.89","127.0.0.1","10.1.4.82"],
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
        "image": "jayunit100/guestbook-redis-master",
        "cpu": 0,
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
    "replicas": 3,
    "replicaSelector": {"name": "redisslave"},
    "podTemplate": {
      "desiredState": {
         "manifest": {
           "version": "v1beta1",
           "id": "redis-slave-controller",
           "containers": [{
             "name": "slave",
             "image": "jayunit100/guestbook-redis-slave",
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
kubectl create -f rm.json --api-version=v1beta1
kubectl create -f rm-s.json --api-version=v1beta1
sleep 3 # precaution to prevent fe from spinning up too soon.
kubectl create -f slave-rc.json --api-version=v1beta1
kubectl create -f rs-s.json --api-version=v1beta1
sleep 3 # see above comment.
kubectl create -f fe-rc.json --api-version=v1beta1 
kubectl create -f fe-s.json --api-version=v1beta1
kubectl create -f bps-load-gen-rc.json --api-version=v1beta1

i=0

### New test.
python test.py

### Original test.
### Loop through and keep trying.
for i in `seq 1 150`;
do
    ### Just testing that the front end comes up.  Not sure how to test total entries etc... (yet)
    echo "Trying curl ... $i . expect a few failures while pulling images... " 
    curl "localhost:3000" > result
    cat result
    cat result | grep -q "k8-bps"
    if [ $? -eq 0 ]; then
        echo "TEST PASSED after $i tries !"
        i=1000
        exit 0
    fi 
    echo "the above RESULT didn't contain target string for trial $i"
    sleep 5
done
cat result
echo " After several [ $i ] tries, TEST FAILED !!!!!!!"
exit 1
