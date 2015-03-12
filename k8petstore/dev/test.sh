## First set up the host VM.  That ensures
## we avoid vagrant race conditions.
set -x 

cd hosts/ 
ls
#vagrant up
#echo "removing containers"
#vagrant ssh -c "sudo docker rm -f $(docker ps -a -q)"
cd ..

## Now spin up the docker containers
## these will run in the ^ host vm above.

vagrant destroy --force && vagrant up

## Finally, curl the length, it should be 3 .

x=`curl localhost:3000/llen`

if [ x$x -eq "x3" ]; then 
    echo " passed $3 "
    exit 0
else
    echo " FAIL" 
    exit 1
fi
