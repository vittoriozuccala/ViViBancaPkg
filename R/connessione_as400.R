#' Connessione AS400
#'
#' Questa funzione serve per connettersi ad AS400
#' @param configurazione che deve avere userID, pwd, dbAS400
#' @return Ritorna la connessione
#' @examples 
#' con <- connessione_as400(configurazione);
#' @export
#' @import RODBC

connessione_as400 <- function(configurazione){
  user.name <-configurazione$userID
  pwd <- configurazione$pwd
  db.name <- configurazione$dbAS400
  
  con.txt <- paste( "MDPRODR",
                    ";Database=",db.name,
                    ";UID=", user.name,
                    ";PWD=",pwd,
                    ";CCSID = 1252",
                    sep="")
  
  conn <- odbcConnect(con.txt)
  
  
  return(conn)
  
}