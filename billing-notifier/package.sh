#!/bin/sh

# Execute this locally to refresh package.zip

rm -rf ./.package
pip3 install -r requirements_package.txt -t ./.package

cd .package
zip -r ../package.zip .

cd ..
zip package.zip handler.py
