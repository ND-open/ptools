
#' Create or append SQL tables from url (such as HDFS folder ;;; (all files must have the same structure)).
#'
#' @param hdfsUri , url of platform
#' @param dirUri , directory of interest
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
#' @importFrom httr PUT
#' @importFrom data.table fread
#' @importFrom DBI dbGetQuery dbDisconnect dbSendQuery dbClearResult dbQuoteIdentifier
#' @importFrom tools file_path_sans_ext

df_2_sql <- function(hdfsUri, dirUri, db_name, tab_name, id, pw, host, port, delim = ",") {


        # --- HDFS data fetching ---

        path <- "C:\\Users\\cbonamy\\Documents\\SAAGIE_Vallourec\\R_project\\SizeRangeAnalyser\\data-raw\\"
        # file <- "list_globaldata.csv"
        file <- "data_Round.csv"

        df_global <- vroom::vroom(file = paste0(path, file) )

        # --- jj ---

        df_global_clean <- df_global %>%

                mutate(Manufacturing_process_list = stringr::str_replace_all(string = Manufacturing_process_list,
                                                                             pattern = "/",
                                                                             replacement = "_"),
                       Manufacturing_process_list = stringr::str_replace_all(string = Manufacturing_process_list,
                                                                             pattern = "&",
                                                                             replacement = "_"),
                       Manufacturing_process_list = stringr::str_replace_all(string = Manufacturing_process_list,
                                                                             pattern = "\\+",
                                                                             replacement = "_"),
                       Manufacturing_process_list = stringr::str_replace_all(string = Manufacturing_process_list,
                                                                             pattern = "\\(",
                                                                             replacement = "_"),
                       Manufacturing_process_list = stringr::str_replace_all(string = Manufacturing_process_list,
                                                                             pattern = "\\)",
                                                                             replacement = ""),
                       Manufacturing_process_list = stringr::str_replace_all(string = Manufacturing_process_list,
                                                                             pattern = ";",
                                                                             replacement = ""),
                       Manufacturing_process_list = stringr::str_replace_all(string = Manufacturing_process_list,
                                                                             pattern = "-",
                                                                             replacement = ""),
                       Manufacturing_process_list = stringr::str_replace_all(string = Manufacturing_process_list,
                                                                             pattern = "High Frequency Electric Resistance Welding HFI _ HF ЕRW",
                                                                             replacement = "High_freq_elec_resistance_welding_hfi_hf_erw"
                       )
                )

        # conn <- connect_init(id = id, pw = pw, host = host, port = port)
        # --- con init ---

        conn <- RMariaDB::dbConnect(drv = RMariaDB::MariaDB(),
                                    host = "192.168.59.130",
                                    port = 3306,
                                    dbname = "doc_usecase",
                                    user = Sys.getenv("id_duc"),
                                    password = Sys.getenv("pw_duc")
        )

        # --- show ---

        res <- DBI::dbGetQuery(conn, paste0("SHOW TABLES in ", db_name," LIKE '", tab_name, "'"))
        res <- nrow(res) > 0


        # if table exists invalidate metadata is enough in Impala / Hive

        if(res == TRUE){
                cat("Update of table", tab_name,"\n")
                res <- DBI::dbSendQuery(conn, "invalidate metadata ;")
                DBI::dbClearResult(res)

        # else table needs to be created

        }else{

                # Go inside directory and list csv files
                flist_name <- list_files(hdfsUri = hdfsUri, dirUri = dirUri)
                file_name <- flist_name[1]

                # fetch file
                data_raw <- data.table::fread(paste0(hdfsUri, dirUri, file_name, "?op=OPEN"))

                # ===== Create Impala table
                classes <- sapply(data_raw, class) # Classes de l'objet en R
                classes_impala <- c(character = 'STRING', numeric = 'DOUBLE', integer = 'INTEGER', logical="BOOLEAN")
                classes_to_write <- classes_impala[classes] # Mapping Impala classes to R object

                cat("Classes detected :", unique(classes_to_write), "\n")

                # cleaning the names for compatibility
                names(data_raw) <- stringr::str_replace_all(string = names(data_raw), pattern = "\\.", replacement = "_")
                # names(data_raw) <- stringr::str_remove_all(string = names(data_raw), pattern = [[:punct:]])

                # Adding quote ids in case of key word used
                df_names <- dbQuoteIdentifier(conn, names(data_raw)) # Ajout des quotes `` aux noms des colonnes
                variables_types <- paste(df_names, classes_to_write, collapse = ', ') # Partie de la requête pour les noms et types

                instruction <- "CREATE EXTERNAL TABLE IF NOT EXISTS " ;

                row_format <- paste0(" row format delimited fields terminated by '", delim, "' ") ;
                source_format <- "stored as textfile location " ; #
                source_location <- dirUri # paste0("/", fileUri) ;
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

        cat("End creation of table", dirUri, "\n")

        DBI::dbDisconnect(conn)

} # df_2_sql


