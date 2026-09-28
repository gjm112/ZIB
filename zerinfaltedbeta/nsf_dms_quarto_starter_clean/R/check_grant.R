# Run with:
#   quarto render grant.qmd
#
# Then inspect output/grant.pdf.
#
# Optional local source-word check:

source("R/grant_checks.R")

cat("Approximate source word count:", project_description_word_count(), "\n")
