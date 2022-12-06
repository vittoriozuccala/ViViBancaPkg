#' Accorpa data Anno,Mese,Giorno in AnnoMeseGiorno
#'
#' Nelle basi dati tipo i GEUTY, si trovano le date divise in tre campi diversi
#' come ad esempio DATAPERF_AA, DATAPERF_MM, DATAPERF_GG
#' La funzione serve per unirli in un unico campo.
#' Viene previsto anche il caso in cui anno, mese e giorno siano nulli
#' @param aa Rappresenta l'anno
#' @param mm Rappresenta il mese
#' @param gg Rappresenta il giorno
#' @return I tre campi accorpati
#' @examples 
#' data <- accorpa_AAMMGG(2008,1,19);
#' @export

accorpa_AAMMGG <- function(aa,mm,gg){
  gg[aa==0] <- 1
  mm[aa==0] <- 1
  aa[aa==0] <- 1900
  dd <- paste(aa,mm,gg,sep = "-")
  dd <- as.Date(dd)
  
  return(dd)
}