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
teaching: docs/svm-teaching-reflection.pdf docs/svm-teaching-philosophy.pdf


docs/svm-cv.pdf docs/svm-cv-jm.pdf:	docs/svm-cv.Rmd
	Rscript -e 'source("docs/make_cv.R")'
	
docs/svm-research-statement.pdf: docs/svm-research-statement.Rmd
	Rscript -e 'source("docs/make_research.R")'
	
docs/svm-societal-interaction.pdf: docs/svm-societal-interaction.Rmd
	Rscript -e 'source("docs/make_societal.R")'
	
docs/svm-teaching-philosophy.pdf: docs/svm-teaching-philosophy.Rmd
	Rscript -e 'source("docs/make_teaching-philosophy.R")'
	
docs/svm-teaching-reflection.pdf: docs/svm-teaching-reflection.Rmd
	Rscript -e 'source("docs/make_teaching-reflection.R")'
	
# I probably want to do something smarter here, but I just want to get this going
.PHONY: deaux

deaux:
	rm -f docs/*.log 