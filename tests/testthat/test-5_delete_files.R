
context("test-delete_files")

test_that("delete_files", {

        cond <- Sys.getenv("dotest_ptools")
        testthat::skip_if_not( cond == TRUE )

        if(cond == TRUE){
                hdfsUri <- Sys.getenv("webhdfs_ptools")
                user_name <- Sys.getenv("id_ptools")
                dirUri <-  paste0(Sys.getenv("hdfs_landing_ptools"), "origin/")
                destUri <- paste0(Sys.getenv("hdfs_landing_ptools"), "dest/")
                fname <- "test_ptools.csv"
                user_name <- Sys.getenv("id_ptools")

                user_name <- "camille.bonamy"

                # --- testing 1 file deletion

                ptools::delete_files(hdfsUri, destUri, user_name, delete_all = FALSE, fname = fname)
                lfiles <- ptools::list_files(hdfsUri = hdfsUri, dirUri = destUri)
                testthat::expect_true( is.na ( lfiles[base::match(x = lfiles, table = fname)] ) )

                #  is.na ( sum ( lfiles[base::match(x = lfiles, table = fname)] ) == fname )

                # --- testing all files deletion
                # destUri <-> since it is were to begin or new test
                ptools::delete_files(hdfsUri, destUri, user_name, delete_all = TRUE, fname="")
                lfiles <- ptools::list_files(hdfsUri = hdfsUri, dirUri = destUri)
                testthat::expect_true(object = is.null(lfiles))

                # destUri used for df_2_Impala
                }
})
