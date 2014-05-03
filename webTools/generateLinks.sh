cat="cars"
for file in *.jpg;
  do echo '<a href="images/artwork/'$cat'/'$file'" rel="shadowbox"><img src="images/artwork/'$cat'/thumbs/'$file'"></a>';
done
