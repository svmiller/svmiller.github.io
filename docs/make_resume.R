rmarkdown::render("docs/svm-resume.Rmd", 
                  output_file="svm-resume.pdf",
                  rmarkdown::pdf_document(template = stevetemplates::templ_resume(), 
                                          latex_engine = "xelatex", dev="cairo_pdf"))
