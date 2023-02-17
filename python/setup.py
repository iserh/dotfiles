#!/usr/bin/env python
from setuptools import find_packages, setup

with open("requirements.txt") as f:
    deps = f.read().split("\n")

setup(
    name="{{PROJECT}}",
    version="0.1.0",
    description="{{DESCRIPTION}}",
    long_description=open("README.md", "r").read(),
    long_description_content_type="text/markdown",
    author="Henri Iser",
    author_email="iserhenri@gmail.com",
    url="{{URL}}",
    packages=find_packages(include=["{{PROJECT}}*"]),
    install_requires=deps,
)
