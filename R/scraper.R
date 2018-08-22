### scraper na data volby.cz (1994, 1998, 2002)

library('RCurl')
library('XML')
library('stringr')

scraper <- function(rok) {

  
  ## seznam obcí + linků
  
  x_listobci <- read.csv(text='KODZASTUP, NAZEVZAST, DRUHZASTUP, OBVODY, LINK')
  
  # v roce 1994 starý číselník
  if (rok %in% c(1998, 2002)) {
    nuts <- read.csv('../data/kandidatky/ciselniky/nuts.csv', header=F)
  } else {
    nuts <- read.csv('../data/kandidatky/ciselniky/nuts_old.csv', header=F)
  }
  nuts <- as.vector(nuts[,1])
  
  for (i in 1:length(nuts)) {
    
    x_web<- getURL(paste0('https://volby.cz/pls/kv', rok, 
                          '/kv222?xjazyk=CZ&xid=1&xv=11&xnumnuts=', 
                          nuts[i]), .encoding = 'ISO-8859-2') 
    x_web <- readLines(tc <- textConnection(x_web)); close(tc)
    
    x_radky <- grep('<td align="CENTER" nowrap="nowrap"><a href="kv221', x_web)  
    
    x_kodzast <- x_web[x_radky]  
    x_kodzast <- gsub('<td.*\">', '', x_kodzast)
    x_kodzast <- gsub('</a.*', '', x_kodzast)
    
    x_nazevzast <- x_web[x_radky + 1]  
    x_nazevzast <- gsub('<td nowrap="nowrap">', '', x_nazevzast)
    x_nazevzast <- gsub('</td>', '', x_nazevzast)
    
    x_druhzast <- x_web[x_radky + 2]  
    x_druhzast <- gsub('<td.*\">', '', x_druhzast)
    x_druhzast <- gsub('</td>', '', x_druhzast)
    
    x_obvody <- x_web[x_radky + 3]  
    x_obvody <- gsub('<td.*\">', '', x_obvody)
    x_obvody <- gsub('</a></td>', '', x_obvody)
    x_obvody <- gsub('&nbsp;</td>', '', x_obvody)
    x_obvody <- gsub('</tr>', '', x_obvody)
    
    x_link <- x_web[x_radky]  
    x_link <- gsub('<td.*<a href=\"', '', x_link)
    x_link <- gsub('\">.*', '', x_link)
    
    x_obce <- cbind(x_kodzast, x_nazevzast, x_druhzast, x_obvody, x_link)
    
    x_listobci <- rbind(x_listobci, x_obce)
    
    print(i)
    
  }  
  
  colnames(x_listobci) <- c('KODZAST', 'NAZEVZAST', 'DRUHZAST', 'OBVODY', 'LINK')  
  
  # link na obce má jiné čtyřčíslí, než je v seznamu; taky vadí 'amp;'
  x_listobci$LINK <- gsub('kv2211', 'kv21111', x_listobci$LINK)
  x_listobci$LINK <- gsub('amp;', '', x_listobci$LINK)
  
  x_listobci$KODZAST <- as.character(x_listobci$KODZAST)
  x_listobci$NAZEVZAST <- as.character(x_listobci$NAZEVZAST)
  x_listobci$DRUHZAST <- as.character(x_listobci$DRUHZAST)
  x_listobci$OBVODY <- as.character(x_listobci$OBVODY)
  

  ## pro jednotlivé obce
  
  df <- read.csv(text='KODZASTUP, NAZEVZAST, DRUHZASTUP, COBVODU, OSTRANA, NAZEVCELK, PORCISLO, JMENOPRIJMENI, TITULY, VEK, NSTRANA, PSTRANA, POCHLASU, POCPROCVSE, PORADI, MANDAT')
  
  for (i in 1:nrow(x_listobci)) {
    
    x_web<- getURL(paste0('https://volby.cz/pls/kv', rok, '/', x_listobci$LINK[i], 
                          '&xstrana=0'), .encoding = 'ISO-8859-2')
    x_web <- readLines(tc <- textConnection(x_web)); close(tc)
    
    x_radek <- grep('<table  BORDER nowrap="nowrap"  ALIGN="CENTER"  CELLPADDING="5">', x_web)
    
    # obce s obvody mají v tabulce o řádek víc
    if (x_listobci$OBVODY[i] == 'X') {
      x_radek <- x_radek + 20 
      x_radky <- seq(x_radek, length(x_web) - 25, by = 15)
      
      x_obvod <- x_web[x_radky]  
      x_obvod <- gsub('<td.*\">', '', x_obvod)
      x_obvod <- gsub('</td>', '', x_obvod)
      
      x_ostrana <- x_web[x_radky + 1]
      x_ostrana <- gsub('<td.*\">', '', x_ostrana)
      x_ostrana <- gsub('</td>', '', x_ostrana)  
      
      x_strana <- x_web[x_radky + 2]  
      x_strana <- gsub('<td.*\">', '', x_strana)
      x_strana <- gsub('<BR></td>', '', x_strana)
      
      x_porcislo <- x_web[x_radky + 3]  
      x_porcislo <- gsub('<td.*\">', '', x_porcislo)
      x_porcislo <- gsub('</td>', '', x_porcislo)  
      
      x_jmeno <- x_web[x_radky + 4]  
      x_jmeno <- gsub('<td.*\">', '', x_jmeno)
      x_jmeno <- gsub('</td>', '', x_jmeno)  
      x_jmeno <- gsub('&nbsp;', ' ', x_jmeno)
      
      x_titul <- x_web[x_radky + 5]  
      x_titul <- gsub('<td.*\">', '', x_titul)
      x_titul <- gsub('</td>', '', x_titul)  
      x_titul <- gsub('&nbsp;', ' ', x_titul)
      
      x_vek <- x_web[x_radky + 6]  
      x_vek <- gsub('<td.*\">', '', x_vek)
      x_vek <- gsub('</td>', '', x_vek)  
      
      x_nstrana <- x_web[x_radky + 7]  
      x_nstrana <- gsub('<td.*\">', '', x_nstrana)
      x_nstrana <- gsub('</td>', '', x_nstrana)  
      
      x_pstrana <- x_web[x_radky + 8]  
      x_pstrana <- gsub('<td.*\">', '', x_pstrana)
      x_pstrana <- gsub('</td>', '', x_pstrana)  
      
      x_hlasy <- x_web[x_radky + 9]  
      x_hlasy <- gsub('<td.*\">', '', x_hlasy)
      x_hlasy <- gsub('</td>', '', x_hlasy)  
      x_hlasy <- gsub('&nbsp;', '', x_hlasy)  
      
      x_proc <- x_web[x_radky + 10]  
      x_proc <- gsub('<td.*\">', '', x_proc)
      x_proc <- gsub('</td>', '', x_proc)  
      
      x_poradi <- x_web[x_radky + 11]  
      x_poradi <- gsub('<td.*\">', '', x_poradi)
      x_poradi <- gsub('</td>', '', x_poradi)  
      x_poradi <- gsub('&nbsp;', '', x_poradi)  
      
      x_mandat <- x_web[x_radky + 12]  
      x_mandat <- gsub('<td.*\">', '', x_mandat)
      x_mandat <- gsub('</td>', '', x_mandat)  
      x_mandat <- gsub('&nbsp;', '', x_mandat)  
      
    } else {
      x_radek <- x_radek + 19 
      x_radky <- seq(x_radek, length(x_web) - 25, by = 14)
      
      x_obvod <- 1
      
      x_ostrana <- x_web[x_radky]
      x_ostrana <- gsub('<td.*\">', '', x_ostrana)
      x_ostrana <- gsub('</td>', '', x_ostrana)  
      
      x_strana <- x_web[x_radky + 1]  
      x_strana <- gsub('<td.*\">', '', x_strana)
      x_strana <- gsub('<BR></td>', '', x_strana)
      
      x_porcislo <- x_web[x_radky + 2]  
      x_porcislo <- gsub('<td.*\">', '', x_porcislo)
      x_porcislo <- gsub('</td>', '', x_porcislo)  
      
      x_jmeno <- x_web[x_radky + 3]  
      x_jmeno <- gsub('<td.*\">', '', x_jmeno)
      x_jmeno <- gsub('</td>', '', x_jmeno)  
      x_jmeno <- gsub('&nbsp;', ' ', x_jmeno)
      
      x_titul <- x_web[x_radky + 4]  
      x_titul <- gsub('<td.*\">', '', x_titul)
      x_titul <- gsub('</td>', '', x_titul)  
      x_titul <- gsub('&nbsp;', ' ', x_titul)
      
      x_vek <- x_web[x_radky + 5]  
      x_vek <- gsub('<td.*\">', '', x_vek)
      x_vek <- gsub('</td>', '', x_vek)  
      
      x_nstrana <- x_web[x_radky + 6]  
      x_nstrana <- gsub('<td.*\">', '', x_nstrana)
      x_nstrana <- gsub('</td>', '', x_nstrana)  
      
      x_pstrana <- x_web[x_radky + 7]  
      x_pstrana <- gsub('<td.*\">', '', x_pstrana)
      x_pstrana <- gsub('</td>', '', x_pstrana)  
      
      x_hlasy <- x_web[x_radky + 8]  
      x_hlasy <- gsub('<td.*\">', '', x_hlasy)
      x_hlasy <- gsub('</td>', '', x_hlasy)  
      x_hlasy <- gsub('&nbsp;', '', x_hlasy)  
      
      x_proc <- x_web[x_radky + 9]  
      x_proc <- gsub('<td.*\">', '', x_proc)
      x_proc <- gsub('</td>', '', x_proc)  
      
      x_poradi <- x_web[x_radky + 10]  
      x_poradi <- gsub('<td.*\">', '', x_poradi)
      x_poradi <- gsub('</td>', '', x_poradi)  
      x_poradi <- gsub('&nbsp;', '', x_poradi)  
      
      x_mandat <- x_web[x_radky + 11]  
      x_mandat <- gsub('<td.*\">', '', x_mandat)
      x_mandat <- gsub('</td>', '', x_mandat)  
      x_mandat <- gsub('&nbsp;', '', x_mandat)  
    }
    
    x_kandidati <- cbind(x_listobci$KODZAST[i], x_listobci$NAZEVZAST[i], x_listobci$DRUHZAST[i], 
                         x_obvod, x_ostrana, x_strana, x_porcislo, x_jmeno, x_titul, 
                         x_vek, x_nstrana, x_pstrana, x_hlasy, x_proc, x_poradi, x_mandat)
    
    colnames(x_kandidati) <- c('KODZASTUP', 'NAZEVZAST', 'DRUHZASTUP', 'COBVODU', 'OSTRANA', 
                               'NAZEVCELK', 'PORCISLO', 'JMENOPRIJMENI', 'TITULY', 'VEK', 
                               'NSTRANA', 'PSTRANA', 'POCHLASU', 'POCPROCVSE', 'PORADI', 
                               'MANDAT')
    
    df <- rbind(df, x_kandidati)
    
    print(i)
    
  }  
  
  # vyčistit nečeské symboly
  
  for (i in 1:16) {
    df[, i] <- gsub('»', 'ť', df[, i]); df[, i] <- gsub('«', 'Ť', df[, i])
    df[, i] <- gsub('ľ', 'ž', df[, i]); df[, i] <- gsub('®', 'Ž', df[, i])
    df[, i] <- gsub('ą', 'š', df[, i]); df[, i] <- gsub('©', 'Š', df[, i])
    df[, i] <- gsub('¶', 'ś', df[, i]); df[, i] <- gsub('¦', 'Ś', df[, i])
    print(i)
  }
  
  # jméno a příjmení samostatně
  df$JMENOPRIJMENI <- toupper(df$JMENOPRIJMENI)
  df$JMENO <- gsub('.* ', '', df$JMENOPRIJMENI)
  df$PRIJMENI <- gsub(' .*', '', df$JMENOPRIJMENI)
  
  # věk jako numeric
  df$VEK <- as.numeric(df$VEK)
  
  # a u názvů stran odstranit uvozovky
  df$NAZEVCELK <- gsub('"', '', df$NAZEVCELK, fixed = T) 
  
  
  ## přidat jako data frame do global
  
  x_name <- paste0('df_', substr(rok, 3, 4))
  assign(x_name, df, envir = .GlobalEnv)

}
