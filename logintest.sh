#!/bin/bash
#dos2unix *.sh

read -p "Please input the project environment[30QA/30QAold/30staging/30prod/teststaging]?" ENVIRONMENT
if [ -z ${ENVIRONMENT} ];then
	echo "The project environment cannot be null"
	exit 1
fi
arr=(30QA 30QAold 30staging 30prod teststaging)
if
	echo ${arr[@]} | grep -wq ${ENVIRONMENT}
then
    echo "" >/dev/null
else
    echo "invalid environment"
	exit 1
fi

source /scripts/logintest/ip.sh $ENVIRONMENT

build_number_ui=$(ssh -o StrictHostKeyChecking=no root@$IP "cd /media/sf_src/app-ui && git branch | grep '^*' | awk '{printf \$2}'")
echo "branch of app-ui: $build_number_ui"
build_number_core=$(ssh -o StrictHostKeyChecking=no root@$IP "cd /media/sf_src/app-core && git branch | grep '^*' | awk '{printf \$2}'")
echo "branch of app-core: $build_number_core"

if [ "$build_number_ui" == "$build_number_core" ]; then

    ssh -o StrictHostKeyChecking=no root@10.137.160.104 "cd /jmeter/apache-jmeter-3.1/bin && ./jmeter -n -t $CASE -l $ENVIRONMENT.csv"

    if curl -s -A Chrome/55.0.2883.87 -D /tmp/logintest -o /tmp/logintestcontent "$URL"
    then
	    sleep 5
	    RETURN=$(grep "HTTP" /tmp/logintest | awk '{printf $2}')
	    if [ $RETURN -ne 200 ]
	    then
	        rm -f /tmp/logintest /tmp/logintestcontent
	        echo "Login test output error(curl access fail)"
	    else
            if
                ssh -o StrictHostKeyChecking=no root@10.137.160.104 "grep -niw "false" /jmeter/apache-jmeter-3.1/bin/$ENVIRONMENT.csv"
                #grep -niw "false" /tmp/logintest
            then
	            echo "Login test output error(jmeter test fail)"
                ssh -o StrictHostKeyChecking=no root@10.137.160.104 "rm /jmeter/apache-jmeter-3.1/bin/$ENVIRONMENT.csv"
                rm /tmp/logintest /tmp/logintestcontent
            else
	            echo "Login test success"
                ssh -o StrictHostKeyChecking=no root@10.137.160.104 "rm /jmeter/apache-jmeter-3.1/bin/$ENVIRONMENT.csv"
                rm /tmp/logintest /tmp/logintestcontent
            fi
        fi
    else
        echo "Login test output error(curl access fail)"
        rm /tmp/logintest
    fi
else
    echo "Login test output error(Build number doesn't match)"
fi