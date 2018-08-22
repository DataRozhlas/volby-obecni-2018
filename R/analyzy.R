### analýzy 


## vymírání komunistů a lidovců (plus poločas rozpadu, pokud by strana nenabírala)

# počet kandidátů a průměrný věk podle strany 

##############
# změnit ROK #
##############
x_kand_by_str <- aggregate(JMENO ~ NSTRANA_14, df, length)
x_kand_by_str <- merge(x_kand_by_str, df_14, 
                       by.x = 'NSTRANA_14', by.y = 'NSTRANA', all.x = T)
x_kand_by_str <- unique(data.frame(x_kand_by_str$NSTRANA_14, 
                                   x_kand_by_str$ZKRATKAO8, x_kand_by_str$JMENO.x))
colnames(x_kand_by_str) <- c('NSTRANA', 'ZKRATKA', 'JMENO')

x_kand_by_str_vek <- aggregate(VEK ~ NSTRANA_14, df, mean)
x_kand_by_str <- merge(x_kand_by_str, x_kand_by_str_vek, 
                       by.x = 'NSTRANA', by.y = 'NSTRANA_14', all.x = T)
x_kand_by_str$VEK <- x_kand_by_str$VEK - 4

x_kand_by_str_10 <- aggregate(JMENO ~ NSTRANA_10, df, length)
x_kand_by_str_vek_10 <- aggregate(VEK ~ NSTRANA_10, df, mean)
x_kand_by_str_10 <- merge(x_kand_by_str_10, x_kand_by_str_vek_10, 
                          by.x = 'NSTRANA_10', by.y = 'NSTRANA_10', all.x = T)
x_kand_by_str_10$VEK <- x_kand_by_str_10$VEK - 8
x_kand_by_str <- merge(x_kand_by_str, x_kand_by_str_10, 
                       by.x = 'NSTRANA', by.y = 'NSTRANA_10', all.x = T)

x_kand_by_str_06 <- aggregate(JMENO ~ NSTRANA_06, df, length)
x_kand_by_str_vek_06 <- aggregate(VEK ~ NSTRANA_06, df, mean)
x_kand_by_str_06 <- merge(x_kand_by_str_06, x_kand_by_str_vek_06, 
                          by.x = 'NSTRANA_06', by.y = 'NSTRANA_06', all.x = T)
x_kand_by_str_06$VEK <- x_kand_by_str_06$VEK - 12
x_kand_by_str <- merge(x_kand_by_str, x_kand_by_str_06, 
                       by.x = 'NSTRANA', by.y = 'NSTRANA_06', all.x = T)

x_kand_by_str_02 <- aggregate(JMENO ~ NSTRANA_02, df, length)
x_kand_by_str_vek_02 <- aggregate(VEK ~ NSTRANA_02, df, mean)
x_kand_by_str_02 <- merge(x_kand_by_str_02, x_kand_by_str_vek_02, 
                          by.x = 'NSTRANA_02', by.y = 'NSTRANA_02', all.x = T)
x_kand_by_str_02$VEK <- x_kand_by_str_02$VEK - 16
x_kand_by_str <- merge(x_kand_by_str, x_kand_by_str_02, 
                       by.x = 'ZKRATKA', by.y = 'NSTRANA_02', all.x = T)

x_kand_by_str_98 <- aggregate(JMENO ~ NSTRANA_98, df, length)
x_kand_by_str_vek_98 <- aggregate(VEK ~ NSTRANA_98, df, mean)
x_kand_by_str_98 <- merge(x_kand_by_str_98, x_kand_by_str_vek_98, 
                          by.x = 'NSTRANA_98', by.y = 'NSTRANA_98', all.x = T)
x_kand_by_str_98$VEK <- x_kand_by_str_98$VEK - 20
x_kand_by_str <- merge(x_kand_by_str, x_kand_by_str_98, 
                       by.x = 'ZKRATKA', by.y = 'NSTRANA_98', all.x = T)

x_kand_by_str_94 <- aggregate(JMENO ~ NSTRANA_94, df, length)
x_kand_by_str_vek_94 <- aggregate(VEK ~ NSTRANA_94, df, mean)
x_kand_by_str_94 <- merge(x_kand_by_str_94, x_kand_by_str_vek_94, 
                          by.x = 'NSTRANA_94', by.y = 'NSTRANA_94', all.x = T)
x_kand_by_str_94$VEK <- x_kand_by_str_94$VEK - 24
x_kand_by_str <- merge(x_kand_by_str, x_kand_by_str_94, 
                       by.x = 'ZKRATKA', by.y = 'NSTRANA_94', all.x = T)

##############
# změnit ROK #
##############
colnames(x_kand_by_str) <- c('ZKRATKA', 'NSTRANA', 'KAND_14', 'VEK_14', 'KAND_10', 'VEK_10',
                             'KAND_06', 'VEK_06', 'KAND_02', 'VEK_02', 'KAND_98', 'VEK_98',
                             'KAND_94', 'VEK_94')

# zajímají mě jenom hlavní strany, co jsou na scéně od 94
x_kand_by_str <- x_kand_by_str[complete.cases(x_kand_by_str),]
x_kand_by_str <- x_kand_by_str[x_kand_by_str$NSTRANA != '80',]

rm(x_kand_by_str_18); rm(x_kand_by_str_14); rm(x_kand_by_str_10); rm(x_kand_by_str_06)
rm(x_kand_by_str_02); rm(x_kand_by_str_98); rm(x_kand_by_str_94)
rm(x_kand_by_str_vek); rm(x_kand_by_str_vek_18); rm(x_kand_by_str_vek_14)
rm(x_kand_by_str_vek_10); rm(x_kand_by_str_vek_06); rm(x_kand_by_str_vek_02)
rm(x_kand_by_str_vek_98); rm(x_kand_by_str_vek_94); rm(kand_by_str)

##############
# změnit ROK #
##############
x_vek <- data.frame(x_kand_by_str$ZKRATKA, round(x_kand_by_str$VEK_14, 1), 
                    round(x_kand_by_str$VEK_10, 1), round(x_kand_by_str$VEK_06, 1),
                    round(x_kand_by_str$VEK_02, 1), round(x_kand_by_str$VEK_98, 1),
                    round(x_kand_by_str$VEK_94, 1))
colnames(x_vek) <- c('ZKRATKA', 'VEK_14', 'VEK_10', 'VEK_06', 'VEK_02', 'VEK_98', 'VEK_94')

# kde postaví aspoň jednoho kandidáta

x_kand_by_zast_kom <- unique(data.frame(df[df$NSTRANA == 47, 3:4]))

x_kand_by_zast_kdu <- unique(data.frame(df[df$NSTRANA == 1, 3:4]))

setdiff(x_kand_by_zast_kom$NAZEVZAST, x_kand_by_zast_kdu$NAZEVZAST)

rm(x_kand_by_zast_kom); rm(x_kand_by_zast_kdu)



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
x_nejvic_kandidatur <- df[(!is.na(df$NAZEVCELK_14) & !is.na(df$NAZEVCELK_10) &
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
