#!/bin/bash

usage="$(basename "$0")
[-help]  -- Example to show how to pass relevant arguments.
USAGE:
$(basename "$0") servername=12.299.222.155 application=testApp username=johndoe metrictemplate=metric-template-name logtemplate=log-template-name lifetimeHours=0.5 canaryAnalysisIntervalMins=30 baseline=1e8ecb994cbba canary=1e8ecb994cbba baselineStartTimeMs=1528139701000 canaryStartTimeMs=1528139701000 canaryResultScore=90 minimumCanaryScore=70"

while getopts ':hhelp:' option; do
  case "$option" in
    h) echo "$usage" ;;
    *) echo "usage: $0 [-help]" >&2
       exit 1 ;;
  esac
done
if  [ $# -eq 0 ]; then
    echo "Please pass the mandatory arguments. To know about the required arguments type option -help"
    exit 1
fi
echo "---------------------------------------------------------------------------"
echo "********** Printing Arguments and their values ****************************"
echo "---------------------------------------------------------------------------"
count=0;
for ARGUMENT in "$@"
do

    KEY=$(echo "$ARGUMENT" | cut -f1 -d=)
    VALUE=$(echo "$ARGUMENT" | cut -f2 -d=)
    count=$((count+1))
    echo $count"." $KEY"=" $VALUE
    case "$KEY" in
            servername)
               if [ -z "${VALUE}" ];then
                 echo "Value for mandatory parameter 'servername' is not specified!"
               fi
            servername=${VALUE} ;;
            application)
               if [ -z "${VALUE}" ];then
                 echo "Value for mandatory parameter 'application' name is not specified!"
               fi
            application=${VALUE} ;;
            canaryAnalysisIntervalMins)
               if [ -z "${VALUE}" ];then
                 echo "Value for mandatory parameter 'canaryAnalysisIntervalMins' is not specified!"
               fi
            canaryAnalysisIntervalMins=${VALUE} ;;
            metrictemplate)
               if [ -z "${VALUE}" ];then
                 echo "Value for mandatory parameter 'metrictemplate' is not specified!"
               fi
            metrictemplate=${VALUE};;
            logtemplate)
                if [ -z "${VALUE}" ];then
                 echo "Value for mandatory paramter 'logtemplate' is not specified!"
               fi
            logtemplate=${VALUE};;
            minimumCanaryScore)
               if [ -z "${VALUE}" ];then
                  echo "Value for optional parameter 'minimumCanaryScore' is not specified in the arguments, assigning the default value to 70!"
		  value=70
               fi
            minimumCanaryScore=${VALUE};;
            canaryResultScore)
               if [ -z "${VALUE}" ];then
                 echo "Value for optional parameter 'canaryResultScore' is not specified in the arguments, assigning the default value to 90!"
		 value=90
               fi
            canaryResultScore=${VALUE};;
            lifetimeHours)
               if [ -z "${VALUE}" ];then
                 echo "Value for mandatory parameter 'lifetimeHours' is not specified!"
               fi
            lifetimeHours=${VALUE};;
            username)
               if [ -z "${VALUE}" ];then
                 echo "Value for mandatory parameter 'username' is not specified!"
               fi
            username=${VALUE};;
            baseline)
               if [ -z "${VALUE}" ];then
                 echo "Value for mandatory parameter 'baseline' is not specified!"
               fi
            baseline=${VALUE};;
            baselineStartTimeMs)
              if [ -z "${VALUE}" ];then
                 echo "Value for mandatory parameter 'baselineStartTimeMs' is not specified!"
               fi
            baselineStartTimeMs=${VALUE};;
            canary)
               if [ -z "${VALUE}" ];then
                 echo "Value for mandatory parameter 'canary' is not specified!"
               fi
            canary=${VALUE};;
 	    canaryStartTimeMs)
              if [ -z "${VALUE}" ];then
                 echo "Value for mandatory parameter 'canaryStartTimeMs' is not specified!"
               fi
            canaryStartTimeMs=${VALUE};;
            *)
    esac

done

echo "--------------------------------------------------------------------------"
echo "********** Checking for mandatory parameters *****************************"
echo "--------------------------------------------------------------------------"
# Checking for mandatory parameters, if not present
counter=0
MESSAGE="Please pass the following required parameters as arguments : "
if [ -z $servername ]; then
   counter=$((counter+1))
   if  [ $counter -eq 1 ]; then
	echo $MESSAGE
   fi
   echo $counter". 'servername'"
fi
if [ -z $application ]; then
   counter=$((counter+1))
   if  [ $counter -eq 1 ]; then
	echo $MESSAGE
   fi
   echo $counter". 'application'"
