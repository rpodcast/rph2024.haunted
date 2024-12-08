% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{import_quiz_question}
\alias{import_quiz_question}
\title{Import quiz question from JSON input}
\usage{
import_quiz_question(txt)
}
\arguments{
\item{txt}{String of the quiz question in JSON format}
}
\value{
a list with the following elements:
* place_name
* question_text
* correct_answer
* incorrect_choice_1
* incorrect_choice_2
* incorrect_choice_3
}
\description{
Import quiz question from JSON input
}
