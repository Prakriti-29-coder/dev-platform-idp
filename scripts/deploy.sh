#!/bin/bash

echo "=============================="
echo " Developer Self-Service Portal"
echo "=============================="
echo "Choose deployment type:"
echo "1. App Service"
echo "2. Exit"

read choice

case $choice in
  1)
    echo "Enter app name (must be globally unique, lowercase):"
    read appname

    REGION="southeastasia"

    ############################################
    # CREATE INPUT FOR OPA POLICY ENGINE
    ############################################
    cat <<EOF > input.json
{
  "app_name": "$appname",
  "region": "$REGION"
}
EOF

    ############################################
    # RUN OPA COMPLIANCE CHECK
    ############################################
    ALLOW=$(opa eval -i input.json -d policy.rego "data.idp.compliance.allow" -f raw)

    if [ "$ALLOW" != "true" ]; then
      echo "❌ Deployment blocked by Compliance Engine"
      echo "Reason: Violates GDPR / ISO 27001 / NIST policies"
      exit 1
    fi

    echo "✅ Compliance passed (GDPR + ISO + NIST)"

    ############################################
    # DEPLOY INFRASTRUCTURE
    ############################################
    cd ../templates/appservice-template

    terraform init
    terraform apply -auto-approve -var="app_name=$appname"
    ;;

  2)
    echo "Exiting..."
    ;;

  *)
    echo "Invalid choice"
    ;;
esac
