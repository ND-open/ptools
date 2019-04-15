
# =============================================================================================

# connect_init

# Purpose : initiate connection to impala, the driver depending is automatically detected.

#       id : connexion identification parameter in interactive session
#       pw : connexion password parameter in interactive session
#       host : optionnal argument, ip adress of the server
#       port : optionnal argument, impala port

# =============================================================================================

connect_init <- function(id, pw, host = "192.168.59.20", port = 21050){

        # if(interactive() == TRUE) { id <- Sys.getenv("id") ; pw <- Sys.getenv("pw") }

        driver <- ifelse(.Platform[[1]] == "windows",
                         "Cloudera ODBC Driver for Impala",
                         "Cloudera ODBC Driver for Impala 64-bit")

        conn <- DBI::dbConnect(odbc::odbc(),
                               Driver   = driver,
                               Host     = "192.168.59.20",
                               Port     = 21050,
                               Schema   = "default",
                               AuthMech = 3,
                               UseSASL  = 1,
                               UID      = id,
                               PWD      = pw
        )

        return(conn)

}

# === for test
# if(interactive() == TRUE){
#         conn <- connect_init(id = Sys.getenv("id"), pw = Sys.getenv("pw"))
#         print(conn)
#         DBI::dbDisconnect(conn)
# }



# ======== An other failed implyr test

# library(implyr)
#
# impala <- src_impala(
#         drv = odbc::odbc(),
#         driver = "Cloudera ODBC Driver for Impala 64-bit",
#         host = "192.168.59.20",
#         port = 21050,
#         AuthMech = 3,
#         UseSASL  = 1,
#         uid = Sys.getenv("id"),
#         pwd = Sys.getenv("pw")
# )
