#!/bin/bash

pushgatewayhost="gbp-monitor-03.ec2-east1.glassbeam.com"
host=`hostname`

#########################################   FUNCTIONS  #######################################
function check_infoserver(){

var="up{}"

IS_CHECK="infoserver"   #Process that is to be checked
IS_STATUS=$(ps aux | grep -v grep | grep $IS_CHECK)  

if [ "${#IS_STATUS}" -gt 0 ] ;  #Check for match
then 
  var="$var""1"$'\n'                         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/infoserver/instance/"$host"  #Push the stats to PushGateway
else 
  var="$var""0"$'\n'                         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/infoserver/instance/"$host"  #Push the stats to PushGateway
fi
}

function check_gbforgb(){

var="up{}"  #This has to be re-initialised for every new process. Else, it will use the value which is set above.

GBFORGB_CHECK="com.glassbeam.Kafka_gb4gb.GB4GBStream"  #Process that is to be checked
GBFORGB_STATUS=$(ps aux | grep -v grep | grep $GBFORGB_CHECK)

if [ "${#GBFORGB_STATUS}" -gt 0 ] ;  #Check for match
then 
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/gbforgb/instance/"$host"  #Push the stats to PushGateway
else 
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/gbforgb/instance/"$host"  #Push the stats to PushGateway
fi
}

