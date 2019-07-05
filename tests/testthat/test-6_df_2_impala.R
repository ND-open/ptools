
context("test-df_2_impala")

test_that("df_2_impala", {

        cond <- Sys.getenv("dotest_ptools")
        testthat::skip_if_not( cond == TRUE )

        if(cond == TRUE){
                hdfsUri <- Sys.getenv("webhdfs_ptools")
                dirUri <-  paste0(Sys.getenv("hdfs_landing_ptools"), "origin/")
                db_name <- Sys.getenv("db_ptools")
                tab_name <- Sys.getenv("tab_ptools")
                id <- Sys.getenv("id_ptools")
                pw <- Sys.getenv("pw_ptools")
                host <- Sys.getenv("host_ptools")
                port <- Sys.getenv("port_ptools")
                delim = "," # assuming default csv
                ptools::df_2_impala(hdfsUri, dirUri, db_name, tab_name, id, pw, host, port, delim = ",")

                if(cond == TRUE){
                        conn <- ptools::connect_init(id, pw, host, port)
                        ltable <- DBI::dbGetQuery(conn, paste0("SHOW TABLES in ", db_name, " LIKE '", tab_name, "'") )
                }
                testthat::expect_true( match(x = ltable, table = tab_name, nomatch = 0) > 0 )
        }

})
