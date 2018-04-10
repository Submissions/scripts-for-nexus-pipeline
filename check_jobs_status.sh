#!/bin/bash

log_file=$1

num_of_jobs=`cat $log_file | grep job | wc -l`
echo "number of jobs submitted:" $num_of_jobs

num_of_done=0
num_of_running=0
num_of_failed=0
num_of_waiting=0

for id in `cat $log_file | grep job`
do 
   state=`dx describe $id | grep -e "State"`

   if [[ $state == *done ]]
   then
       num_of_done=`expr $num_of_done + 1`
   elif [[ $state == *running ]]
   then
       num_of_running=`expr $num_of_running + 1`
   elif [[ $state == *failed ]]
   then
       num_of_failed=`expr $num_of_failed + 1`
   elif [[ $state == *runnable ]]
   then
       num_of_waiting=`expr $num_of_waiting + 1`
   else
       echo "unknown status:" $state
   fi

done

state_known=`expr $num_of_done + $num_of_running + $num_of_failed + $num_of_waiting`
state_unknown=`expr $num_of_jobs - $state_known`

echo "Done:" $num_of_done
echo "Running:" $num_of_running
echo "Failed:" $num_of_failed
echo "Waiting:" $num_of_waiting
echo "State unknown:" $state_unknown
