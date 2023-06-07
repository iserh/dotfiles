SHELL := /bin/bash

.DEFAULT: help
help:
	@echo "make test"
	@echo "    run tests using pytest"
	@echo "make format"
	@echo "    use isort, reindent & black to format source code"
	@echo "make lint"
	@echo "    use flake8 to lint source code"

test:
	python -m pytest

format:
	isort $$(find src/ tests/ -type f -name '*.py')
	reindent -r -n src/ tests/
	black src/ tests/

lint:
	flake8 $$(find src/ tests/ -type f -name '*.py')
