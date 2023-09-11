#!/bin/bash

ip=`curl -s https://bytefreaks.net/what-is-my-ip | grep '<h1 style="text-align: center;"' | cut -d '>' -f 2 | cut -d '<' -f 1`
ip=`echo $ip | cut -d, -f1`
echo "Got public IP: $ip"
echo "Checking existing IP in Gateway - Home"
getgwip=` curl -s --request GET \
  --url https://api.cloudflare.com/client/v4/accounts/$accountid/gateway/locations \
  -H "Authorization: Bearer $apitoken" \
  -H "Content-Type: application/json" | jq -r '.result[] | select(.name == "Home") | .networks[].network' | awk -F/ '{print $1}'`
echo "Found GW IP: $getgwip"

if [ "$ip" != "$getgwip" ]; then
    echo "Updating IP ..."
    curl --request PUT \
    --url https://api.cloudflare.com/client/v4/accounts/$accountid/gateway/locations/83247e4a07d44a02a49d1359164f256b \
    -H "Authorization: Bearer $apitoken" \
    -H "Content-Type: application/json" \
    --data "{
    \"client_default\": true,
    \"ecs_support\": false,
    \"name\": \"Home\",
    \"networks\": [{
            \"network\": \"$ip/32\"
            }]
    }"
else
    echo "No change in IP. Update skipped."
fi