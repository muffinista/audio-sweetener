#!/bin/bash

NAME=$(basename $PWD)
echo $NAME
docker build -t $NAME .
