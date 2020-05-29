#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

docker image inspect igriswold/dige-sextractor >/dev/null 2>&1 && echo "Image already installed" || docker pull igriswold/dige-sextractor

bash backend/run.sh
