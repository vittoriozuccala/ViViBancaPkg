#' Estrai iSal
#'
#' Questa funzione serve per estrarre iSal
#' @param connessione è connessione
#' @return Ritorna iSal
#' @examples 
#' isal <- estrai_tabella_isal(connessione);
#' @export

estrai_tabella_isal <- function(connessione){

  # Per i test:
  # connessione <- con
  
  
  #### Creazione FeedbackMacro ####
  feedbackMacro = tribble(
    ~IDFeedback,~FeedbackMacroDescrizione,
    0,       "NoRisp",
    1,       "Conclusa",
    2,       "Conclusa",
    3,       "Progress",
    4,       "Progress",
    5,       "Conclusa",
    6,       "Conclusa",
    7,       "Scaduta",
    8,       "Conclusa",
    9,       "Conclusa"
  )
  
  #### Creazione FollowupMacro ####
  followupMacro = tribble(
    ~IDFollowup, ~FollowupMacroDescrizione,
    0,           "NoRisp",
    1,           "Conclusa",
    2,           "Non eseguita",
    3,           "Non eseguita",
    4,           "Terminare",
    5,           "Terminare",
    6,           "Terminare",
    7,           "Conclusa"
  )
  
  
  #### Estrazione AUSAL020: categorie ####
  query <- paste("select * from md_webi.ausal020F")
  ausal020 <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  ausal020 <- as_tibble(ausal020)
  
  db_categorie <- ausal020 %>% 
    select(
      IDCategoria=AUSAL_02_ID_CATEGORIA,
      CategoriaDescrizione=AUSAL_02_DESCRIZIONE
    )%>% 
    mutate_at(c("CategoriaDescrizione"),riprogramma_testo) 
  
  
  #### Estrazione AUSAL030F: punteggio ####
  query <- "select * from md_webi.AUSAL030F"
  ausal030 <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  ausal030 <- as_tibble(ausal030)
  
  db_punteggio = ausal030 %>% 
    select(
      IDPunteggio = AUSAL_03_ID_PUNTEGGIO,
      PunteggioDescrizione = AUSAL_03_DESCRIZIONE
    ) %>% 
    mutate_at(c("PunteggioDescrizione"),riprogramma_testo)
  
  
  #### Estrazione AUSAL040: tipologia ####
  query <- paste("select * from md_webi.ausal040F")
  ausal040 <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  ausal040 <- as_tibble(ausal040)
  
  db_tipologie <- ausal040 %>% 
    select(
      IDTipologia=AUSAL_04_ID_TIPOLOGIA,
      TipologiaDescrizione=AUSAL_04_DESCRIZIONE,
      TipologiaStato=AUSAL_04_STATO
    )%>% 
    mutate_at(c("TipologiaDescrizione"),riprogramma_testo)
 
  #### Estrazione AUSAL050: area rischio ####
  query <- paste("select * from md_webi.ausal050F")
  ausal050 <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  ausal050 <- as_tibble(ausal050)
  
  db_arearischi <- ausal050 %>% 
    select(
      IDAreaRischio=AUSAL_05_ID_AREA_RISCHIO,
      AreaRischioDescrizione=AUSAL_05_DESCRIZIONE
    )%>% 
    mutate_at(c("AreaRischioDescrizione"),riprogramma_testo) 
  
  #### Estrazione AUSAL070F: ufficio ####
  query <- "select * from md_webi.AUSAL070F"
  ausal070 <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  ausal070 <- as_tibble(ausal070)
  
  db_uffici = ausal070 %>% 
    select(
      IDUfficio=AUSAL_07_ID_UFFICIO,
      UfficioDescrizione=AUSAL_07_DESCRIZIONE
    ) %>% 
    mutate_at(c("UfficioDescrizione"),riprogramma_testo)
  
  
  #### Estrazione AUSAL080F: responsabile ####
  query <- "select * from md_webi.AUSAL080F"
  ausal080 <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  ausal080 <- as_tibble(ausal080)
  
  db_responsabile = ausal080 %>% 
    select(
      IDResponsabile = AUSAL_08_ID_RESPONSABILE,
      ResponsabileDescrizione = AUSAL_08_DESCRIZIONE
    ) %>% 
    mutate_at(c("ResponsabileDescrizione"),riprogramma_testo)
  
  #### Estrazione AUSAL090F: referente ####
  query <- "select * from md_webi.AUSAL090F"
  ausal090 <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  ausal090 <- as_tibble(ausal090)
  
  db_referente = ausal090 %>% 
    select(
      IDReferente = AUSAL_09_ID_REFERENTE,
      ReferenteDescrizione = AUSAL_09_DESCRIZIONE
    ) %>% 
    mutate_at(c("ReferenteDescrizione"),riprogramma_testo)
  
  #### Estrazione AUSAL100F: status Feedback ####
  query <- "select * from md_webi.AUSAL100F"
  ausal100 <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  ausal100 <- as_tibble(ausal100)
  
  db_fb = ausal100 %>% 
    select(
      IDFeedback=AUSAL_10_ID_FEEDBACK, 
      FeedbackDescrizione = AUSAL_10_DESCRIZIONE
    ) %>%
    mutate(FeedbackDescrizione=replace_non_ascii(FeedbackDescrizione),.keep="unused") %>% 
    mutate_at(c("FeedbackDescrizione"),riprogramma_testo) %>% 
    left_join(feedbackMacro, by = "IDFeedback")
  
  
  
  #### Estrazione AUSAL110F: status FollowUP ####
  query <- "select * from md_webi.AUSAL110F"
  ausal110 <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  ausal110 <- as_tibble(ausal110)
  
  db_fu = ausal110 %>% 
    select(
      IDFollowup=AUSAL_11_ID_FOLLOWUP,
      FollowupDescrizione=AUSAL_11_DESCRIZIONE
    ) %>% 
    mutate_at(c("FollowupDescrizione"),riprogramma_testo) %>% 
    left_join(followupMacro,by="IDFollowup")
  
  
  
  #### Estrazione AUSAL170: problematicita' ####
  query <- paste("select * from md_webi.ausal170F")
  ausal170 <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  ausal170 <- as_tibble(ausal170)
  
  db_problematicita = ausal170 %>% 
    select(
      IDProblematicita=AUSAL_17_ID_PROBLEMATICITA,
      ProblemaDescrizione=AUSAL_17_DESCRIZIONE
    )%>% 
    mutate_at(c("ProblemaDescrizione"),riprogramma_testo)
  
  
  
  #### Estrazione AUSAL010: rilievi ####
  query <- "select * from md_webi.AUSAL010F"
  ausal010 <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  ausal010 <- as_tibble(ausal010)
  
  db_rilievi = ausal010 %>% 
            select(
              IDRaccomandazione = AUSAL_01_RACCOMANDAZIONE, 
              RaccomandazioneTitolo = AUSAL_01_INT_TITOLO, 
              RaccomandazioneDescrizione = AUSAL_01_RIL_DESCRIZIONE, 
              IDCategoria = AUSAL_01_INT_ID_CATEGORIA, # AUSAL_01_INT_NUMERO,
              NDGAgente = AUSAL_01_INT_NDG, 
              IDPianificata = AUSAL_01_INT_PIANIFICATA, 
              IDMotivazione = AUSAL_01_INT_MOTIVAZIONE, 
              IDPunteggio = AUSAL_01_INT_ID_PUNTEGGIO, 
              DataInserimento =  AUSAL_01_INT_DATA, 
              DataVerifica = AUSAL_01_INT_DATA_VERIFICA, 
              IDTipologia = AUSAL_01_RIL_ID_TIPOLOGIA, #AUSAL_01_RIL_NUMERO, 
              IDProblematicita = AUSAL_01_RIL_ID_PROBLEMATIC, 
              IDAreaRischio = AUSAL_01_RIL_ID_AREA_RISCHIO, 
              IDUfficio = AUSAL_01_RIL_ID_UFFICIO, # AUSAL_01_RIL_ID_RESPONSABILE1, 
              IDResponsabile = AUSAL_01_RIL_ID_RESPONSABILE2, 
              IDReferente = AUSAL_01_RIL_ID_REFERENTE, 
              IDFeedback = AUSAL_01_FB_ID_STATUS, 
              FeedbackTesto = AUSAL_01_FB_DESCRIZIONE, 
              FeedbackScadenza = AUSAL_01_FB_SCADENZA, 
              FeedbackScadenzaOriginaria = AUSAL_01_FB_SCADENZA_ORIG, 
              FeedbackNumeroRipianificazioni = AUSAL_01_FB_NR_RIPIANIFICAZ, 
              FeedbackUtente = AUSAL_01_FB_UTENTE, 
              FeedbackData = AUSAL_01_FB_DATA, 
              FeedbackOra = AUSAL_01_FB_ORA, 
              IDFollowup=AUSAL_01_FU_ID_STATUS, #AUSAL_01_FU_TIPO_FU, 
              FollowupTesto = AUSAL_01_FU_DESCRIZIONE, 
              FollowupMotivo = AUSAL_01_FB_MOTIVO, 
              FollowupAnnotazione = AUSAL_01_FU_ANNOTAZIONI, 
              FollowupUtente = AUSAL_01_FU_UTENTE, 
              FollowupData=AUSAL_01_FU_DATA, 
              FollowupOra=AUSAL_01_FU_ORA, 
              ModGestore=AUSAL_01_MOD_GESTORE, 
              ModReferente=AUSAL_01_MOD_REFERENTE, 
              Lock=AUSAL_01_LOCK, 
              LockUser=AUSAL_01_LOCK_USER 
            ) %>% 
    mutate(RaccomandazioneTitolo=replace_non_ascii(RaccomandazioneTitolo),.keep="unused") %>% 
    mutate(RaccomandazioneDescrizione=replace_non_ascii(RaccomandazioneDescrizione),.keep="unused") %>% 
    mutate(FollowupTesto=replace_non_ascii(FollowupTesto),.keep="unused") %>% 
    mutate(FeedbackTesto=replace_non_ascii(FeedbackTesto),.keep="unused") %>% 
    mutate(DataInserimento=ymd(DataInserimento),.keep="unused") %>% 
    mutate(DataVerifica=ymd(DataVerifica),.keep="unused") %>%
    mutate_at(                                                   #IMPORTANTISSIMO
      c("FeedbackData","FollowupData","FeedbackScadenza"),       #DATE con Zeri
      ~ifelse(.==0,19000101,.)
    ) %>% 
    mutate(FeedbackData=ymd(FeedbackData),.keep="unused") %>% 
    mutate(FollowupData=ymd(FollowupData),.keep="unused") %>% 
    mutate(FeedbackScadenza=ymd(FeedbackScadenza),.keep="unused")
  

    
  
  
  #### ISAL ####
  iSal <- db_rilievi %>% 
    left_join(db_categorie,by = "IDCategoria") %>% 
    left_join(db_punteggio, by = "IDPunteggio") %>% 
    left_join(db_tipologie,by = "IDTipologia") %>% 
    left_join(db_arearischi,by = "IDAreaRischio") %>% 
    left_join(db_uffici,"IDUfficio") %>% 
    left_join(db_responsabile,by = "IDResponsabile") %>% 
    left_join(db_referente,by = "IDReferente") %>% 
    left_join(db_fb, by = "IDFeedback") %>% 
    left_join(db_fu, by = "IDFollowup") %>% 
    left_join(db_problematicita,by = "IDProblematicita") %>% 
    mutate_if(is.character, ~gsub('[^ -~]', '', .))

  # Trasformo ciascuna colonna in UTF8
  for (i in names(iSal)) {
    iSal[[i]]<-stri_enc_toascii(iSal[[i]])
  }
  
  return(iSal)
  
}