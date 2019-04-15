
#' copy_files
#'
#' @param hdfsUri , the url of the platform
#' @param dirUri , the path to the folder of origin
#' @param destUri , the path to the folder of destination
#' @param user_name , credential with writing credential
#' @param copy_all , optionnal argument : shall all the files in origin folder be copied ?
#' @param fname , optionnal argument : name of the unique file to copy
#' @param from_hdfs , optionnal argument : is the file stored locally in R session ?
#' @param from_folder , optionnal argument : boolean, is the file to move stored in a local folder ?
#' @param newname , optionnal default to "", usefull when copy from HDFS : allow copied file renaming
#'
#' @return nada , the file is copied to wanted directory
#' @export
#' @import httr
#' @import utils

copy_files <- function(hdfsUri, dirUri, destUri, user_name, copy_all=TRUE, fname="", from_hdfs=TRUE, from_folder="", newname=""){

        # ===== Getting file names to move
        if(from_hdfs == TRUE){

                fnames <- list_files(hdfsUri, dirUri)
        }

        # ===== Reading parameter
        optionnalParameters <- ""
        readParameter <- "?op=OPEN"

        # ===== Writing parameter
        user_name <- ifelse(is.null(user_name), "", paste0("&user.name=", user_name) )
        optionnalParametersWrite <- paste0("&overwrite=true", user_name)
        writeParameter <- "?op=CREATE"

        if(copy_all){
                cat("The following files will be moved :\n", fnames, "\n")
                for (fname in fnames){

                        # Load
                        if(from_hdfs==TRUE){
                                uri <- paste0(hdfsUri, dirUri, fname, readParameter, optionnalParameters)
                                utils::download.file(uri, fname)
                        }

                        # Save
                        uriToWrite <- paste0(hdfsUri, destUri, fname, writeParameter, optionnalParametersWrite)
                        response <- httr::PUT(uriToWrite)
                        # Get the url of the datanode returned by hdfs
                        uriWrite <- response$url
                        # Upload the file with a httr::PUT request
                        responseWrite <- httr::PUT(uriWrite, body = upload_file(paste0(from_folder, fname) ))

                        warn_for_status(responseWrite)

                        # removes the temporary file
                        if(tryCatch( base::file.remove(paste0(from_folder, fname) ), silent=T, message=NULL)){}

                        cat("The following file has been moved :\n", paste0(from_folder, fname), "\n")
                }
        }else{
                cat("Only one file will be moved :\n", fname, "\n")
                # Load
                if(from_hdfs==TRUE){
                        uri <- paste0(hdfsUri, dirUri, fname, readParameter, optionnalParameters)
                        if(newname != ""){fname <- newname}
                        utils::download.file(uri, fname)
                }

                if(newname == ""){newname <- fname}else{cat("Using newname", newname, "\n")}

                # Save
                uriToWrite <- paste0(hdfsUri, destUri, newname, writeParameter, optionnalParametersWrite)
                response <- httr::PUT(uriToWrite)
                # Get the url of the datanode returned by hdfs
                uriWrite <- response$url
                # Upload the file with a httr::PUT request
                cat("Uploading : ", paste0(from_folder, fname), "\n")
                responseWrite <- httr::PUT(uriWrite, body = httr::upload_file( paste0(from_folder, fname) ))

                warn_for_status(responseWrite)

                # Handling error
                if(responseWrite$status_code >= 400){
                        warning(paste("Copy error to hdfs :", responseWrite$status_code)) # *** commit08-04-19 stop <> warning
                             }

                # removes the temporary file
                if( tryCatch( base::file.remove(paste0(from_folder, fname) ), silent=T, message=NULL)){}
                cat("The following file has been moved :\n", paste0(from_folder, fname), "\n \n")

        } # else

} # copy_files
