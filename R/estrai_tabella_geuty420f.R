#' Estrae GEUTY420F con gli importi erogati ed ergoabili
#'
#' Questa funzione permette di estrarre la tabella GEUTY420F dal CRM aziendale su AS400
#' 
#' La elaborazione dura almeno un paio di minuti perchè deve estrarre 
#' centinaia di migliaia di records.
#' 
#' Al termine viene estratto un dataframe sottoforma di tibble.
#' 
#' I campi numerici sono stati modificati correttamente in numero
#' @param connessione è la connessione ad AS400 di solito realizzata con la funzione connessione_as400 del pacchetto.
#' @return Ritorna geuty420f
#' @examples 
#' g420 <- estrai_tabella_geuty420f(connessione);
#' @export


estrai_tabella_geuty420f <- function(connessione){
  
  # Per test
  # connessione <- con
  
  query <- paste("select * from odbc_md.geuty420f")
  df <- sqlQuery(connessione, query, stringsAsFactors=FALSE )
  tb <- as_tibble(df)

  names(tb) <- names(tb) %>% map_chr(str_replace,"GE420_","")
  

  tb$DES_FINANZIARIA <- riprogramma_testo(tb$DES_FINANZIARIA)
  tb$DES_BANCA <- riprogramma_testo(tb$DES_BANCA)
  
  tb$DDE <- accorpa_AAMMGG(
    tb$DDEA,
    tb$DDEM,
    tb$DDEG)
  
  tb$DTL <- accorpa_AAMMGG(
    tb$DTLA,
    tb$DTLM,
    tb$DTLG)
  
  tb$DTR <- accorpa_AAMMGG(
    tb$DTRA,
    tb$DTRM,
    tb$DTRG)
  
  tb$DTS <- accorpa_AAMMGG(
    tb$DTSA,
    tb$DTSM,
    tb$DTSG)
  
  tb$DTE <- accorpa_AAMMGG(
    tb$DTEA,
    tb$DTEM,
    tb$DTEG)
  
  tb$DTAB <- accorpa_AAMMGG(
    tb$DTABA,
    tb$DTABM,
    tb$DTABG)
  
  tb$DTCO <- accorpa_AAMMGG(
    tb$DTCOA,
    tb$DTCOM,
    tb$DTCOG)
  
  # Questa istruzione serve per aggiustare l'encoding
  tb %>% mutate_if(is.character, ~gsub('[^ -~]', '', .))
  
  # Elimino i campi inutili all'inizio dell'estrattore
  tb <- tb %>% select(
    -INDICAZIONE, -DESC_INDICAZIONE,-PROG_MESSAGGIO, -TESTO_1,
    -DDEA, -DDEM, -DDEG,
    -DTLA, -DTLM, -DTLG,
    -DTRA, -DTRM, -DTRG,
    -DTSA, -DTSM, -DTSG,
    -DTEA, -DTEM, -DTEG,
    -DTABA, -DTABM, -DTABG,
    -DTCOA, -DTCOM, -DTCOG,
    )
  
  tb <- tb %>% select(
    NumeroPratica = PRATICA, 
    DDE, DTL, DTR, DTS, DTE, DTAB, DTCO,
    TIPOLOGIA, PROGRESSIVO_PRINC, PROGRESSIVO_SECON,
    TIPO_IMPEGNO, DA_ESTINGUERE, TIPO_CONTRATTO,
    PROV_PROCEDURA, PROV_PRODOTTO, RIF_PRATICA_EST,
    DES_PRATICA_EST, NumeroPraticaCollegata = PRATICA_COLLEGATA,
    FONDO, RESIDUO, 
    IMP_RATA, NUM_RATE, 
    FINANZIARIA, DES_FINANZIARIA, DES_FINANZIARIA_E,
    CONT_ESTINZ, INTE_GIORNALIERI, INTE_CALCOLATI,
    TIPO_EROGAZ, DESTIN_EROGAZ,
    N_RATE_TRATTENUTE, IMP_RATA_TRATT,
    INT_PASS_TRATT, IMP_LIQUIDATO, MOD_PAGAMENTO,
    IMP_COMMISSIONI, IMP_BOLLI, IMP_ANTICIPO,
    BANCA, DES_BANCA, IBAN_BANCA, DES_BON_ELETTR,
    IBAN, CRO
    )

  return(tb)
}
