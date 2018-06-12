#!/bin/bash

docker run -v /tmp/output:/../work dige-sextractor

mv /tmp/output/* run
