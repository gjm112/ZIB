# NSF proposal checks
#
# These checks are intentionally advisory. They do not replace NSF's
# submission system or the official solicitation/PAPPG.

count_words <- function(path = "grant.qmd") {
  txt <- paste(readLines(path, warn = FALSE), collapse = "\n")

  # Remove YAML front matter, code fences, Quarto directives, and comments.
  txt <- sub("^---.*?---", "", txt, perl = TRUE)
  txt <- gsub("```.*?```", " ", txt, perl = TRUE)
  txt <- gsub("<!--.*?-->", " ", txt, perl = TRUE)
  txt <- gsub(":::.*", " ", txt)
  txt <- gsub("\\{\\{<.*?>\\}\\}", " ", txt)
  txt <- gsub("!\\[.*?\\]\\(.*?\\)", " ", txt)

  words <- unlist(strsplit(trimws(txt), "\\s+"))
  words <- words[nzchar(words)]

  length(words)
}

project_description_word_count <- function() {
  sections <- list.files("sections", pattern = "\\.qmd$", full.names = TRUE)
  txt <- paste(unlist(lapply(sections, readLines, warn = FALSE)), collapse = "\n")
  txt <- gsub("```.*?```", " ", txt, perl = TRUE)
  txt <- gsub("<!--.*?-->", " ", txt, perl = TRUE)
  words <- unlist(strsplit(txt, "\\s+"))
  words <- words[nzchar(words)]
  length(words)
}

grant_page_check <- function() {
  message("Advisory proposal checks:")
  message("  Project Description source word count: ",
          project_description_word_count())
  message("  Note: page count must be checked from the rendered PDF.")

  cat(
    "\\begin{center}\\small ",
    "Proposal source word count: ",
    project_description_word_count(),
    ". Page count should be verified from the rendered PDF against the ",
    "current NSF solicitation/PAPPG. ",
    "\\end{center}",
    sep = ""
  )
}
