import os
import sys
import json
from linode_api4 import LinodeClient, Instance

client = LinodeClient(sys.argv[1])
ipv4 = []
ipv6 = []
private = []

for instance_id in sys.argv[2:]:
    instance = client.load(Instance, instance_id)
    ipv4.append(instance.ips.ipv4.public[0].address)
    ipv6.append(instance.ips.ipv6.slaac.address)
    private.append(instance.ips.ipv4.private[0].address)

print(json.dumps({'ipv4': ','.join(ipv4), 'ipv6': ','.join(ipv6), 'private': ','.join(private)}))