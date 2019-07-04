
context("test-delete_files")

test_that("delete_files", {

        cond <- grepl("saagie", Sys.getenv("RSTUDIO_HTTP_REFERER"))
        testthat::skip_if( cond == FALSE )

        if(cond == TRUE){
                hdfsUri <- Sys.getenv("webhdfs_ptools")
                user_name <- Sys.getenv("id_ptools")
                dirUri <-  paste0(Sys.getenv("hdfs_landing_ptools"), "origin")
                destUri <- paste0(Sys.getenv("hdfs_landing_ptools"), "dest")
                fname <- "test_ptools.csv"
                user_name <- Sys.getenv("id_ptools")

                # --- testing 1 file deletion

                delete_files(hdfsUri, dirUri, user_name, delete_all = FALSE, fname = fname)
                lfiles <- ptools::list_files(hdfsUri = hdfsUri, dirUri = destUri)
                testthat::expect_false( is.na ( sum ( lfiles[base::match(x = lfiles, table = fname)]) == fname ) )

                # --- testing all files deletion

                delete_files(hdfsUri, destUri, user_name, delete_all = TRUE, fname="")
                lfiles <- ptools::list_files(hdfsUri = hdfsUri, dirUri = destUri)
                testthat::expect_true(object = length(lfiles) < 1)
                }
})
