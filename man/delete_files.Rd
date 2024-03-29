% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/delete_files.R
\name{delete_files}
\alias{delete_files}
\title{Delete files on HDFS.}
\usage{
delete_files(hdfsUri, dirUri, user_name, delete_all = TRUE, fname = "")
}
\arguments{
\item{hdfsUri}{, hdfs url}

\item{dirUri}{, path to directory of interest}

\item{user_name}{, user name with overwrite credential}

\item{delete_all}{, default set to TRUE, to delete all files in folder}

\item{fname}{, default set to empty string, if only one file is to be delete set delete_all to FALSE and name it here}
}
\value{
nada , delete one file or all files in hdfs directory
}
\description{
Delete files on HDFS.
}
