#!/bin/sh
# Cleans up directories from previous workflows.
# Submits a new set of workflows using the standard workflow manager client.
# Must be execute on a host running a workflow manager container.

# identify the first worker container
wrkr_ids=`docker ps | grep oodt-wmgr | awk '{print $1}' | awk '{print $1}'`
wrkr_id=`echo $wrkr_ids | awk '{print $1;}'`
echo $wrkr_id

# clean up shared directories
docker exec -it $wrkr_id sh -c "rm -rf /usr/local/oodt/pges/test-workflow/jobs/*"
docker exec -it $wrkr_id ls -l /usr/local/oodt/pges/test-workflow/jobs

NJOBS=10
for ((i=1;i<=NJOBS;i++)); do
   # submit workflow $i
   echo "Submitting workflow # $i"
   docker exec -it $wrkr_id sh -c "cd /usr/local/oodt/cas-workflow/bin; ./wmgr-client --url http://oodt-wmgr:9001 --operation --sendEvent --eventName test-workflow --metaData --key Dataset abc --key Project 123 --key Run $i"
done
