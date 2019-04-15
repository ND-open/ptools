
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

        # ==== Pour tests

        # hdfsUri = webhdfs_url
        # dirUri = hdfs_dir
        # destUri = hdfs_dnext
        # user_name = params[1]
        # copy_all = FALSE
        # fname = paste0(fname, ".rds")
        # from_hdfs=FALSE
        # from_folder="/data/"

        # hdfsUri = webhdfs_url
        # dirUri = hdfs_dir
        # destUri = paste0(hdfs_final, "4Impala_cdepo/")
        # user_name = params[1]
        # copy_all = FALSE
        # fname = fname
        # from_hdfs = FALSE
        # from_folder = "data/"
        # newname = paste0("cdepo", "_", Sys.Date(), ".csv")



        # ===== Getting file names to move
        if(from_hdfs == TRUE){
                source("R/file_manip/list_files.R")
                fnames <- list_files(hdfsUri, dirUri)
        }

        # === Error handled in list_files

        # if (dim(filelist)[1] == 0){stop("There is no new file to process")}
        # if (length(fnames) == 0){stop("There is no new file to process")}
        # else{

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
        }else{
                cat("Only one file will be moved :\n", fname, "\n")
                # Load
                if(from_hdfs==TRUE){
                        uri <- paste0(hdfsUri, dirUri, fname, readParameter, optionnalParameters)
                        if(newname != ""){fname <- newname}
                        download.file(uri, fname)
                }

                if(newname == ""){newname <- fname}else{cat("Using newname", newname, "\n")}

                # Save
                uriToWrite <- paste0(hdfsUri, destUri, newname, writeParameter, optionnalParametersWrite)
                response <- PUT(uriToWrite)
                # Get the url of the datanode returned by hdfs
                uriWrite <- response$url
                # Upload the file with a PUT request
                cat("Uploading : ", paste0(from_folder, fname), "\n")
                responseWrite <- PUT(uriWrite, body = upload_file( paste0(from_folder, fname) ))

                # Handling error
                if(responseWrite$status_code >= 400){
                        warning(paste("Copy error to hdfs :", responseWrite$status_code)) # *** commit08-04-19 stop <> warning
                             }

                # removes the temporary file
                if(tryCatch(file.remove(paste0(from_folder, fname) ), silent=T, message=NULL)){}
                cat("The following file has been moved :\n", paste0(from_folder, fname), "\n \n")
        } # else
} # copy_files

# ==== bit o' testing
# webhdfs_url <- "http://nn1:50070/webhdfs/v1"
# hdfs_dir <-"/landing/prod_process_project/SV/pour_tests/"
# hdfs_dest <-"/landing/prod_process_project/SV/archive/"
# hdfs_dnext <-"/data/raw/prod_process_project/SV/newdata/"
# fname <- "coulee_joins_2019-01-29.rds"
# params <- c("user_test_prod_project" , "test_prod2018")
#
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

