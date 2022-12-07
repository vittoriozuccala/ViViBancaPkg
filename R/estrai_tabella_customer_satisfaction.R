#' Estrae tabella AS400
#'
#' Questa funzione estrae CS da AS
#' @param connessione è la connessione ad AS400
#' @return Ritorna cd
#' @examples 
#' cs <- estrai_tabella_customer_satisfaction(connessione);
#' @export
#' @import yaml


estrai_tabella_customer_satisfaction <- function(connessione){
  
  # Per test
  # connessione <- con
  
  trovaOK <- function(stringa){
    stringa[str_starts(stringa,"KO")] = "-1"
    stringa[str_starts(stringa,"OK")] = "0"
    stringa[is.na(stringa)] = "0"
    stringa[stringa == "  "] = "0"
    stringa[stringa != "0" & stringa!="-1"] = "0"
    return(stringa)
  }
  
  query <- paste("select * from odbc_md.piaud100wk")
  df <- sqlQuery(con, query, stringsAsFactors=FALSE )
  tb_csall <- as_tibble(df)

  
  query <- paste("select * from odbc_md.utcre001w2")
  df <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  tb_utcre <- as_tibble(df)
  tb_utcre <- tb_utcre %>% select( 
    NDGAgente = INTERMED,
    Intermediario = RAGSOC
  )
  tb_utcre$Intermediario <- riprogramma_testo(tb_utcre$Intermediario)
  
  tb <- tb_csall %>%
    select(
      NumeroPratica = PIAUD_10_PRATICA,
      IDPeriodo = PIAUD_10_PERIODO,
      IDCluster = PIAUD_10_CLUSTER,
      NDGCliente = PIAUD_10_CLI_NDG,
      NDGAgente = PIAUD_10_AGE_NDG,
      ClienteDenominazione = PIAUD_10_CLI_DENOM,
      DataTel1 = PIAUD_10_DATA_TEL1,
      DataTel2 = PIAUD_10_DATA_TEL2,
      DataTel3 = PIAUD_10_DATA_TEL3,
      EsitoTel1 = PIAUD_10_ESITO_TEL1,
      EsitoTel2 = PIAUD_10_ESITO_TEL2,
      EsitoTel3 = PIAUD_10_ESITO_TEL3,
      Esito1 = PIAUD_10_ESITO_DOMANDA1,
      Esito2 = PIAUD_10_ESITO_DOMANDA2,
      Esito3 = PIAUD_10_ESITO_DOMANDA3,
      Esito4 = PIAUD_10_ESITO_DOMANDA4,
      Esito5 = PIAUD_10_ESITO_DOMANDA5,
      Esito6 = PIAUD_10_ESITO_DOMANDA6,
      Esito7 = PIAUD_10_ESITO_DOMANDA7,
      EsitoINT = PIAUD_11_ESITO_INTERNO,
      Nota1 = PIAUD_10_NOTA_DOMANDA1,
      Nota2 = PIAUD_10_NOTA_DOMANDA2,
      Nota3 = PIAUD_10_NOTA_DOMANDA3,
      Nota4 = PIAUD_10_NOTA_DOMANDA4,
      Nota5 = PIAUD_10_NOTA_DOMANDA5,
      Nota6 = PIAUD_10_NOTA_DOMANDA6,
      Nota7 = PIAUD_10_NOTA_DOMANDA7,
      DataEsitoInterno = PIAUD_11_DATA,
      InvioNuovoContratto = PIAUD_11_FLAG_INVIO,
      InvioPEC = PIAUD_11_INVIO_PEC,
      NotaEsitoInterno = PIAUD_11_NOTE_ESITO
    ) %>% 
    mutate_at(
      c(
        "Esito1","Esito2",
        "Esito3","Esito4",
        "Esito5","Esito6",
        "Esito7","EsitoINT"),
      trovaOK)%>%
    mutate_at(
      c("Esito1","Esito2",
        "Esito3","Esito4",
        "Esito5","Esito6",
        "Esito7","EsitoINT"),
      as.integer) %>%
    mutate(EsitoFinale=Esito3+Esito4+Esito5+Esito6+Esito7+EsitoINT) %>%
    mutate_at(c("EsitoFinale"),~if_else(.<0,"KO","OK")) %>% 
    left_join(tb_utcre,by = "NDGAgente")
  
  controllo <-  sum(
    as.integer(tb$Esito3))+
    sum(as.integer(tb$Esito4))+
    sum(as.integer(tb$Esito5))+
    sum(as.integer(tb$Esito6))+
    sum(as.integer(tb$Esito7))+
    sum(as.integer(tb$EsitoINT))
  
  if (!is.numeric(controllo)) {
    stop("Errore di conversione Esiti in numerico in Customer Satisfaction")
  }
  
  names(tb) <- names(tb) %>% map_chr(str_replace,"PIAUD_10_","")
  names(tb) <- names(tb) %>% map_chr(str_replace,"PIAUD_11_","")
  
  tb %>% mutate_if(is.character, ~gsub('[^ -~]', '', .))
  
  # Interessante per l'uso di mutate_if al fondo del codice commentato  
  # tb <- tb %>% 
  #   select(
  #     IDPratica = PIAUD_10_PRATICA,
  #     IDPeriodo = PIAUD_10_PERIODO, 
  #     IDCluster = PIAUD_10_CLUSTER,
  #     IDCliente = PIAUD_10_CLI_NDG,
  #     ClienteDenominazione = PIAUD_10_CLI_DENOM,
  #     IDAgente = PIAUD_10_AGE_NDG, 
  #     DataTel1 = PIAUD_10_DATA_TEL1,
  #     DataTel2 = PIAUD_10_DATA_TEL2,
  #     DataTel3 = PIAUD_10_DATA_TEL3,
  #     EsitoTel1 = PIAUD_10_ESITO_TEL1,
  #     EsitoTel2 = PIAUD_10_ESITO_TEL2,
  #     EsitoTel3 = PIAUD_10_ESITO_TEL3,
  #     Esito1 = PIAUD_10_ESITO_DOMANDA1,
  #     Esito2 = PIAUD_10_ESITO_DOMANDA2,
  #     Esito3 = PIAUD_10_ESITO_DOMANDA3,
  #     Esito4 = PIAUD_10_ESITO_DOMANDA4,
  #     Esito5 = PIAUD_10_ESITO_DOMANDA5,
  #     Esito6 = PIAUD_10_ESITO_DOMANDA6,
  #     Esito7 = PIAUD_10_ESITO_DOMANDA7,
  #     Nota1 = PIAUD_10_NOTA_DOMANDA1,
  #     Nota2 = PIAUD_10_NOTA_DOMANDA2,
  #     Nota3 = PIAUD_10_NOTA_DOMANDA3,
  #     Nota4 = PIAUD_10_NOTA_DOMANDA4,
  #     Nota5 = PIAUD_10_NOTA_DOMANDA5,
  #     Nota6 = PIAUD_10_NOTA_DOMANDA6,
  #     Nota7 = PIAUD_10_NOTA_DOMANDA7,
  #     Esito=PIAUD_11_ESITO_INTERNO,
  #     DataEsitoInterno = PIAUD_11_DATA,
  #     InvioNuovoContratto = PIAUD_11_FLAG_INVIO, 
  #     InvioPEC = PIAUD_11_INVIO_PEC,
  #     NotaEsitoInterno = PIAUD_11_NOTE_ESITO
  #   ) %>%
  #   mutate(
  #     EsitoOutsourcer = if_else(
  #         Esito3 == "KO" |
  #         Esito4 == "KO" | 
  #         Esito5 == "KO" | 
  #         Esito6 == "KO" | 
  #         Esito7 == "KO",
  #         "KO",
  #         "OK"
  #     )
  #     ) %>%
  #   mutate(EsitoInterno = case_when(
  #     Esito=="OK - accertamenti effettuati                      " ~ "OK",
  #     Esito=="OK                                                " ~ "OK",
  #     is.na(Esito) ~ "---"
  #   )) %>%
  #   left_join(tb_utcre, by="IDAgente")
  
  # Trasformo ciascuna colonna in UTF8
  for (i in names(tbl)) {
    tbl[[i]]<-stri_enc_toascii(tbl[[i]])
  }
  
  return(tb)  
}
