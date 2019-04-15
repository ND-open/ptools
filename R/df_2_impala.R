
# =============================================================================================

# df_2_impala

# Purpose : From 1 folder with csv to Impala (creation, append)

# -- params description
# - hdfs_uri : url to hdfs
# - dir_path : the source folder
#
# =============================================================================================


df_2_impala <- function(hdfs_uri, dir_path, db_name, tab_name, id, pw) {


        pkgs <- c("httr", "data.table", "DBI", "odbc", "tools")

        for (pkg in pkgs){
                if(!(require(pkg, character.only = TRUE))){install.packages(pkg, character.only = TRUE)}
                library(pkg, character.only = TRUE)
        }

        source("R/pipe_tools/connect_init.R")
        conn <- connect_init(id = id, pw = pw)


        # ***************

        # source("R/pipe_tools/connect_init.R")
        # conn <- connect_init(id = params[1], pw = params[2])
        #
        # df_2_impala(hdfs_uri = webhdfs_url, dir_path = paste0(hdfs_final, dir_name),
        #             db_name = db_name, tab_name = tab_name,
        #             id = params[1], pw = params[2])

        # ***************

        # If table already up, update via metadata invalidation

        res <- DBI::dbGetQuery(conn, paste0("SHOW TABLES in ", db_name," LIKE '", tab_name, "'"))
        res <- nrow(res) > 0

        if(res == TRUE){
                cat("Update of table", tab_name,"\n")
                res <- dbSendQuery(conn, "invalidate metadata ;")
                dbClearResult(res)
        }else{

                source("R/file_manip/list_files.R")

                # Go inside directory and list csv files
                flist_name <- list_files(hdfsUri = hdfs_uri, dirUri = dir_path)
                name_cible <- flist_name[1]

                # fetch file
                resultat_cible <- data.table::fread(paste0(hdfs_uri, dir_path, "/", name_cible, "?op=OPEN"))

                # take first file to get structure
                name_cible <- tools::file_path_sans_ext(name_cible)

                # ===== Creation de la table sur Impala
                classes <- sapply(resultat_cible, class) # Classes de l'objet en R
                classes_impala <- c(character = 'STRING', numeric = 'DOUBLE', integer = 'INTEGER', logical="BOOLEAN") # Mapping entre classes R et Impala
                classes_to_write <- classes_impala[classes] # Attribution des classes Impala à l'objet R

                cat("Classes attribuées :", unique(classes_to_write), "\n")

                # === Gestion char speciaux
                # custom

                # Adding quote ids in case of key word used
                df_names <- dbQuoteIdentifier(conn, names(resultat_cible)) # Ajout des quotes `` aux noms des colonnes
                variables_types <- paste(df_names, classes_to_write, collapse = ', ') # Partie de la requête pour les noms et types

                instruction <- "CREATE EXTERNAL TABLE IF NOT EXISTS " ;
                # db_name
                # tab_name

                row_format <- " row format delimited fields terminated by ';' " ;
                source_format <- "stored as textfile location " ; #
                source_location <- dir_path # paste0("/", fileUri) ;
                tblproperties <- " tblproperties('skip.header.line.count'='1') ; "

                # ===== Écriture de la requête complète
                createRequest <- paste0(instruction,
                                        db_name, ".", tab_name,
                                        " (", variables_types, ")",
                                        row_format,
                                        source_format,
                                        "'", source_location, "'",
                                        tblproperties)
                # else *** 11/03

                cat("Creation of table", tab_name,"\n")
                res <- dbSendQuery(conn, createRequest) # Execute query
                dbClearResult(res)

                res <- dbSendQuery(conn, "invalidate metadata ;")
                dbClearResult(res)

        } # else

        cat("End creation/append table", dir_path, "\n")

        DBI::dbDisconnect(conn)

} # df_2_impala


# === for local test : building prod_criteria
# params <- c("http://nn1:50070/webhdfs/v1",            # webhdfs_url
#             "/data/final/prod_process_project/SV/4Impala_prod_criteria",
#             "test_process",
#             "prod_criteria")
#
# hdfs_uri <- params[1]
# dir_path <- params[2]
# db_name <- params[3]
# tab_name <- params[4]
#
# df_2_impala(hdfs_uri, dir_path, db_name, tab_name)




