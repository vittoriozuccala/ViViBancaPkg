% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estrai_tabella_customer_satisfaction.R
\name{estrai_tabella_customer_satisfaction}
\alias{estrai_tabella_customer_satisfaction}
\title{Estrae tabella AS400}
\usage{
estrai_tabella_customer_satisfaction(connessione)
}
\arguments{
\item{connessione}{è la connessione ad AS400}
}
\value{
Ritorna cd
}
\description{
Questa funzione estrae CS da AS
}
\examples{
cs <- estrai_tabella_customer_satisfaction(connessione);
}
