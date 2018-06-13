#!/bin/bash

#run the image with a specified volume
docker run -v /tmp/output:/../work dige-sextractor

#make an output directory based on the date
folderName=$(date "+output-%Y-%m-%d-%H-%M-%S")
mkdir run/$folderName

#move output files into that directory
mv /tmp/output/* run/$folderName

for subdir in $(ls run/$folderName); do
    for ff in $(ls run/$folderName/$subdir | grep ".cat"); do
        NAME=`echo "$ff"| cut -d'.' -f1`
	cp run/$folderName/$subdir/$ff run/$folderName/$subdir/$NAME.csv
	rm run/$folderName/$subdir/$ff  
    done
done
