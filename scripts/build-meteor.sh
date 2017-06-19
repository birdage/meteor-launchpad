#!/bin/bash

#
# builds a production meteor bundle directory
#
set -e

# Fix permissions warning in Meteor >=1.4.2.1 without breaking
# earlier versions of Meteor with --unsafe-perm or --allow-superuser
# https://github.com/meteor/meteor/issues/7959
export METEOR_ALLOW_SUPERUSER=true

cd $APP_SOURCE_DIR

# Install app deps
#printf "\n[-] Running npm install in app directory...\n\n"
#meteor npm install
printf "\n[-] Make the app bundle directory...\n\n"
# make the dir
mkdir -p $APP_BUNDLE_DIR

# adding the bundle
printf "\n[-] Adding Meteor bundle...\n\n"
ADD ../xmp-package/xmp.tar.gz $APP_BUNDLE_DIR/xmp.tar.gz
tar -xzf xmp.tar.gz -C ./

# build the bundle
#printf "\n[-] Building Meteor application...\n\n"
#meteor build --directory $APP_BUNDLE_DIR

# run npm install in bundle
printf "\n[-] Running npm install in the server bundle...\n\n"
cd $APP_BUNDLE_DIR/bundle/programs/server/
meteor npm install --production

# put the entrypoint script in WORKDIR
mv $BUILD_SCRIPTS_DIR/entrypoint.sh $APP_BUNDLE_DIR/bundle/entrypoint.sh

# change ownership of the app to the node user
chown -R node:node $APP_BUNDLE_DIR
