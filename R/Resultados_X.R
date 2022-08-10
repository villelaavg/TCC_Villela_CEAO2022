
#### Libraries ####

library(tidyverse)
library(ggplot2)
library(data.table)
library(ggpubr) 
library(cowplot)
library(MASS)
library(gridExtra)
library(geosphere)
library(readxl)
library(rworldmap)
library(rworldxtra) #rworldmap em alta resolução.
library(knitr)
library(readxl)
library(svglite)
library(viridis)
library(gtable)
library(gghighlight)

#### Códigos Diversos ####

#Importa os bancos de dados
# p_0_40 - Ângulo 0, afastado 40 NM para uma APG de 60NM (40+20).
APG_X <- read_excel("Resultados/APG_X_semT.xlsx")


colnames(APG_X) <- c("Grupo","AngDist","Q_Menor_Rota",
                     "Menor_Rota","Dist_Menor_Rota(NM)","Q_Maior_Rota",
                     "Maior_Rota","Dist_Maior_Rota(NM)","Diferenca(NM)",
                     "Diferenca_Percentual","Dist_Centro_Base",
                     "Angulo_Centro_Base")

APG_X$Grupo <- as.factor(APG_X$Grupo)
APG_X$AngDist <- as.factor(APG_X$AngDist)
APG_X$Menor_Rota <- as.factor(APG_X$Menor_Rota)
APG_X$Maior_Rota <- as.factor(APG_X$Maior_Rota)
#APG_X$Dist_Centro_Base <- as.factor(APG_X$Dist_Centro_Base)
#APG_X$Angulo_Centro_Base <- as.factor(APG_X$Angulo_Centro_Base)
APG_X$Q_Menor_Rota <- as.numeric(APG_X$Q_Menor_Rota)
APG_X$Q_Maior_Rota <- as.numeric(APG_X$Q_Maior_Rota)


APG_X$Grupo <- factor(APG_X$Grupo, levels = c("APG40","APG65", 
                                              "APG150", "APG565"))

str(APG_X)

APG_X <- APG_X %>% 
  mutate(Grupo = factor(Grupo, 
                        levels = c("APG40", "APG65", "APG150", "APG565")))

attach(APG_X)

detach(APG_X)

hist(Diferenca_Percentual, 
     las = 1, 
     #main = "Centro - Base",
     #xlab = "Distância (NM)",
     ylab = "Frequência")

plot(Diferenca_Percentual, 
     #main = "Centro - Base",
     ylab = "Frequência")


ggplot(mutate(APG_X, Menor_Rota = fct_infreq(Menor_Rota))) + #Ordena as barras em ordem decrescente
  geom_bar(aes(factor(Menor_Rota)), fill = "#77B6EA") +
  theme_classic() +
  xlab("Menor Rota") +
  ylab("Frequência") +
  labs(fill = "Rotas", title = "Rotas Escolhidas") +
  coord_cartesian(ylim=c(0, 100)) + 
  scale_y_continuous(breaks=seq(0, 100, 10)) +
  coord_polar()


ggplot(mutate(APG_X, Menor_Rota = fct_infreq(Menor_Rota))) + #Ordena as barras em ordem decrescente
  geom_bar(aes(factor(Menor_Rota)), fill = "#77B6EA") +
  theme_classic() +
  xlab("Menor Rota") +
  ylab("Frequência") +
  labs(fill = "Rotas", title = "Menor Rota") +
  coord_cartesian(ylim=c(0, 100)) + 
  scale_y_continuous(breaks=seq(0, 100, 10)) +
  coord_flip()

ggplot(APG_X, aes(x = Menor_Rota, fill = Grupo, colour = Grupo)) + 
  geom_histogram(alpha = 0.5, position = "identity", stat = "count")


ggplot(APG_X, 
       aes(x = Menor_Rota, 
           fill = Grupo)) + 
  geom_bar(position = "dodge") +
  coord_flip()

# Scatter plot by group
ggplot(APG_X, aes(x = Diferenca_Percentual , 
                  y = Grupo, 
                  color = Grupo)) +
  geom_point()


ggplot(APG_X, aes(x = Menor_Rota , y = Angulo_Centro_Base, 
                  color = Angulo_Centro_Base)) +
  geom_point()

