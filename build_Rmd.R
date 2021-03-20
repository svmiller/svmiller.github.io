# Derived from Ken Kellner's tutorial
# https://github.com/kenkellner/blog/blob/master/build_Rmd.R
args = commandArgs(trailingOnly = TRUE)
knitr::knit(args[1],output=paste(args[2],sep=''))

# rmarkdown::render(args[1],output_file=paste('../',args[2],sep=''))
# ^ I still want to figure out a render option here, but I have that oddball Jekyll tag for my lead images.