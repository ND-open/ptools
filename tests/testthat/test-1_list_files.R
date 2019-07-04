
context("test-list_files")

test_that("list_files", {

        cond <- grepl("saagie", Sys.getenv("RSTUDIO_HTTP_REFERER"))
        testthat::skip_if_not( cond == TRUE )

        if(cond == TRUE){
                hdfsUri <- Sys.getenv("webhdfs_ptools")
                user_name <- Sys.getenv("id_ptools")
                dirUri <-  paste0(Sys.getenv("hdfs_landing_ptools"), "origin")
                destUri <- paste0(Sys.getenv("hdfs_landing_ptools"), "dest")
                fname <- "test_ptools.csv"

                # --- Result of the test
                lfiles <- ptools::list_files(hdfsUri = hdfsUri, dirUri = dirUri)
                testthat::expect_true(lfiles == fname)
        }

})
