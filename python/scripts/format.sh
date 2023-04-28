#!/usr/bin/env bash
isort $(find . -type f -name '*.py')
python -m reindent -r -n $(find . -type f -name '*.py')
black .
