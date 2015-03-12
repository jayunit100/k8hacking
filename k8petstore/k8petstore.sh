MAKE SURE YOU HAVE A FILE rhnpassword which has your rhn password in it on the first line!
Fratyobavcue1-
echo "WRITING KUBE FILES , will overwrite the jsons, then testing pods. is kube clean ready to go?"

PUBLIC_IP="127.0.0.1" # ip which we use to access the Web server.
SECONDS=1000          # number of seconds to measure throughput.
FE="1"                # amount of Web server  
LG="1"                # amount of load generators
SLAVE="1"             # amount of redis slaves 

function create { 

cat << EOF > fe-rc.json
{
  "id": "fectrl",
  "kind": "ReplicationController",
  "apiVersion": "v1beta1",
  "desiredState": {
    "replicas": $FE,
    "replicaSelector": {"name": "frontend"},
    "podTemplate": {
      "desiredState": {
         "manifest": {
           "version": "v1beta1",
           "id": "frontendCcontroller",
           "containers": [{
             "name": "frontend-go-restapi",
             "image": "jayunit100/k8petstore",
           }]
         }
       },
       "labels": {
         "name": "frontend",
         "uses": "redis-master"
       }
      }},
  "labels": {"name": "frontend"}
}
EOF

cat << EOF > bps-load-gen-rc.json
{
  "id": "bpsloadgenrc",
  "kind": "ReplicationController",
  "apiVersion": "v1beta1",
  "desiredState": {
    "replicas": $LG,
    "replicaSelector": {"name": "bps"},
    "podTemplate": {
      "desiredState": {
         "manifest": {
           "version": "v1beta1",
           "id": "bpsLoadGenController",
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
  "labels": {"name": "bpsLoadGenController"}
}
EOF

cat << EOF > fe-s.json
{
  "id": "frontend",
  "kind": "Service",
  "apiVersion": "v1beta1",
  "port": 3000,
  "containerPort": 3000,
  "publicIPs":["$PUBLIC_IP","$PUBLIC_IP2", "10.1.4.89","127.0.0.1","10.1.4.82"],
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
  "id": "redismaster",
  "kind": "Pod",
  "apiVersion": "v1beta1",
  "desiredState": {
    "manifest": {
      "version": "v1beta1",
      "id": "redismaster",
      "containers": [{
        "name": "master",
        "image": "jayunit100/guestbook-redis-master",
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
  "id": "redismaster",
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
  "id": "redissc",
  "kind": "ReplicationController",
  "apiVersion": "v1beta1",
  "desiredState": {
    "replicas": $SLAVE,
    "replicaSelector": {"name": "redisslave"},
    "podTemplate": {
      "desiredState": {
         "manifest": {
           "version": "v1beta1",
           "id": "redissc",
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
}

function test { 
	pass_http=0

	### Test HTTP Server comes up.
	for i in `seq 1 150`;
	do
	    ### Just testing that the front end comes up.  Not sure how to test total entries etc... (yet)
	    echo "Trying curl ... $i . expect a few failures while pulling images... " 
	    curl "$PUBLIC_IP:3000" > result
	    cat result
	    cat result | grep -q "k8-bps"
	    if [ $? -eq 0 ]; then
		echo "TEST PASSED after $i tries !"
		i=1000
		break
	    else	
		echo "the above RESULT didn't contain target string for trial $i"
	    fi
	    sleep 5
	done

	if [ $i -eq 1000 ]; then
	   pass_http=-1
	fi

	pass_load=0 

	### Print statistics of db size, every second, until $SECONDS are up.
	for i in `seq 1 $SECONDS`;
	do
	    echo "$i `curl \"$PUBLIC_IP:3000/llen\"`"
	    sleep 1
	done
}

# create
test
