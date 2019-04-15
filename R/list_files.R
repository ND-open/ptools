
#' list_files
#'
#' @param hdfsUri , hdfs url
#' @param dirUri , path to folder
#'
#' @return a character vector of files in directory
#' @export
#' @import httr
#' @import magrittr
#' @importFrom purrr pluck
#' @importFrom purrr map_dfr
#' @import tibble
#'
# @import dplyr
# @import stringr

list_files <- function(hdfsUri, dirUri){

        filelist <-
                # LISTSTATUS is the webHDFS equivalent of `$ ls`
                paste0(hdfsUri, dirUri, "?op=LISTSTATUS") %>%
                httr::GET()

        httr::warn_for_status(filelist)

        filelist <- filelist %>%
                httr::content(type = "application/json") %>%
                purrr::pluck(1, 1) %>%
                purrr::map_dfr(tibble::as_tibble)

        # this step generates error if dir is empty - value does not exists otherwise
        if( match("value", names(filelist), nomatch = 0 ) == 1 | dim(filelist)[1] == 0 ){
                if(dim(filelist)[1] == 0){
                        cat("No files in", dirUri,"tibble null. \n")
                        }
                else if(filelist$value == "FileNotFoundException"){
                        cat("Directory",  paste0(hdfsUri, dirUri), "is empty, stopping execution. \n")
                }
                # stop("Directory empty, stopping execution.") # ************* commit from 08-04-19
        }else{
                fnames <- filelist %>%
                        dplyr::pull("pathSuffix")
                return(fnames)
        }
}
