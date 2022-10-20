#!/bin/bash

sed "s/IMAGE_VERSION/$1/g" $2 > out.yaml
