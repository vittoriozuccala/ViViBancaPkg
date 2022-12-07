#' Estrae GEUTY
#'
#' Questa funzione serve per estrarre geuty
#' @param connessione è la connessione
#' @return Ritorna geuty
#' @examples 
#' g400 <- estrai_tabella_geuty400f(connessione);
#' @export


estrai_tabella_geuty400f <- function(connessione){
  
  # Per test
  # connessione <- con
  
  query <- paste("select * from odbc_md.geuty400f")
  df <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  tb <- as_tibble(df)
  
  names(tb) <- names(tb) %>% map_chr(str_replace,"GE400_","")
  
  tb$DENOM_1_ANA_6 <- riprogramma_testo(tb$DENOM_1_ANA_6)
  tb$DENOM_1_ANA_1 <- riprogramma_testo(tb$DENOM_1_ANA_1)
  
  tb$DataPerfezionamento <- accorpa_AAMMGG(
    tb$DATA_PERF_AA,
    tb$DATA_PERF_MM,
    tb$DATA_PERF_GG)
  
  tb$DataUltimaDelibera <- accorpa_AAMMGG(
    tb$DATA_ULT_DELI_AA,
    tb$DATA_ULT_DELI_MM,
    tb$DATA_ULT_DELI_GG)
  
  tb$DataCaricamento <- accorpa_AAMMGG(
    tb$DATA_CARI_AA,
    tb$DATA_CARI_MM,
    tb$DATA_CARI_GG)
  
  StatoAttributoPratica <- map2_chr(
    tb$STATO,
    tb$ATTRIBUTO,
    ~paste(.x,.y,sep = "-")
    )
  
  # Questa istruzione serve per aggiustare l'encoding
  tb %>% mutate_if(is.character, ~gsub('[^ -~]', '', .))
  
  unique(StatoAttributoPratica) %>% 
    str_match("RT$")
  
  # Trasformo ciascuna colonna in UTF8
  for (i in names(tb)) {
    tb[[i]]<-stri_enc_toascii(tb[[i]])
  }
  
  return(tb)
}
