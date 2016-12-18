# Readme

This project will attempt to predict the likelihood of West Nile Virus in mosquitos captured using traps around Chicago, IL. The data sets originate from the Kaggle competition, [West Nile Virus Prediction](https://www.kaggle.com/c/predict-west-nile-virus). 

To recreate my analysis, clone this repository or download the project to your computer. Then download the data files from Kaggle. The files need to be unzipped and placed in a folder called 'data' in the project folder. 

All code is found in the src folder. The R scripts are to be run in order of their filename, so 01_weather.R should be the first script run. The technical draft and other .Rmd files can then be knitted. 

## Necessary packages
* tidyverse
* plyr
* caret
* ggmap
* gganimate
* animation
* caTools
* zoo
* ROCR
* pROC