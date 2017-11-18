## 11/13/2017
* [Field_Plan_Final]
	* Files inside folder from OneDrive [\Projects\CookEastGeospatialFieldsAndStrips\Received\CookEastStrips]
* [CookEastBoundary_20171106.json]
	* From Azure Cosmos DB (ltarcaf-docdb/cafdb/items).  Filename is the ID.
	
## 11/14/2017
* [CookEast_GeoreferencePoints_20171117.json]
	* From Azure Cosmos DB (ltarcaf-docdb/cafdb/items).  Filename is the ID.
* [HY2015GP_GrainWeightOnly_171020.csv]
	* From OneDrive [\Projects\CookEastPlantHandHarvest\1999-2016\Working\Excel\Export]
	
## 11/15/2017
* [RYAvg.xlsx]
	* From Kadar's data on CAHNRS Cloud drive: [L:\Inbox\FromKedarKoirala_170331\Desktop\RYAvg.xlsx]
* [HY2008GP_CopiedFromRYAvg_171115.csv]
	* Data was transformed (copy/pasted) from RYAvg.xlsx. Note that column is labeled GrainWeightWet but is actually yield (g/m2)
	
## 11/17/2017
* [HY2013GP_GrainWeightOnly_171020.csv]
	* Copied from OneDrive: [\Projects\CookEastPlantHandHarvest\1999-2016\Working\Excel\Export]
* [HY2016GP_GrainWeightOnly_171020.csv]
	* Copied from OneDrive: [\Projects\CookEastPlantHandHarvest\1999-2016\Working\Excel\Export]
* [Cook Farm All years all points.xlsx]
	* Copied from OneDrive: [\Projects\CookEastPlantHandHarvest\1999-2016\Received\FromDaveHuggins_160801_oldDataBackup]
* [HY1999GP_CopiedFromRYAvg_171117.csv]
	* Data was transformed (copy/pasted) from [RYAvg.xlsx]
	* Transformation
		* "spring wheat" to "SW"
		* "Sample Location" to "ID2"
		* Used "total grain yield dry (grams)", column "AK" for "GrainWeightWet" since missing a lot of "dry" values
			* Set values of -99999 to ""
		
* [HY2008GP_CopiedFromRYAvg_171117.csv]
	* Data was transformed (copy/pasted) from [Cook Farm All years all points.xlsx]
	* Differs from previous version by using total grain wet mass (g)
	* "Sample Location" to "ID2"
	* Added row for units
	* Swapped columns so order Northing, Easting (I had it wrong)
* [HY2013GP_GrainWeightOnly_171117.csv]
	* Added row for units
* [HY2015GP_GrainWeightOnly_171117.csv]
	* Added row for units
* [HY2016GP_GrainWeightOnly_171117.csv]
	* Added row for units