fi
if [ -z $username ]; then
   counter=$((counter+1))
   if  [ $counter -eq 1 ]; then
	echo $MESSAGE
   fi
   echo $counter ". 'username'"
fi
if [ -z $lifetimeHours ]; then
   counter=$((counter+1))
   if  [ $counter -eq 1 ]; then
	echo $MESSAGE
   fi
   echo $counter ". 'lifetimeHours'"
fi
if [ -z $canaryAnalysisIntervalMins ]; then
   counter=$((counter+1))
   if  [ $counter -eq 1 ]; then
	echo $MESSAGE
   fi
   echo $counter ". 'canaryAnalysisIntervalMins'"
fi
if [ -z $baseline ]; then
   counter=$((counter+1))
   if  [ $counter -eq 1 ]; then
	echo $MESSAGE
   fi
   echo $counter ". 'baseline'"
fi
if [ -z $canary ]; then
   counter=$((counter+1))
   if  [ $counter -eq 1 ]; then
	echo $MESSAGE
   fi
   echo $counter ". 'canary'"
fi
if [ -z $baselineStartTimeMs ]; then
   counter=$((counter+1))
   if  [ $counter -eq 1 ]; then
	echo $MESSAGE
   fi
   echo $counter ". 'baselineStartTimeMs'"
fi
if [ -z $canaryStartTimeMs ]; then
   counter=$((counter+1))
   if  [ $counter -eq 1 ]; then
	echo $MESSAGE
   fi
   echo $counter ". 'canaryStartTimeMs'"
fi
if  [ $counter -gt 0 ]; then
       exit 1
fi

if [ -z $metrictemplate ] && [ -z $logtemplate ]; then
  echo "Aleast one of the parameters 'metrictemplate' or 'logtemplate' is required"
  exit 1
fi
if  [ $counter -eq 0 ]; then
  echo "All required parameters are specified properly."
fi

counter=0
echo "---------------------------------------------------------------------------"
echo "********** Setting optional parameters, if not specified by user **********"
echo "---------------------------------------------------------------------------"
# Setting optional parameters, if not specified by user
if [ -z $minimumCanaryScore ];then
   counter=$((counter+1))
   echo $counter". Optional parameter 'minimumCanaryScore' is not specified in the arguments, assigning the default value to 70!"
   minimumCanaryScore=70
fi
if [ -z $canaryResultScore ];then
   counter=$((counter+1))
   echo $counter". Optional parameter 'canaryResultScore' is not specified in the arguments, assigning the default value to 90!"
   canaryResultScore=90
fi
echo "--------------------------------------------------------------------------"
echo "********** Triggering the Analysis ***************************************"
echo "--------------------------------------------------------------------------"
url="https://$servername:8090/registerCanary"
echo "Calling the URL : "$url
jsondata="{\"application\":\"$application\", \"canaryConfig\":{ \"canaryAnalysisConfig\":{ \"beginCanaryAnalysisAfterMins\": \"0\",\"canaryAnalysisIntervalMins\" : \"$canaryAnalysisIntervalMins\",  \"lookbackMins\" : 0, \"name\" : \"metric-template:$metrictemplate;log-template:$logtemplate\", \"notificationHours\" : [ ], \"useLookback\" : false }, \"canaryHealthCheckHandler\" : {\"@class\" : \"com.netflix.spinnaker.mine.CanaryResultHealthCheckHandler\", \"minimumCanaryResultScore\" : \"$minimumCanaryScore\"}, \"canarySuccessCriteria\" : { \"canaryResultScore\" : \"$canaryResultScore\" },\"combinedCanaryResultStrategy\" : \"AGGREGATE\", \"lifetimeHours\" : \"$lifetimeHours\", \"name\" : \"$username\", \"application\" : \"prodk8\"}, \"canaryDeployments\" : [ { \"@class\" : \".CanaryTaskDeployment\", \"accountName\" : \"my-k8s-account\", \"baseline\" : \"$baseline\", \"baselineStartTimeMs\": "$baselineStartTimeMs", \"canary\" : \"$canary\", \"canaryStartTimeMs\": "$canaryStartTimeMs", \"type\" : \"cluster\" } ], \"watchers\" : [ ]}"

echo "Request body : "
echo $jsondata
response=$(curl -H  "Content-Type:application/json"  -X POST -d "$jsondata" "$url")
echo "Report URL : http://$servername:8161/opsmx-analysis/public/canaryAnalysis.html#/analysis/$response"
echo "********** End of Analysis ***********************************************"
echo "--------------------------------------------------------------------------"
echo "Returning canary Id :"
echo $response > canary_response_id_file
