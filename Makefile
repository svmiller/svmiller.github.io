SRC=_rmd
BUILD=_posts

RMD_IN = $(wildcard $(SRC)/*.Rmd)
RMD_OUT := $(patsubst $(SRC)/%.Rmd,$(BUILD)/%.md,$(RMD_IN))

$(BUILD)/%.md: $(SRC)/%.Rmd
	Rscript build_Rmd.R $< $@
    
all: $(RMD_OUT)
	@echo "Done"