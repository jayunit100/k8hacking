echo "Starting guestbook load tests. Assumes you've already started guestbook"

function curl-guestbook {
   curl "localhost:8000/index.php?cmd=set&key=messages&value=jayunit100`date +%s%N`"
}

### 10,000 inserts into redis.
### Each should succeed, because, this test should run right after
### the original guestbook.sh script. 
failures=0
for i in `seq 1 10000`;
do curl-guestbook > result
   cat result
   cat result | grep -q "Updated"
   if [ $? -eq 0 ]; then
        blah=1
   else
        failures=$((failures+1))
        echo "FAILURES : $failures"
   fi 
   echo "RESULT $i"
   
   done

exit 0
