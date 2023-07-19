#!/bin/bash
set -eux

# Assign credentials to variables
CLIENT_ID="2o1b1a93o83g3h3cqiihm84ut2"
USER_POOL_ID="us-east-2_dNvPOb4dl"
USERNAME="testuser3"
PASSWORD="aA12345678!"
URL="https://qopph0gthe.execute-api.us-east-2.amazonaws.com/prod/users"

# Sign-up user
aws cognito-idp sign-up \
  --client-id "${CLIENT_ID}" \
  --username "${USERNAME}" \
  --password "${PASSWORD}"

# Confirm user
aws cognito-idp admin-confirm-sign-up \
  --user-pool-id "${USER_POOL_ID}" \
  --username "${USERNAME}"

# Authenticate and get token
TOKEN=$(
  aws cognito-idp initiate-auth \
    --client-id "${CLIENT_ID}" \
    --auth-flow USER_PASSWORD_AUTH \
    --auth-parameters USERNAME="${USERNAME}",PASSWORD="${PASSWORD}" \
    --query 'AuthenticationResult.IdToken' \
    --output text
)

# Make API call
curl -H "Authorization: ${TOKEN}" "${URL}" | jq
