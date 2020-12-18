#!/usr/bin/env bash
docker run -it --privileged --rm=true -v $(pwd):/mnt/host fittest/ubuntu-20.04:latest
