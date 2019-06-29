
#' move_files
#'
#' @param hdfsUri, hdfs url
#' @param dirUri, path to directory to move file from
#' @param destUri, destination folder
#' @param user_name, credential with write access
#' @param move_all, boolean : should all file in folder been moved ?
#' @param fname, name of the file to move
#' @param newname, default to empty string (no change). Allows to rename the file if needed.
#'
#' @return nothing, see more HDFS API at ttps://hadoop.apache.org/docs/r1.0.4/webhdfs.html
#' @export
#' @importFrom httr PUT warn_for_status

move_files <- function(hdfsUri, dirUri, destUri, user_name, move_all=TRUE, fname="", newname=""){

        if(move_all == TRUE){
                source("R/file_manip/list_files.R")
                fname_list <- list_files(hdfsUri, dirUri)

                cat("Moving the files from", dirUri, "to", destUri, ": \n")
                cat(paste(fname_list, collapse = ", \n"), "\n")
        }else{
                fname_list <- fname
                cat("Moving the file", fname, "from", dirUri, "to", destUri, ": \n")
        }

        # --- settin' options for webHDFS API
        option_verb <- "RENAME"
        option <- paste0("?op=", option_verb)
        overwrite <- paste0("&overwrite=true")
        user <- paste0("&user.name=", user_name)
        destination <- paste0("&destination=", destUri)

        for(fname_1 in fname_list){

                # -- for test
                # fname_1 <- fname_list[2]

                # --- create new dir
                uriToWrite <- paste0(hdfsUri, destUri, "?op=MKDIRS&permission=755", user)
                response <- httr::PUT(uriToWrite)
                httr::warn_for_status(response)

                uriToWrite <- paste0(hdfsUri, dirUri, fname_1, option, overwrite, user, destination)
                response <- httr::PUT(uriToWrite)
                httr::warn_for_status(response)

                cat("The file", fname_1, "has been moved with response code", response$status_code,"\n")
        }
}
