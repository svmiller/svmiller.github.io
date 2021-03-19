rmarkdown::render("docs/svm-research-statement.Rmd", 
                  output_file="svm-research-statement.pdf", 
                  params=list(github="svmiller"),
                  rmarkdown::pdf_document(template = stevetemplates::templ_statement(), 
                                          latex_engine = "xelatex", dev="cairo_pdf"))
