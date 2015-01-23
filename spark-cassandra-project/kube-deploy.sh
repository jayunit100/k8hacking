# Below we start the master pod and service first.
# Then, we start slaves, which will connect through the 
# slave proxy. 
if [ $# -eq 0 ]; then
	echo "when done, you can run -- kube-create.sh destroy --- ... "
	kubectl create -f ./spark-master-pod.yaml 
	kubectl create -f ./spark-master-service.json 
	sleep 10
	kubectl create -f ./spark-slave-controller.json 
	kubectl create -f ./spark-slave-service.json 
	kubectl get pods,services
fi 

if [ $1 = "destroy" ]; then 
	kubectl delete -f ./spark-master-pod.yaml 
	kubectl delete -f ./spark-master-service.json
	kubectl delete -f ./spark-slave-controller.json 
	kubectl delete -f ./spark-slave-service.json 
	echo "deleting pods..............................."
        for line in $(kubectl get pods | grep spark | cut -d' ' -f 1 | grep 1); do kubectl delete pod $line ; done;
fi



