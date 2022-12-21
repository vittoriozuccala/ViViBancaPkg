#' Estrai restfope da AS400
#'
#' Questa funzione serve per estrarre restfope della Collection
#' @param connessione è connessione di AS400
#' @return Ritorna restfope in formato tibble
#' @examples 
#' rst <- estrai_tabella_restfopecq(connessione);
#' @export


estrai_tabella_restfopecq <- function(connessione){
  
  # Per test
  # connessione <- con
  
  query <- paste("select * from odbc_md.restfopecq")
  df <- sqlQuery(con, query, stringsAsFactors=FALSE )
  tb <- as_tibble(df)

  tb <- tb %>% mutate_if(is.character, ~gsub('[^ -~]', '', .))
  
  # Trasformo ciascuna colonna in UTF8
  for (i in names(tb)) {
    tb[[i]]<-stri_enc_toascii(tb[[i]])
  }
  
  tb <- tb %>% mutate(
    across(
      c(
        PRATI,CLIENTE, AZIENDA,
        SCADUTO, SCADERE,
        AGENTE,
        STATO
        ),
      .fns = as.numeric 
      )
    )
  
  return(tb)  
}