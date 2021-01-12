# A bug in external-dns creates thousands of AAAA DNS records when there is an IPv6 external IP,
# This is a script to cleanup these duplicated records

import os
from linode_api4 import LinodeClient

client = LinodeClient(os.getenv("LINODE_TOKEN"))
domains = client.domains()

for domain in domains:
    exists = {}
    to_delete = []
    for record in domain.records:
        if record.type != 'AAAA':
            continue
        if exists.get(str(record.name)):
            to_delete.append(record)
            continue
        exists[str(record.name)] = True
    
    for record in to_delete:
        record.delete()