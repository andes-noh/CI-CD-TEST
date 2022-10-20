#!/bin/bash

sed "s/IMAGE_VERSION/$1/g" test.deployment.yaml > out.yaml
