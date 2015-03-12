for line in $(kubectl get rc); do kubectl delete rc $line ; done

for line in $(kubectl get services); do kubectl delete service $line ; done


kubectl get pods
echo "kill all pods ???"

read x

kubectl delete pod --all

## for older kube versions...
for line in $(kubectl get pods | grep jay | cut -d' ' -f 1);

kubectl get services,pods,rc

for line in $(kubectl get pods | grep jay | cut -d' ' -f 1); do kubectl delete pod $line ; done
kubectl get services,pods,rc
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
