############################################################################
### 00.1. set the working and temporary directories
###
### checks for nodename or username and sets directories accordingly
### please add } else if ... to the function here to specify directories to work in
### use Sys.info() to identify username or nodename (username works better on macOS)
### defines path2temp and path2wd which will be used throughout
############################################################################

.setwdntemp <- function(){
  cu <- Sys.info()["user"]
  cn <- Sys.info()["nodename"]
  
  if (cu == "christopherhassall") ## example, please adjust
  {
    path2temp <- "/Users/christopherhassall/Dropbox/000FAWKES/FAWKESII/temp/" #CH
    path2wd <- "/Users/christopherhassall/Dropbox/000FAWKES/FAWKESII/" #CH
    
  } else if (cu == "fbscha") ## example, please adjust
  {
    path2temp <- "H:/Document Files/Research/FAWKES II/Temp/" #CH
    path2wd <- "H:/Document Files/Research/FAWKES II/git/" #CH

      } else if (cn == "juro-MacBookPro"){
    path2wd <- "/home/juro/git/FAWKESII/" #MB
    path2temp <- "/home/juro/tmp/FAWKESII/" #MB
    
      } else if (cn == "CLE179L"){
        path2wd <- "C:/Users/cord/Documents/FAWKESII/" #AC
        path2temp <- "C:/Daten/Konferenzen_Workshops/2016/FAWKES_2/tmp_git/" #AC

    } else if (cn == "CLE175L"){
  path2wd <- "C:/Users/kaim/Andrea/Git/FAWKESII/" #AK
  path2temp <- "C:/Users/kaim/Andrea/tmp" #AK
  
    } else if (cn == "CLE185L"){
      path2wd <- "C:/Users/hoelting/Documents/FAWKES/git/FAWKES-III/" #LH
      path2temp <- "C:/Users/hoelting/Documents/FAWKES/git/tmp" #LH
  
  } 
  return(list(path2temp,path2wd))
}

set.list <-  .setwdntemp()
path2temp <- set.list[[1]]
path2wd <- set.list[[2]]

############################################################################
### 00.2. source all relevant R scripts
###
### to be added
############################################################################

### helper function
"%+%" <- function(x,y)paste(x,y,sep="")

### load libraries, functions and google sheets 
source(path2wd %+% "01_load_libraries_and_functions.R")
source(path2wd %+% "02_load_data.R")
#source(path2wd %+% "03_Species_trends_IUCN_script.R") # works but takes very long time
#source(path2wd %+% "04_Natura2000_Pressures.R")
#source(path2wd %+% "05_Text_mining_Natura2000.R")

############################################################################
###  DATA ANALYSIS
############################################################################

############################################################################
###  Plotting & Model Diagnostics
############################################################################

