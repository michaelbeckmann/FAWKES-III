############################################################################
### 01.1. set the working and temporary directories
###
### checks for nodename or username and sets directories accordingly
############################################################################

.setwdntemp <- function(){
  cu <- Sys.info()["user"]
  cn <- Sys.info()["nodename"]
  
  if (cn == "juro-MacBookPro"){
    path2wd <- "/home/juro/git/FAWKES-III/" #MB
    path2temp <- "/home/juro/git/FAWKES-III/temp/" #MB
    
  } else if (cn == "enter your name here"){
    path2wd <- "/Users/..."
    path2temp <- "/Users/...tmp/" 
  }  
  return(list(path2temp,path2wd))
}

set.list <-  .setwdntemp()
path2temp <- set.list[[1]]
path2wd <- set.list[[2]]

############################################################################
### 01.2. load libraries and functions
############################################################################

needed_libs <- c("ggplot2",# For plotting
                 "raster",# for adding map data
                 "rgdal", # for loading map data
                 "rgeos", # dependency for rgdal
                 "letsR",
                 "foreign",
                 #"ggplot",
                 "MASS",
                 "Hmisc",
                 "reshape2",
                 "VGAM"
)

usePackage <- function(p) {
  if (!is.element(p, installed.packages()[,1]))
    install.packages(p, dep = TRUE)
  require(p, character.only = TRUE)
}
sapply(needed_libs,usePackage)

rm(needed_libs)


############################################################################
### 01.3. load Natura2000 Species data
############################################################################

setwd(path2temp)

if (file.exists("PublicNatura2000End2016_csv.zip")==FALSE){
  download.file("https://www.dropbox.com/s/52y55t4qdjaflhi/PublicNatura2000End2016_csv.zip?dl=1", "PublicNatura2000End2016_csv.zip", mode="wb")
  unzip("PublicNatura2000End2016_csv.zip")
} else {unzip("PublicNatura2000End2016_csv.zip")}

### create table of all Bird species with Sitecodes and Conservation Status

N2000Species <- read.csv("SPECIES.csv",header=TRUE)
mySpeciesdata <- N2000Species[which(N2000Species$SPGROUP=="Birds"),c(2,3,4,16)] # only bird species
mySpeciesdata <- mySpeciesdata[which(mySpeciesdata$CONSERVATION=="A"|mySpeciesdata$CONSERVATION=="B"|mySpeciesdata$CONSERVATION=="C"),]       # remove Conservation Status = "NULL"

N2000Sites <- read.csv("NATURA2000SITES.csv",header=TRUE) 
mySPAsites <- N2000Sites[which(N2000Sites$SITETYPE=="A"|N2000Sites$SITETYPE=="C"),c(2,3)]  # take only SPA sites (where SITETYPE is A or C) and columns 2 and 3

mydata <- merge(mySpeciesdata, mySPAsites, by="SITECODE")

### load bird species lost and categories

if (file.exists("bird_categorization.csv")==FALSE){
  download.file("https://www.dropbox.com/s/bxf39frp982fe4z/bird%20categorization.csv?dl=1", "bird_categorization.csv", mode="wb")
  bird<-read.csv("bird_categorization.csv",sep=";")
} else {bird<-read.csv("bird_categorization.csv",sep=";")}


############################################################################
### 01.4. Load archetypes raster and Natura2000 shapefiles
############################################################################

if (file.exists("Archetypes_Levers_et_al_2015.zip")==FALSE){
  download.file("https://www.dropbox.com/s/2qybuvj1balvcwo/Archetypes_Levers_et_al_2015.zip?dl=1", "Archetypes_Levers_et_al_2015.zip", mode="wb")
  unzip("Archetypes_Levers_et_al_2015.zip")
} else {unzip("Archetypes_Levers_et_al_2015.zip")}

# load land system archetypes (15 classes)
LSA<-raster("LandSystemArchetypes_2006_Levers2015.tif")
#plot(LSA)
#hist(LSA)

# load archetypes change trajectories (17 classes)
ACT<-raster("ArchetypicalChangeTrajectories_1990_2006_Levers2015.tif")
values(ACT)[values(ACT) > 17] = NA       # there are only 17 categories: put all values > 17 to NAs
#plot(ACT)
#hist(ACT)

# load N2000 shapefile
Natura2000_shape <- readOGR(dsn = ".", layer = "Natura2000_end2016") 
sitecodes <- Natura2000_shape$SITECODE 

# subset N2000 dataset to use only SPAs and "both" (i.e. only those sites that are focusing on bird conservation)
N2000SPASiteCodes <- subset(N2000Sites$SITECODE,N2000Sites$SITETYPE=="A"|N2000Sites$SITETYPE=="C")  # 5572 sitecodes

# There are 3 Sitecodes which cannot be found in the SPA Shapefiles
overlapSPA <- sitecodes[which(as.character(sitecodes)%in%as.character(N2000SPASiteCodes)==T)]       # 5569 sitecodes
length(N2000SPASiteCodes)-length(overlapSPA)

############################################################################
### 01.5. Re-load previous workspace
############################################################################

#load("FAWKES.RData")