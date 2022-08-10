Comparativo <- read_excel("Comparativo.xlsx", 
                          sheet = "Sheet2")
str(Comparativo)

Comparativo$Grupo <- as.factor(Comparativo$Grupo)

ggplot(filter(Comparativo, Angulo == 0),
       aes(x = Distancia_Centro, y = Diferenca)) +
  labs(x ="Distância Centro-Base", y = "Diferença entre distâncias das rotas (NM)") +
  geom_line(linetype = 2, size = 0.5, show.legend = F, color = "red") +
  geom_point()+
  facet_grid(~Grupo, scales = "free") +
  scale_y_continuous(breaks = seq(0,6,1))+
  scale_x_continuous(breaks = c(40,100,150,360))+
  theme_bw()


ggplot(filter(Comparativo, Angulo == 15),
       aes(x = Distancia_Centro, y = Diferenca)) +
  labs(x ="Distância Centro-Base", y = "Diferença entre distâncias das rotas (NM)") +
  geom_line(linetype = 2, size = 0.5, show.legend = F, color = "red") +
  geom_point()+
  facet_grid(~Grupo, scales = "free") +
  scale_y_continuous(breaks = seq(0,6,1))+
  scale_x_continuous(breaks = c(40,100,150,360))+
  theme_bw()

ggplot(filter(Comparativo, Angulo == 15),
       aes(x = Distancia_Centro, y = Diferenca)) +
  labs(x ="Distância Centro-Base", y = "Diferença entre distâncias das rotas (NM)") +
  geom_line(linetype = 2, size = 0.5, show.legend = F, color = "red") +
  geom_point()+
  facet_grid(~Grupo, scales = "free") +
  scale_y_continuous(breaks = seq(0,10,1))+
  scale_x_continuous(breaks = c(40,100,150,360))+
  theme_bw()

ggplot(filter(Comparativo, Angulo == 90),
       aes(x = Distancia_Centro, y = Diferenca)) +
  labs(x ="Distância Centro-Base", y = "Diferença entre distâncias das rotas (NM)") +
  geom_line(linetype = 2, size = 0.5, show.legend = F, color = "red") +
  geom_point()+
  facet_grid(~Grupo, scales = "free") +
  scale_y_continuous(breaks = seq(0,12,1))+
  scale_x_continuous(breaks = c(40,100,150,360))+
  theme_bw()

ggplot(filter(Comparativo, Angulo == 75),
       aes(x = Distancia_Centro, y = Diferenca)) +
  labs(x ="Distância Centro-Base", y = "Diferença entre distâncias das rotas (NM)") +
  geom_line(linetype = 2, size = 0.5, show.legend = F, color = "red") +
  geom_point()+
  facet_grid(~Grupo, scales = "free") +
  scale_y_continuous(breaks = seq(-10,10,2))+
  scale_x_continuous(breaks = c(40,100,150,360))+
  geom_hline(yintercept = 0,linetype="dashed", color = "blue",
             size = 0.5)+
  theme_bw()


