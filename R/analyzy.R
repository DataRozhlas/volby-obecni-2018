### analýzy 

library(binhf)


## vymírání komunistů a lidovců (plus poločas rozpadu, pokud by strana nenabírala)

# počet kandidátů v jednotlivých volbách podle strany 

x_pocet_kandidatu <- aggregate(JMENO ~ NSTRANA_18, df, length)

x_pocet_kandidatu_old <- aggregate(JMENO ~ NSTRANA_14, df, length)
x_pocet_kandidatu <- merge(x_pocet_kandidatu, x_pocet_kandidatu_old, 
                           by.x = 'NSTRANA_18', by.y = 'NSTRANA_14', all = T)

x_pocet_kandidatu_old <- aggregate(JMENO ~ NSTRANA_10, df, length)
x_pocet_kandidatu <- merge(x_pocet_kandidatu, x_pocet_kandidatu_old, 
                           by.x = 'NSTRANA_18', by.y = 'NSTRANA_10', all = T)

x_pocet_kandidatu_old <- aggregate(JMENO ~ NSTRANA_06, df, length)
x_pocet_kandidatu <- merge(x_pocet_kandidatu, x_pocet_kandidatu_old, 
                           by.x = 'NSTRANA_18', by.y = 'NSTRANA_06', all = T)

colnames(x_pocet_kandidatu) <- c('NSTRANA', 'KAND_18', 'KAND_14', 'KAND_10', 'KAND_06')

df_cislastran <- read.csv('../data/kandidatky/ciselniky/pstrana.csv', encoding = 'UTF-8')

x_pocet_kandidatu <- merge(x_pocet_kandidatu, df_cislastran, 
                           by.x = 'NSTRANA', by.y = 'PSTRANA', all = T)

x_pocet_kandidatu_hist <- aggregate(JMENO ~ NSTRANA_02, df, length) 

x_pocet_kandidatu_old <- aggregate(JMENO ~ NSTRANA_98, df, length)  
x_pocet_kandidatu_hist <- merge(x_pocet_kandidatu_hist, x_pocet_kandidatu_old, 
                           by.x = 'NSTRANA_02', by.y = 'NSTRANA_98', all = T)

x_pocet_kandidatu_old <- aggregate(JMENO ~ NSTRANA_94, df, length)  
x_pocet_kandidatu_hist <- merge(x_pocet_kandidatu_hist, x_pocet_kandidatu_old, 
                                by.x = 'NSTRANA_02', by.y = 'NSTRANA_94', all = T)

colnames(x_pocet_kandidatu_hist) <- c('NSTRANA', 'KAND_02', 'KAND_98', 'KAND_94')

x_pocet_kandidatu <- merge(x_pocet_kandidatu, x_pocet_kandidatu_hist, 
                                by.x = 'ZKRATKAP8', by.y = 'NSTRANA', all = T)

x_pocet_kandidatu <- data.frame(x_pocet_kandidatu$ZKRATKAP8, x_pocet_kandidatu$NAZEV_STRP,
                                x_pocet_kandidatu$NSTRANA, x_pocet_kandidatu$KAND_18,
                                x_pocet_kandidatu$KAND_14, x_pocet_kandidatu$KAND_10,
                                x_pocet_kandidatu$KAND_06, x_pocet_kandidatu$KAND_02,
                                x_pocet_kandidatu$KAND_98, x_pocet_kandidatu$KAND_94)

colnames(x_pocet_kandidatu) <- c('ZKRATKA', 'NAZEVFULL', 'NSTRANA', 'KAND18', 'KAND14',
                                 'KAND10', 'KAND06', 'KAND02', 'KAND98', 'KAND94')

x_pocet_kandidatu <- x_pocet_kandidatu[(x_pocet_kandidatu$KAND18 > 3000) | (x_pocet_kandidatu$KAND14 > 3000) |
                       (x_pocet_kandidatu$KAND10 > 3000) | (x_pocet_kandidatu$KAND06 > 3000) |
                       (x_pocet_kandidatu$KAND02 > 3000) | (x_pocet_kandidatu$KAND98 > 3000) |
                       (x_pocet_kandidatu$KAND94 > 3000),] 

