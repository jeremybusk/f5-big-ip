#!/usr/bin/env bash
set -e
username=youruser
userpass=yourpass
host=api.f5.example.com

api_auth_test() {
  r=$(curl -sk https://$host/mgmt/shared/authn/login -X POST -H "Content-Type: application/json" \
        -d '{"username":"'$username'", "password":"'$userpass'", "loginProviderName":"tmos"}')
  token=$(echo $r | jq .token.token | tr -d \")
  r=$(curl -sk https://$host/mgmt/shared/authz/tokens/$token -H "X-F5-Auth-Token: $token")
  r=$(curl -sk https://$host/mgmt/shared/authz/tokens/$token -X DELETE -H "X-F5-Auth-Token: $token")

}


while true; do
  start=$(date +%s)
  api_auth_test
  end=$(date +%s)
  runtime=$((end-start))
  echo "api test response time: $runtime"
done
