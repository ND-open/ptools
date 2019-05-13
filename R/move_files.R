
# =======================================================================================

#       move_files around in HDFS

# hdfsUri : hdfs url
# dirUri : path to directory of interest
# desturi : where to
# user_name : user name with overwrite credential
#       optionnal parameter :
#               - copy_all : default set to TRUE, to copy all files in folder
#               - fname : default set to empty string, if only one file is to be copy set copy_all to FALSE and name it here
#               - newname : default to ""

# dev note [16-04-19]
# --- Wisdom from Thomas Q
# with help from https://hadoop.apache.org/docs/r1.0.4/webhdfs.html
#
# En fait il faut que tu fasses un WebHDFS rename, encore plus simple
# “<HOST>:<PORT>/webhdfs/v1/<PATH>?op=RENAME&destination=<PATH>”

# =======================================================================================

#' Title
#'
#' @param hdfsUri, hdfs url
#' @param dirUri, path to directory to move file from
#' @param destUri, destination folder
#' @param user_name, credential with write access
#' @param copy_all, boolean : should all file in folder been moved ?
#' @param fname, name of the file to move
#' @param newname, default to empty string (no change). Allows to rename the file if needed.
#'
#' @return
#' @export

move_files <- function(hdfsUri, dirUri, destUri, user_name, copy_all=TRUE, fname="", newname=""){

        require("httr")
        require("utils")

        if(copy_all == TRUE){
                source("R/file_manip/list_files.R")
                fname_list <- list_files(hdfsUri, dirUri)

                cat("Moving the files from", dirUri, "to", destUri, ": \n")
                cat(paste(fname_list, collapse = ", \n"), "\n")
        }else{fname_list <- fname
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
                response <- PUT(uriToWrite)
                warn_for_status(response)

                uriToWrite <- paste0(hdfsUri, dirUri, fname_1, option, overwrite, user, destination)
                response <- PUT(uriToWrite)
                warn_for_status(response)

                cat("The file", fname_1, "has been moved with response code", response$status_code,"\n")
        }
}


# --- For tests -----------------------------------------------------------------------------------


if(interactive() == TRUE){

        # --- testing 1 file movement
        if(FALSE){
                hdfsUri <- Sys.getenv("webhdfs_url")
                user_name <- Sys.getenv("id")
                dirUri <- "/landing/prod_process_project/SV/test/"
                destUri <- "/landing/prod_process_project/SV/test/test_move_files/"
                fname <- "cdepo.csv"

                move_files(hdfsUri, dirUri, destUri, user_name, copy_all=FALSE, fname=fname, newname="")
        }

        # --- testing all files movements

        # Forward
        if(FALSE){
                hdfsUri <- Sys.getenv("webhdfs_url")
                user_name <- Sys.getenv("id")
                dirUri <-  "/landing/prod_process_project/SV/newdata/"
                destUri <- "/landing/prod_process_project/SV/archive/data_test05/"

                move_files(hdfsUri, dirUri, destUri, user_name, copy_all=TRUE, fname="", newname="")
        }

        # Backward
        if(FALSE){
                hdfsUri <- Sys.getenv("webhdfs_url")
                user_name <- Sys.getenv("id")
                dirUri <- "/landing/prod_process_project/SV/archive/data_2019-04-16/newdata/"
                destUri <- "/landing/prod_process_project/SV/newdata/"

                move_files(hdfsUri, dirUri, destUri, user_name, copy_all=TRUE, fname="", newname="")
        }

        # An another test backward *** --- +++ ///
        if(FALSE){
                hdfsUri <- Sys.getenv("webhdfs_url")
                user_name <- Sys.getenv("id")
                dirUri <- "/landing/prod_process_project/SV/archive/error_test/"
                destUri <- "/landing/prod_process_project/SV/newdata/"

                move_files(hdfsUri, dirUri, destUri, user_name, copy_all=TRUE, fname="", newname="")
        }
}

