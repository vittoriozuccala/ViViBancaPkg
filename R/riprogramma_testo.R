#' Riprogramma il testo
#'
#' Questa funzione serve riprogrammare il testo
#' @param elemento è il nome dell'elemento da riprogrammare
#' @return Ritorna un elemento riprogrammato
#' @examples 
#' elem <- riprogramma_testo(elemento);
#' @export
#' @import purrr
#' @import stringr
#' @import stringi

riprogramma_testo <- function(elemento){
  
  elemento <- elemento %>% 
    map(iconv, "UTF-8", "ASCII", sub = "") %>% 
    map(~gsub('[:alnum:]', '', .)) %>% 
    map(str_to_title) %>% 
    map(str_replace,"\\s{2,}"," ") %>% 
    map(stri_enc_toutf8, validate = FALSE) %>%
    map(str_trim,side="both") %>% 
    flatten()
  
  return(elemento)
}
