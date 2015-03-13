#K8PetStore version is tied to the redis version.  We will add more info to version tag later.
version="r.2.8.19"
docker build -t jayunit100/redis:$version ./redis/
docker build -t jayunit100/redis-master:$version ./redis-master
docker build -t jayunit100/redis-slave:$version ./redis-slave
docker build -t jayunit100/k8petstore:$version ./redis-slave

docker push jayunit100/k8petstore:$version
docker push jayunit100/redis:$version
docker push jayunit100/redis-master:$version
docker push jayunit100/redis-slave:$version
