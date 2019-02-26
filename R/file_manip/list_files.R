
# =======================================================================================
#       List file directory

# hdfsUri : hdfs url
# dirUri : path to folder

# =======================================================================================


list_files <- function(hdfsUri, dirUri){

        require("httr")
        require("magrittr")
        require("purrr")
        require("tibble")
        require("dplyr")
        require("stringr")

        # *** for test
        # hdfsUri <- hdfsUri0
        # dirUri <- dirUri0
        # ***

        filelist <-
                # LISTSTATUS is the webHDFS equivalent of `$ ls`
                paste0(hdfsUri, dirUri, "?op=LISTSTATUS") %>%
                httr:: GET() %>%
                httr::content(type = "application/json") %>%
                purrr::pluck(1, 1) %>%
                purrr::map_dfr(tibble::as_tibble)

        # filelist %>% glimpse()

        # this step generates error if dir is empty
        if(filelist$value != "FileNotFoundException"){
                fnames <- filelist %>%
                dplyr::pull("pathSuffix")
                return(fnames)
        }else{
                cat("Directory",  paste0(hdfsUri, dirUri), "is empty, stopping execution. \n")
        }
}


