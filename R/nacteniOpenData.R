### příprava otevřených dat (2006, 2010, 2014, 2018)

# načtení kandidátek (to stejné pro všechny roky)

nacteniOpenData <- function(rok) {

  df_kandidati <- read.csv(paste0('../data/kandidatky/', rok, '/kandidati.csv'), sep=';')
  df_obce <- read.csv(paste0('../data/kandidatky/', rok, '/obce.csv'), sep=';')
  df_strany <- read.csv(paste0('../data/kandidatky/', rok, '/strany.csv'), sep=';')
  
  # spojení kandidátů s číselníkem obcí; u 'velkých' zast. se duplikují podřízené obce, 
  # ty je nutné odstranit; je jedno kterou nechám, výsledky jsou všude stejné  
  df <- merge(df_kandidati, df_obce, by = c('KODZASTUP','COBVODU'), all.x = T)
  df <- df[!duplicated(data.frame(df$KODZASTUP, df$OSTRANA, df$PORCISLO, df$JMENO, 
                                  df$PRIJMENI)),]
  
  # spojení kandidátů a obcí s číselníkem stran
  df <- merge(df, df_strany, by = c('KODZASTUP','COBVODU','OSTRANA'), all.x = T)
  
  # doplnění pohlaví, muž = T
  df$POHLAVI <- !grepl('.*(á|Á)$', df$PRIJMENI)
  
  # jméno, příjmení a název strany slouží k merge, takže raději všechno uppercase
  df$JMENO <- toupper(df$JMENO)
  df$PRIJMENI <- toupper(df$PRIJMENI)
  df$NAZEVCELK <- toupper(df$NAZEVCELK)
  
  # a u názvů stran odstranit uvozovky
  df$NAZEVCELK <- gsub('"', '', df$NAZEVCELK, fixed = T) 
  
  # uspořádání kandidátky
  
  # v roce 2018 se COBROP přejmenoval na ORP
  if (rok == 2018) {
    df <- data.frame(df$KRAJ, df$OKRES, df$KODZASTUP, df$NAZEVZAST.x, 
                     df$COBVODU, df$VSTRANA, df$ZKRATKAO8, df$PORCISLO, 
                     df$JMENO, df$PRIJMENI, df$TITULPRED, df$TITULZA,
                     df$VEK, df$POHLAVI, df$POVOLANI, df$BYDLISTEN, 
                     df$DATNAR, df$MANDAT, df$POCHLASU, df$POCPROCVSE, 
                     df$MAND_STR, df$HLASY_STR, df$PROCHLSTR, df$OSTRANA, 
                     df$PSTRANA, df$NSTRANA, df$POCSTR_SLO, df$SLOZENI, 
                     df$POCHL_PRES, df$PORADIMAND, df$PORADINAHR, 
                     df$ZKRATKAO30, df$NAZEVCELK, df$POR_STR_HL.x,
                     df$TYPZASTUP, df$DRUHZASTUP, df$OBEC, df$NAZEVOBCE, 
                     df$ORP, df$CPOU, df$REGURAD, df$OBVODY, 
                     df$MANDATY, df$POCOBYV, df$MINOKRSEK1, df$MAXOKRSEK1, 
                     df$MINOKRSEK2, df$MAXOKRSEK2, df$MINOKRSEK3, 
                     df$MAXOKRSEK3, df$MINOKRSEK4, df$MAXOKRSEK4, 
                     df$MINOKRSEK5, df$MAXOKRSEK5, df$MINOKRSEK6, 
                     df$MAXOKRSEK6, df$MINOKRSEK7, df$MAXOKRSEK7, 
                     df$MINOKRSEK8, df$MAXOKRSEK8, df$MINOKRSEK9, 
                     df$MAXOKRSEK9, df$MINOKRSE10, df$MAXOKRSE10, 
                     df$TYPDUVODU, df$POCET_VS, df$PLATNOST, df$STAV_OBCE)
  } else {
    df <- data.frame(df$KRAJ, df$OKRES, df$KODZASTUP, df$NAZEVZAST.x, 
                       df$COBVODU, df$VSTRANA, df$ZKRATKAO8, df$PORCISLO, 
                       df$JMENO, df$PRIJMENI, df$TITULPRED, df$TITULZA,
                       df$VEK, df$POHLAVI, df$POVOLANI, df$BYDLISTEN, 
                       df$DATNAR, df$MANDAT, df$POCHLASU, df$POCPROCVSE, 
                       df$MAND_STR, df$HLASY_STR, df$PROCHLSTR, df$OSTRANA, 
                       df$PSTRANA, df$NSTRANA, df$POCSTR_SLO, df$SLOZENI, 
                       df$POCHL_PRES, df$PORADIMAND, df$PORADINAHR, 
                       df$ZKRATKAO30, df$NAZEVCELK, df$POR_STR_HL.x,
                       df$TYPZASTUP, df$DRUHZASTUP, df$OBEC, df$NAZEVOBCE, 
                       df$COBROP, df$CPOU, df$REGURAD, df$OBVODY, 
                       df$MANDATY, df$POCOBYV, df$MINOKRSEK1, df$MAXOKRSEK1, 
                       df$MINOKRSEK2, df$MAXOKRSEK2, df$MINOKRSEK3, 
                       df$MAXOKRSEK3, df$MINOKRSEK4, df$MAXOKRSEK4, 
                       df$MINOKRSEK5, df$MAXOKRSEK5, df$MINOKRSEK6, 
                       df$MAXOKRSEK6, df$MINOKRSEK7, df$MAXOKRSEK7, 
                       df$MINOKRSEK8, df$MAXOKRSEK8, df$MINOKRSEK9, 
                       df$MAXOKRSEK9, df$MINOKRSE10, df$MAXOKRSE10, 
                       df$TYPDUVODU, df$POCET_VS, df$PLATNOST, df$STAV_OBCE)
  }
  
  colnames(df) <- c('KRAJ','OKRES','KODZASTUP','NAZEVZAST','COBVODU','VSTRANA','ZKRATKAO8',
                        'PORCISLO','JMENO','PRIJMENI','TITULPRED','TITULZA','VEK', 'POHLAVI', 'POVOLANI',
                        'BYDLISTEN','DATNAR','MANDAT','POCHLASU','POCPROCVSE','MAND_STR',
                        'HLASY_STR','PROCHLSTR','OSTRANA','PSTRANA','NSTRANA','POCSTR_SLO',
                        'SLOZENI','POCHL_PRES','PORADIMAND','PORADINAHR','ZKRATKAO30','NAZEVCELK',
                        'POR_STR_HL','TYPZASTUP','DRUHZASTUP','OBEC','NAZEVOBCE','COBROP','CPOU',
                        'REGURAD','OBVODY','MANDATY','POCOBYV','MINOKRSEK1','MAXOKRSEK1',
                        'MINOKRSEK2','MAXOKRSEK2','MINOKRSEK3','MAXOKRSEK3','MINOKRSEK4',
                        'MAXOKRSEK4','MINOKRSEK5','MAXOKRSEK5','MINOKRSEK6','MAXOKRSEK6',
                        'MINOKRSEK7','MAXOKRSEK7','MINOKRSEK8','MAXOKRSEK8','MINOKRSEK9',
                        'MAXOKRSEK9','MINOKRSE10','MAXOKRSE10','TYPDUVODU','POCET_VS',
                        'PLATNOST','STAV_OBCE')
  
  
  ## přidat jako data frame do global
  
  x_name <- paste0('df_', substr(rok, 3, 4))
  assign(x_name, df, envir = .GlobalEnv)

}
