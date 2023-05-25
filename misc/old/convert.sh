
# brew install libpng
# brew install libjpeg
# brew install imagemagick
# brew install gs

convert image.png \
  -format pbm \
  -write image.pbm

# potrace -s -o image.svg image.pbm
