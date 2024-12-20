#!/bin/sh +x
trash bootstrap-files
mkdir bootstrap-files
cd files
git switch bootstrap
cp -r * ../bootstrap-files
cd ..
