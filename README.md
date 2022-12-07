# ViViBancaPkg

Questo pacchetto contiene diverse funzioni utili per tutti gli utenti che lavorano all'interno di [ViViBanca S.p.A.](https://www.vivibanca.it/) ed utilizzano il *Linguaggio R* .

I sorgenti per compilare il progetto si trovano su **Github** e si possono scarciare dal link [ViViBancaPkg](https://vittoriozuccala.github.io/ViViBancaPkg/.

Per avere maggiori informazioni sulle funzioni contenute, leggere tutorial o articoli pertinenti, è possibile consultare [la pagina del progetto](https://github.com/vittoriozuccala/ViViBancaPkg)

# Funzioni contenute
Le funzioni contenute nel file sono:

- Funzioni di utilità generale:
  - **leggi_configurazione**: legge una configurazione *YAML*
  - **accorpa_AAMMGG**: serve per accorpare anno mese giorno in un unico campo
  - **definisci_data**
  - **riprogramma_testo**
- Funzioni legate ad AS400:
  - **connessione_as400**
  - **estrai_tabella_customer_satisfaction**
  - **estrai_tabella_geuty400**
  - **estrai_tabella_reclami**

Mentre le funzioni di utilità generale sono funzioni che possono essere utilizzate in differenti contesti anche non per forza associate ai database

## leggi_configurazione
La prima funzione permette di leggere un file di configurazione in formato **YAML**. Ovviamente richiede l'apposito pacchetto 

```
cnf <- leggi_configurazione("file_config.txt")
``` 








## Il sistema di cartelle
Il sistema di cartelle in un *pacchetto R* è variegato. Nella cartella del progetto è necessario avere sicuramente:

- **R**: dove saranno posizionati i vari files in R
- **man**: viene generata in forma automatica da *roxygen2* dopo alla creazione della documentazione 


Ci sono poi altre cartelle che possono essere necessarie al progetto:

- **data**: contiene tutti gli eventuali data-files necessari al corretto funzionamento del pacchetto R. Questi files sono salvati in *formato .rda* utilizzando la funzione *save()* in R e possono essere caricati dal pacchetto come succede, ad esempio a *data(mtcars)* nel pacchetto *base* di R.
- **docs**: include documenti per un eventuale sito da configurare su *GitHub* come quello di [questo progetto](https://vittoriozuccala.github.io/ViViBancaPkg/). Personalmente ho utilizzato [pgkdown](https://pkgdown.r-lib.org/articles/pkgdown.html)
- src contains compiled code that is used by your R functions. This could include code written in C or C++ to speed up computations. In some packages, most of the code is actually in this folder.
- tests includes files to test your code to ensure that it is running properly throughout the development process. This folder can be created using the testthat R package. For large projects, especially, this is extremely useful because it allows you to quickly test to make sure that all of the functions that you write return the output that you expect of them.
- vignettes includes larger documentation files for your code – more like a package guide than a simple help file for package functions. [Here is an example from GMSE](https://confoobio.github.io/gmse/articles/SI1.html).


We can build a source package (i.e., a zipped version of the R package) in Rstudio by selecting Build > Build Source Package. This will create a zipped package outside of the package directory, which would be what we would need to build if we wanted to submit our package to CRAN.