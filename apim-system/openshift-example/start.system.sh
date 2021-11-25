#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));


############################################################################################################################
# Settings
export MONGO_VOLUME="$scriptDir/tmp/mongo-data"
export MONGODB_USER=myuser
export MONGODB_PASSWORD=password
export MONGODB_DATABASE=mydb
export MONGODB_ADMIN_PASSWORD=admin123
export MONGODB_EXTERNAL_PORT=27020

############################################################################################################################
# prepare

mkdir -p $MONGO_VOLUME


############################################################################################################################
# Notes
# Auth DB name defaults to 'admin'
# Admin user defaults to 'admin'
#
# connect: mongodb://{admin-user}:{admin-password}@localhost:{external-port}/{auth-db-name}?retryWrites=true
# connect: mongodb://admin:admin123@localhost:27020/admin?retryWrites=true

docker run -d \
  -e MONGODB_USER=$MONGODB_USER \
  -e MONGODB_PASSWORD=$MONGODB_PASSWORD \
  -e MONGODB_DATABASE=$MONGODB_DATABASE \
  -e MONGODB_ADMIN_PASSWORD=$MONGODB_ADMIN_PASSWORD \
  -v $MONGO_VOLUME:/var/lib/mongodb/data \
  -p $MONGODB_EXTERNAL_PORT:27017 \
  centos/mongodb-36-centos7

docker-compose -p "openshift-example" -f ./docker-compose.yml up -d

echo docker logs openshift-example-apim-connector
