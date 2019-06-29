context("test-connect_init")

test_that("connect_init", {

        # === for test
        # if(interactive() == TRUE){
                conn <- ptools::connect_init(id = Sys.getenv("id_ptools"),
                                              pw = Sys.getenv("pw_ptools"),
                                              host = Sys.getenv("host_ptools"),
                                              port = Sys.getenv("port_ptools")
                                              )
                # str(conn)
                # class(conn)[1]
                # print(conn)
                # DBI::dbDisconnect(conn)
                # rm(conn)
        # }

  testthat::expect_true(class(conn)[1] == "Impala")
  DBI::dbDisconnect(conn)
  rm(conn)
})


