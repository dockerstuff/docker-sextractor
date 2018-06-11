#!/bin/bash

docker build -t dige-sextractor .
docker run dige-sextractor
