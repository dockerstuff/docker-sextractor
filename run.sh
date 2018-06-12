#!/bin/bash

docker run -v /tmp/output:/../work dige-sextractor

folderName=$(date "+output-%Y-%m-%d-%H-%M-%S")
mkdir run/$folderName

mv /tmp/output/* run/$folderName

