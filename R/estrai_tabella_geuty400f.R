#' Estrae GEUTY
#'
#' Questa funzione permette di estrarre la tabella GEUTY400F dal CRM aziendale su AS400
#' La elaborazione dura almeno un paio di minuti perchè deve estrarre 
#' centinaia di migliaia di records.
#' Al termine viene estratto un dataframe sottoforma di tibble.
#' @param connessione è la connessione ad AS400 di solito realizzata con la funzione connessione_as400 del pacchetto.
#' @return Ritorna geuty
#' @examples 
#' g400 <- estrai_tabella_geuty400f(connessione);
#' @export


estrai_tabella_geuty400fnew <- function(connessione){
  
  # Per test
  # connessione <- con
  
  query <- paste("select * from odbc_md.geuty400f")
  df <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  tb <- as_tibble(df)
  
  names(tb) <- names(tb) %>% map_chr(str_replace,"GE400_","")
  
  tb %>% mutate(
    across(
      .cols = c(
        STATO, STATO_WF, BANCA,
        NUM_RATE, IMP_RATE,
        MONTANTE, FINANZIATO, FINANZIATO_CON_ASS, DELTA_MONTANTE,
        COSTO_1, COSTO_2, COSTO_3, COSTO_4, COSTO_5, COSTO_6, 
        COSTO_ASS_VITA, COSTO_ASS_2,
        NETTO, IMPEGNI, INTER_SCALARI, COMM_BANCARIE, BOLLO_RIVALSA,
        PROVVIGIONI_TOT, PROVVIGIONI_AGE, PROVVIGIONI_SUB,
        SPESE_DA_RETROCEDERE, REDDITO, SALDO_CLIENTE, 
        TAN, TAEG, TEG, 
        IRR_NOMIN, IRR_EFFET,
        TOT_RIL_CARIC, 
        IMP_FLUSSO, TASSO_FLU
      ), 
      .fns =  as.numeric
    )
  )
  
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
