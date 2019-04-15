

#' delete_files
#'
#' @param hdfsUri, the Uniform Resource Identifier of the HDFS used
#' @param dirUri, the path to the directory to delete files from
#' @param user_name, a user name with write and delelete rights
#'
#' @return Nothing. Files in directory are removed.
#' @export
#' @import httr
#' @importFrom dplyr pull

delete_files <- function(hdfsUri, dirUri, user_name){

        fnames <- list_files(hdfsUri, dirUri)

        if (length(fnames) == 0){stop("There is no new file to process")}
        else{
                # ===== Delete parameter
                optionnalParametersWrite <- paste0("&overwrite=true&user.name=", user_name)
                deleteParameter <- "?op=DELETE"

                cat("The following files will be deleted :\n", fnames, "\n")

                for (fname in fnames){
                        # Delete
                        uriToDelete <- paste0(hdfsUri, dirUri, fname, deleteParameter, optionnalParametersWrite)
                        response <- DELETE(uriToDelete)
                }
        }
}

# library("dftools")
