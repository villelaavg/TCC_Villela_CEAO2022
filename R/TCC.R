library(tidyverse)
library(ggplot2)
library(data.table)
library(ggpubr) 
library(cowplot)
library(MASS)
library(gridExtra)
library(nortest)
library(fitdistrplus)
library(geosphere)
library(readxl)
library(rworldmap)
library(rworldxtra) #rworldmap em alta resolução.

#Importa o Banco de Dados

DF_SAR <- read_excel("C:/Users/andre/OneDrive/Área de Trabalho/CEAO 2022/TCC/PROJETO_TCC/DF_SAR.xlsx")

SBCG <- as.numeric(c(-54.66667,-20.46944))

# Pega as coordenadas e mede as distâncias, considerando a superfície da Terra.
# Distância entre Origem e Destino
DF_SAR <- DF_SAR %>% 
  mutate((D = distGeo(cbind(DF_SAR$LONG_ORIGEM, DF_SAR$LAT_ORIGEM), cbind(DF_SAR$LONG_DESTINO, DF_SAR$LAT_DESTINO))))
colnames(DF_SAR)[18] <- "Metros_Orig_Dest"

# Transforma de metros para Milhas Náuticas (NM)
DF_SAR <- DF_SAR %>% 
  mutate(DF_SAR$Metros_Orig_Dest / 1852)

# Muda o nome da coluna
colnames(DF_SAR)[19] <- "Distancia_Orig_Dest"

# Distância entre LKP e Destino
DF_SAR <- DF_SAR %>% 
  mutate((D = distGeo(cbind(DF_SAR$LONG_LKP, DF_SAR$LAT_LKP), cbind(DF_SAR$LONG_DESTINO, DF_SAR$LAT_DESTINO))))
colnames(DF_SAR)[20] <- "Metros_LKP_Dest"
DF_SAR <- DF_SAR %>% 
  mutate(DF_SAR$Metros_LKP_Dest / 1852)
colnames(DF_SAR)[21] <- "Distancia_LKP_Dest"

# Distância entre LKP e Base de Operação
DF_SAR <- DF_SAR %>% 
  mutate((D = distGeo(cbind(DF_SAR$LONG_LKP, DF_SAR$LAT_LKP), cbind(DF_SAR$LONG_BASE, DF_SAR$LAT_BASE))))
colnames(DF_SAR)[22] <- "Metros_LKP_Base"
DF_SAR <- DF_SAR %>% 
  mutate(DF_SAR$Metros_LKP_Base / 1852)
colnames(DF_SAR)[23] <- "Distancia_LKP_Base"

# Distância entre LKP e SBCG
DF_SAR <- DF_SAR %>% 
  mutate((D = distGeo(cbind(DF_SAR$LONG_LKP, DF_SAR$LAT_LKP), (SBCG))))
colnames(DF_SAR)[24] <- "Metros_LKP_SBCG"
DF_SAR <- DF_SAR %>% 
  mutate(DF_SAR$Metros_LKP_SBCG / 1852)
colnames(DF_SAR)[25] <- "Distancia_LKP_SBCG"

# Distância entre LKP e SBCG
DF_SAR <- DF_SAR %>% 
  mutate((D = distGeo(cbind(DF_SAR$LONG_BASE, DF_SAR$LAT_BASE), (SBCG))))
colnames(DF_SAR)[26] <- "Metros_BASE_SBCG"
DF_SAR <- DF_SAR %>% 
  mutate(DF_SAR$Metros_BASE_SBCG / 1852)
colnames(DF_SAR)[27] <- "Distancia_BASE_SBCG"

#Excluiu as colunas com distâncias em metros
DF_SAR <- DF_SAR[,-c(18,20,22,24,26)]


str(DF_SAR)
DF_SAR$ARCC <- as.factor(DF_SAR$ARCC)
DF_SAR$ORIGEM <- as.factor(DF_SAR$ORIGEM)
DF_SAR$DESTINO <- as.factor(DF_SAR$DESTINO)
DF_SAR$LAT_AVISTAMENTO <- as.numeric(DF_SAR$LAT_AVISTAMENTO)
DF_SAR$LONG_AVISTAMENTO <- as.numeric(DF_SAR$LONG_AVISTAMENTO)
DF_SAR$TIPO_OBJETO <- as.factor(DF_SAR$TIPO_OBJETO)
DF_SAR$BASE <- as.factor(DF_SAR$BASE)

DF_AZ <- DF_SAR %>% filter(DF_SAR$ARCC == "AZ")
DF_CW <- DF_SAR %>% filter(DF_SAR$ARCC == "CW")
DF_RE <- DF_SAR %>% filter(DF_SAR$ARCC == "RE")
DF_BS <- DF_SAR %>% filter(DF_SAR$ARCC == "BS")

hist(DF_SAR$Distancia_LKP_Dest, 
     ylim = c(0,50), 
     las = 1)

hist(DF_SAR$Distancia_LKP_Base,
     ylim = c(0,25),
     las = 1)

hist(DF_SAR$Distancia_LKP_SBCG,
     ylim = c(0,15),
     las = 1)

hist(DF_SAR$Distancia_BASE_SBCG,
     ylim = c(0,20),
     las = 1)

plot(DF_SAR$Distancia_LKP_Dest)
plot(DF_SAR$Distancia_LKP_Base)
plot(DF_SAR$Distancia_LKP_SBCG)
plot(DF_SAR$Distancia_BASE_SBCG)

ks.test(DF_SAR$Distancia_LKP_Dest, "pnorm")
ks.test(DF_SAR$Distancia_LKP_Base, "pnorm")
ks.test(DF_SAR$Distancia_LKP_SBCG, "pnorm")
ks.test(DF_SAR$Distancia_BASE_SBCG, "pnorm")


descdist(DF_SAR$Distancia_LKP_Dest)
descdist(DF_SAR$Distancia_LKP_Base)
descdist(DF_SAR$Distancia_LKP_SBCG)
descdist(DF_SAR$Distancia_BASE_SBCG)


summary(DF_SAR$Distancia_LKP_Dest)

boxplot(DF_SAR$Distancia_LKP_Dest)
boxplot(DF_SAR$Distancia_LKP_Base)
boxplot(DF_SAR$Distancia_LKP_SBCG)
boxplot(DF_SAR$Distancia_BASE_SBCG)



APG <- sample(DF_SAR$Distancia_LKP_Dest, size = 500000, replace = T)
APG <- matrix(APG, nrow = 50000, ncol = 50)
medias.amostras <- rowMeans(APG)
hist(medias.amostras)
ks.test(medias.amostras, "pnorm")

# LKP no mapa do Brasil
newmap = getMap(resolution = "high")
plot(newmap) #plota o mapa do mundo dessa library rworldmap 
plot(newmap, #plota o mapa do mundo, cortando nessas coord que eu delimitei.
     xlim = c(-65.98283055, -30.79314722),
     ylim = c(-32.75116944, 5.27438888),
     asp = 1, #razão de aspecto
     bg = "lightblue", #background
     col = "black") #colore o mapa com a cor que eu escolhi.

points(DF_SAR$LONG_LKP, DF_SAR$LAT_LKP,
       col = "red",
       cex = 0.5,
       pch = 20)



