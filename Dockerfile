FROM kbase/kbase:sdkbase2.latest
MAINTAINER KBase Developer
# -----------------------------------------

# Insert apt-get instructions here to install
# any required dependencies for your module.

RUN apt-get update
COPY ./cpanfile /kb/module/cpanfile
WORKDIR /kb/module
RUN cpanm --reinstall JSON::XS
RUN cpanm -f --installdeps .
RUN apt-get -y install nano

# -----------------------------------------

ENV PATH /opt/conda/bin:$PATH
ENV LANG C
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

RUN conda update conda
RUN conda install python=3.7
RUN conda config --add channels  https://conda.anaconda.org/rdkit
RUN conda install -y zlib \
		     cairo \
                     nomkl \
                     pandas \
                     pymongo \
                     rdkit

# Catching means this layer may not get updated when the source does.
# I'm making the pickaxe version explicit here for consistency.
RUN cd /kb/dev_container/modules && \
   	mkdir Pickaxe && cd Pickaxe && \
    git clone https://github.com/JamesJeffryes/MINE-Database.git  && \
    cd MINE-Database && \
    git checkout 1e79696e0556e38a52238665cd35605cca561cab && \
    python3 setup.py install

RUN echo '/kb/module/lib/kb_picaxe/ python3 setup.py install'

COPY ./ /kb/module
RUN mkdir -p /kb/module/work
RUN chmod 777 /kb/module


WORKDIR /kb/module

RUN make all

ENTRYPOINT [ "./scripts/entrypoint.sh" ]

CMD [ ]
