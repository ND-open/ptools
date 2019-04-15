
#' delete_files
#'
#' @param hdfsUri , hdfs url
#' @param dirUri , path to directory of interest
#' @param user_name , user name with overwrite credential
#' @param delete_all , default set to TRUE, to delete all files in folder
#' @param fname , default set to empty string, if only one file is to be delete set delete_all to FALSE and name it here
#'
#' @return nada , delete one file or all files in hdfs directory
#' @export
#' @import httr
#' @import dplyr

delete_files <- function(hdfsUri, dirUri, user_name, delete_all = TRUE, fname=""){

        fnames <- list_files(hdfsUri, dirUri)

        if (length(fnames) == 0){warning("There is no new file to process")}
        else{
                # ===== Delete parameter
                username <- ifelse(is.null(user_name), "", paste0("&user.name=", user_name) )
                optionnalParametersWrite <- paste0("&overwrite=true", user_name)

                if(user_name == ""){warning("user_name empty, this may cause problems.")}

                deleteParameter <- "?op=DELETE"

                cat("The following file(s) will be deleted :\n", fnames, "\n")

                if(delete_all){
                        for (fname in fnames){
                                # Delete
                                uriToDelete <- paste0(hdfsUri, dirUri, fname, deleteParameter, optionnalParametersWrite)
                                response <- DELETE(uriToDelete)

                                warn_for_status(response)

                                cat("The following file has been deleted :\n", fname, "\n")
                        }
                }
                else{
                        # Delete
                        uriToDelete <- paste0(hdfsUri, dirUri, fname, deleteParameter, optionnalParametersWrite)
                        response <- DELETE(uriToDelete)

                        warn_for_status(response)

                        cat("The following file has been deleted :\n", fname, "\n")
                }
        }
}

