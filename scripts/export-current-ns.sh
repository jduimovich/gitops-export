#!/bin/bash 

oc project
export VERSION=v4.2.0  
export BINARY=yq_linux_amd64
wget -q https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O ./yq
chmod +x ./yq 

# Identify all objects
EXCLUSIONS="limitranges|networkpolicies|appliedclusterresourcequotas|clusterserviceversions|images|image.openshift.io|events|machineautoscalers.autoscaling.openshift.io|credentialsrequests.cloudcredential.openshift.io|podnetworkconnectivitychecks.controlplane.operator.openshift.io|leases.coordination.k8s.io|machinehealthchecks.machine.openshift.io|machines.machine.openshift.io|machinesets.machine.openshift.io|baremetalhosts.metal3.io|pods.metrics.k8s.io|alertmanagerconfigs.monitoring.coreos.com|alertmanagers.monitoring.coreos.com|podmonitors.monitoring.coreos.com|volumesnapshots.snapshot.storage.k8s.io|profiles.tuned.openshift.io|tuneds.tuned.openshift.io|endpointslice.discovery.k8s.io|ippools.whereabouts.cni.cncf.io|overlappingrangeipreservations.whereabouts.cni.cncf.io|packagemanifests.packages.operators.coreos.com|endpointslice.discovery.k8s.io|endpoints|pods"

IGNORES="argocd|primer|secret-key|kube-root-ca.crt|image-puller|kubernetes.io/service-account-token|builder|default|default-token|default-dockercfg|deployer|openshift-gitops-operator|redhat-openshift-pipelines-operator|edit|admin|pipeline-dockercfg"

if [ "$1" == "quick" ]; then   
      if [ -d "export" ]
      then
      echo "Quick Mode, refresh pre-exported resources"
      RESOURCES=$(cd export; ls) 
      else 
      echo "Quick Mode Disabled, No prior export exists, will generate full export"
      fi 
fi

if [ "$RESOURCES" == "" ]; then 
RESOURCES=`kubectl api-resources --verbs=list --namespaced -o name | egrep -v $EXCLUSIONS | awk -F. '{print $1}'`         
fi

DBG_DIR=debug
OUTPUT_DIR=export
rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR
rm -rf $DBG_DIR
mkdir -p $DBG_DIR

echo Output to $OUTPUT_DIR

SCRIPT_DIR=$(dirname "$0")

# prevent overrunning system

if [ -z $MAX_FORK ]
then
MAX_FORK=25     
fi

echo $0: "Running in parallel set with MAX_FORK=$MAX_FORK"

echo output > stdout.txt
rtotal=0
for o in $RESOURCES; do  
      let rtotal++
done

idx=0 
counter=0 
# Generate yamls
for o in $RESOURCES; do  
      let idx++
      let counter++
      echo Processing $o  $idx/$rtotal
      bash $SCRIPT_DIR/export-resources.sh $OUTPUT_DIR $DBG_DIR $IGNORES $o  &  
      echo Processing $o  $idx/$rtotal >> stdout.txt
      if [[ "$counter" -eq $MAX_FORK ]]; then
       counter=0 
       wait  
      fi
done  
wait  
bash $SCRIPT_DIR/scrub-secrets.sh $OUTPUT_DIR/secrets
 




 

