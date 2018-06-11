#!/bin/sh
echo "ready"
# A script that takes a directory full of FITS files, run SExtractor on
# each of them, and outputs the check images and catalog files in
# another directory. Note that both types of check images - APERTURES
# and SEGMENTATION - are generated.

# K. Arun <karbak@cmu.edu>
# 2002/12/30
#
# Updated March 6, 2018
# Ardon Shorr
# Ardon.Shorr@gmail.com
#

# Variables
SX=/usr/bin/sex;
BASE_DIR=.
SX_CONFIG=${BASE_DIR}/DIGE.sex
SX_PARAM=${BASE_DIR}/DIGE.param
FITS_3_DIR=${BASE_DIR}/input_fits_3
FITS_5_DIR=${BASE_DIR}/input_fits_5
FITS_SUM_DIR=${BASE_DIR}/input_fits_sum
APER_3_DIR=${BASE_DIR}/output_image_3
CAT_3_DIR=${BASE_DIR}/output_numbers_3
APER_5_DIR=${BASE_DIR}/output_image_5
CAT_5_DIR=${BASE_DIR}/output_numbers_5
echo "pre sanity"
# Sanity checking
if [ ! -e $SX ]; then
    echo "Cannot find SExtractor executable.";
    exit;
fi

if [ ! -e $SX_CONFIG ]; then
    echo "Cannot find SExtractor configuration file.";
    exit;
fi

if [ ! -d $BASE_DIR ]; then
    echo "Cannot find directory with original FITS images.";
    exit;
fi

# Create output directories if they don't exist
if [ ! -d $APER_3_DIR ]; then mkdir $APER_3_DIR; fi
if [ ! -d $CAT_3_DIR ]; then mkdir $CAT_3_DIR; fi
if [ ! -d $APER_5_DIR ]; then mkdir $APER_5_DIR; fi
if [ ! -d $CAT_5_DIR ]; then mkdir $CAT_5_DIR; fi
if [ $? -ne 0 ]; then echo "Could not create a required output directory."; exit; fi

# Build up a list of files and run SExtractor twice on each file,
# putting results into respectively allocated output directories

for i in ${FITS_SUM_DIR}/*
do
  if [ -e $i ]; then
      file_base=`basename $i | sed -e 's/.fits$//'`
echo "FILE_BASE: $file_base"
# Generate apertures image for Cy3 images
      ${SX} -c ${SX_CONFIG} -CHECKIMAGE_TYPE APERTURES \
	  -CHECKIMAGE_NAME ${APER_3_DIR}/${file_base}_cy3_aper.fits \
	  -CATALOG_NAME ${CAT_3_DIR}/${file_base}_cy3.cat \
          -PARAMETERS_NAME ${SX_PARAM} $i,${FITS_3_DIR}/${file_base}.fits
# Generate apertures image for Cy5 images
      ${SX} -c ${SX_CONFIG} -CHECKIMAGE_TYPE APERTURES \
	  -CHECKIMAGE_NAME ${APER_5_DIR}/${file_base}_cy5_aper.fits \
	  -CATALOG_NAME ${CAT_5_DIR}/${file_base}_cy5.cat \
          -PARAMETERS_NAME ${SX_PARAM} $i,${FITS_5_DIR}/${file_base}.fits
  fi
done
