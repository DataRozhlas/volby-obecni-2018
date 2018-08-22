### příprava CSV pro kandidátkovou aplikaci

kandidatkovaAplikace <- function () {

  
  ## csv obce - okresy
  
  df_okresy <- read.csv('../data/kandidatky/ciselniky/cisokresu.csv', encoding = 'UTF-8')
  
  tab_obce <- unique(data.frame(df_18$KODZASTUP, df_18$OKRES, df_18$NAZEVZAST))
  colnames(tab_obce) <- c('KODZASTUP', 'OKRES', 'NAZEVZAST')
  
  # spojit obce s okresy
  tab_obce <- merge(tab_obce, df_okresy, by.x = 'OKRES', by.y = 'IDOKRESU', all.x = T)
  
  # odstranit první sloupec OKRES
  tab_obce <- tab_obce[, 2:4]
  
  tab_obce$NAZEVFULL <- paste(tab_obce$NAZEVZAST, ' (', tab_obce$OKRES, ')', sep = '')  
  tab_obce <- data.frame(tab_obce$NAZEVFULL, tab_obce$KODZASTUP)
  colnames(tab_obce) <- c('NAZEVFULL', 'KODZASTUP')
  
  assign('tab_obce', tab_obce, envir = .GlobalEnv)
  
  write.csv(tab_obce, '../data/kandidatky/app/obce/nazvyobci.csv', row.names = F, 
            fileEncoding = 'UTF-8')
  
  
  ## csv strana - kandidati
  
  # nejdřív kandidáti, pak teprv strany; kvůli obhajobě mandátů, ty se pro strany počítají
  # z detailních kandidátek
  
  tab_kandidati <- data.frame(df$KODZASTUP, df$OSTRANA_18, df$PORCISLO_18, df$TITULPRED_18,
                              df$JMENO, df$PRIJMENI, df$TITULZA_18, df$VEK, df$POVOLANI_18, 
                              df$BYDLISTEN_18, df$PSTRANA_18, df$MANDAT_14, df$NAZEVCELK_14)
  colnames(tab_kandidati) <- c('KODZASTUP', 'OSTRANA', 'PORCISLO', 'TITULPRED', 'JMENO',
                               'PRIJMENI', 'TITULZA', 'VEK', 'POVOLANI', 'BYDLISTE',
                               'PSTRANA', 'OBHAJUJE', 'MINULASTRANA')
  
  # Vyřazení těch, co letos nekandidují
  tab_kandidati <- tab_kandidati[!is.na(tab_kandidati$OSTRANA),]
  
  # Poskládat jméno vč. titulů
  tab_kandidati$JMENOFULL <- paste(tab_kandidati$TITULPRED, tab_kandidati$JMENO,
                                   tab_kandidati$PRIJMENI, tab_kandidati$TITULZA)
  tab_kandidati$JMENOFULL <- trimws(tab_kandidati$JMENOFULL)
  
  # Obhajoba mandátu na string
  tab_kandidati$OBHAJUJE[tab_kandidati$OBHAJUJE == 1] <- 'Ano'
  tab_kandidati$OBHAJUJE[tab_kandidati$OBHAJUJE == 0] <- 'Ne'
  tab_kandidati$OBHAJUJE[is.na(tab_kandidati$OBHAJUJE)] <- 'Ne'

  # u minulé strany NA na prázdný řetězec
  tab_kandidati$MINULASTRANA <- as.character(tab_kandidati$MINULASTRANA)
  tab_kandidati$MINULASTRANA[is.na(tab_kandidati$MINULASTRANA)] <- ''
  
  # spojení s číselníkem politických stran k určení politické příslušnosti
  df_strany_prisl <- read.csv('../data/kandidatky/ciselniky/2018/pstrana.csv', 
                              encoding='Windows-1250', sep=';')
  tab_kandidati <- merge(tab_kandidati, df_strany_prisl, by = 'PSTRANA')
  
  # BEZPP budeme říkat nestraníci
  tab_kandidati$ZKRATKAP8 <- gsub('BEZPP', 'Nestr.', tab_kandidati$ZKRATKAP8)
  
  # u názvu strany odstraníme uvozovky
  tab_kandidati$ZKRATKAP8 <- gsub('"', '', tab_kandidati$ZKRATKAP8, fixed = T)  
  
  tab_kandidati <- data.frame(tab_kandidati$KODZASTUP, tab_kandidati$OSTRANA, 
                              tab_kandidati$PORCISLO, tab_kandidati$JMENOFULL,
                              tab_kandidati$VEK, tab_kandidati$POVOLANI,
                              tab_kandidati$BYDLISTE, tab_kandidati$OBHAJUJE,
                              tab_kandidati$ZKRATKAP8, tab_kandidati$MINULASTRANA);
  
  colnames(tab_kandidati) <- c('ID', 'StranaNr', 'Pořadí', 'Jméno', 'Věk', 'Povolání',
                               'Bydliště', 'Obhajuje', 'Příslušnost', 'Minulá kandidatura')
  
  assign('tab_kandidati', tab_kandidati, envir = .GlobalEnv)
  
  for (i in unique(tab_kandidati$ID)) {
    
    x_strana_kand <- tab_kandidati[tab_kandidati$ID == i, 2:10] 
    write.csv(x_strana_kand, paste0('../data/kandidatky/app/kandidati/', i, '.csv'), 
              row.names = F, fileEncoding = 'UTF-8')    
    print(i)
    
  }
  

  ## csv obce - strany
  
  tab_strany <- unique(data.frame(df_18$KODZASTUP, df_18$NAZEVCELK, df_18$OSTRANA))
  colnames(tab_strany) <- c('KODZASTUP', 'NAZEVCELK', 'OSTRANA')
  
  # naplněnost kandidátky

  x_obce_pocetkand <- aggregate(JMENO ~ KODZASTUP + OSTRANA, df_18, length)
  tab_strany <- merge(tab_strany, x_obce_pocetkand, by = c('KODZASTUP', 'OSTRANA'))
  
  x_obce_maxpocetkand <- aggregate(MANDATY ~ KODZASTUP, df_18, FUN = function(x) {
    max(x)
  })
  
  # u obcí s 5 až 7 mandáty můžou mít kandidátky o třetinu víc kandidátů
  x_obce_maxpocetkand[x_obce_maxpocetkand$MANDATY == 7,]$MANDATY <- 9
  x_obce_maxpocetkand[x_obce_maxpocetkand$MANDATY == 6,]$MANDATY <- 8
  x_obce_maxpocetkand[x_obce_maxpocetkand$MANDATY == 5,]$MANDATY <- 6
  tab_strany <- merge(tab_strany, x_obce_maxpocetkand, by = 'KODZASTUP')
  tab_strany$NAPLNENOST <- paste(tab_strany$JMENO, tab_strany$MANDATY, sep='/')
  
  # obhajoba mandátu (z detailních kandidátek)
  x_obce_mandaty <- data.frame(tab_kandidati$ID, tab_kandidati$StranaNr, 
                               tab_kandidati$Obhajuje)  
  colnames(x_obce_mandaty) <- c('KODZASTUP', 'OSTRANA', 'MANDAT') 
  x_obce_mandaty <- aggregate(MANDAT ~ KODZASTUP + OSTRANA, x_obce_mandaty, FUN = function(x) {
    sum(x == 'Ano')
  })
  
  tab_strany <- merge(tab_strany, x_obce_mandaty, by = c('KODZASTUP', 'OSTRANA'), all.x = T)
  tab_strany$MANDAT[is.na(tab_strany$MANDAT)] <- 0
  
  # přeběhlíci
  
  x_obce_preb <- aggregate(PREB_18_14 ~ KODZASTUP + NAZEVCELK_18, df, sum)
  colnames(x_obce_preb)[2] <- 'NAZEVCELK'
  tab_strany <- merge(tab_strany, x_obce_preb, by = c('KODZASTUP', 'NAZEVCELK'), all.x = T)
  
  # věk
  
  x_obce_vek <- aggregate(VEK ~ KODZASTUP + OSTRANA, df_18, FUN = function(x) {
    round(mean(x), 1)
  })
  tab_strany <- merge(tab_strany, x_obce_vek, by = c('KODZASTUP', 'OSTRANA'))
  tab_strany$VEK <- gsub('.', ',', tab_strany$VEK, fixed = T)
  
  # podíl žen
  
  x_obce_zeny <- aggregate(POHLAVI ~ KODZASTUP + OSTRANA, df_18, FUN = function(x) {
    100 * round(sum(!x)/length(x), 2)
  })
  tab_strany <- merge(tab_strany, x_obce_zeny, by = c('KODZASTUP', 'OSTRANA'))
  tab_strany$POHLAVI <- paste0(tab_strany$POHLAVI, '%')
  
  # akademický titul
  
  x_obce_titul <- df_18
  x_obce_titul$TITUL <- paste0(x_obce_titul$TITULPRED, x_obce_titul$TITULZA)
  x_obce_titul <- aggregate(TITUL ~ KODZASTUP + OSTRANA, x_obce_titul, FUN = function(x) {
    100 * round(sum(x > 1)/length(x), 2)  
  })
  tab_strany <- merge(tab_strany, x_obce_titul, by = c('KODZASTUP', 'OSTRANA'))
  tab_strany$TITUL <- paste0(tab_strany$TITUL, '%')
  
  tab_strany <- data.frame(tab_strany$KODZASTUP, tab_strany$NAZEVCELK,
                           tab_strany$NAPLNENOST, tab_strany$MANDAT,
                           tab_strany$PREB_18_14, tab_strany$VEK, tab_strany$POHLAVI, 
                           tab_strany$TITUL, tab_strany$OSTRANA)
  
  colnames(tab_strany) <- c('ID', 'Strana', 'Počet kand.', 'Mandát obhajuje', 
                            'Změna strany', 'Prům. věk', 'Podíl žen',
                            'VŠ titul', 'StranaNr')
  
  assign('tab_strany', tab_strany, envir = .GlobalEnv)
  
  for (i in unique(tab_strany$ID)) {
    
    x_obec_strany <- tab_strany[tab_strany$ID == i, 2:9] 
    write.csv(x_obec_strany, paste0('../data/kandidatky/app/strany/', i, '.csv'), row.names = F, fileEncoding = 'UTF-8')    
    print(i)
    
  }
  
}

