
context("test-copy_files")

test_that("copy_files", {

        cond <- Sys.getenv("dotest_ptools")
        testthat::skip_if_not( cond == TRUE )

        if(cond == TRUE){
                hdfsUri <- Sys.getenv("webhdfs_ptools")
                user_name <- Sys.getenv("id_ptools")
                dirUri <-  paste0(Sys.getenv("hdfs_landing_ptools"), "origin/")
                destUri <- paste0(Sys.getenv("hdfs_landing_ptools"), "dest/")
                fname <- "test_ptools.csv"

                # --- testing 1 file copy

                copy_files(hdfsUri, dirUri, destUri, user_name, copy_all=FALSE, fname=fname, newname="")
                lfiles <- ptools::list_files(hdfsUri = hdfsUri, dirUri = destUri)
                testthat::expect_true(lfiles == fname)

                # --- testing all files copy

                lfiles_1 <- ptools::list_files(hdfsUri = hdfsUri, dirUri = dirUri)
                copy_files(hdfsUri, dirUri, destUri, user_name, copy_all=TRUE, fname="", newname="")
                lfiles_2 <- ptools::list_files(hdfsUri = hdfsUri, dirUri = destUri)
                testthat::expect_true(object = sum(lfiles_1 == lfiles_2) == length(lfiles_1))
        }

})
