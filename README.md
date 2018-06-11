# TODO:
- [x]() list syntax required (any unordered or ordered list supported)
- [x]() this is a complete item
- [ ]() this is an incomplete item


# Introduction
This project from the Minden lab is a way to help you apply Source Extractor to detect changes in DIGE gels.

[Source Extractor][4] is a neural-network based star/galaxy classifier that we've also found to be useful for identifying and quantifying protein spots in DIGE gels. The advantage is that it’s free and open source, so we know where the values are coming from, which provides a more accurate and transparent way to measure protein changes. Here’s a [3-minute video overview of the project][5].

You can check out the on-line [documentation][6], the [official web page][7], and the [user forum][8]. 

Here’s a guide to take you from TIFF files to protein changes:

## 1. Install Docker and SourceExtractor
1. Docker is a way to install and run software on many platforms, similar to a virtual machine. This makes installing Source Extractor much easier and more secure. [Download it here][9].

2. Github is a way to host and update files. Download docker-sextractor [from our github][10].

3. Navigate to the Github folder you downloaded, and open it in Terminal.
> Hopefully we'll make this clickable and not require terminal

Install:
\`Bash build-run.sh

4. Optional: Install some useful DIGE and SExtractor macros:

Copy `DIGE_SExtractor_tools.txt` to ImageJ/macros/toolsets

## 2. Prepare files
- In ImageJ, save the Cy3 and Cy5 TIFF images as FITS files in the folders `input_fits_3` and `input_fits_5`
- Make a merged sum: paste control → add, copy and paste one window on to the other. Save the result as a FITS file in the folder `fitsSum` 
- Make sure all files have the same name

- Run `docker run dige-sextractor`

Afterwards you should find:
- **Aper files** are masks that you can open in ImageJ to check that there's a reasonable size. Dotted lines mean less confidence.

- The **cat folder** is where you get raw intensity values. You can open in excel and make the columns index, x, y, raw intensity. 

- [ ]() What are the other columns produced in cat files? What is the thershold of confidence for dotted circles? are the coordinates a centroid?

Note: Sometimes the y coordinate will be inverted. In that case, in imageJ, analyse / set measurements / invert y coordinate

## 3. Tune segmentation parameters

- [ ]() Coming soon to a readme near you!

This section should include:
- [ ]()  Key parameters
- [ ]() Intuition on what they mean
- [ ]() How to adjust them
- [ ]() Recommended range
- [ ]() Possible example images

`ANALYSIS_THRESH 1.7`
Threshold to start running analysis, measured in in number of sigmas over background RMS. 

`DETECT_MINAREA 10`		
minimum number of pixels above threshold

`DETECT_MAXAREA` 
Can be used to avoid objects larger than a set number of pixels, for example, _Drosophila_ yolk.

`DETECT_THRESH	1.7`
\<sigmas\> or \<threshold\>,\<ZP\> in mag.arcsec-2

`DEBLEND_NTHRESH	64`	
Number of deblending sub-thresholds

`DEBLEND_MINCONT	0.00001`
Minimum contrast parameter for deblending 
0 picks up the faintest objects/ 1 turns deblending off. For faint images, we recommend 0, otherwise turn up to 0.0001

`BACK_SIZE	16`
Size of the background mesh: \<size\> or \<width\>,\<height\> 
The default is 32, but I recommend 8-16.

If this is too small, the background estimation gets distracted by objects and noise, and the signal gets absorbed into noise. 
If this is too big, you miss the small-scale variation in background. 

32-256 is normal for stars. I thought DIGE would have much less background variation, meaning bigger is better, but 16 seems to be a good compromise based on fly data. 8 is also reasonable, and will give smaller ROIs.

`BACK_FILTERSIZE 3`
Background filter: \<size\> or \<width\>,\<height\>

`BACK_TYPE MANUAL `
- [ ]() still trying this out

`BACK_VALUE 300` 
- [ ]() still trying this out

- [ ]() What's ASSOC?

## 4. Decide on guidestars

- [ ]() How do you look at raw values in excel?

SExtractor will output a .cat file
rename your .cat file .csv
Open a new Excel document and select file / import / CSV file
Save as CSV

You can visualize these coordinates in ImageJ/Fiji: 
- Install the ImageJ macros as described in 1.4 above
- In ImageJ, click the double red arrow on the right and load `DIGE_SExtractor_tools`
- Click the button labeled “Import XY… Tool”
- Select your CSV file
You should get something that looks like “example of imported coordinates.png”

If you want to only load some points, you might want to copy and paste only those coordinates into a new CSV file. Any columns that you delete in excel you also have to select and "clear contents" or there will be extra spaces and the macro will get confused.

- Across at least 3 biological replicates, look at all the raw values. Find 5-6 spots that are evenly distributed through the gel and don't change more than 6% between Cy5 and Cy3

- Take a ratio of Cy5 to Cy3 for each guide star, take an average, and multiply the raw values by that correction factor.

Consider making the ratio less than 1 to prevent stack overflow. A good correction factor is within 30%.

## 5. Quantify changes
- In Excel, multiply one channel by the correction factor. Now all the guide stars should be about the same between channels.

- Then calculate fold ratio changes, and set a threshold

More than a hundred changes is probably too many.

Rejoice! You’ve identified and quantified protein changes in DIGE gels!

## About the authors


## PS: Troubleshooting importing XY coordinates into ImageJ
It's possible to import points from a text file too, provided you put it in this format:
	`
	points
	n
	x1 y1
	x2 y2
	...
	xn yn
	```
Where n is the total number of points you have.

For troubleshooting purposes, make some dummy points and use the Export XY macro to see the format it expects. You can then copy your data over that file.

Note that the Import XY macro inverts the Y coordinate in line 41:

`ypoints[i-1] = parseInt(1023-line[iY]);`

If you want to keep the Y coordinates as they are, just delete the "1023-" part.

[4]:	http://astromatic.net/software/sextractor
[5]:	https://www.youtube.com/watch?v=ZZwJOo-vCFU
[6]:	http://sextractor.readthedocs.org
[7]:	http://astromatic.net/software/sextractor
[8]:	http://astromatic.net/forum/forumdisplay.php?fid=4
[9]:	[https://www.docker.com/community-edition]
[10]:	[https://github.com/peptidoglycanthrope/docker-sextractor]
