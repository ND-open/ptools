context("test-connect_init")

test_that("connect_init", {

   cond <- Sys.getenv("dotest_ptools")

   testthat::skip_if_not( cond == TRUE )

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


