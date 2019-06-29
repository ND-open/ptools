
context("test-list_files")

test_that("list_files", {

        testthat::skip_if(.Platform$OS.type == "windows")

        hdfsUri <- Sys.getenv("webhdfs_ptools")
        user_name <- Sys.getenv("id_ptools")
        dirUri <-  paste0(Sys.getenv("hdfs_landing_ptools"), "origin")
        destUri <- paste0(Sys.getenv("hdfs_landing_ptools"), "dest")
        fname <- "test_ptools.csv"

        # --- Result of the test
        lfiles <- ptools::list_files(hdfsUri = hdfsUri, dirUri = dirUri)
        testthat::expect_true(lfiles == fname)

})
