#!/bin/bash
gcloud auth activate-service-account --key-file=gcloud.json
printf "1\n1\n1"| gcloud init