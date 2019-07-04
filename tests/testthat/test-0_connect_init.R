context("test-connect_init")

test_that("connect_init", {

   cond <- grepl("saagie", Sys.getenv("RSTUDIO_HTTP_REFERER"))

   testthat::skip_if( cond == FALSE )

   if(cond == TRUE){
      conn <- ptools::connect_init(id = Sys.getenv("id_ptools"),
                                   pw = Sys.getenv("pw_ptools"),
                                   host = Sys.getenv("host_ptools"),
                                   port = Sys.getenv("port_ptools")
      )

      testthat::expect_true(class(conn)[1] == "Impala")
      DBI::dbDisconnect(conn)
      rm(conn)
   }
})


