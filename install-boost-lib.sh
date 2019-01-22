#!/bin/bash

cp libboost*.a /usr/local/lib
cp libboost*.dylib /usr/local/lib
cd /usr/local/lib
for f in libboost*.dylib; do
  ln -s "$f" "${f}-mt.dylib"
done