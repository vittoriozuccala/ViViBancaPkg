# ViViBancaPkg
In questo pacchetto vengono accorpate delle funzioni utili per chi lavora con R in ViViBanca S.p.A.   

Le spiegazioni alla creazione di un pacchetto sono recuperate dal sito [Ourcodingclub](https://ourcodingclub.github.io/tutorials/writing-r-package/#:~:text=To%20get%20started%20on%20a,with%20the%20New%20Directory%20option.) 

Dopo aver inserito il codice su un file.R si metta la documentazione in roxigen e si digitino i seguenti comandi:
getwd()            # Assicurati che la cartella sia quella del pacchetto
library(roxygen2); # Read in the roxygen2 R package
roxygenise();      # Builds the help files
