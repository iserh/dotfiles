SHELL := /bin/bash
VENV_NAME?=.venv
PYTHON=${VENV_NAME}/bin/python
PIP=${VENV_NAME}/bin/pip
# IMAGE_NAME=<image_name>
# PORT=<port>

.PHONY: help prepare_venv init test format lint licenses run build-image run-image

.DEFAULT: help

help:
	@echo "make prepare_venv"
	@echo "    create virtualenv"
	@echo "make init"
	@echo "    make prepare_venv and install dependencies"
	@echo "make test"
	@echo "    run tests using pytest"
	@echo "make format"
	@echo "    use isort, reindent & black to format source code"
	@echo "make lint"
	@echo "    use flake8 to lint source code"
	@echo "make licenses"
	@echo "    create LICENSES folder with pip licenses"
# @echo "make run"
# @echo "    run service"
# @echo "make build-image"
# @echo "    build docker image ${IMAGE_NAME}:latest"
# @echo "make run-image"
# @echo "    run docker image ${IMAGE_NAME}:latest on port ${PORT}"

prepare_venv:
	@python -m venv .venv

init: prepare_venv
	${PIP} install -r requirements.txt

test:
	${PYTHON} -m pytest

format:
	${PYTHON} -m isort $$(find . -type f -name '*.py')
	${PYTHON} -m reindent -r -n .
	${PYTHON} -m black .

lint:
	${PYTHON} -m flake8 $$(find . -type f -name '*.py')

licenses:
	${PIP}-licenses --format=plain-vertical --with-license-file --no-license-path --output-file=./LICENSES/licenses.txt
	${PIP}-licenses --with-urls --output-file=./LICENSES/LICENESES-INFO.txt

# run:

# build-image:

# run-image:
