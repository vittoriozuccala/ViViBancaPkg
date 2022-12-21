#' Estrai utcre001w2 con le informazioni degli intermediari da AS400
#'
#' Questa funzione serve per estrarre utcre001w2 che rappresenta
#' il file con le informazioni degli agenti e dei subagenti
#' che collaborano o hanno collaborato con la Banca
#' @param connessione è connessione ad AS400
#' @return Ritorna utcre001w2 in formato tibble
#' @examples 
#' ut <- estrai_tabella_utcre001w2(connessione);
#' @export

estrai_tabella_utcre001w2 <- function(connessione){
  
  # Per i test
  # connessione <- con
  
  
  query <- paste("select * from odbc_md.utcre001w2")
  df <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  tb <- as_tibble(df)
  
  
  tb$RAGSOC<-riprogramma_testo(tb$RAGSOC)
  tb$SEDE<-riprogramma_testo(tb$SEDE)
  tb$CITTA<-riprogramma_testo(tb$CITTA)
  
  tb$StatoAttributoAgente <- map2(
    tb$STATO,
    tb$ATTRIB,
    ~ paste(.x,.y,sep = "-"))
  
  att <- c('AT-  ', 'AT-SO')
  chi <- c('CH-  ', 'CH-CB', 'CH-DS',  'CH-IF', 'CH-CA', 
           'AT-DS', 'CH-IT','CH-RV', 'CH-DL', 'AT-PD')
  res <- c('RE-CM', 'RE-IN', 'RE-  ')
  pot <- c('PT-  ')
  
  
  for (i in 1:length(att)) {
    tb$StatoAttributoAgente[tb$StatoAttributoAgente==att[i]] <- "Attivo"
  }
  for (i in 1:length(chi)) {
    tb$StatoAttributoAgente[tb$StatoAttributoAgente==chi[i]] <- "Chiuso"
  }
  for (i in 1:length(res)) {
    tb$StatoAttributoAgente[tb$StatoAttributoAgente==res[i]] <- "Respinto"
  }
  for (i in 1:length(pot)) {
    tb$StatoAttributoAgente[tb$StatoAttributoAgente==pot[i]] <- "Potenziale"
  }
  
  controlloStato <- tb$StatoAttributoAgente %>% 
    discard(~ .=="Attivo") %>% 
    discard(~ .=="Chiuso") %>% 
    discard(~ .=="Respinto") %>% 
    discard(~ .=="Potenziale")
  
  if(length(controlloStato>0)){
    stringa <- paste(unique(controlloStato),collapse = ";")
    stringa <- paste("Ci sono Stati Agente non associati:",stringa,sep = " ")
    stop(stringa)
  }
  
  tb <- tb %>% mutate_if(is.character, ~gsub('[:alnum:]', '', .))
  
  
  # Trasformo ciascuna colonna in UTF8
  for (i in names(tb)) {
    tb[[i]]<-stri_enc_toascii(tb[[i]])
  }
  
  tb <- tb %>% mutate(
    across(
      c(INTERMED,AGENTE,FILIALE),
      .fns = as.numeric 
    )
  )

  return(tb)
  
}
