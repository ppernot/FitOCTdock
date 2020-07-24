# MAJ de FitOCT
FROM ppernot1/fitoct

#RUN R -e "devtools::install_github('ppernot/FitOCTlib')"
COPY FitOCTdock_*.tar.gz  /FitOCTdock.tar.gz
RUN R -e "install.packages('FitOCTdock.tar.gz', repos = NULL, type = 'source')"

COPY Rprofile.site /usr/local/lib/R/etc
EXPOSE 3838
CMD ["R", "-e FitOCTdock::fitOCT()"]