ggplot(APG_X, aes(x = Menor_Rota , y = Dist_Centro_Base, 
                  color = Dist_Centro_Base)) +
  geom_point()

ggplot(APG_X, aes(x = Diferenca_Percentual , y = Dist_Centro_Base, 
                  color = Dist_Centro_Base)) +
  geom_point()

ggplot(APG_X, aes(x = Angulo_Centro_Base , y = Diferenca_Percentual, 
                  color = Grupo)) +
  geom_point()

ggplot(APG_X, aes(x = Angulo_Centro_Base , y = Diferenca_Percentual, 
                  color = Angulo_Centro_Base)) +
  geom_point()


plot(APG_X)

F_Menor_Rota <- APG_X %>% count(Menor_Rota)

F_Menor_Rota <- as.data.frame(F_Menor_Rota)


plot(Diferenca_Percentual ~ Dist_Centro_Base)

plot(Diferenca_Percentual ~ Angulo_Centro_Base)



ggplot(APG_X, aes(x = Menor_Rota , y = Angulo_Centro_Base, 
                  color = Angulo_Centro_Base)) +
  geom_point()

ggplot(APG_X, aes(x = Angulo_Centro_Base , y = Diferenca_Percentual, 
                  color = Dist_Centro_Base)) +
  geom_point()

ggplot(APG_X, aes(x = Angulo_Centro_Base , y = Dist_Centro_Base,
       color = Menor_Rota)) +
  geom_point()


ggplot(APG_X, aes(x = Angulo_Centro_Base, y = Dist_Centro_Base, 
                  color = Menor_Rota)) +
  geom_point()


ggplot(APG_X, aes(x = Angulo_Centro_Base, y = Dist_Centro_Base)) +
  geom_point() +
  facet_wrap(~ Menor_Rota)

ggplot(APG_X, aes(x = Dist_Centro_Base, y = Angulo_Centro_Base)) +
  geom_point() +
  facet_wrap(~ Menor_Rota, ncol = 4)



ggplot(APG_X,
       aes(x = Dist_Centro_Base, y = Angulo_Centro_Base, color = Menor_Rota)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

ggplot(APG_X,
       aes(x = Angulo_Centro_Base, y = Dist_Centro_Base, color = Menor_Rota)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))


# Teste

ggplot(APG_X, aes(x = Angulo_Centro_Base, y = Dist_Centro_Base, 
                  color = Menor_Rota)) +
  geom_point()  + 
  scale_x_continuous(breaks = seq(0, 359, by = 15), limits = c(-10, 350)) +
  scale_y_continuous(breaks = seq(-100, 400, 100), limits = c(-10,400)) +
  coord_polar(start = -pi/18, clip = "off") +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

APG_X_Rota1 <- filter(APG_X, Menor_Rota == "[0, 1, 2, 4, 3, 5, 6, 0]")

ggplot(APG_X_Rota1, aes(x = Angulo_Centro_Base, y = Dist_Centro_Base, 
                        color = as.factor(Dist_Centro_Base))) +
  geom_point()  + 
  scale_x_continuous(breaks = seq(0, 359, by = 15), limits = c(-10, 350)) +
  scale_y_continuous(breaks = seq(-100, 400, 100), limits = c(-40,370)) +
  coord_polar(start = -pi/18, clip = "off")+
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

APG_X_Rota2 <- filter(APG_X, Menor_Rota == "[0, 1, 2, 4, 3, 5, 6, 0]")

ggplot(APG_X, aes(x = Angulo_Centro_Base, y = Dist_Centro_Base)) +
  geom_point()  + 
  scale_x_continuous(breaks = seq(0, 359, by = 15), limits = c(-10, 350)) +
  scale_y_continuous(breaks = seq(-100, 400, 100), limits = c(-40,370)) +
  coord_polar(start = -pi/18, clip = "off")+
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