x_pocet_kandidatu <- x_pocet_kandidatu[rowSums(is.na(x_pocet_kandidatu)) != ncol(x_pocet_kandidatu), ]
x_pocet_kandidatu$ZKRATKA <- as.character(x_pocet_kandidatu$ZKRATKA)
x_pocet_kandidatu$ZKRATKA[19] <- 'SNK'
x_pocet_kandidatu$ZKRATKA[20] <- 'SPD'
x_pocet_kandidatu[19,8:10] <- x_pocet_kandidatu[17,8:10] 
x_pocet_kandidatu <- x_pocet_kandidatu[-17,] 

rm(x_pocet_kandidatu_hist); rm(x_pocet_kandidatu_old); rm(df_cislastran)

write.csv(x_pocet_kandidatu, '../data/analýzy/početkandidátů.csv', row.names = F, 
          fileEncoding = 'UTF-8')

# věk kandidátů v aktuálních volbách podle strany 

# strany, co mě zajímají, mají aspoň 2k členů
x_strany <- aggregate(JMENO ~ NSTRANA, df_18, length)

df_cislastran <- read.csv('../data/kandidatky/ciselniky/pstrana.csv', encoding = 'UTF-8')

x_strany <- merge(x_strany, df_cislastran, by.x = 'NSTRANA', by.y = 'PSTRANA', all = T)
x_strany <- data.frame(x_strany$ZKRATKAP8, x_strany$NSTRANA, x_strany$JMENO)
colnames(x_strany) <- c('ZKRATKA', 'NSTRANA', 'KANDIDATI')

x_strany <- x_strany[x_strany$KANDIDATI > 2000,]
x_strany <- x_strany[complete.cases(x_strany[, c(2:3)]),]

x_strany$ZKRATKA <- as.character(x_strany$ZKRATKA)
x_strany[5,]$ZKRATKA <- 'SNK'
x_strany[10,]$ZKRATKA <- 'SPD'

x_breaks <- seq(1, 105, by = 5) 
x_cut <- cut(df_18[(df_18$NSTRANA == 720),]$VEK, x_breaks, right = F)

x_vek_kandidatu <- data.frame(table(x_cut))
x_vek_kandidatu <- data.frame(x_vek_kandidatu[, -2])

for (i in c('TRUE', 'FALSE')) {
    
  for (j in x_strany$NSTRANA) {
    
    x_vek_kandidatu_strana <- df_18[(df_18$NSTRANA == j) & (df_18$POHLAVI == i),]$VEK
  
    x_cut <- cut(x_vek_kandidatu_strana, x_breaks, right = F)
    
    x_vek_kandidatu_strana <- data.frame(table(x_cut))
    x_vek_kandidatu_strana <- data.frame(x_vek_kandidatu_strana[, -1])
    
    x_vek_kandidatu <- cbind(x_vek_kandidatu, x_vek_kandidatu_strana)
    
  }

}

colnames(x_vek_kandidatu) <- c('věk', paste0(x_strany$ZKRATKA, '_MUŽI'), 
                               paste0(x_strany$ZKRATKA, '_ŽENY'))
x_vek_kandidatu$věk <- c(1:104)
x_vek_kandidatu$věk <- as.factor(x_vek_kandidatu$věk)


# poločas rozpadu

df_umrtnost <- read.csv('../data/ČSÚ/umrtnost.csv', encoding = 'UTF-8')
df_umrtnost$muži <- as.numeric(as.character(df_umrtnost$muži))
df_umrtnost$ženy <- as.numeric(as.character(df_umrtnost$ženy))

x_polocas_rozpadu <- data.frame('x', 'y')[-1,]
colnames(x_polocas_rozpadu) <- c('strana', 'polocas')

# pro jednotlivé strany
x_vek_kandidatu_temp <- x_vek_kandidatu
x_celkem_kandidatu <- sum(x_vek_kandidatu$'SPD_MUŽI') + sum(x_vek_kandidatu$'SPD_ŽENY')
x_celkem_umrti <- 0  
rok <- 0
print(x_celkem_kandidatu)

