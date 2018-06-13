#!/bin/bash

DIGE=/tmp/dige-sex

rm -rf $DIGE/*

#need a place to put output files
mkdir $DIGE/output

#need a place to put input files, then actually put them there
mkdir $DIGE/input

for input in $(ls dige | grep "input"); do
    cp -r dige/$input $DIGE/input/
done

#same thing, but for .sex and .param files
mkdir $DIGE/config

cp dige/DIGE.sex $DIGE/config
cp dige/DIGE.param $DIGE/config 

#run the image with a specified volume
docker run -v $DIGE:/../work dige-sextractor

#make an output directory based on the date
folderName=$(date "+output-%Y-%m-%d-%H-%M-%S")
mkdir dige/$folderName

#move output files into that directory
cp -r $DIGE/output/* dige/$folderName

for subdir in $(ls dige/$folderName); do
    for ff in $(ls dige/$folderName/$subdir | grep ".cat"); do
        NAME=`echo "$ff"| cut -d'.' -f1`
	cp dige/$folderName/$subdir/$ff dige/$folderName/$subdir/$NAME.csv
	rm dige/$folderName/$subdir/$ff  
    done
done
