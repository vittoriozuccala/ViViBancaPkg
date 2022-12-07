#' Estrai reclami
#'
#' Questa funzione serve per estrarre reclami
#' @param connessione è connessione
#' @return Ritorna tabella reclami
#' @examples 
#' rec <- estrai_tabella_reclami(connessione);
#' @export



estrai_tabella_reclami <- function(connessione){
  
  # Per test
  # connessione <- con
  
  
  #### Testata ####
  query <- paste("select * from odbc_md.pircl001qm")
  df <- sqlQuery(con, query, stringsAsFactors=FALSE )
  tb_testata <- as_tibble(df)
  tb_testata <- tb_testata %>% 
    select(
      IDReclamo = "NRREC",
      T_ReclamoProgressivo = "PROGRESSIVORECLAMO",
      T_DataRicezioneReclamo = "DATARICEZIONERECLAMO",
      T_Canale = "CANALERICEZIONE",
      T_SettoreBusiness = "SETTOREBUSINESS",
      T_TipoMittente = "TIPOMITTENTE",
      T_Mittente = "MITTENTE",
      T_BloccoCtr = "BLOCCOCONTRATTO",
      T_Gestore="GESTOREINTERNO",
      T_TipoReclamo = "TIPOLOGIARECLAMO",
      T_DettaglioReclamo="DETTAGLIORECLAMO",
      T_DataRisposta="DATARISPOSTA",
      T_Lexitor="SENTENZALEXITOR",
      T_TipoCliABI="TIPOCLIENTEABI",
      T_TipoRichiestaABI="TIPORICHIESTAEUROABI",
      T_EsitoReclamo= "ESITORECLAMO",
      T_TempoGestione="TEMPOGESTIONE",
      T_Note="NOTE"    )
  
  
  #### Dettagli ####
  query <- paste("select * from odbc_md.pircl002qm")
  df <- sqlQuery(con, query, stringsAsFactors=FALSE )
  tb_dettagli <- as_tibble(df)
  tb_dettagli <- tb_dettagli %>% 
    select(
      T_ReclamoProgressivo="PROGRESSIVORECLAMO",
      NumeroPratica = "NUMPRATICA",
      NDGCliente = "NDGCLIENTE",
      D_DataContratto = "DATACONTRATTO",
      D_BloccoCtr="BLOCCOCONTRATTO",
      D_TipoProdotto = "TIPOPRODOTTO",
      NDGAgente = "NDGAGENTE",
      D_TipoPratica = "TIPOPRATICA",
      D_Cessionario="CESSIONARIO",
      D_RichiestaCliente="RICHIESTACLIENTE",
      D_Transazione= "TRANSAZIONE",
      D_ImportoRiconosciuto="IMPORTORICONOSCIUTO",
      D_Esito="ESITORECLAMO",
      D_DataRisposta="DATARISPOSTA",
      D_Note="NOTE"   
    )
  
  
  #### Allegati ####
  # Non lo utilizzo
  query <- paste("select * from odbc_md.pircl003qm")
  df <- sqlQuery(con, query, stringsAsFactors=FALSE )
  tb_allegati <- as_tibble(df)
  
  
  #### UTCRE001W2 ####
  query <- paste("select * from odbc_md.utcre001w2")
  df <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  tb_utcre <- as_tibble(df)
  
  tb_utcre$RAGSOC <- riprogramma_testo(tb_utcre$RAGSOC)
  
  tb_utcre <- tb_utcre %>% select(
    NDGAgente=INTERMED,
    Intermediario = RAGSOC
  )
  

  tb <- tb_testata  %>% 
          left_join(tb_dettagli,by = "T_ReclamoProgressivo") %>% 
          left_join(tb_utcre,by = "NDGAgente")
  
  tb %>% mutate_if(is.character, ~gsub('[^ -~]', '', .))
  
  # Trasformo ciascuna colonna in UTF8
  for (i in names(tb)) {
    tb[[i]]<-stri_enc_toascii(tb[[i]])
  }
  
  return(tb)  
}