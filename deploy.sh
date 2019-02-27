#!/usr/bin/env bash

# Make sure we have gcloud installed in travis env
if [ ! -d "$HOME/google-cloud-sdk/bin" ]; then
  rm -rf "$HOME/google-cloud-sdk"
  curl https://sdk.cloud.google.com | bash > /dev/null
fi

# Promote gcloud to PATH top priority (prevent using old version fromt travis)
source $HOME/google-cloud-sdk/path.bash.inc

# Make sure kubectl is updated to latest version
gcloud components update kubectl

make gauth build push deploy
