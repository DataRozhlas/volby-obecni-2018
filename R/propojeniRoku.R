### propojení všech kandidátek od 1994 do 2018

propojeniRoku <- function() {

  x_18 <- df_18
  x_14 <- df_14
  x_10 <- df_10
  x_06 <- df_06
  x_02 <- df_02
  x_98 <- df_98
  x_94 <- df_94
  
  # změna věku kvůli merge, takže VEK je věk v roce 2018
  x_14$VEK <- x_14$VEK + 4
  x_10$VEK <- x_10$VEK + 8
  x_06$VEK <- x_06$VEK + 12
  x_02$VEK <- x_02$VEK + 16
  x_98$VEK <- x_98$VEK + 20
  x_94$VEK <- x_94$VEK + 24
  
  # postupné spojení, vlevo nejnovější volby
  df <- merge(x_98, x_94, by=c('JMENO', 'PRIJMENI', 'VEK', 'KODZASTUP'), all = T)
  
  colnames(df)[5:18] <- c('NAZEVZAST_98', 'DRUHZASTUP_98', 'COBVODU_98', 'OSTRANA_98',
                          'NAZEVCELK_98', 'PORCISLO_98', 'JMENOPRIJMENI_98', 'TITULY_98',
                          'NSTRANA_98', 'PSTRANA_98', 'POCHLASU_98', 'POCPROCVSE_98', 
                          'PORADI_98', 'MANDAT_98')
  
  colnames(df)[19:32] <- c('NAZEVZAST_94', 'DRUHZASTUP_94', 'COBVODU_94', 'OSTRANA_94',
                           'NAZEVCELK_94', 'PORCISLO_94', 'JMENOPRIJMENI_94', 'TITULY_94',
                           'NSTRANA_94', 'PSTRANA_94', 'POCHLASU_94', 'POCPROCVSE_94', 
                           'PORADI_94', 'MANDAT_94')
  
  df <- merge(x_02, df, by=c('JMENO', 'PRIJMENI', 'VEK', 'KODZASTUP'), all = T)
  
  colnames(df)[5:18] <- c('NAZEVZAST_02', 'DRUHZASTUP_02', 'COBVODU_02', 'OSTRANA_02',
                          'NAZEVCELK_02', 'PORCISLO_02', 'JMENOPRIJMENI_02', 'TITULY_02',
                          'NSTRANA_02', 'PSTRANA_02', 'POCHLASU_02', 'POCPROCVSE_02', 
                          'PORADI_02', 'MANDAT_02')
  
  df <- merge(x_06, df, by=c('JMENO','PRIJMENI', 'VEK', 'KODZASTUP'), all = T)
  
  colnames(df)[5:68] <- c('KRAJ_06','OKRES_06','NAZEVZAST_06','COBVODU_06','VSTRANA_06',
                          'ZKRATKAO8_06','PORCISLO_06','TITULPRED_06','TITULZA_06',
                          'POHLAVI_06','POVOLANI_06','BYDLISTEN_06','DATNAR_06','MANDAT_06',
                          'POCHLASU_06','POCPROCVSE_06','MAND_STR_06','HLASY_STR_06',
                          'PROCHLSTR_06','OSTRANA_06','PSTRANA_06','NSTRANA_06',
                          'POCSTR_SLO_06','SLOZENI_06','POCHL_PRES_06','PORADIMAND_06',
                          'PORADINAHR_06','ZKRATKAO30_06','NAZEVCELK_06','POR_STR_HL_06',
                          'TYPZASTUP_06','DRUHZASTUP_06','OBEC_06','NAZEVOBCE_06','COBROP_06',
                          'CPOU_06','REGURAD_06','OBVODY_06','MANDATY_06','POCOBYV_06',
                          'MINOKRSEK1_06','MAXOKRSEK1_06','MINOKRSEK2_06','MAXOKRSEK2_06',
                          'MINOKRSEK3_06','MAXOKRSEK3_06','MINOKRSEK4_06','MAXOKRSEK4_06',
                          'MINOKRSEK5_06','MAXOKRSEK5_06','MINOKRSEK6_06','MAXOKRSEK6_06',
                          'MINOKRSEK7_06','MAXOKRSEK7_06','MINOKRSEK8_06','MAXOKRSEK8_06',
                          'MINOKRSEK9_06','MAXOKRSEK9_06','MINOKRSE10_06','MAXOKRSE10_06',
                          'TYPDUVODU_06','POCET_VS_06','PLATNOST_06','STAV_OBCE_06')
  
  df <- merge(x_10, df, by=c('JMENO', 'PRIJMENI', 'VEK', 'KODZASTUP'), all = T)
  
  colnames(df)[5:68] <- c('KRAJ_10','OKRES_10','NAZEVZAST_10','COBVODU_10','VSTRANA_10',
                          'ZKRATKAO8_10','PORCISLO_10','TITULPRED_10','TITULZA_10',
                          'POHLAVI_10','POVOLANI_10','BYDLISTEN_10','DATNAR_10','MANDAT_10',
                          'POCHLASU_10','POCPROCVSE_10','MAND_STR_10','HLASY_STR_10',
                          'PROCHLSTR_10','OSTRANA_10','PSTRANA_10','NSTRANA_10',
                          'POCSTR_SLO_10','SLOZENI_10','POCHL_PRES_10','PORADIMAND_10',
                          'PORADINAHR_10','ZKRATKAO30_10','NAZEVCELK_10','POR_STR_HL_10',
                          'TYPZASTUP_10','DRUHZASTUP_10','OBEC_10','NAZEVOBCE_10','COBROP_10',
                          'CPOU_10','REGURAD_10','OBVODY_10','MANDATY_10','POCOBYV_10',
                          'MINOKRSEK1_10','MAXOKRSEK1_10','MINOKRSEK2_10','MAXOKRSEK2_10',
                          'MINOKRSEK3_10','MAXOKRSEK3_10','MINOKRSEK4_10','MAXOKRSEK4_10',
                          'MINOKRSEK5_10','MAXOKRSEK5_10','MINOKRSEK6_10','MAXOKRSEK6_10',
                          'MINOKRSEK7_10','MAXOKRSEK7_10','MINOKRSEK8_10','MAXOKRSEK8_10',
                          'MINOKRSEK9_10','MAXOKRSEK9_10','MINOKRSE10_10','MAXOKRSE10_10',
                          'TYPDUVODU_10','POCET_VS_10','PLATNOST_10','STAV_OBCE_10')
  
  df <- merge(x_14, df, by=c('JMENO','PRIJMENI', 'VEK', 'KODZASTUP'), all = T)
  
  colnames(df)[5:68] <- c('KRAJ_14','OKRES_14','NAZEVZAST_14','COBVODU_14','VSTRANA_14',
                          'ZKRATKAO8_14','PORCISLO_14','TITULPRED_14','TITULZA_14',
                          'POHLAVI_14','POVOLANI_14','BYDLISTEN_14','DATNAR_14','MANDAT_14',
                          'POCHLASU_14','POCPROCVSE_14','MAND_STR_14','HLASY_STR_14',
                          'PROCHLSTR_14','OSTRANA_14','PSTRANA_14','NSTRANA_14',
                          'POCSTR_SLO_14','SLOZENI_14','POCHL_PRES_14','PORADIMAND_14',
                          'PORADINAHR_14','ZKRATKAO30_14','NAZEVCELK_14','POR_STR_HL_14',
                          'TYPZASTUP_14','DRUHZASTUP_14','OBEC_14','NAZEVOBCE_14','COBROP_14',
                          'CPOU_14','REGURAD_14','OBVODY_14','MANDATY_14','POCOBYV_14',
                          'MINOKRSEK1_14','MAXOKRSEK1_14','MINOKRSEK2_14','MAXOKRSEK2_14',
                          'MINOKRSEK3_14','MAXOKRSEK3_14','MINOKRSEK4_14','MAXOKRSEK4_14',
                          'MINOKRSEK5_14','MAXOKRSEK5_14','MINOKRSEK6_14','MAXOKRSEK6_14',
                          'MINOKRSEK7_14','MAXOKRSEK7_14','MINOKRSEK8_14','MAXOKRSEK8_14',
                          'MINOKRSEK9_14','MAXOKRSEK9_14','MINOKRSE10_14','MAXOKRSE10_14',
                          'TYPDUVODU_14','POCET_VS_14','PLATNOST_14','STAV_OBCE_14')
  
  df <- merge(x_18, df, by=c('JMENO','PRIJMENI', 'VEK', 'KODZASTUP'), all = T)
  
  colnames(df)[5:68] <- c('KRAJ_18','OKRES_18','NAZEVZAST_18','COBVODU_18','VSTRANA_18',
  'ZKRATKAO8_18','PORCISLO_18','TITULPRED_18','TITULZA_18',
  'POHLAVI_18','POVOLANI_18','BYDLISTEN_18','DATNAR_18','MANDAT_18',
  'POCHLASU_18','POCPROCVSE_18','MAND_STR_18','HLASY_STR_18',
  'PROCHLSTR_18','OSTRANA_18','PSTRANA_18','NSTRANA_18',
  'POCSTR_SLO_18','SLOZENI_18','POCHL_PRES_18','PORADIMAND_18',
  'PORADINAHR_18','ZKRATKAO30_18','NAZEVCELK_18','POR_STR_HL_18',
  'TYPZASTUP_18','DRUHZASTUP_18','OBEC_18','NAZEVOBCE_18','COBROP_18',
  'CPOU_18','REGURAD_18','OBVODY_18','MANDATY_18','POCOBYV_18',
  'MINOKRSEK1_18','MAXOKRSEK1_18','MINOKRSEK2_18','MAXOKRSEK2_18',
  'MINOKRSEK3_18','MAXOKRSEK3_18','MINOKRSEK4_18','MAXOKRSEK4_18',
  'MINOKRSEK5_18','MAXOKRSEK5_18','MINOKRSEK6_18','MAXOKRSEK6_18',
  'MINOKRSEK7_18','MAXOKRSEK7_18','MINOKRSEK8_18','MAXOKRSEK8_18',
  'MINOKRSEK9_18','MAXOKRSEK9_18','MINOKRSE10_18','MAXOKRSE10_18',
  'TYPDUVODU_18','POCET_VS_18','PLATNOST_18','STAV_OBCE_18')
  
  # podle čeho definovat přeběhlíky?
  # PSTRANA (politická strana, stranická příslušnost)
  # NSTRANA (navrhující strana) 
  # VSTRANA (volební strana) = název kandidátky, ale nerozlišuje mezi různými SNK
  # OSTRANA (?) = název kandidátky, rozlišuje mezi SNK, ale v různých letech se mění jejich číslo
  # *NAZEVCELK (název kandidátky) má problém se změnou názvu/koalice (ale je to stejná strana)
  # počty přeběhlíků: VSTRANA 24035, OSTRANA 43966, NAZEVCELK 50408
  
  df$PREB_18_14 <- (df$NAZEVCELK_18 != df$NAZEVCELK_14) & 
    (!is.na(df$NAZEVCELK_18)) & (!is.na(df$NAZEVCELK_14))
  
  df$PREB_14_10 <- (df$NAZEVCELK_14 != df$NAZEVCELK_10) & 
    (!is.na(df$NAZEVCELK_14)) & (!is.na(df$NAZEVCELK_10))
  
  df$PREB_10_06 <- (df$NAZEVCELK_10 != df$NAZEVCELK_06) & 
    (!is.na(df$NAZEVCELK_10)) & (!is.na(df$NAZEVCELK_06))
  
  df$PREB_06_02 <- (df$NAZEVCELK_06 != df$NAZEVCELK_02) & 
    (!is.na(df$NAZEVCELK_06)) & (!is.na(df$NAZEVCELK_02))
  
  df$PREB_02_98 <- (df$NAZEVCELK_02 != df$NAZEVCELK_98) & 
    (!is.na(df$NAZEVCELK_02)) & (!is.na(df$NAZEVCELK_98))
  
  df$PREB_98_94 <- (df$NAZEVCELK_98 != df$NAZEVCELK_94) & 
    (!is.na(df$NAZEVCELK_98)) & (!is.na(df$NAZEVCELK_94))
  
  assign('df', df, envir = .GlobalEnv)

  write.csv(df, '../data/kandidatky/kandidati_94_18.csv', row.names = F, 
            fileEncoding = 'UTF-8')

}