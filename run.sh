#!/bin/bash

#run the image with a specified volume
docker run -v /tmp/output:/../work dige-sextractor

#make an output directory based on the date
folderName=$(date "+output-%Y-%m-%d-%H-%M-%S")
mkdir dige/$folderName

#move output files into that directory
mv /tmp/output/* dige/$folderName

for subdir in $(ls dige/$folderName); do
    for ff in $(ls dige/$folderName/$subdir | grep ".cat"); do
        NAME=`echo "$ff"| cut -d'.' -f1`
	cp dige/$folderName/$subdir/$ff dige/$folderName/$subdir/$NAME.csv
	rm dige/$folderName/$subdir/$ff  
    done
done
