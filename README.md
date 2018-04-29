# BioNoMo Toolkit
R functions to prepare data for publication in the Biodiversity Network of Mozambique

---

This repo provides R functions and SQL code to prepare the data coming from various providers to be hosted on the Biodiversity Network of Mozambique (BioNoMo). [BioNoMo](http://bionomo.herokuapp.com/en/) is an initiative of the [SECOSUD II Italian Cooperation Project](http://www.secosud2project.com/), and it's aimed at developing a national platform for the collection, organization and sharing of information on biological diversity. BioNoMo is implemented in partnership with the major generators and providers of primary biodiversity data to create a national unified, open portal to research-grade information about biodiversity in Mozambique.
Although most of the functions' behaviour is very specific to BioNoMo purposes, anyone is allowed to use this code to create his/her own functions and to redistribute it freely under the terms of the GNU GPL v3.0 (see LICENSE for details).

---

## How to use the functions

You can see several folders in this repo, each named after a data provider, and containing functions that are specifically conceived to work with the particular data structure found at that institution. The "Taxonomy" folder contains some functions to review taxon names and correct typos, outdated naming etc. this can be useful in any case, and you should start from there. To facilitate the navigation inside these help page, see the following table of contents.

### Table of contents

1. [Taxonomy](#Taxonomy)
2. [IIP](#IIP)

---

### <a name="Taxonomy"></a>Taxonomy
The first thing to do when you have a list of identified species is to check that the spelling is correct (no typos) and that the identification is sound (the species is actually present in your study area) and up-to-date (the given name is accepted and not a synonym). Then, you have to build the taxon tree and transform it in a table with internal hierarchical reference (if you are building a new DB and not using Specify or similar software with a pre-built structure).

#### Phase 1: Check taxonomy
You will find an R script named '01-checkTaxonomyWin.R' inside the Taxonomy folder. This script defines the function called `checkTaxonomy()`. To create the function inside your R working environment, just source the script. You can do it by clicking the 'source' button after loading the script in RStudio editor, or in R prompt with the `source` command. Type `?source` for help on how to use it.
Before using the function, be sure your R installation meets all of its dependencies. `checktaxonomy()` requires the following packages to be installed:

* _psych_
* _data.table_
* _taxize_
* _ggplot2_
* _rgbif_

You can install those with the `install.packages` command in R prompt.

`checkTaxonomy()` does three things:

1. Checks the spelling of species names, and returns the correct version
2. Uses the correct name to search for the accepted name. This part is trickier, since there is no universal authority on accepted names. In general, we refer to different sources of information depending on the Kingdom we are working on:

    * Plants: Tropicos
    * Animals: NCBI

    We use NCBI for animals because it is the most comprehensive resource, but particular species names can be manually checked on ITIS, WoRMS, FishBase etc. if needed.

3. Searches for the accepted name on GBIF, and displays the records found in Southern Africa plotting the coordinates on a map. In this way, you can check if that species is actually present in the region.

`checkTaxonomy()` takes 4 arguments in the following order (or, as usual, by name):

1. **specieslist**: a matrix or a data frame with at least 1 column, containing species names as they appear in the original data. If the matrix contains more than one column, the species names must be in the first one. View 'Data format' below for detail.
2. **fir**: number of record (in order of appearance in the table) to start with (default=1).
3. **las**: number of record (in order of appearance in the table) to end with (default=5). It is generally advised to execute the function with 5 species at a time to avoid overloading the internet connection and to keep the output map readable.
4. **src**: Source of information. Input 'NCBI' for NCBI, 'iPlant_TNRS' for Tropicos, or 'MSW3' for Mammal Species of the World 3rd edition (default='NCBI').

_**Data format**_

The species list to be fed to the function has to be a matrix or a data frame containing at least one column (the first) with species names:

*specieslist* (data.frame / matrix)

|Column name    |Data type  |Details                            |
|---            |:---:      |:---:                              |
|\*any name\*   |CHAR/FACTOR|species names as in original data  |

_**Reading and using the results**_

Each time the function is executed, a table is returned in the standard output, containing the species names fed to the source, the correct name found (if any), and the accepted name. In addition, a map is plotted with the position of the species actually found in Southern Africa. For each species found in the region, the user must copy the accepted name returned from the source and paste it in the original data table or in a new table, keeping the reference (the taxon code, if any) to the original name. If the species is not found in the region, it is better to check the actual distribution manually before inserting it among the species present in the dataset.

#### Phase 2: Build the taxon tree
Once you're sure about your species names, you have to build the related tree by obtaining information about all the associated parent taxa. To do this, there is an R script named '02-taxonomic_names.R' inside the Taxonomy folder. This script defines the function called `get_tree()`. To create the function inside your R working environment, just source the script. You can do it by clicking the 'source' button after loading the script in RStudio editor, or in R prompt with the `source` command. Type `?source` for help on how to use it.
Before using the function, be sure your R installation meets all of its dependencies. `get_tree()` requires the following packages to be installed:

* _taxize_

You can install that with the `install.packages` command in R prompt.

`get_tree()` takes your species names and searches for parent taxa, building and returning a full taxon table with a separate column for each rank (Kingdom, Phylum, Class, Order, Family, Genus, Species). The function takes 2 arguments in the following order (or, as usual, by name):

1. **specieslist**: A data frame (see 'Data format' below for details about the required structure).
2. **db**: Database to query. either ‘ncbi’, ‘itis’, ‘eol’, ‘col’, ‘tropicos’, ‘gbif’, ‘nbn’, ‘worms’, or ‘natserv’. By default, it is set to 'dynamic', meaning that each species will be searched in the database associated to it in the 'source' column of **specieslist**.

_**Data format**_

The species list to be fed to the function has to be a data frame structured as follows (column names are case-sensitive).

*specieslist* (data.frame)

|Column name    |Data type  |Details                            |
|---            |:---:      |:---:                              |
|species        |CHAR/FACTOR|species names obtained from Phase 1|
|Author         |CHAR/FACTOR|Name of the Author (if known)      |
|source         |CHAR/FACTOR|source of species name information |
|origID         |CHAR/FACTOR|original species code (id)         |

_**Reading and using the results**_

`get_tree()` returns a full plain taxon table in the form of a data frame. The output is structured as follows:

*speciestable* (data.frame)

|Column name    |Data type  |Details                                               |
|---            |:---:      |:---:                                                 |
|Kingdom        |CHAR/FACTOR|Name of Kingdom                                       |
|Phylum         |CHAR/FACTOR|Name of Phylum                                        |
|Class          |CHAR/FACTOR|Name of Class                                         |
|Order          |CHAR/FACTOR|Name of Order                                         |
|Family         |CHAR/FACTOR|Name of Phylum                                        |
|Genus          |CHAR/FACTOR|Name of Genus                                         |
|Species        |CHAR/FACTOR|Name of Species                                       |
|Author         |CHAR/FACTOR|Name of the Author (as in input list)                 |
|source         |CHAR/FACTOR|Source of species name information (as in input list) |
|origID         |CHAR/FACTOR|original species code (as in input list)              |
|notes          |CHAR/FACTOR|comments on the output (see below)                    |
|origSp         |CHAR/FACTOR|Species name (as in input list)                       |

The user must control that the table is complete and no information is missing. Missing records will be marked with 'NOT FOUND' in the 'notes' column. In those cases, the search can be repeated on a different database (**db** parameter). Sometimes, the species name found on the remote database can be different from the original provided by the user: in this cases, records will be marked with 'INCONGRUENCE' in the 'notes' column. Please check those records carefully before proceeding. Another possible state of the 'notes' column is 'ERROR': this happens when an error is thrown during the search. Those records must be checked too before advancing to the next step.

#### Phase 3: Check consistency of the taxon tree
Before building the taxon catalogue, the consistency of your plain taxon table has to be checked. Sometimes, when searching for the same taxon in different databases, the resulting classification can be different (this is mostly due to synonymies). This can lead to inconsistencies, such as the same taxon having more than one parent (that are not really different, but just synonyms). Such inconsistencies break the hierarchical system of the taxon catalogue, and therefore cannot be left uncorrected. In order to identify the inconsistencies, there is an R script named '02-checkConsistency.R' inside the Taxonomy folder. This script defines the function called `checkConsistency()`. To create the function inside your R working environment, just source the script. You can do it by clicking the 'source' button after loading the script in RStudio editor, or in R prompt with the `source` command. Type `?source` for help on how to use it.

`checkConsistency()` controls each taxon in each rank to check if in the parent rank there is more than one associated taxon. In this case, it prints the taxon name together with the number of parents found. The function takes just one argument:

1. **x**: the taxon tree in the form of a dataframe, just as it resulted from the previous phase (see 'Reading and using the results' in 'Phase 2: Build the taxon tree').

_**Reading and using the results**_

If the function prints ('All good. Taxon tree is fully consistent'), your taxon tree is fully consistent and you can advance to the next phase. Otherwise, for each inconsistency found the function will print the name of the taxon and the number of parents it is associated with (e.g., 'Taxon Poaceae has two parents'). It will also print the total number of errors (e.g., 'Number of inconsistencies found: 4. Please check the taxa listed above and try again'). In this case, the user has to search for the listed taxa and correct the inconsistencies until each taxon has one and only one parent. To check if the corrections were successful, execute the function again until confirmation of full consistency is printed.

#### Phase 4: build the taxon catalogue

Once your taxon tree has been checked for consistency, you can start building the taxon catalogue, a hierarchical table in which each taxon is connected to its direct parent through an internal reference. To build the taxon catalogue, there is an R script named '04-taxonLookupTable_altID.R' inside the Taxonomy folder. This script defines the function called `taxonLookupTable_ID()`. To create the function inside your R working environment, just source the script. You can do it by clicking the 'source' button after loading the script in RStudio editor, or in R prompt with the `source` command. Type `?source` for help on how to use it.

`taxonLookupTable_ID()` controls each taxon in each rank to check if in the parent rank there is more than one associated taxon. In this case, it prints the taxon name together with the number of parents found. The function takes just one argument:

1. **x**: The taxon tree in the form of a dataframe, just as it resulted from Phase 2 and with the modifications(if any) introduced after checking the consistency in Phase 3 (see 'Reading and using the results' in 'Phase 2: Build the taxon tree' and the whole 'Phase 3' section).

_**Reading and using the results**_
`taxonLookupTable_ID()` returns a hierarchical taxon catalogue in the form of a data frame. The output is structured as follows:

*taxoncatalogue* (data.frame)

|Column name    |Data type  |Details                                               |
|---            |:---:      |:---:                                                 |
|id             |INT        |Unique numeric identifier                             |
|Taxon          |CHAR/FACTOR|Scientific name of taxon                              |
|Rank           |CHAR/FACTOR|Rank of taxon in the taxonomical hierarchy            |
|Author         |CHAR/FACTOR|Name of the Author (as in input table)                |
|Source         |CHAR/FACTOR|Source of taxon name information (as in input table)  |
|Parent         |INT        |id of parent taxon                                    |
|OrigID         |CHAR/FACTOR|original species code (as in input table)             |

After running the function, you can check the output by reconstructing some branches of the tree. To do this, start from the lower rank ('Species') and go up by following he internal reference (go to the id reported in the 'Parent' column to find the parent taxon, and repeat until you reach the highest rank). Check that your results match with the original taxon tree. 

#### Phase 5: add authorship to the taxa

As a final step, before your catalogue is ready to be imported into the database, author names have to be added to all taxa (when possible). To do this, there is an R script named '05-authority_search.R' inside the Taxonomy folder. This script defines the function called `authority_search()`. To create the function inside your R working environment, just source the script. You can do it by clicking the 'source' button after loading the script in RStudio editor, or in R prompt with the `source` command. Type `?source` for help on how to use it.
Before using the function, be sure your R installation meets all of its dependencies. `authority_search()` requires the following packages to be installed:

* _ritis_
* _taxize_

You can install those with the `install.packages` command in R prompt.

`authority_search()` takes your taxon names and searches for respective author names, returning the taxon catalogue with the Author field updated (where authorship information has been found). The source for author information is the Integrated Taxonomic Information System (ITIS). The function takes just one argument:

1. **taxoncatalogue**: The taxon catalogue in the form of a dataframe, just as it resulted from Phase 4 (see 'Phase 4: build the taxon catalogue').

The taxon catalogue as it results after running this function can be post-processed (reorganizing the fields as in the BioNoMo DB structure) and then imported into the database.

---

### <a name="IIP"></a>IIP
*#TODO*