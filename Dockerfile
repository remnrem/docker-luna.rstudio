FROM rocker/rstudio:3.5.2

WORKDIR /build


ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y zlib1g-dev fftw3-dev

RUN cd /build \
 && git clone https://github.com/remnrem/luna-base.git \
 && git clone https://github.com/remnrem/luna.git \
 && cd luna-base \
 && make -j 2 \
 && ln -s /build/luna-base/luna /usr/local/bin/luna \
 && ln -s /build/luna-base/destrat /usr/local/bin/destrat \
 && ln -s /build/luna-base/behead /usr/local/bin/behead \
 && ln -s /build/luna-base/fixrows /usr/local/bin/fixrows \
 && cd /build \
 && R -e "install.packages('git2r', repos='http://cran.rstudio.com/')" \
 && R -e "install.packages('plotrix', repos='http://cran.rstudio.com/')" \
 && R -e "install.packages('geosphere', repos='http://cran.rstudio.com/')" \
 && R -e "install.packages('matlab', repos='http://cran.rstudio.com/')" \
 && R CMD build luna \
 && LUNA_BASE=/build/luna-base R CMD INSTALL luna_0.25.5.tar.gz \
 && mkdir /home/rstudio/data \
 && mkdir /home/rstudio/data1 \
 && mkdir /home/rstudio/data2 \
 && mkdir /home/rstudio/tutorial \
 && cd /home/rstudio/tutorial \
 && wget http://zzz.bwh.harvard.edu/dist/luna/tutorial.zip \
 && unzip tutorial.zip \
 && rm tutorial.zip \
 && chown -R rstudio /home/rstudio
