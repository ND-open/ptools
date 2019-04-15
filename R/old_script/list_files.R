
#' list_files
#'
#' @param hdfsUri, the Uniform Resource Identifier of the HDFS used
#' @param dirUri, the path to the directory to list files from
#'
#' @return a vector with the file names from corresponding directory.
#' @export
#' @import httr
#' @import magrittr
#' @importFrom purrr pluck
#' @importFrom purrr map_dfr
#' @importFrom tibble as.tibble
#'
list_files <- function(hdfsUri, dirUri){
        filelist <-
                # LISTSTATUS is the webHDFS equivalent of `$ ls`
                paste0(hdfsUri, dirUri, "?op=LISTSTATUS") %>%
                httr:: GET() %>%
                httr::content(type = "application/json") %>%
                purrr::pluck(1, 1) %>%
                purrr::map_dfr(tibble::as_tibble)

        # filelist %>% glimpse()

        fnames <- filelist %>%
                pull("pathSuffix")

        return(fnames)
}

