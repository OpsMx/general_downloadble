#!/bin/bash

usage="$(basename "$0")
[-help]  -- Example to show how to pass relevant arguments.
USAGE:
$(basename "$0") servername='12.299.222.155' username='johndoe' metrictemplate='apptemplate' logtemplate='elastictemplate' lifetimeHours=0.5 canaryAnalysisIntervalMins='30' baseline=1e8ecb994cbba canary=1e8ecb994cbba baselineStartMs=1528139701000 canaryResultScore='60' minimumCanaryScore=50"

while getopts ':hhelp:' option; do
  case "$option" in
    h) echo "$usage" ;;
    *) echo "usage: $0 [-help]" >&2
       exit 1 ;;
  esac
done
if  [ "$#" -lt 11 ] || [ $# -eq 0 ]; then
    echo "Should pass sufficent arguments. For help pass -help"
    exit 1
fi
for ARGUMENT in "$@"
do

    KEY=$(echo "$ARGUMENT" | cut -f1 -d=)
    VALUE=$(echo "$ARGUMENT" | cut -f2 -d=)

    case "$KEY" in
            servername)
               if [ -z "${VALUE}" ];then
                 echo "servername not found!"
               fi
            servername=${VALUE} ;;
            canaryAnalysisIntervalMins)
               if [ -z "${VALUE}" ];then
                 echo "canaryAnalysisIntervalMins not found!"
               fi
            canaryAnalysisIntervalMins=${VALUE} ;;
            metrictemplate)
               if [ -z "${VALUE}" ];then
                 echo "metrictemplate not found!"
               fi
            metrictemplate=${VALUE};;
            logtemplate)
                if [ -z "${VALUE}" ];then
                 echo "logtemplate not found!"
               fi
            logtemplate=${VALUE};;
            minimumCanaryScore)
               if [ -z "${VALUE}" ];then
                  echo "minimumCanaryScore not found!"
               fi
            minimumCanaryScore=${VALUE};;
            canaryResultScore)
               if [ -z "${VALUE}" ];then
                 echo "canaryResultScore not found!"
               fi
            canaryResultScore=${VALUE};;
            lifetimeHours)
               if [ -z "${VALUE}" ];then
                 echo "lifetimeHours not found!"
               fi
            lifetimeHours=${VALUE};;
            username)
               if [ -z "${VALUE}" ];then
                 echo "username not found!"
               fi
            username=${VALUE};;
            baseline)
               if [ -z "${VALUE}" ];then
                 echo "baseline not found!"
               fi
            baseline=${VALUE};;
            baselineStartMs)
              if [ -z "${VALUE}" ];then
                 echo "baselineStartMs not found!"
               fi
            baselineStartMs=${VALUE};;
            canary)
               if [ -z "${VALUE}" ];then
                 echo "canary not found!"
               fi
            canary=${VALUE};;
            *)
    esac

done

# checking for optional parameters if not present (baselineStartMs)

if [ -z $baselineStartMs ]; then
  baselineStartMs='null'
fi

if [ -z $logtemplate ]; then
  logtemplate='null'
fi

url="http://$servername:8090/registerCanary"
jsondata="{\"application\":\"prodk8\", \"canaryConfig\":{ \"canaryAnalysisConfig\":{ \"beginCanaryAnalysisAfterMins\": \"0\",\"canaryAnalysisIntervalMins\" : \"$canaryAnalysisIntervalMins\",  \"lookbackMins\" : 0, \"name\" : \"metric-template:$metrictemplate;log-template:$logtemplate\", \"notificationHours\" : [ ], \"useLookback\" : false }, \"canaryHealthCheckHandler\" : {\"@class\" : \"com.netflix.spinnaker.mine.CanaryResultHealthCheckHandler\", \"minimumCanaryResultScore\" : \"$minimumCanaryScore\"}, \"canarySuccessCriteria\" : { \"canaryResultScore\" : \"$canaryResultScore\" },\"combinedCanaryResultStrategy\" : \"AGGREGATE\", \"lifetimeHours\" : \"$lifetimeHours\", \"name\" : \"$username\", \"application\" : \"prodk8\"}, \"canaryDeployments\" : [ { \"@class\" : \".CanaryTaskDeployment\", \"accountName\" : \"my-k8s-account\", \"baseline\" : \"$baseline\", \"baselineStartMs\": "$baselineStartMs", \"canary\" : \"$canary\", \"type\" : \"cluster\" } ], \"watchers\" : [ ]}"

response=$(curl -H  "Content-Type:application/json"  -X POST -d "$jsondata" "$url")
echo $response
