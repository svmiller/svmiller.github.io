# Make commands/targets for rendering/knitting posts

SRC=_rmd
BUILD=_posts

RMD_IN = $(wildcard $(SRC)/*.Rmd)
RMD_OUT := $(patsubst $(SRC)/%.Rmd,$(BUILD)/%.md,$(RMD_IN))

$(BUILD)/%.md: $(SRC)/%.Rmd
	Rscript build_Rmd.R $< $@
    
posts: $(RMD_OUT)
	@echo "Done"

# Make commands/targets for rendering/knitting job docs

cv: docs/svm-cv.pdf docs/svm-cv-jm.pdf
research: docs/svm-research-statement.pdf
societal: docs/svm-societal-interaction.pdf

docs/svm-cv.pdf docs/svm-cv-jm.pdf:	docs/svm-cv.Rmd
	Rscript -e 'source("docs/make_cv.R")'
	
docs/svm-research-statement.pdf: docs/svm-research-statement.Rmd
	Rscript -e 'source("docs/make_research.R")'
	
docs/svm-societal-interaction.pdf: docs/svm-societal-interaction.Rmd
	Rscript -e 'source("docs/make_societal.R")'