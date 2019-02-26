

#' copy_files
#'
#' @param hdfsUri, the Uniform Resource Identifier of the HDFS used
#' @param dirUri, the path to the directory to move files from
#' @param destUri, the path to the directory to move files to
#' @param user_name, a user name with write and delelete rights
#'
#' @return Nothing. All files within directory will be copied from one folder to another.
#' @export
#' @import httr
#' @importFrom utils download.file

move_files <- function(hdfsUri, dirUri, destUri, user_name){

        # ===== Getting file names to move
        # filelist <- list_files()
        fnames <- list_files(hdfsUri, dirUri)

        # if (dim(filelist)[1] == 0){stop("There is no new file to process")}
        if (length(fnames) == 0){stop("There is no new file to process")}
        else{
                cat("The following files will be moved :\n", fnames, "\n")

                # ===== Reading parameter
                optionnalParameters <- ""
                readParameter <- "?op=OPEN"

                # ===== Writing parameter
                optionnalParametersWrite <- paste0("&overwrite=true&user.name=", user_name)
                writeParameter <- "?op=CREATE"

                for (fname in fnames){

                        # Load
                        uri <- paste0(hdfsUri, dirUri, fname, readParameter, optionnalParameters)
                        download.file(uri, fname)

                        # Save
                        uriToWrite <- paste0(hdfsUri, destUri, fname, writeParameter, optionnalParametersWrite)
                        response <- PUT(uriToWrite)
                        # Get the url of the datanode returned by hdfs
                        uriWrite <- response$url
                        # Upload the file with a PUT request
                        responseWrite <- PUT(uriWrite, body = upload_file(fname))
                        # removes the temporary file
                        if(tryCatch(file.remove(fname), silent=T, message=NULL)){}
                }
        }
}
