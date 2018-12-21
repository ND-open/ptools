#
#
#
# main <- function(arg){
#
#         # require(tidyverse)
#         # require(httr)
#
#         hdfsUri <- arg[1]
#         dirUri <- arg[2]
#         destUri <- arg[3]
#
#         # ===== Getting file names to move
#
#         filelist <-
#                 # LISTSTATUS is the webHDFS equivalent of `$ ls`
#                 paste0(hdfsUri, dirUri, "?op=LISTSTATUS") %>%
#                 GET() %>%
#                 content(type = "application/json") %>%
#                 pluck(1, 1) %>%
#                 map_dfr(as_tibble)
#
#         # filelist %>% glimpse()
#
#         if (dim(filelist)[1] == 0){stop("Pas de nouveaux fichiers a traiter")}
#         else{
#
#                 fnames <- filelist %>%
#                         pull("pathSuffix")
#
#
#                 cat("fnames", fnames, "\n")
#
#                 # ===== Reading parameter
#                 optionnalParameters <- ""
#                 readParameter <- "?op=OPEN"
#
#                 # ===== Writing parameter
#                 optionnalParametersWrite <- "&overwrite=true&user.name=as24user"
#                 writeParameter <- "?op=CREATE"
#
#                 # ===== Delete parameter
#                 deleteParameter <- "?op=DELETE"
#
#                 for (fname in fnames){
#
#                         # Load
#                         uri <- paste0(hdfsUri, dirUri, fname, readParameter, optionnalParameters)
#                         download.file(uri, fname)
#
#                         # Save
#                         uriToWrite <- paste0(hdfsUri, destUri, fname, writeParameter, optionnalParametersWrite)
#                         response <- PUT(uriToWrite)
#                         # Get the url of the datanode returned by hdfs
#                         uriWrite <- response$url
#                         # Upload the file with a PUT request
#                         responseWrite <- PUT(uriWrite, body = upload_file(fname))
#                         # removes the temporary file
#                         if(tryCatch(file.remove(fname), silent=T, message=NULL)){}
#
#                         # Delete
#                         uriToDelete <- paste0(hdfsUri, dirUri, fname, deleteParameter, optionnalParametersWrite)
#                         response <- DELETE(uriToDelete)
#                 }
#         } # else non error
#
# } # main
#
# # main(commandArgs(trailingOnly = TRUE))
#
# # ===== to test

