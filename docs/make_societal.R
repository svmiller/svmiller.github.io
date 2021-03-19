rmarkdown::render("docs/svm-societal-interaction.Rmd", 
                  output_file="svm-societal-interaction.pdf",
                  rmarkdown::pdf_document(template = stevetemplates::templ_statement(), 
                                          latex_engine = "xelatex", dev="cairo_pdf"))
