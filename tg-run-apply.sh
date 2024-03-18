#!/bin/bash
# ----------------------------------------------------------------------------
# tg-run-apply.sh
# ----------------------------------------------------------------------------
# Creates the CloudTrain Kubernetes kubernetes-cluster from a local machine.
# ----------------------------------------------------------------------------

set -uex

export CODEBUILD_SRC_DIR=.
export TARGET_REGION=eu-west-1
export TARGET_STAGE=dev

echo "Build CloudTrain infrastructure"
cd $CODEBUILD_SRC_DIR/$TARGET_REGION/$TARGET_STAGE
echo "Create platform (phase 1)"
terragrunt run-all apply --terragrunt-non-interactive
echo "Configure platform (phase 2)"
export TF_VAR_prometheus_operator_enabled=true
export TF_VAR_jaeger_enabled=true
terragrunt run-all apply --terragrunt-non-interactive
