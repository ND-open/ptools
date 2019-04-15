
#' df_2_impala
#'
#' @param hdfs_uri , url of platform
#' @param dir_path , directory of interest
#' @param db_name , database name
#' @param tab_name , name of the table to be created
#' @param id , identification credential
#' @param pw , password credential
#' @param host , url of impala/hive service
#' @param port , hive or impala port
#' @param delim , optionnal argument for the delimiter of the file. Default to ',' .
#'
#' @return nada , allows impala/hive table creation from 1 folder with csv(s) to Impala (creation, append)
#' @export
#' @import httr
#' @importFrom data.table fread
#' @import DBI
#' @import odbc
#' @importFrom tools file_path_sans_ext

df_2_impala <- function(hdfs_uri, dir_path, db_name, tab_name, id, pw, host, port, delim = ",") {


        conn <- connect_init(id = id, pw = pw, host = host, port = port)

        res <- DBI::dbGetQuery(conn, paste0("SHOW TABLES in ", db_name," LIKE '", tab_name, "'"))
        res <- nrow(res) > 0

        if(res == TRUE){
                cat("Update of table", tab_name,"\n")
                res <- DBI::dbSendQuery(conn, "invalidate metadata ;")
                DBI::dbClearResult(res)
        }else{

                # Go inside directory and list csv files
                flist_name <- list_files(hdfsUri = hdfs_uri, dirUri = dir_path)
                name_cible <- flist_name[1]

                # fetch file
                resultat_cible <- data.table::fread(paste0(hdfs_uri, dir_path, "/", name_cible, "?op=OPEN"))

                # take first file to get structure
                name_cible <- tools::file_path_sans_ext(name_cible)

                # ===== Create Impala table
                classes <- sapply(resultat_cible, class) # Classes de l'objet en R
                classes_impala <- c(character = 'STRING', numeric = 'DOUBLE', integer = 'INTEGER', logical="BOOLEAN")
                classes_to_write <- classes_impala[classes] # Mapping Impala classes to R object

                cat("Classes detected :", unique(classes_to_write), "\n")

                # Adding quote ids in case of key word used
                df_names <- dbQuoteIdentifier(conn, names(resultat_cible)) # Ajout des quotes `` aux noms des colonnes
                variables_types <- paste(df_names, classes_to_write, collapse = ', ') # Partie de la requête pour les noms et types

                instruction <- "CREATE EXTERNAL TABLE IF NOT EXISTS " ;

                row_format <- paste0(" row format delimited fields terminated by '", delim, "' ") ;
                source_format <- "stored as textfile location " ; #
                source_location <- dir_path # paste0("/", fileUri) ;
                tblproperties <- " tblproperties('skip.header.line.count'='1') ; "

                # ===== Writtin' complete query
                createRequest <- paste0(instruction,
                                        db_name, ".", tab_name,
                                        " (", variables_types, ")",
                                        row_format,
                                        source_format,
                                        "'", source_location, "'",
                                        tblproperties)

                cat("Creation of table", tab_name,"\n")
                res <- DBI::dbSendQuery(conn, createRequest) # Execute query
                DBI::dbClearResult(res)

                res <- DBI::dbSendQuery(conn, "invalidate metadata ;")
                DBI::dbClearResult(res)

        } # else

        cat("End creation/append table", dir_path, "\n")

        DBI::dbDisconnect(conn)

} # df_2_impala


