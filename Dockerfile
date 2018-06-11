FROM centos:latest

WORKDIR /work
VOLUME /work

ENV SEX_PKG sextractor-2.19.5-1.x86_64.rpm

#add files in run and setup to working directory
ADD ./run .
ADD ./setup .

RUN rpm --install --quiet $SEX_PKG

CMD bash /work/run.sh
