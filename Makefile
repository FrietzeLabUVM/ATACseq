SHELL := /bin/bash

# Targets
TARGETS = .conda .channels .envs .homer
PBASE=$(shell pwd)

all:   	$(TARGETS)

.conda:
	wget 'https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh' && bash Miniconda3-latest-Linux-x86_64.sh -b -p ${PBASE}/bin && rm -f Miniconda3-latest-Linux-x86_64.sh && touch .conda

.channels: .conda
	export PATH=${PBASE}/bin/bin:${PATH} && conda config --add channels defaults && conda config --add channels conda-forge && conda config --add channels bioconda && touch .channels

.envs: .conda .channels
	conda create -p bin/envs/atac --file atac.env.txt && conda create -p bin/envs/atac2 --file atac2.env.txt

.homer: .conda .channels .envs
	export PATH=${PBASE}/bin/bin:${PATH} && source activate ${PBASE}/bin/envs/atac2 && perl ${PBASE}/bin/envs/atac2/share/homer-4.9.1-6/configureHomer.pl -install hg19 && source deactivate && touch .homer

clean:
	rm -rf $(TARGETS) $(TARGETS:=.o) bin/
