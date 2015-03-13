docker build -t jayunit100/redis:2.8.19 ./redis/
docker build -t jayunit100/redis-master:2.8.19 ./redis-master
docker build -t jayunit100/redis-slave:2.8.19 ./redis-slave
docker push jayunit100/redis:2.8.19
docker push jayunit100/redis-master:2.8.19
docker push jayunit100/redis-slave:2.8.19