while (x_celkem_umrti < (x_celkem_kandidatu/2)) {
    
  x_letos_umrti = sum(df_umrtnost$muži[1:104] * x_vek_kandidatu_temp$'SPD_MUŽI'[1:104]) + 
                  sum(df_umrtnost$ženy[1:104] * x_vek_kandidatu_temp$'SPD_ŽENY'[1:104])
  
  x_celkem_umrti <- x_celkem_umrti + x_letos_umrti
  
  x_vek_kandidatu_temp$'SPD_MUŽI' <- shift(x_vek_kandidatu_temp$'SPD_MUŽI', 1, dir = 'right')
  x_vek_kandidatu_temp$'SPD_ŽENY' <- shift(x_vek_kandidatu_temp$'SPD_ŽENY', 1, dir = 'right')
  rok <- rok + 1
  
  print(round(x_celkem_kandidatu - x_celkem_umrti))
}

x_mesice <- (x_celkem_umrti - x_celkem_kandidatu/2) / x_letos_umrti
x_polocas <- rok - 1 + x_mesice

x_radek <- cbind('SPD', x_polocas)
colnames(x_radek) <- c('strana', 'polocas')
x_polocas_rozpadu <- rbind(x_polocas_rozpadu, x_radek)

write.csv(x_polocas_rozpadu, '../data/analýzy/poločasrozpadu.csv', row.names = F, 
          fileEncoding = 'UTF-8')

rm(x_breaks); rm(x_cut); rm(i); rm(j); rm(x_vek_kandidatu_strana); rm(x_strany); 
rm(df_cislastran); rm(df_umrtnost); rm(); rm(rok); rm(x_celkem_kandidatu); rm(x_mesice)
rm(x_celkem_umrti); rm(x_letos_umrti); rm(x_vek_kandidatu_temp); rm(x_radek); rm(x_polocas);
rm(x_vek_kandidatu)

# plot(x_vek_kandidatu[,c(1, 2)])

# obce, kde postaví aspoň jednoho kandidáta

x_obce_18_kscm <- unique(data.frame(df_18[df_18$NSTRANA == 47,]$NAZEVZAST))
x_obce_14_kscm <- unique(data.frame(df_14[df_14$NSTRANA == 47,]$NAZEVZAST))
x_obce_10_kscm <- unique(data.frame(df_10[df_10$NSTRANA == 47,]$NAZEVZAST))
x_obce_06_kscm <- unique(data.frame(df_06[df_06$NSTRANA == 47,]$NAZEVZAST))
x_obce_02_kscm <- unique(data.frame(df_02[df_02$NSTRANA == 'KSČM',]$NAZEVZAST))
x_obce_98_kscm <- unique(data.frame(df_98[df_98$NSTRANA == 'KSČM',]$NAZEVZAST))
x_obce_94_kscm <- unique(data.frame(df_94[df_94$NSTRANA == 'KSČM',]$NAZEVZAST))

x_obce_kscm <- data.frame(setdiff(x_obce_94_kscm[,1], x_obce_98_kscm[,1]))
colnames(x_obce_kscm) <- 'OBCEBEZKSČM'
x_obce_kscm <- data.frame(x_obce_kscm[order(x_obce_kscm$OBCEBEZKSČM, decreasing = F),])

write.csv(x_obce_kscm, '../data/analýzy/obceksčm.csv', row.names = F, 
          fileEncoding = 'UTF-8')

rm(x_obce_02_kscm); rm(x_obce_06_kscm); rm(x_obce_10_kscm); rm(x_obce_14_kscm)
rm(x_obce_18_kscm); rm(x_obce_94_kscm); rm(x_obce_98_kscm); rm(x_obce_kscm_temp)

x_obce_18_kscm <- unique(data.frame(df_18[df_18$NSTRANA == 47,]$KODZASTUP))
x_obce_14_kscm <- unique(data.frame(df_14[df_14$NSTRANA == 47,]$KODZASTUP))
x_obce_10_kscm <- unique(data.frame(df_10[df_10$NSTRANA == 47,]$KODZASTUP))
x_obce_06_kscm <- unique(data.frame(df_06[df_06$NSTRANA == 47,]$KODZASTUP))
x_obce_02_kscm <- unique(data.frame(df_02[df_02$NSTRANA == 'KSČM',]$KODZASTUP))
x_obce_98_kscm <- unique(data.frame(df_98[df_98$NSTRANA == 'KSČM',]$KODZASTUP))
x_obce_94_kscm <- unique(data.frame(df_94[df_94$NSTRANA == 'KSČM',]$KODZASTUP))