# É esse!
ggplot(APG_X,
       aes(x = Angulo_Centro_Base, y = Diferenca_Percentual, 
           color = Dist_Centro_Base)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565")) +
  geom_vline(xintercept = c(90,180), linetype="dashed", 
             color = "red")

ggplot(APG_X,
       aes(x = Angulo_Centro_Base, y = Diferenca_Percentual, 
           color = Grupo)) +
  geom_point() +
  scale_fill_discrete(breaks=c("APG40", "APG65", "APG150", "APG565")) +
  facet_grid(~ fct_relevel(as.factor(Dist_Centro_Base),
                           "40", "100", "150", "360"))

APG_X90 <- filter(APG_X, Angulo_Centro_Base >= 0 & Angulo_Centro_Base <= 90)


ggplot(APG_X90,
       aes(x = Angulo_Centro_Base, y = Dist_Centro_Base, color = Menor_Rota)) +
  geom_point() +
  facet_grid( ~fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))


ggplot(mutate(APG_X90, Menor_Rota = fct_infreq(Menor_Rota))) + #Ordena as barras em ordem decrescente
  geom_bar(aes(factor(Menor_Rota)), fill = "#77B6EA") +
  theme_classic() +
  xlab("Menor Rota") +
  ylab("Frequência") +
  labs(fill = "Rotas", title = "Rotas Escolhidas") +
  coord_cartesian(ylim=c(0, 100)) + 
  scale_y_continuous(breaks=seq(0, 100, 10)) +
  coord_flip()


plot(Diferenca_Percentual ~ Angulo_Centro_Base, 
     data = APG_X90)

ggplot(APG_X90, aes(x = Angulo_Centro_Base, y = Dist_Centro_Base, 
                  color = Diferenca_Percentual)) +
  geom_point()


ggplot(APG_X,
       aes(x = Dist_Centro_Base, y = Diferenca_Percentual, color = Grupo)) +
  geom_point() +
  facet_grid(~ Grupo)


detach(APG_X)


plot(Angulo_Centro_Base,Diferenca_Percentual)


ggplot(APG_X,
       aes(x = Angulo_Centro_Base, y = Diferenca_Percentual, 
           color = Grupo)) +
  geom_point()

ggplot(APG_X,
       aes(x = Dist_Centro_Base, y = Diferenca_Percentual, 
           color = Grupo)) +
  geom_point()


ggplot(APG_X,
       aes(x = as.numeric(Menor_Rota), y = Angulo_Centro_Base, 
           color = Dist_Centro_Base)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

ggplot(APG_X,
       aes(x = as.numeric(Menor_Rota), y = Dist_Centro_Base, 
           color = Angulo_Centro_Base)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))



##### 1º Quadrante #####

A0 <- filter(APG_X, Angulo_Centro_Base == 0 )

ggplot(A0, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 0") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A0,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  labs(title="Azimute 0",
          x ="Distância Centro-Base", y = "Menor Rota") +
  geom_point(show.legend = FALSE) +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565")) +
  scale_x_continuous(breaks = c(40,100,150, 360)) +
  scale_colour_viridis_d()+
  theme_bw()


A15 <- filter(APG_X, Angulo_Centro_Base == 15 )

