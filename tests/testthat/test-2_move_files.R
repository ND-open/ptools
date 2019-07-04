
context("test-move_files")

test_that("move_files", {

        cond <- grepl("saagie", Sys.getenv("RSTUDIO_HTTP_REFERER"))
        testthat::skip_if( cond == FALSE )

        if(cond == TRUE){

                hdfsUri <- Sys.getenv("webhdfs_ptools")
                user_name <- Sys.getenv("id_ptools")
                dirUri <-  paste0(Sys.getenv("hdfs_landing_ptools"), "origin")
                destUri <- paste0(Sys.getenv("hdfs_landing_ptools"), "dest")
                fname <- "test_ptools.csv"

                # --- testing 1 file movement

                move_files(hdfsUri, dirUri, destUri, user_name, move_all=FALSE, fname=fname, newname="")
                lfiles <- ptools::list_files(hdfsUri = hdfsUri, dirUri = destUri)
                testthat::expect_true(lfiles == fname)

                # --- testing all files movements
                # Forward

                lfiles_1 <- ptools::list_files(hdfsUri = hdfsUri, dirUri = dirUri)
                move_files(hdfsUri, dirUri, destUri, user_name, move_all=TRUE, fname="", newname="")
                lfiles_2 <- ptools::list_files(hdfsUri = hdfsUri, dirUri = destUri)
                testthat::expect_true(object = sum(lfiles_1[-1] == lfiles_2) == length(lfiles_1)) # [-1] to account for first movement

                # Backward

                lfiles_1 <- ptools::list_files(hdfsUri = hdfsUri, dirUri = destUri)
                move_files(hdfsUri, destUri, dirUri, user_name, move_all=TRUE, fname="", newname="")
                lfiles_2 <- ptools::list_files(hdfsUri = hdfsUri, dirUri = destUri)
                testthat::expect_true(object = sum(lfiles_1 == lfiles_2) == length(lfiles_1))
        }

})
