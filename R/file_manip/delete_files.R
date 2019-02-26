
# =======================================================================================
#       Delete one file or all file in hdfs directory

# hdfsUri : hdfs url
# dirUri : path to directory of interest
# user_name : user name with overwrite credential
# delete_all : default set to TRUE, to delete all files in folder
# fname : default set to empty string, if only one file is to be delete set delete_all to FALSE and name it here

# =======================================================================================

delete_files <- function(hdfsUri, dirUri, user_name, delete_all = TRUE, fname=""){

        require("httr")
        require("dplyr")

        source("R/file_manip/list_files.R")

        fnames <- list_files(hdfsUri, dirUri)

        if (length(fnames) == 0){stop("There is no new file to process")}
        else{
                # ===== Delete parameter
                optionnalParametersWrite <- paste0("&overwrite=true&user.name=", user_name)
                deleteParameter <- "?op=DELETE"

                cat("The following file will be deleted :\n", fnames, "\n")

                if(delete_all){
                        for (fname in fnames){
                                # Delete
                                uriToDelete <- paste0(hdfsUri, dirUri, fname, deleteParameter, optionnalParametersWrite)
                                response <- DELETE(uriToDelete)

                                cat("The following file has been deleted :\n", fname, "\n")
                        }
                }
                else{
                        # Delete
                        uriToDelete <- paste0(hdfsUri, dirUri, fname, deleteParameter, optionnalParametersWrite)
                        response <- DELETE(uriToDelete)

                        cat("The following file has been deleted :\n", fname, "\n")
                }
        }
}

