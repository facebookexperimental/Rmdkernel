# Copyright (c) IRkernel authors
# Copyright (c) Meta Platforms, Inc. and affiliates.

.PHONY: Rmdkernel.pdf docs check test docker_dev_image docker_dev docker_test

DEV_IMAGE:=jupyter/r-notebook-dev

Rmdkernel.pdf: man/*.Rd
	RD2PDF_INPUTENC=inputenx R_RD4PDF=ae,hyper R CMD Rd2pdf --force --batch --no-preview --encoding=UTF-8 --output=$@ .

docs:
	Rscript -e "library(devtools); document('.'); check_doc()"

check:
	Rscript -e "library(devtools); check()"

test: 
	Rscript  -e "library(testthat); test()"

docker_dev_image:
	@docker build -f Dockerfile.dev -t $(DEV_IMAGE) .

docker_dev: docker_dev_image
	@docker run -it --rm \
	-p 8888:8888 \
	-v `pwd`:/src_rmdkernel \
	$(DEV_IMAGE) bash -c 'R CMD INSTALL -l /opt/conda/lib/R/library /src_rmdkernel && \
	                        jupyter notebook --no-browser --port 8888 --ip='*''

docker_test: docker_dev_image
	@echo 'Running Rmdkernel tests'
	@docker run -it --rm \
		-v `pwd`:/src_rmdkernel \
		$(DEV_IMAGE) bash -c 'R CMD build /src_rmdkernel && \
		R CMD check Rmdkernel*.tar.gz'
