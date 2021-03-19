SRC=_rmd
BUILD=_posts

RMD_IN = $(wildcard $(SRC)/*.Rmd)
RMD_OUT := $(patsubst $(SRC)/%.Rmd,$(BUILD)/%.md,$(RMD_IN))

$(BUILD)/%.md: $(SRC)/%.Rmd
	Rscript build_Rmd.R $< $@
    
posts: $(RMD_OUT)
	@echo "Done"


cv: docs/svm-cv.pdf docs/svm-cv-jm.pdf

docs/svm-cv.pdf docs/svm-cv-jm.pdf:	docs/svm-cv.Rmd
	Rscript -e 'source("docs/make_cv.R")'