#!/bin/bash

# Batch processing to scale high res artwork photos to
# a more managable size.

for file in *.jpg;
  do convert $file -resize 1024x768 $file;
done
