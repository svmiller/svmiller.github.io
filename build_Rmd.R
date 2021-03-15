# Derived from Ken Kellner's tutorial
# https://github.com/kenkellner/blog/blob/master/build_Rmd.R
args = commandArgs(trailingOnly = TRUE)
knitr::knit(args[1],output=paste(args[2],sep=''))