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
       aes(x = Dist_Centro_Base, y = Menor_Rota)) +
  labs(x ="Distância Centro-Base", y = "Menor Rota") +
  geom_point(show.legend = FALSE) +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565")) +
  scale_x_continuous(breaks = c(40,100,150, 360)) +
  scale_y_discrete(limits = c("[0, 4, 3, 5, 6, 2, 1, 0]",
                              "[0, 3, 4, 6, 5, 1, 2, 0]",
                              "[0, 2, 1, 5, 6, 4, 3, 0]",
                              "[0, 1, 2, 6, 5, 3, 4, 0]",
                              "[0, 1, 2, 4, 3, 5, 6, 0]",
                              "[0, 6, 5, 3, 4, 2, 1, 0]",
                              "[0, 2, 1, 3, 4, 6, 5, 0]",
                              "[0, 5, 6, 4, 3, 1, 2, 0]"))+
  theme_bw()

ggplot(A15,
       aes(x = Dist_Centro_Base, y = Menor_Rota)) +
  labs(x ="Distância Centro-Base", y = "Menor Rota") +
  geom_point(show.legend = FALSE) +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565")) +
  scale_x_continuous(breaks = c(40,100,150, 360)) +
  theme_bw()

ggplot(A75,
       aes(x = Dist_Centro_Base, y = Menor_Rota)) +
  labs(x ="Distância Centro-Base", y = "Menor Rota") +
  geom_point(show.legend = FALSE) +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565")) +
  scale_x_continuous(breaks = c(40,100,150, 360)) +
  theme_bw()

A195 <- filter(APG_X, Angulo_Centro_Base == 195)

ggplot(A195,
       aes(x = Dist_Centro_Base, y = Menor_Rota)) +
  labs(x ="Distância Centro-Base", y = "Menor Rota") +
  geom_point(show.legend = FALSE) +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565")) +
  scale_x_continuous(breaks = c(40,100,150, 360)) +
  theme_bw()

ggplot(A90,
       aes(x = Dist_Centro_Base, y = Menor_Rota)) +
  labs(x ="Distância Centro-Base", y = "Menor Rota") +
  geom_point(show.legend = FALSE) +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565")) +
  scale_x_continuous(breaks = c(40,100,150, 360)) +
  theme_bw()

ggplot(filter(APG_X, Angulo_Centro_Base == 270),
       aes(x = Dist_Centro_Base, y = Menor_Rota)) +
  labs(x ="Distância Centro-Base", y = "Menor Rota") +
  geom_point(show.legend = FALSE) +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565")) +
  scale_x_continuous(breaks = c(40,100,150, 360)) +
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
           color = as.factor(Dist_Centro_Base))) +
  geom_point() +
  facet_grid(~ fct_relevel(Grupo,"APG40", "APG65", "APG150", "APG565")) +
  scale_x_continuous(breaks=seq(0, 360, 90)) +
  scale_y_continuous(breaks=seq(0, 37.5, 2.5)) +
  labs(x = "Azimute Centro-Base", y = "Diferença Percentual", colour = "Distância") +
  scale_color_viridis_d(option = "cividis", direction = -1) +
  geom_vline(xintercept = c(90,180,270), linetype="dashed", 
             color = "red")+ 
  theme_bw()+
  theme(legend.position = "bottom")


ggplot(APG_X,
       aes(x = Angulo_Centro_Base, y = Diferenca_Percentual, 
           color = Grupo)) +
  geom_point() +
  facet_grid(~ fct_relevel(as.factor(Dist_Centro_Base),
                           "40", "100", "150", "360"))+
  scale_x_continuous(breaks=seq(0, 360, 90)) +
  scale_y_continuous(breaks=seq(0, 37.5, 2.5)) +
  labs(x = "Azimute Centro-Base", y = "Diferença Percentual", colour = "APG") +
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
  labs(x = "Azimute Centro-Base", y = "Diferença Percentual", colour = "APG") +
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

ggplot(APG_X, aes(x = Angulo_Centro_Base, y = Dist_Centro_Base)) +
  geom_point()  + 
  scale_x_continuous(breaks = seq(0, 359, by = 15), limits = c(-10, 350)) +
  scale_y_continuous(breaks = seq(0, 370, 40), limits = c(0,370)) +
  coord_polar(start = -pi/18, clip = "off")+
  theme_bw()+
  labs(y = "Distância Centro-Base", x = "Azimute Centro-Base")

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
  labs(x = "Casos", y = "Azimute Centro-Base") +
  geom_point() +
  theme_bw()+
  coord_flip()

# with marginal histogram
ggMarginal(p, type="histogram", margins = "x")



#### Escala de Cores da Viridis ####
library(scales)
show_col(viridis_pal(option = "cividis")(20))
  