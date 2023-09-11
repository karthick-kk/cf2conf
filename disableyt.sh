#!/bin/bash

echo "Disable YT Block"
curl -X PUT "https://api.cloudflare.com/client/v4/accounts/$accountid/gateway/rules/35e4d431-5b32-4c6b-9336-c86cbb9a0205" \
     -H "Authorization: Bearer $apitoken" \
     -H "Content-Type: application/json" \
     --data '{
        "name": "yt-block-policy",
        "action": "block",
        "traffic": "any(dns.domains[*] matches \"youtube.com\")",
        "enabled": false
    }'
