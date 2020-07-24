# FitOCTdock
Package for running FitOCT UI in docker file ppernot1/fitoct

## How to update package and docker image 
1. generate source package FitOCTdock    
2. copy it in inst/FitOCTdockerFiles    
3. run `docker build -t ppernot1/fitoct`

The image is built upon `jrnold/rstan` 

## How to run the docker container
`docker run -d -p 3838:3838 ppernot1/fitoct`
