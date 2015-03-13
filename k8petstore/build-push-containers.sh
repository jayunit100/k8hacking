#K8PetStore version is tied to the redis version.  We will add more info to version tag later.
version="r.2.8.19"
docker build -t jayunit100/k8-petstore-redis:$version ./redis/
docker build -t jayunit100/k8-petstore-redis-master:$version ./redis-master
docker build -t jayunit100/k8-petstore-redis-slave:$version ./redis-slave
docker build -t jayunit100/k8-petstore-web-server:$version ./web-server

docker push jayunit100/k8-petstore-redis:$version
docker push jayunit100/k8-petstore-redis-master:$version
docker push jayunit100/k8-petstore-redis-slave:$version
docker push jayunit100/k8-petstore-web-server:$version
