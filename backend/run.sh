#!/bin/bash

mkdir /tmp/dige-sex

DIGE=/tmp/dige-sex

LOCAL_INPUT=io
LOCAL_OUTPUT=io
LOCAL_CONFIG=config

rm -rf $DIGE/*

#need a place to put output files
mkdir $DIGE/output

#need a place to put input files, then actually put them there
mkdir $DIGE/input

for input in $(ls ${LOCAL_INPUT} | grep "input"); do
    cp -r ${LOCAL_INPUT}/$input $DIGE/input/
done

#same thing, but for .sex and .param files
mkdir $DIGE/config

cp ${LOCAL_CONFIG}/DIGE.sex $DIGE/config
cp ${LOCAL_CONFIG}/DIGE.param $DIGE/config 
cp ${LOCAL_CONFIG}/gauss_2.0_3x3.conv $DIGE/config 

#run the image with a specified volume
docker run -v $DIGE:/../work igriswold/dige-sextractor

#make an output directory based on the date
folderName=$(date "+output-%Y-%m-%d-%H-%M-%S")
mkdir ${LOCAL_OUTPUT}/$folderName

#move output files into that directory
cp -r $DIGE/output/* ${LOCAL_OUTPUT}/$folderName

for subdir in $(ls ${LOCAL_OUTPUT}/$folderName); do
    for ff in $(ls ${LOCAL_OUTPUT}/$folderName/$subdir | grep ".cat"); do
        NAME=`echo "$ff"| cut -d'.' -f1`
	cp ${LOCAL_OUTPUT}/$folderName/$subdir/$ff ${LOCAL_OUTPUT}/$folderName/$subdir/$NAME.csv
	rm ${LOCAL_OUTPUT}/$folderName/$subdir/$ff  
    done
done
