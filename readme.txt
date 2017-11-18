## Purpose
To calculate relative yield for georeference points located in Cook East

## Methods

Many normalization methods have been tested (see Kedar's manuscripts).  The method that was determined suitable for Cook was normalizing by the mean yield of a given crop collected from a given strip.  Each strip has a different history of crop rotation, fertilization rates, etc, so bounding the mean spatially to a given strip prevents many confounding factors.

* Note, the raw files found in Kedar's desktop suggest that he did not actually find the mean of each strip and instead grouped proximate strips where the same crop was planted.  There is a very likely chance that the files found (RYAvg.xlsx) are not the same data he used for analysis.

* Note, most strips were planted in the same crop other than 2016 where spring canola was planted erroneously in a winter wheat strip (C1 and C2). Care was taken to ensure that only the correct georeference points where used to calculate the respective mean and relative yields.

## To do
[ ] The script currently expects an intermediate file format and not the final format expected for the yield dataset.  These scripts and values should be updated once the final format is determined and data populated.