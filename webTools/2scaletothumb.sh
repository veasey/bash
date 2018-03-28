#!/bin/bash

# Batch processing to scale high res artwork photos to
# a thumbnail for links.

for file in *.jpg;
  do convert $file -resize 100x100 thumbs/$file;
done
