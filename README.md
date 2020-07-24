[![DOI](https://zenodo.org/badge/282165832.svg)](https://zenodo.org/badge/latestdoi/282165832)

# FitOCTdock
Package for running FitOCT UI in docker file ppernot1/fitoct

+ the FitOCT UI is issued from [FitOCT](https://github.com/ppernot/FitOCT)    
+ the docker image is built upon [docker-stan](https://github.com/jrnold/docker-stan)

## How to update package and docker image 
1. generate source package FitOCTdock    
2. copy it in inst/FitOCTdockerFiles    
3. run `docker build -t ppernot1/fitoct`


## How to run the docker container
`docker run -d -p 3838:3838 ppernot1/fitoct`
