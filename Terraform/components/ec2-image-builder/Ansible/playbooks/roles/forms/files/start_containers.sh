#!/bin/bash -ex
docker start "$(docker ps -a -q)"
