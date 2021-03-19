rmarkdown::render("docs/svm-teaching-philosophy.Rmd", 
                  output_file="svm-teaching-philosophy.pdf",
                  rmarkdown::pdf_document(template = stevetemplates::templ_statement(), 
                                          latex_engine = "xelatex", dev="cairo_pdf"))
