
context("test-move_files")

test_that("move_files", {

        cond <- Sys.getenv("dotest_ptools")
        testthat::skip_if_not( cond == TRUE )

        if(cond == TRUE){

                hdfsUri <- Sys.getenv("webhdfs_ptools")
                user_name <- Sys.getenv("id_ptools")
                dirUri <-  paste0(Sys.getenv("hdfs_landing_ptools"), "origin/")
                destUri <- paste0(Sys.getenv("hdfs_landing_ptools"), "dest/")
                fname <- "test_ptools.csv"
                list_fname <- c("test_ptools.csv", "test_ptools2.csv")

                # --- testing 1 file movement

                ptools::move_files(hdfsUri, dirUri, destUri, user_name, move_all=FALSE, fname=fname, newname="")
                lfiles <- ptools::list_files(hdfsUri = hdfsUri, dirUri = destUri)
                testthat::expect_true(prod(lfiles == fname) == 1)

                # --- testing all files movements
                # Forward

                lfiles_1 <- ptools::list_files(hdfsUri = hdfsUri, dirUri = dirUri)
                ptools::move_files(hdfsUri, dirUri, destUri, user_name, move_all=TRUE, fname="", newname="")
                lfiles_2 <- ptools::list_files(hdfsUri = hdfsUri, dirUri = destUri)
                testthat::expect_true(object = sum(lfiles_1 == lfiles_2[-1]) == length(lfiles_1)) # [-1] to account for first movement

                # Backward

                lfiles_1 <- ptools::list_files(hdfsUri = hdfsUri, dirUri = destUri)
                ptools::move_files(hdfsUri, destUri, dirUri, user_name, move_all=TRUE, fname="", newname="")
                lfiles_2 <- ptools::list_files(hdfsUri = hdfsUri, dirUri = dirUri)
                testthat::expect_true(object = sum(lfiles_1 == lfiles_2) == length(lfiles_1))
        }

})
