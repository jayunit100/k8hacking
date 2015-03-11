for line in $(kubectl get rc); do kubectl delete rc $line ; done

for line in $(kubectl get services); do kubectl delete service $line ; done


kubectl get pods
echo "kill all pods ???"

read x

kubectl delete pod --all
kubectl get services,pods,rc
