#!/bin/bash
# ----------------------------------------------------------------------------
# tg-run-destroy.sh
# ----------------------------------------------------------------------------
# Destroys the CloudTrain Kubernetes kubernetes-cluster from a local machine.
# ----------------------------------------------------------------------------

set -uex

export CODEBUILD_SRC_DIR=.
export TARGET_REGION=eu-west-1
export TARGET_STAGE=dev

echo "Destroy CloudTrain infrastructure"
cd $CODEBUILD_SRC_DIR/$TARGET_REGION/$TARGET_STAGE
terragrunt run-all destroy --terragrunt-non-interactive
