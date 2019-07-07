
#' List files from HDFS folder.
#'
#' @param hdfsUri , hdfs url
#' @param dirUri , path to folder
#'
#' @return a character vector of files in directory
#' @export
#' @importFrom httr GET warn_for_status content
#' @importFrom magrittr %>%
#' @importFrom purrr pluck map_dfr
# @importFrom purrr map_dfr
#' @importFrom tibble as_tibble
#' @importFrom dplyr pull

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
        if( base::match("value", names(filelist), nomatch = 0 ) == 1 | dim(filelist)[1] == 0 ){
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
