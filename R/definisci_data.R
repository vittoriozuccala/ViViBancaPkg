#' Definisce date
#'
#' Questa funzione serve per definire date
#' @param quando è il nome del tempo e può essere InizioAnno, FineMesePrecedente, Oggi (default), Ultimi3Mesi, Ultimi12Mesi
#' @param  dt è una data di partenza. Di default Sys.Date()
#' @return Ritorna la data desiderata
#' @examples 
#' data <- definisci_data(quando="Ultimi3Mesi",dt="2022-12-06");
#' @export
#' @import lubridate


definisci_data <- function(quando="Oggi",dt=Sys.Date()){
  
  periodi = c(
    "InizioAnno",
    "FineMesePrecedente",
    "Oggi",
    "Ultimi3Mesi",
    "Ultimi12Mesi"
  )
  
  frase_start= paste("Definisco la data",quando,sep = " ")
  message(frase_start)
  
  if(quando=="Oggi"){
    dd <- Sys.Date()  
  }
  else if (quando=="InizioAnno") {
    dd <- ymd(paste(year(dt),"1","1"))
  }
  else if(quando=="FineMesePrecedente"){
    dd <- floor_date(dt,unit="month")-days(1)  
  }
  else if (quando=="Ultimi3Mesi") {
    dd <- dt - months(3)
  }
  else if (quando=="Ultimi12Mesi") {
    dd <- dt - years(1)
  }
  else{
    periodi_tot = paste(periodi, collapse = ", ")
    frase_stop = paste("Il parametro 'quando' deve essere uno di: ",periodi_tot)
    stop(frase_stop)  
  }
  
  return(dd)
}