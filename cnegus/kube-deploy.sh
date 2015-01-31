kubectl delete rc database
kubectl delete rc web 

kubectl delete -f webserver-rc.yaml
kubectl delete -f db-rc.yaml

for line in $(kubectl get pods | grep "dbc" | cut -d' ' -f 1 | grep 1); do kubectl delete pod $line ; done; 

for line in $(kubectl get pods | grep "web" | cut -d' ' -f 1 | grep 1); do kubectl delete pod $line ; done; 

for line in $(kubectl get pods | grep "data" | cut -d' ' -f 1 | grep 1); do kubectl delete pod $line ; done; 

echo "done deleteing......."
sleep 10
echo "restart...."

kubectl create -f webserver-rc.yaml
kubectl create -f db-rc.yaml
