#/bin/bash

IP=`kubectl --kubeconfig=.kubeconfig get service --namespace ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`
echo "{\"ip\":\"$IP\"}"