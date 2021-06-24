#!/usr/bin/env bash

ENV=${1}

echo ""
echo "Start applying for env: ${ENV}"
echo ""
echo "terragrunt Apply"
echo "========================="

terragrunt run-all apply "terragrunt-${ENV}.plan"

echo "========================="
echo ""