write.csv(x_obce_18_kscm, '../data/analýzy/obcekscm18.csv', row.names = F, 
          fileEncoding = 'UTF-8')


### koalice

x_koalice <- data.frame(table(df$SLOZENI))
x_koalice <- x_koalice[order(x_koalice$Freq, decreasing = T),]
x_koalice <- x_koalice[grepl(',', x_koalice$Var1),]

# koalice více stran je potřeba rozdělit na dvojice (asi manuálně)

x_koalice_triavic <- x_koalice[grepl(',.*,', x_koalice$Var1),]

rm(x_koalice); rm(x_koalice_triavic)



### kandidáti na mandát

x_kand_mandat <- aggregate(JMENO ~ KODZASTUP + NAZEVZAST, df, length)
x_kand_mandaty <- unique(df[,c(3, 42)])
x_kand_mandat <- merge(x_kand_mandat, x_kand_mandaty, all.x = T)

x_kand_mandat$KANDMAND <- round(x_kand_mandat$JMENO/x_kand_mandat$MANDATY, 1)
colnames(x_kand_mandat)[3] <- c('KANDIDATI')
x_kand_mandat <- x_kand_mandat[order(x_kand_mandat$KANDMAND, decreasing = F),]

rm(x_kand_mandat); rm(x_kand_mandaty)


### ad hoc analýzy 

# nejvíckrát kandidovali
x_nejvic_kandidatur <- df[(!is.na(df$NAZEVCELK_18) &
                           !is.na(df$NAZEVCELK_14) & !is.na(df$NAZEVCELK_10) &
                             !is.na(df$NAZEVCELK_06) & !is.na(df$NAZEVCELK_02) &
                             !is.na(df$NAZEVCELK_98) & !is.na(df$NAZEVCELK_94)),]

# nejvíckrát získali mandát
x_nejvic_mandatu <- df[(df$MANDAT_14 %in% '1' & df$MANDAT_10 %in% '1' & 
                          df$MANDAT_06 %in% '1' & df$MANDAT_02 %in% '*' & 
                          df$MANDAT_98 %in% '*' & df$MANDAT_94 %in% '*'),]

# obce s nejvíc obhájenými mandáty
x_obce_nejvic_mandatu <- aggregate(JMENO ~ KODZASTUP + NAZEVZAST_14, x_nejvic_mandatu, length)
x_obce_nejvic_mandatu <- merge(x_obce_nejvic_mandatu, df_14, by = 'KODZASTUP', all.x = T)
x_obce_nejvic_mandatu <- unique(data.frame(x_obce_nejvic_mandatu$KODZASTUP, 
                                           x_obce_nejvic_mandatu$NAZEVZAST,
                                           x_obce_nejvic_mandatu$JMENO.x,
                                           x_obce_nejvic_mandatu$MANDATY))
colnames(x_obce_nejvic_mandatu) <- c('KODZAST', 'NAZEVZAST', 'STALICE', 'MANDATY')
x_obce_nejvic_mandatu$PODILSTALIC <- x_obce_nejvic_mandatu$STALICE/x_obce_nejvic_mandatu$MANDATY

# nejvíckrát přeběhli
x_nejvic_prebehnuti <- df[(df$NSTRANA_14 != df$NSTRANA_10 & df$NSTRANA_10 != df$NSTRANA_06 &
                             df$NSTRANA_06 != df$NSTRANA_02 &
                             !is.na(df$NSTRANA_14) & !is.na(df$NSTRANA_10) & 
                             !is.na(df$NSTRANA_06) & !is.na(df$NSTRANA_02)),]

# průměrný věk

x_prumerny_vek <- data.frame(mean(df_94$VEK, na.rm=T), mean(df_98$VEK, na.rm=T),
                             mean(df_02$VEK, na.rm=T), mean(df_06$VEK, na.rm=T),
                             mean(df_10$VEK, na.rm=T), mean(df_14$VEK, na.rm=T))

rm(x_nejvic_kandidatur); rm(x_nejvic_mandatu); rm(x_nejvic_prebehnuti); rm(x_prumerny_vek)
rm(x_obce_nejvic_mandatu)
