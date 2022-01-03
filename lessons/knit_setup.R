## general knit options
knitr::opts_knit$set(base.url="",
                     base.dir="/Users/benski/orgs/edquant/edh7916/figures/")

knitr::opts_chunk$set(fig.path="../figures/",
                      dpi=90,
                      out.width="100%",
                      error = TRUE## ,
                      ## comment = NA
                      )

## limit output lines (h/t https://stackoverflow.com/a/23147563)
hook_output <- knitr::knit_hooks$get("output")
knitr::knit_hooks$set(output = function(x, options) {
  lines <- options$output.lines
  if (is.null(lines)) {
    return(hook_output(x, options))  # pass to default hook
  }
  x <- unlist(strsplit(x, "\n"))
  more <- "..."
  if (length(lines)==1) {        # first n lines
    if (length(x) > lines) {
      # truncate the output, but add ....
      x <- c(head(x, lines), more)
    }
  } else {
    x <- c(more, x[lines], more)
  }
  # paste these lines together
  x <- paste(c(x, ""), collapse = "\n")
  hook_output(x, options)
})
