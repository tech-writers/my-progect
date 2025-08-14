#!/bin/sh
set -e

echo "Cleaning output directory..."
rm -rf ./build/site

echo "Generating Antora site..."
docker run --rm -v "$PWD:/antora" -w /antora -e NODE_PATH=/usr/local/lib/node_modules docs-antora-antora:latest antora-playbook.yml

echo "Site generated successfully!"

if [ -d "./build/site" ]; then
  echo "Starting local HTTP server at http://localhost:8080 ..."
  npx http-server build/site -c-1
else
  echo "Error: build/site directory not found!"
  exit 1
fi