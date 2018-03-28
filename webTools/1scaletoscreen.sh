#!/bin/bash

# Batch processing to scale high res artwork photos to
# a more managable size.

# rename them all lowecase for the love of god
find . -type f | perl -n -e 'chomp; system("mv", $_, lc($_))'
rename 's/ /_/g' *

for file in *.jpg;
  do convert $file -resize 1024x768 $file;
done
