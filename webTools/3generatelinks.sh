cat="various"
for file in *.jpg;
  do echo '<div class="galleryThumbnail"><a href="images/artwork/'$cat'/'$file'" rel="shadowbox['$cat']"><img src="images/artwork/'$cat'/thumbs/'$file'"></a></div>';
done
