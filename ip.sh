#/bin/bash

#Configure each environment variable
case $1 in
	"30QA")
		DTPATH=/media/sf_src
        ENVIRONMENT=$1
		IP=10.137.48.138
		CASE=login30qa.jmx
		URL="app.30qa.dealtap.ca"
		;;
	"30staging")
		DTPATH=/media/sf_src
        ENVIRONMENT=$1
		IP=10.137.48.141
		CASE=login30staging.jmx
		URL="app.30staging.dealtap.ca"
		;;
	"30prod")
		DTPATH=/media/sf_src
        ENVIRONMENT=$1
		IP=10.137.48.143
		CASE=login30prod.jmx
		URL="https://app.30prod.dealtap.ca"
		;;
	"30QAold")
		DTPATH=/media/sf_src
        ENVIRONMENT=$1
		IP=10.137.48.139
		CASE=login30qaold.jmx
		URL="app.30qaold.dealtap.ca"
	    ;;
	"teststaging")
		DTPATH=/media/sf_src
        ENVIRONMENT=$1
		IP=10.137.160.212
		CASE=loginstaging.jmx
		URL="https://app.teststaging.dealtap.ca"
	    ;;
	*)

		echo "please reset"
		;;
esac
