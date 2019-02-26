
# =======================================================================================
#       Copy file to specified directory

# hdfsUri : hdfs url
# dirUri : path to directory of interest
# user_name : user name with overwrite credential
#       optionnal parameter :
#               - copy_all : default set to TRUE, to copy all files in folder
#               - fname : default set to empty string, if only one file is to be copy set copy_all to FALSE and name it here
#               - from_hdfs : boolean, is the file to move in hdfs or local in R ?
#               - from_folder : boolean, is the file to move stored in a local folder ?
#               - newname : default to "", usefull when copy from HDFS : allow copied file renaming

# =======================================================================================


copy_files <- function(hdfsUri, dirUri, destUri, user_name, copy_all=TRUE, fname="", from_hdfs=TRUE, from_folder="", newname=""){

        require("httr")
        require("utils")

        # ===== Getting file names to move

        source("R/file_manip/list_files.R")
        fnames <- list_files(hdfsUri, dirUri)

        # if (dim(filelist)[1] == 0){stop("There is no new file to process")}
        if (length(fnames) == 0){stop("There is no new file to process")}
        else{
                # ===== Reading parameter
                optionnalParameters <- ""
                readParameter <- "?op=OPEN"

                # ===== Writing parameter
                optionnalParametersWrite <- paste0("&overwrite=true&user.name=", user_name)
                writeParameter <- "?op=CREATE"

                if(copy_all){
                        cat("The following files will be moved :\n", fnames, "\n")
                        for (fname in fnames){

                                # Load
                                if(from_hdfs==TRUE){
                                        uri <- paste0(hdfsUri, dirUri, fname, readParameter, optionnalParameters)
                                        download.file(uri, fname)
                                }

                                # Save
                                uriToWrite <- paste0(hdfsUri, destUri, fname, writeParameter, optionnalParametersWrite)
                                response <- PUT(uriToWrite)
                                # Get the url of the datanode returned by hdfs
                                uriWrite <- response$url
                                # Upload the file with a PUT request
                                responseWrite <- PUT(uriWrite, body = upload_file(paste0(from_folder, fname) ))
                                # removes the temporary file
                                if(tryCatch(file.remove(paste0(from_folder, fname) ), silent=T, message=NULL)){}

                                cat("The following file has been moved :\n", paste0(from_folder, fname), "\n")
                        }
                }
                else{
                        cat("Only one file will be moved :\n", fname, "\n")
                        # Load
                        if(from_hdfs==TRUE){
                                uri <- paste0(hdfsUri, dirUri, fname, readParameter, optionnalParameters)
                                if(newname != ""){fname <- newname}
                                download.file(uri, fname)
                        }

                        # Save
                        uriToWrite <- paste0(hdfsUri, destUri, fname, writeParameter, optionnalParametersWrite)
                        response <- PUT(uriToWrite)
                        # Get the url of the datanode returned by hdfs
                        uriWrite <- response$url
                        # Upload the file with a PUT request
                        cat("Uploading : ", paste0(from_folder, fname), "\n")
                        responseWrite <- PUT(uriWrite, body = upload_file( paste0(from_folder, fname) ))
                        # removes the temporary file
                        if(tryCatch(file.remove(paste0(from_folder, fname) ), silent=T, message=NULL)){}

                        cat("The following file has been moved :\n", paste0(from_folder, fname), "\n \n")
                }
        }
}

# copy_files(
#         hdfsUri = webhdfs_url,
#         dirUri = hdfs_dir,
#         destUri = hdfs_dnext,
#         user_name = params[1],
#         copy_all = FALSE,
#         fname = fname,
#         from_hdfs=FALSE,
#         from_folder="data/"
# )

