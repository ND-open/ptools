context("test-write_hdfs")

test_that("write_hdfs (as peculiar copy_files)", {

        cond <- Sys.getenv("dotest_ptools")
        testthat::skip_if_not( cond == TRUE )

        if(FALSE){ # cond == TRUE // This step fails due to data connexion ; To use to init hdfs test

                hdfsUri <- Sys.getenv("webhdfs_ptools")
                user_name <- Sys.getenv("id_ptools")
                dirUri <-  paste0(Sys.getenv("hdfs_landing_ptools"), "origin/")
                fname_new <- "test_ptools.csv"

                # --- Result of the test

                # test_data <- readRDS(file.path(system.file("data", package="ptools"), "Rdata.rds"))

                # if(file.exists("tests/testthat/data/iris_test.csv") == FALSE){
                #         dir.create("data", showWarnings = FALSE)
                #         write.csv(iris, "data/iris_test.csv")
                #         write.csv(iris, "data/iris_test2.csv")
                # }

                ptools::copy_files(hdfsUri = hdfsUri,
                                   dirUri = dirUri,
                                   destUri = dirUri,
                                   user_name,
                                   copy_all = FALSE,
                                   fname = "iris_test.csv",
                                   from_hdfs = FALSE,
                                   from_folder = "data/",
                                   newname = fname_new,
                                   rm_temp_file = FALSE
                )

                ptools::copy_files(hdfsUri = hdfsUri,
                                   dirUri = dirUri,
                                   destUri = dirUri,
                                   user_name,
                                   copy_all = FALSE,
                                   fname = "iris_test2.csv",
                                   from_hdfs = FALSE,
                                   from_folder = "data/",
                                   newname = "test_ptools2.csv",
                                   rm_temp_file = FALSE
                )

                # rewrite file
                # if(file.exists("data/iris_test.csv") == FALSE){
                #         write.csv(iris, "/ptools/data/iris_test.csv")
                #         write.csv(iris, "/ptools/data/iris_test2.csv")
                # }

                # testthat::expect_true(lfiles == fname)
        }
})

# --- for tests
# ptools::copy_files(
# hdfsUri = hdfsUri
# dirUri = dirUri
# destUri = dirUri
# user_name
# copy_all = FALSE
# fname = "iris_test.csv"
# from_hdfs = FALSE
# from_folder = "data"
# newname = fname_new
# )
