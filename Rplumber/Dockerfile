# Version: 0.0.1
FROM trestletech/plumber
MAINTAINER bio.xfu@gmail.com

RUN R -e "install.packages('dplyr')"
RUN R -e "install.packages('dbplyr')"
RUN R -e "install.packages('data.table')"
RUN R -e "install.packages('RSQLite')"
RUN R -e "install.packages('ggplot2')"
RUN wget https://bioconductor.org/packages/release/bioc/src/contrib/drawProteins_1.0.0.tar.gz;\
    R CMD INSTALL drawProteins_1.0.0.tar.gz;

CMD ["/app/plumber.R"]