ggplot(A15, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 15") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A15,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))


A30 <- filter(APG_X, Angulo_Centro_Base == 30 )

ggplot(A30, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 30") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A30,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))


A45 <- filter(APG_X, Angulo_Centro_Base == 45 )

ggplot(A45, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 45") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A45,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

A60 <- filter(APG_X, Angulo_Centro_Base == 60 )

ggplot(A60, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 60") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A60,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

A75 <- filter(APG_X, Angulo_Centro_Base == 75 )

ggplot(A75, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 75") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A75,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

A90 <- filter(APG_X, Angulo_Centro_Base == 90 )

ggplot(A90, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 90") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A90,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))


#### 2º Quadrante ####

A105 <- filter(APG_X, Angulo_Centro_Base == 105)

ggplot(A105, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 105") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A105,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

A120 <- filter(APG_X, Angulo_Centro_Base == 120)

ggplot(A120, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 120") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A120,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

A135 <- filter(APG_X, Angulo_Centro_Base == 135)

ggplot(A135, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 135") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A135,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

A150 <- filter(APG_X, Angulo_Centro_Base == 150)

ggplot(A150, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 150") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A150,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

A165 <- filter(APG_X, Angulo_Centro_Base == 165)

ggplot(A165, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 165") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A165,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

A180 <- filter(APG_X, Angulo_Centro_Base == 180)

ggplot(A180, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 180") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A180,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  labs(title="Azimute 180",
       x ="Distância Centro-Base", y = "Menor Rota") +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565")) +
  scale_colour_viridis_d()+
  theme_bw()



#### 3º Quadrante ####

A195 <- filter(APG_X, Angulo_Centro_Base == 195)

ggplot(A195, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 195") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A195,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))


A210 <- filter(APG_X, Angulo_Centro_Base == 210)

ggplot(A210, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 210") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A210,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))


A225 <- filter(APG_X, Angulo_Centro_Base == 225)

ggplot(A225, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 225") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A225,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))


A240 <- filter(APG_X, Angulo_Centro_Base == 240)

ggplot(A240, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 240") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A240,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

A255 <- filter(APG_X, Angulo_Centro_Base == 255)

ggplot(A255, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 255") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A255,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))


A270 <- filter(APG_X, Angulo_Centro_Base == 270)

ggplot(A270, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 270") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A270,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))


##### 4º Quadrante ####

A285 <- filter(APG_X, Angulo_Centro_Base == 285)

ggplot(A285, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 285") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A285,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

A300 <- filter(APG_X, Angulo_Centro_Base == 300)

ggplot(A300, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 300") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A300,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

A315 <- filter(APG_X, Angulo_Centro_Base == 315)

ggplot(A315, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 300") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A315,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))


A330 <- filter(APG_X, Angulo_Centro_Base == 330)

ggplot(A330, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 330") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A330,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))

A345 <- filter(APG_X, Angulo_Centro_Base == 345)

ggplot(A345, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(title="Azimute 345") +
  geom_bar(position = "dodge") +
  coord_flip()

ggplot(A345,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565"))


#### Testando Códigos ####

df <- data.frame(r = c(0, 1), theta = c(0, 3 / 2 * pi))
ggplot(df, aes(r, theta)) + 
  geom_line() + 
  geom_point(size = 2, colour = "red")

interp <- function(rng, n) {
  seq(rng[1], rng[2], length = n)
}
munched <- data.frame(
  r = interp(df$r, 15),
  theta = interp(df$theta, 15)
)

ggplot(munched, aes(r, theta)) + 
  geom_line() + 
  geom_point(size = 2, colour = "red")


transformed <- transform(munched,
                         x = r * sin(theta),
                         y = r * cos(theta)
)

ggplot(transformed, aes(x, y)) + 
  geom_path() + 
  geom_point(size = 2, colour = "red") + 
  coord_fixed()


#### Diferença Percentual ####

# Importando os Dataframes 
APG_40_combinada <- read_excel("Python/CEAO22/comb_40/APG_40_combinada.xlsx")
APG_65_combinada <- read_excel("Python/CEAO22/comb_65/APG_65_combinada.xlsx")
APG_150_combinada <- read_excel("Python/CEAO22/comb_150/APG_150_combinada.xlsx")
APG_565_combinada <- read_excel("Python/CEAO22/comb_565/APG_565_combinada.xlsx")

# Cobinando as APG
APG_combinada <- rbind(APG_40_combinada,APG_65_combinada,
                       APG_150_combinada,APG_565_combinada)

str(APG_combinada)

APG_combinada$rotas <- as.factor(APG_combinada$rotas)
APG_combinada$grupo <- as.factor(APG_combinada$grupo)

# Exporta para Excel o arquivo combinado
#write_xlsx(
#  APG_combinada,"C:/Users/andre/OneDrive/Área de Trabalho/CEAO 2022/TCC/PROJETO_TCC/Python/CEAO22/APG_combinada.xlsx",
# col_names = TRUE,
# format_headers = TRUE)

###############################################################################

APG_combinada <- read_excel("Python/CEAO22/APG_combinada.xlsx")
APG_combinada$rotas <- as.factor(APG_combinada$rotas)
APG_combinada$grupo <- as.factor(APG_combinada$grupo)
str(APG_combinada)

ggplot(filter(APG_combinada, angulo <= 90),
       aes(x = index, y = dif_percentual, 
           color = angulo)) +
  geom_point() +
  scale_fill_discrete(breaks=c("APG40", "APG65", "APG150", "APG565")) +
  facet_grid(~ fct_relevel(as.factor(grupo),
                           "40", "100", "150", "360")) +
  scale_colour_viridis()


ggplot(filter(APG_combinada, angulo>90 & angulo<=180 & distancia==40), aes(index, dif_percentual, color = as.factor(grupo))) +
  geom_point() +
  geom_smooth()

ggplot(filter(APG_combinada, angulo>90 & angulo<=180 & distancia==100), aes(index, dif_percentual, color = as.factor(grupo))) +
  geom_point() +
  geom_smooth()

ggplot(filter(APG_combinada, angulo>90 & angulo<=180 & distancia==150), aes(index, dif_percentual, color = as.factor(grupo))) +
  geom_point() +
  geom_smooth()

ggplot(filter(APG_combinada, angulo>90 & angulo<=180 & distancia==360), aes(index, dif_percentual, color = as.factor(grupo))) +
  geom_point() +
  geom_smooth()


ggplot(APG_combinada,
       aes(x = index, y = dif_percentual, 
           color = distancia)) +
  geom_point() +
  scale_fill_discrete(breaks=c("40", "65", "150", "565")) +
  facet_grid(~ fct_relevel(as.factor(grupo),
                           "40", "65", "150", "565")) +
  scale_x_continuous(breaks=seq(0, 96, 12))+
  scale_y_continuous(breaks = seq(0,35,5), limits = c(0,35))+
  scale_colour_viridis_c(option = "cividis")+
  theme_bw()

ggplot(APG_combinada,
       aes(x = index, y = dif_percentual, 
           color = grupo)) +
  geom_point() +
  scale_fill_discrete(breaks=c("40", "65", "150", "565")) +
  facet_grid(~ fct_relevel(as.factor(distancia),
                           "40", "100", "150", "360"))+
  scale_x_continuous(breaks=seq(0, 96, 12))+
  scale_y_continuous(breaks = seq(0,35,5), limits = c(0,35))+
  scale_color_viridis_d(option = "cividis") +
  theme_bw()

ggplot(APG_combinada,
       aes(x = index, y = dif_percentual, 
           color = grupo)) +
  geom_point() +
  scale_fill_discrete(breaks=c("40", "65", "150", "565")) +
  facet_grid(~ fct_relevel(as.factor(distancia),
                           "40", "100", "150", "360"))+
  scale_y_continuous(breaks = seq(0,40,5), limits = c(0,40))+
  scale_color_viridis_d() +
  coord_cartesian(xlim=c(0,15))+
  theme_bw()


ggplot(filter(APG_combinada, angulo<=90),
       aes(x = index, y = dif_percentual, 
           color = grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(as.factor(angulo))) +
  scale_color_viridis_d() +
  theme_bw()

ggplot(filter(APG_combinada, angulo<=90 & grupo ==40),
       aes(x = index, y = dif_percentual, 
           color = distancia)) +
  geom_point() +
  facet_grid(~ fct_relevel(as.factor(angulo))) +
  scale_y_continuous(breaks = seq(0,37.5,2.5), limits = c(0,37.5))+
  scale_color_viridis_c() +
  theme_bw()

ggplot(filter(APG_combinada, angulo>90 & grupo ==40),
       aes(x = index, y = dif_percentual, 
           color = distancia)) +
  geom_point() +
  facet_grid(~ fct_relevel(as.factor(angulo))) +
  scale_y_continuous(breaks = seq(0,37.5,2.5), limits = c(0,37.5))+
  scale_color_viridis_c() +
  theme_bw()

ggplot(filter(APG_combinada, angulo>90),
       aes(x = index, y = dif_percentual, 
           color = grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(as.factor(angulo))) +
  scale_y_continuous(breaks = seq(0,37.5,2.5), limits = c(0,37.5))+
  scale_color_viridis_d() +
  theme_bw()


#### Gráficos Padrão ####

ggplot(mutate(APG_X, Menor_Rota = fct_infreq(Menor_Rota))) +
  geom_bar(aes(factor(Menor_Rota))) +
  xlab("Menor Rota") +
  ylab("Frequência") +
  labs(fill = "Rotas") +
  scale_y_continuous(breaks=seq(0, 95, 5)) +
  coord_flip()+
  scale_fill_viridis_d(option = "cividis")+
  theme_bw()

ggplot(A15, 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(x = "Menor Rota", y = "Frequência") +
  geom_bar(position = "dodge") +
  coord_flip()+
  scale_fill_viridis_d(option = "cividis")+
  theme_bw()

G2 <- filter(APG_X, Angulo_Centro_Base>= 15 &  Angulo_Centro_Base<=60)

ggplot(mutate(G2, Menor_Rota = fct_infreq(Menor_Rota))) +
  geom_bar(aes(factor(Menor_Rota))) +
  xlab("Menor Rota") +
  ylab("Frequência") +
  labs(fill = "Rotas", title = "Menor Rota") +
  scale_y_continuous(breaks=seq(0, 100, 10)) +
  coord_flip()+
  scale_fill_viridis_d(option = "cividis")+
  theme_bw()

ggplot((mutate(G2, Menor_Rota = fct_infreq(Menor_Rota))), 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(x = "Menor Rota", y = "Frequência") +
  geom_bar(position = "dodge") +
  scale_y_continuous(breaks=seq(0, 25, 1)) +
  coord_flip() +
  theme_bw() +
  scale_fill_viridis_d(option = "cividis")


ggplot(G2,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = as.factor(Angulo_Centro_Base))) +
  labs(x ="Distância Centro-Base", y = "Menor Rota") +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565")) +
  scale_x_continuous(breaks = c(40,100,150, 360)) +
  scale_colour_viridis_d(option = "cividis")+
  theme_bw()


ggplot(A0,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  labs(x ="Distância Centro-Base", y = "Menor Rota") +
  geom_point(show.legend = FALSE) +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565")) +
  scale_x_continuous(breaks = c(40,100,150, 360)) +
  scale_colour_viridis_d(option = "cividis")+
  theme_bw()

ggplot(A90,
       aes(x = Dist_Centro_Base, y = Menor_Rota, 
           color = Grupo)) +
  labs(x ="Distância Centro-Base", y = "Menor Rota") +
  geom_point(show.legend = FALSE) +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565")) +
  scale_x_continuous(breaks = c(40,100,150, 360)) +
  scale_colour_viridis_d(option = "cividis")+
  theme_bw()

ggplot((mutate(A75, Menor_Rota = fct_infreq(Menor_Rota))), 
       aes(x = Menor_Rota, 
           fill = Grupo)) +
  labs(x = "Menor Rota", y = "Frequência") +
  geom_bar(position = "dodge") +
  scale_y_continuous(breaks=seq(0, 25, 1)) +
  coord_flip() +
  scale_fill_viridis_d(option = "cividis") +
  theme_bw()


ggplot(APG_X,
       aes(x = Angulo_Centro_Base, y = Diferenca_Percentual, 
           color = Dist_Centro_Base)) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565")) +
  scale_x_continuous(breaks=seq(0, 360, 90)) +
  scale_y_continuous(breaks=seq(0, 37.5, 2.5)) +
  labs(x = "Ângulo Centro-Base", y = "Diferença Percentual", colour = "Distância") +
  scale_color_viridis_c(option = "cividis", direction = -1) +
  geom_vline(xintercept = c(90,180,270), linetype="dashed", 
             color = "red")+ 
  theme_bw()

ggplot(APG_X,
       aes(x = Angulo_Centro_Base, y = Diferenca_Percentual, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(as.factor(Dist_Centro_Base),
                           "40", "100", "150", "360"))+
  scale_x_continuous(breaks=seq(0, 360, 90)) +
  scale_y_continuous(breaks=seq(0, 37.5, 2.5)) +
  labs(x = "Ângulo Centro-Base", y = "Diferença Percentual", colour = "APG") +
  scale_color_viridis_d(option = "cividis", direction = -1) +
  theme_bw()+
  theme(legend.position = "bottom")

ggplot(APG_X,
       aes(x = Angulo_Centro_Base, y = Diferenca_Percentual, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(as.factor(Dist_Centro_Base),
                           "40", "100", "150", "360"))+
  scale_x_continuous(breaks=seq(0, 360, 90)) +
  scale_y_continuous(breaks=seq(0, 18, 1)) +
  labs(x = "Ângulo Centro-Base", y = "Diferença Percentual", colour = "APG") +
  scale_color_viridis_d(option = "cividis", direction = -1) +
  theme_bw()+
  theme(legend.position = "bottom")+
  coord_cartesian(ylim=c(4,17.5))+
  geom_hline(yintercept = c(6,12.5),linetype="dashed", color = "red",
             size = 0.9) +
  geom_hline(yintercept = c(4,15.5),linetype="dashed", color = "darkblue", 
             size = 0.9)


p1 <- ggplot(APG_combinada,
             aes(x = index, y = dif_percentual, color = distancia)) +
  labs(x = NULL, y = "Diferença Percentual", colour = "Distância") +
  geom_point() +
  scale_fill_discrete(breaks=c("40", "65", "150", "565")) +
  facet_grid(~ fct_relevel(as.factor(grupo),
                           "40", "65", "150", "565")) +
  scale_x_continuous(breaks=seq(0, 96, 12)) +
  scale_y_continuous(breaks = seq(0,35,5), limits = c(0,35)) +
  scale_colour_viridis_c(option = "cividis") +
  theme_bw()

APG_combinada <- APG_combinada %>% 
  mutate(grupo = factor(grupo, 
                        levels = c("40", "65", "150", "565")))
APG_X <- APG_X %>% 
  mutate(Grupo = factor(Grupo, 
                        levels = c("APG40", "APG65", "APG150", "APG565")))

p2 <- ggplot(APG_combinada,
             aes(x = index, y = dif_percentual, 
                 color = grupo)) +
  labs(x = "Rotas", y = "Diferença Percentual", colour = "APG")+
  geom_point() +
  scale_fill_discrete(breaks=c("40", "65", "150", "565")) +
  facet_grid(~ fct_relevel(as.factor(distancia),
                           "40", "100", "150", "360")) +
  scale_x_continuous(breaks=seq(0, 96, 12)) +
  scale_y_continuous(breaks = seq(0,35,5), limits = c(0,35)) +
  scale_color_viridis_d(option = "cividis") +
  theme_bw()

ggarrange(p1, p2, nrow = 2)


ggplot(APG_combinada,
       aes(x = index, y = dif_percentual, color = distancia)) +
  labs(x = NULL, y = "Diferença Percentual", colour = "Distância") +
  geom_point() +
  scale_fill_discrete(breaks=c("40", "65", "150", "565")) +
  facet_grid(~ fct_relevel(as.factor(grupo),
                           "40", "65", "150", "565")) +
  scale_x_continuous(breaks=seq(0, 20, 2)) +
  scale_y_continuous(breaks = seq(0,17,4), limits = c(0,17)) +
  coord_cartesian(xlim=c(0,20), ylim=c(0,17))+
  scale_colour_viridis_c(option = "cividis") +
  geom_vline(xintercept = 13, linetype="dashed", 
             color = "red")+
  theme_bw()


ggplot(APG_combinada,
       aes(x = index, y = dif_percentual, color = distancia)) +
  labs(x = NULL, y = "Diferença Percentual", colour = "Distância") +
  geom_point() +
  scale_fill_discrete(breaks=c("40", "65", "150", "565")) +
  facet_grid(~ fct_relevel(as.factor(grupo),
                           "40", "65", "150", "565")) +
  scale_x_continuous(breaks=seq(0, 20, 2)) +
  scale_y_continuous(breaks = seq(0,17,4), limits = c(0,17)) +
  coord_cartesian(xlim=c(0,20), ylim=c(0,17))+
  scale_colour_viridis_c(option = "cividis") +
  geom_vline(xintercept = 13, linetype="dashed", 
             color = "red")+
  theme_bw()



ggplot(filter(APG_combinada, grupo == 565),
       aes(x = index, y = dif_percentual, color = angulo)) +
  labs(x = NULL, y = "Diferença Percentual", colour = "Ângulo") +
  geom_point() +
  scale_fill_discrete(breaks=c("40", "100", "150", "360")) +
  facet_grid(~ fct_relevel(as.factor(distancia),
                           "40", "100", "150", "360")) +
  scale_x_continuous(breaks=seq(0, 96, 12)) +
  scale_y_continuous(breaks = seq(0,6,1), limits = c(0,6)) +
  scale_colour_viridis_c(option = "cividis") +
  theme_bw()

ggplot(filter(APG_combinada, grupo == 565),
       aes(x = index, y = dif_percentual, color = angulo)) +
  labs(x = NULL, y = "Diferença Percentual", colour = "Ângulo") +
  geom_point() +
  scale_fill_discrete(breaks=c("40", "100", "150", "360")) +
  facet_grid(~ fct_relevel(as.factor(distancia),
                           "40", "100", "150", "360")) +
  scale_x_continuous(breaks=seq(0, 96, 12)) +
  scale_y_continuous(breaks = seq(0,6,1), limits = c(0,6)) +
  scale_colour_viridis_c(option = "cividis") +
  gghighlight(angulo == "90",
              unhighlighted_params = list(colour=NULL, alpha = 0.20))+
  theme_bw()

ggplot(filter(APG_combinada, grupo == 565),
       aes(x = index, y = dif_percentual, color = distancia)) +
  labs(x = NULL, y = "Diferença Percentual", colour = "Distância") +
  geom_point() +
  facet_grid(~ fct_relevel(as.factor(angulo))) +
  scale_x_continuous(breaks=seq(0, 96, 48)) +
  scale_y_continuous(breaks = seq(0,6,1), limits = c(0,6)) +
  scale_colour_viridis_c(option = "cividis") +
  theme_bw()

#### Mapa do Brasil com LKP ####
newmap = getMap(resolution = "high")
plot(newmap,
     xlim = c(-65.98283055, -30.79314722),
     ylim = c(-32.75116944, 5.27438888),
     asp = 1,
     bg = "lightblue",
     col = "white")

points(DF_SAR$LONG_LKP, DF_SAR$LAT_LKP,
       col = "red",
       cex = 0.8,
       pch = 20)

#### Embasamento Simulação ####
resultados_azimute %>%
  ggplot(aes(x=as.numeric(dataset), y=`distância centro-base`)) +
  geom_boxplot() +
  geom_jitter(color="black", size=1)+
  labs(x = "Casos", y = "Distância Centro-Base") +
  scale_x_continuous(breaks=seq(0, 75, 5)) +
  scale_y_continuous(breaks = seq(0,370,20), limits = c(0,370)) +
  geom_hline(yintercept = c(40,100,150,360),linetype="dashed", color = "red",
             size = 0.5) +
  scale_colour_viridis_d(option = "cividis") +
  theme_bw()+
  coord_flip()

str(DF_SAR)

DF_SAR %>%
  ggplot(aes(x=as.numeric(OBJETO_BUSCA), y=Distancia_LKP_Dest)) +
  geom_boxplot() +
  geom_jitter(color="black", size=1)+
  labs(x = "Casos", y = "Distancia LKP-Destino") +
  scale_x_continuous(breaks=seq(0, 75, 5)) +
  scale_y_continuous(breaks = seq(0,565,40), limits = c(0,570)) +
  geom_hline(yintercept = c(40,65,150,565),linetype="dashed", color = "red",
             size = 0.5) +
  scale_colour_viridis_d(option = "cividis") +
  theme_bw()+
  coord_flip()



#### Scatter Plot com Histograma - Azimutes ####
# library
library(ggExtra)

p <- ggplot(resultados_azimute, 
            aes(x=as.numeric(dataset), y=`ângulo centro-base`)) +
  scale_x_continuous(breaks=seq(0, 75, 5)) +
  scale_y_continuous(breaks = seq(0,360,30), limits = c(0,360)) +
  labs(x = "Casos", y = "Ângulo Centro-Base") +
  geom_point() +
  theme_bw()+
  coord_flip()

# with marginal histogram
ggMarginal(p, type="histogram", margins = "x")



#### Escala de Cores da Viridis ####
library(scales)
show_col(viridis_pal(option = "cividis")(20))

