
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
        # hdfsUri <- params[3]
        # dirUri <- params[6]
        # ***

        filelist <-
                # LISTSTATUS is the webHDFS equivalent of `$ ls`
                paste0(hdfsUri, dirUri, "?op=LISTSTATUS") %>%
                httr:: GET() %>%
                httr::content(type = "application/json") %>%
                purrr::pluck(1, 1) %>%
                purrr::map_dfr(tibble::as_tibble)

        # filelist %>% glimpse()

        # str(filelist)

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

# testing for emptiness
# hdfsUri0 <- "http://nn1:50070/webhdfs/v1"
# dirUri0 <- "/data/final/prod_process_project/SV/"
#
# dirUri0 <- paste0(dirUri0, "cdepo/")
#
# list_files(hdfsUri0, dirUri0)

