rmarkdown::render("docs/svm-teaching-reflection.Rmd", 
                  output_file="svm-teaching-reflection.pdf",
                  rmarkdown::pdf_document(template = stevetemplates::templ_statement(), 
                                          latex_engine = "pdflatex", dev="cairo_pdf", fig_caption = TRUE, citation_package = "natbib"))
