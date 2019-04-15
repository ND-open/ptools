context("test-connect_init")

test_that("connect_init works", {

        # === for test
        # if(interactive() == TRUE){
                conn <- dftools::connect_init(id = Sys.getenv("id_v"),
                                              pw = Sys.getenv("pw_v"),
                                              host = Sys.getenv("host_v"),
                                              port = Sys.getenv("port_v")
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


