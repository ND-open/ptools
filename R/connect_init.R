
#' connect_init
#'
#' @param id , identifiaction credential for connexion
#' @param pw , password credential for connexion
#' @param host , an IP adress
#' @param port , the Impala (or Hive) port to connect to
#'
#' @return a connection to impala, the driver (depending on OS) is automatically detected.
#' @export

connect_init <- function(id, pw, host, port){

        driver <- ifelse(.Platform[[1]] == "windows",
                         "Cloudera ODBC Driver for Impala",
                         "Cloudera ODBC Driver for Impala 64-bit")

        conn <- DBI::dbConnect(odbc::odbc(),
                               Driver   = driver,
                               Host     = host,
                               Port     = port,
                               Schema   = "default",
                               AuthMech = 3,
                               UseSASL  = 1,
                               UID      = id,
                               PWD      = pw
        )

        return(conn)
}


