knit2shiny = function(input) {
  if (!file_test('-d', 'www')) dir.create('www')
  in_dir('www', {
    on.exit(shiny_tags$restore(), add = TRUE)
    out = knit(file.path('..', input), output = 'index.md')
    res = shiny:::renderTags(shiny_tags$get('tags'))
    header = tempfile()
    writeLines(c(
      shiny:::shinyHead(res$singletons, charset = FALSE, jquery = FALSE), res$head
    ), con = header)
    library(rmarkdown)
    rmarkdown::render(
      'index.md',
      html_document(self_contained = FALSE, includes = includes(in_header = header))
    )
  })
  library(shiny)
  runApp('.')
}

#' @export
knit_print.shiny.tag = knit_print.shiny.tag.list = function(x) {
  # store all the tags so we can figure out the HTML head later
  shiny_tags$set(tags = c(shiny_tags$get('tags'), x))
  asis_output(paste('\n\n', format(x, indent = FALSE), '\n\n', sep = ''))
}

shiny_tags = new_defaults(list(tags = list()))
