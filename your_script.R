library(ggplot2)

#commandArgs picks up the variables you pass from the command line
args <- commandArgs(trailingOnly = TRUE)

# Use the input argument
if (length(args) > 0) {
    print(args)
} else {
  cat("No argument was passed.\n")
}
