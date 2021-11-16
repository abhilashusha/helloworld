set -x -e

aws lambda get-alias \
     --function-name $DEPLOY_FUNCTION_NAME \
     --name $DEPLOY_ALIAS_NAME \


aws lambda get-alias \
     --function-name $DEPLOY_FUNCTION_NAME \
     --name $DEPLOY_ALIAS_NAME \
     > output.json

cat output.json
DEVELOPMENT_ALIAS_VERSION=$( cat output.json | jq -r '.FunctionVersion')

cd function
zip ../function.zip *
cd ..

aws lambda update-function-code \
   --function-name $DEPLOY_FUNCTION_NAME \
   --zip-file fileb://function.zip \
   --publish \
   > output.json
LATEST_VERSION=$(cat output.json | jq -r '.Version')

if [[ $DEVELOPMENT_ALIAS_VERSION -ge $LATEST_VERSION ]]; then
    exit 0
fi

cat > $DEPLOY_APPSPEC_FILE <<- EOM
version: 0.2
Resources:
  - helloworld:
      Type: AWS::Lambda::Function
      Properties:
         Name : "$DEPLOY_FUNCTION_NAME"
         Alias:  "$DEPLOY_ALIAS_NAME"
         CurrentVersion:  "$DEVELOPMENT_ALIAS_VERSION"
         TargetVersion: "$LATEST_VERSION"
EOM
aws s3 cp \
    $DEPLOY_APPSPEC_FILE \
    s3://$DEPLOY_BUCKET_NAME/$DEPLOY_APPSPEC_FILE

REVISION=revisionType=S3,s3Location={bucket=$DEPLOY_BUCKET_NAME,key='buildspec.yml',bundleType=YAML}

aws deploy create-deployment \
   --application-name $DEPLOY_APPLICATION_NAME \
   --deployment-group-name $DEPLOY_DEPLOYMENT_GROUP_NAME \
   --deployment-config-name CodeDeployDefault.LambdaAllAtOnce \
   --revision $REVISION