function check_ums(){

UMS_CHECK="usermanagementserver"   #Process that is to be checked
UMS_STATUS=$(ps aux | grep -v grep | grep $UMS_CHECK)

var="up{}"  #This has to be re-initialised for every new process. Else, it will use the value which is set above.

if [ "${#UMS_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'                         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/ums/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'                         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/ums/instance/"$host"  #Push the stats to PushGateway
fi
}

function check_apache(){

APACHE_CHECK="httpd"   #Process that is to be checked
APACHE_STATUS=$(ps aux | grep -v grep | grep $APACHE_CHECK)

var="up{}"  #This has to be re-initialised for every new process. Else, it will use the value which is set above.

if [ "${#APACHE_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'                         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/apache/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'                         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/apache/instance/"$host"  #Push the stats to PushGateway
fi
}

function check_solr(){

SOLR_CHECK="solr"   #Process that is to be checked
SOLR_STATUS=$(ps aux | grep -v grep | grep $SOLR_CHECK)

var="up{}"  #This has to be re-initialised for every new process. Else, it will use the value which is set above.

if [ "${#SOLR_STATUS}" -gt 1 ] ;  #Check for match
then
  var="$var""1"$'\n'                         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/solr/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'                         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/solr/instance/"$host"  #Push the stats to PushGateway
fi

}


function check_zookeeper(){

ZOO_CHECK="zookeeper"  #Process that is to be checked
ZOO_STATUS=$(ps aux | grep -v grep | grep $ZOO_CHECK)

var="up{}"
zoo_type=""

if [ "$1" == "kafka" ];then
   zoo_type="kafka_zk"
else
   zoo_type="solr_zk"   
fi

if [ "${#ZOO_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/"$zoo_type"/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/"$zoo_type"/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_cass(){

CASS_CHECK="org.apache.cassandra.service.CassandraDaemon"
CASS_STATUS=$(ps aux | grep -v grep | grep $CASS_CHECK)

var="up{}"

if [ "${#CASS_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/cassandra/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/cassandra/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_spark_master(){

SPARK_MASTER_CHECK="org.apache.spark.deploy.master.Master"
SPARK_MASTER_STATUS=$(ps aux | grep -v grep | grep $SPARK_MASTER_CHECK)

var="up{}"

if [ "${#SPARK_MASTER_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/sparkmaster/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/sparkmaster/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_spark_worker(){

SPARK_WORKER_CHECK="org.apache.spark.deploy.worker.Worker"
SPARK_WORKER_STATUS=$(ps aux | grep -v grep | grep $SPARK_WORKER_CHECK)

var="up{}"

if [ "${#SPARK_WORKER_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/sparkworker/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/sparkworker/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_kafka(){

KAFKA_CHECK="kafkaServer"
KAFKA_STATUS=$(ps aux | grep -v grep | grep $KAFKA_CHECK)

var="up{}"

if [ "${#KAFKA_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/kafka/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/kafka/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_lcp(){

LCP_CHECK="com.glassbeam.scalar.lcp.batch.LcpBatch"
LCP_STATUS=$(ps aux | grep -v grep | grep $LCP_CHECK)

var="up{}"

if [ "${#LCP_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/lcp/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/lcp/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_rulesmanager(){

RM_CHECK="com.glassbeam.rules.schema.manager.RulesManagerStarter"
RM_STATUS=$(ps aux | grep -v grep | grep $RM_CHECK)

var="up{}"

if [ "${#RM_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/rm/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/rm/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_schemamanager(){

SM_CHECK="com.glassbeam.scalar.schemamanager.core.SchemaManager"
SM_STATUS=$(ps aux | grep -v grep | grep $SM_CHECK)

var="up{}"

if [ "${#SM_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/sm/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/sm/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_h2server(){

H2_CHECK="org.h2.tools.Server"
H2_STATUS=$(ps aux | grep -v grep | grep $H2_CHECK)

var="up{}"

if [ "${#H2_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/h2/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/h2/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_bc2r(){

BC2R_CHECK="com.glassbeam.scalar.bc2r.core.BC2R"
BC2R_STATUS=$(ps aux | grep -v grep | grep $BC2R_CHECK)

var="up{}"

if [ "${#BC2R_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/bc2r/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/bc2r/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_gbforgb_bc2r(){

BC2R_CHECK="com.glassbeam.scalar.bc2r.core.BC2R"
BC2R_STATUS=$(ps aux | grep -v grep | grep $BC2R_CHECK|grep gbforgb)

var="up{}"

if [ "${#BC2R_STATUS}" -gt 1 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/gbforgb_bc2r/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/gbforgb_bc2r/instance/"$host"  #Push the stats to PushGateway
fi

}


function check_tablerules(){

TR_CHECK="com.glassbeam.rules.lcp.table.LcpTableRulesStarter"
TR_STATUS=$(ps aux | grep -v grep | grep $TR_CHECK)

var="up{}"

if [ "${#TR_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/tr/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/tr/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_filerules(){

FR_CHECK="com.glassbeam.rules.lcp.file.LcpFileRulesStarter"
FR_STATUS=$(ps aux | grep -v grep | grep $FR_CHECK)

var="up{}"

if [ "${#FR_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/fr/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/fr/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_bundlerules(){

BR_CHECK="com.glassbeam.rules.lcp.bundle.LcpBundleRulesStarter"
BR_STATUS=$(ps aux | grep -v grep | grep $BR_CHECK)

var="up{}"

if [ "${#BR_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/br/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/br/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_alertengine(){

AE_CHECK="com.glassbeam.scalar.alertengine.core.AlertEngine"
AE_STATUS=$(ps aux | grep -v grep | grep $AE_CHECK)

var="up{}"

if [ "${#AE_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/ae/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/ae/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_LCP_alertengine(){

LCP_AE_CHECK="com.glassbeam.scalar.alertengine.core.LcpAlertEngine"
LCP_AE_STATUS=$(ps aux | grep -v grep | grep $LCP_AE_CHECK)

var="up{}"

if [ "${#LCP_AE_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/lcpae/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/lcpae/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_ML_alertengine(){

ML_AE_CHECK="com.glassbeam.scalar.alertengine.core.MlAlertEngine"
ML_AE_STATUS=$(ps aux | grep -v grep | grep $ML_AE_CHECK)

var="up{}"

if [ "${#ML_AE_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/mlae/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/mlae/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_c2s(){

C2S_CHECK="com.glassbeam.scalar.c2s.C2S"
C2S_STATUS=$(ps aux | grep -v grep | grep $C2S_CHECK)

var="up{}"

if [ "${#C2S_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/c2s/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/c2s/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_lcpbatchrules(){

LCPRULES_CHECK="com.glassbeam.scalar.lcp.batch.rules.LcpBatchWithRules"
LCPRULES_STATUS=$(ps aux | grep -v grep | grep $LCPRULES_CHECK)

var="up{}"

if [ "${#LCPRULES_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/lcprules/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/lcprules/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_loadbalancer(){

ILB_CHECK="com.glassbeam.scalar.loadbalancer.LoadBalancerMain"
ILB_STATUS=$(ps aux | grep -v grep | grep $ILB_CHECK)

var="up{}"

if [ "${#ILB_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/ilb/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/ilb/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_UAD(){

UAD_CHECK="com.glassbeam.ml.rules.uad.UADStarter"
UAD_STATUS=$(ps aux | grep -v grep | grep $UAD_CHECK)

var="up{}"

if [ "${#UAD_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/uad/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/uad/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_modelserver(){

MODELSERVER_CHECK="play.core.server.ProdServerStart"
MODELSERVER_STATUS=$(ps aux | grep -v grep | grep $MODELSERVER_CHECK)

var="up{}"

if [ "${#UAD_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/modelserver/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/modelserver/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_FP(){

FP_CHECK="com.glassbeam.ml.rules.fp.FpStarter"
FP_STATUS=$(ps aux | grep -v grep | grep $FP_CHECK)

var="up{}"

if [ "${#FP_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/fp/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/fp/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_vertica(){

VERTICA_CHECK="spread"
VERTICA_STATUS=$(ps aux | grep -v grep | grep $VERTICA_CHECK)

var="up{}"

if [ "${#VERTICA_STATUS}" -gt 1 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/vertica/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/vertica/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_cassandra_exporter(){

CASS_EXPORTER_CHECK="cassandra_exporter"
CASS_EXPORTER_STATUS=$(ps aux | grep -v grep | grep $CASS_EXPORTER_CHECK)

var="up{}"

if [ "${#CASS_EXPORTER_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/cassexporter/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/cassexporter/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_data_expunge(){

DATA_EXPUNGE_CHECK="com.glassbeam.scalar.dataexpunge.core.DataExpunge"
DATA_EXPUNGE_STATUS=$(ps aux | grep -v grep | grep $DATA_EXPUNGE_CHECK)

var="up{}"

if [ "${#DATA_EXPUNGE_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/dataexpunge/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/dataexpunge/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_configdb_console(){

CONFIGDB_CONSOLE_CHECK="config_db_console"
CONFIGDB_CONSOLE_STATUS=$(ps aux | grep -v grep | grep $CONFIGDB_CONSOLE_CHECK)

var="up{}"

if [ "${#CONFIGDB_CONSOLE_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/h2console/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/h2console/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_seenid_generator(){

SEENID_GENERATOR_CHECK="seen-id"
SEENID_GENERATOR_STATUS=$(ps aux | grep -v grep | grep $SEENID_GENERATOR_CHECK)

var="up{}"

if [ "${#SEENID_GENERATOR_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/seenid/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/seenid/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_sshd_port22(){

PORT_CHECK="0.0.0.0:22"
PORT_STATUS=$(netstat -tupln|grep $PORT_CHECK)

var="up{}"

if [ "${#PORT_STATUS}" -eq 1 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/ssh22/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/ssh22/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_sshd_port443(){

PORT_CHECK="0.0.0.0:443"
PORT_STATUS=$(netstat -tupln|grep $PORT_CHECK)

var="up{}"

if [ "${#PORT_STATUS}" -eq 1 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/ssh443/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/ssh443/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_sshd_port4224(){

PORT_CHECK="0.0.0.0:4224"
PORT_STATUS=$(netstat -tupln|grep $PORT_CHECK)

var="up{}"

if [ "${#PORT_STATUS}" -eq 1 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/ssh4224/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/ssh4224/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_FP_SMS(){

#FPSMS_CHECK="http.port=5805"
FPSMS_CHECK="5805"
FPSMS_STATUS=$(ps aux | grep -v grep |grep play.core.server.ProdServerStart| grep $FPSMS_CHECK)

var="up{}"

if [ "${#FPSMS_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/fpsms/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/fpsms/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_FP_GE(){

FPGE_CHECK="5801"
FPGE_STATUS=$(ps aux | grep -v grep | grep play.core.server.ProdServerStart|grep $FPGE_CHECK)

var="up{}"

if [ "${#FPGE_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/fpge/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/fpge/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_UAD_AUG(){

UAD_AUG_CHECK="5803"
#UAD_AUG_STATUS=$(ps aux | grep -v grep | grep play.core.server.ProdServerStart|grep $UAD_AUG_CHECK)
UAD_AUG_STATUS=$(ps aux | grep -v grep | grep $UAD_AUG_CHECK)

var="up{}"

if [ "${#UAD_AUG_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/uadaug/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/uadaug/instance/"$host"  #Push the stats to PushGateway
fi

}


function check_EPRE(){

EPRE_CHECK="9000"
#EPRE_STATUS=$(ps aux | grep -v grep | grep play.core.server.ProdServerStart|grep $EPRE_CHECK)
EPRE_STATUS=$(ps aux | grep -v grep | grep $EPRE_CHECK)

var="up{}"

if [ "${#EPRE_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/epre/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/epre/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_ntpd(){

NTPD_CHECK="ntpd"
NTPD_STATUS=$(ps aux | grep -v grep | grep $NTPD_CHECK)

var="up{}"

if [ "${#NTPD_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/ntpd/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/ntpd/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_sendmail(){

SENDMAIL_CHECK="sendmail"
SENDMAIL_STATUS=$(ps aux | grep -v grep | grep $SENDMAIL_CHECK)

var="up{}"

if [ "${#SENDMAIL_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/sendmail/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/sendmail/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_sshd(){

SSHD_CHECK="/usr/sbin/sshd"
SSHD_STATUS=$(ps aux | grep -v grep | grep $SSHD_CHECK)

var="up{}"

if [ "${#SSHD_STATUS}" -gt 0 ] ;  #Check for match
then
  var="$var""1"$'\n'         # If the process is up, then append 1.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/sshd/instance/"$host"  #Push the stats to PushGateway
else
  var="$var""0"$'\n'         # If the process is down, then append 0.
  curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/sshd/instance/"$host"  #Push the stats to PushGateway
fi

}

function check_threadscount(){
THREAD_COUNT=$(ps -eLf | grep "java" |wc -l)

var="gb_threadcount{}"
var="$var""${THREAD_COUNT}"$'\n'
curl -X POST -H  "Content-Type: text/plain" --data "$var"  http://"$pushgatewayhost":9091/metrics/job/threadcount/instance/"$host"  #Push the stats to PushGateway
}


if [[ $# -lt 1 ]];then
  echo "Please enter the correct format"
  echo "The correct format is"
  echo "$0 <List of Services to be checked for>"
  echo "For example:"
  echo "$0  is,gb4gb,apache,system" # IS
  echo "$0  ums,gb4gb,apache,system" #UMS
  echo "$0  cass_withmaster" #C* with master & worker
  echo "$0  cass" #C* with worker
  echo "$0  onlycass" # C* Without Worker
  echo "$0  solr_withzk" #Solr with ZK
  echo "$0  solr_withoutzk" # Only Solr
  echo "$0  kafka" #Kafka, ZK
  echo "$0  rules" #FR, BR, TR
  echo "$0  c2s" #Only C2S
  echo "$0  lcp" #Only LcpBatch
  echo "$0  h2" #H2, RM, SM
  echo "$0  sm" #Only SM
  echo "$0  rm"  #Only RM
  echo "$0  onlyh2"
  echo "$0  h2_withlcp" #H2, RM, SM, LCP
  echo "$0  mls" #UAD, AE, ModelServer
  echo "$0  bc2r" #Only BC2R
  echo "$0 lcprules" #Only LcpRules
  echo "$0  vertica" #Only Vertica
  echo "$0  sbx"  # AE, IS, Kafka, C*, ZK, SM, LcpRules 
  echo "$0  ilb"  # ILB
  sleep 10
  exit
else

  IFS=',' read -r -a subcrbr_list <<< "$1"
  for value in "${subcrbr_list[@]}"
  do
    if [ "$value" == "is" ];then
      check_infoserver

    elif [ "$value" == "sendmail" ];then
      check_sendmail

    elif [ "$value" == "apache" ];then
      check_apache

    elif [ "$value" == "gb4gb" ];then
      check_gbforgb

    elif [ "$value" == "system" ];then
      check_ntpd
      check_sshd

    elif [ "$value" == "ums" ];then
      check_ums

    elif [ "$value" == "solr" ];then
      check_solr

    elif [ "$value" == "zoo_solr" ];then
      check_zookeeper solr

    elif [ "$value" == "kafka" ];then
      check_kafka

    elif [ "$value" == "zoo_kafka" ];then
      check_zookeeper kafka

    elif [ "$value" == "cass" ];then
      check_cass

    elif [ "$value" == "SparkMaster" ];then
      check_spark_master

    elif [ "$value" == "SparkWorker" ];then
      check_spark_worker

    elif [ "$value" == "CassExporter" ];then
      check_cassandra_exporter

    elif [ "$value" == "FR" ];then
      check_filerules

    elif [ "$value" == "BR" ];then
      check_bundlerules

    elif [ "$value" == "TR" ];then
      check_tablerules

    elif [ "$value" == "H2" ];then
      check_h2server

    elif [ "$value" == "SM" ];then
      check_schemamanager

    elif [ "$value" == "RM" ];then
      check_rulesmanager

    elif [ "$value" == "LcpBatch" ];then
      check_lcp

    elif [ "$value" == "LCPAE" ];then
      check_LCP_alertengine

    elif [ "$value" == "MLAE" ];then
      check_ML_alertengine

    elif [ "$value" == "UAD" ];then
      check_UAD

    elif [ "$value" == "modelserver" ];then
      check_modelserver

    elif [ "$value" == "FP" ];then
      check_FP

    elif [ "$value" == "EPRE" ];then
      check_EPRE

    elif [ "$value" == "UAD-AUG" ];then
      check_UAD_AUG

    elif [ "$value" == "BC2R" ];then
      check_bc2r

    elif [ "$value" == "BC2R-gb4gb" ];then
      check_gbforgb_bc2r

    elif [ "$value" == "FP-SMS" ];then
      check_FP_SMS

    elif [ "$value" == "FP-GE" ];then
      check_FP_GE

    elif [ "$value" == "LCP-Rules" ];then
      check_lcpbatchrules

    elif [ "$value" == "C2S" ];then
      check_c2s

    elif [ "$value" == "ILB" ];then
      check_loadbalancer

    elif [ "$value" == "SeenID" ];then
      check_seenid_generator

    elif [ "$value" == "Vertica" ];then
      check_vertica

    elif [ "$value" == "AE" ];then
      check_alertengine
    elif [ "$value" == "THREADCOUNT" ];then
      check_threadscount
   fi
  
  done
    
fi
