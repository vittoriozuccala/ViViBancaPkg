#' Leggi configurazione in formato YAML
#'
#' Questa funzione serve per leggere un file di configurazione YAML
#' @param file_config è il nome del file da leggere
#' @return Ritorna un elenco con le configurazioni da utilizzare
#' @examples 
#' cnf <- leggi_configurazione("config.yaml");
#' @export

library(yaml)

leggi_configurazione <- function(file_config){
  configurazione <- read_yaml(file_config)
  return(configurazione)
}