# -*- coding: utf-8 -*-
"""

"""

#%%
import pandas as pd
import numpy as np
import geopy
from geopy.distance import geodesic
from pyproj import Geod
import pyproj
import matplotlib.pyplot as plt

#Chamando arquivo funcoes
from funcoes_7nm import *

#%%
#1) Carregando df SAR c/ 73 casos
df_sar = pd.read_excel('casos_SAR.xlsx')

################################################
#%%
#Gerando os resultados
rotas = pd.read_excel('dados_rotas_7nm_07jul.xlsx', sheet_name='rotas_96')

lista_min = []
lista_max = []
lista_diferenca = []
lista_porcentagem = []
rota_min = []
rota_max = []
lista_ang_base = []
lista_dist_base = []
qtd_min = []
qtd_max = []

for i in range(len(df_sar)):
    #Cálculo dos ângulos
    destino = [df_sar['LAT_DESTINO'][i], df_sar['LONG_DESTINO'][i]]
    lkp = [df_sar['LAT_LKP'][i], df_sar['LONG_LKP'][i]]
    base = [df_sar['LAT_BASE'][i], df_sar['LONG_BASE'][i]]  
    param_angulos = calculo_angulos(destino, lkp)

    #Geração dos datasets
    nome_dataset = df_sar.OBJETO_BUSCA[i]
    print(f'Dataset: {nome_dataset}')
    lkp_sup, lkp_inf, destino_sup, destino_inf = pontos_rebatidos(destino, lkp)
    df_sup = gera_dataset(destino_sup, lkp_sup, param_angulos)
    df_inf = gera_dataset(destino_inf, lkp_inf, param_angulos)
    dataset = junta_2_dataset(df_sup, df_inf)
    dataset.loc[len(dataset)] = ['base', base[0], base[1]]
    
    #Geração das matrizes de distâncias simples
    df_distancias, matriz_distancias = calculo_distancias_12_pontos(dataset)
    
    #Geração da planilha com as distâncias
    caminhos = pd.read_excel('dados_rotas_7nm_07jul.xlsx', sheet_name='caminhos')
    etapa_full = len(caminhos)
    etapa_1 = len(caminhos.index[caminhos.no_de==0])
    etapa_3 = len(caminhos.index[caminhos.no_para==0])
    etapa_2 = etapa_full - etapa_1 - etapa_3
    
    lista_dist = []    
    for i in range(etapa_1):
        lista_dist.append(matriz_distancias[caminhos.no_de[i]][caminhos.no_para[i]])
    
    for i in range(etapa_1, etapa_1+etapa_2):
        dist_de_meio = matriz_distancias[caminhos.no_de[i]][caminhos.no_meio[i]]
        dist_meio_para = matriz_distancias[caminhos.no_meio[i]][caminhos.no_para[i]]
        soma_dist = dist_de_meio + dist_meio_para
        lista_dist.append(soma_dist)
        
    for i in range(etapa_1+etapa_2, etapa_full):
        dist_de_meio = matriz_distancias[caminhos.no_de[i]][caminhos.no_meio[i]]
        dist_meio_para = matriz_distancias[caminhos.no_meio[i]][caminhos.no_para[i]]
        soma_dist = dist_de_meio + dist_meio_para
        lista_dist.append(soma_dist)
    caminhos['distancia'] = lista_dist
    
    #Calculando valores de reposicionamento
    lista_repos = calculo_reposicionamento(dataset=caminhos, fator_antecipacao=4, fator_reposicionamento=6, fator_regresso=0)
    
    #Criando coluna em caminhos
    caminhos['dist_reposicionamento'] = lista_repos
    caminhos['dist_total'] = caminhos.dist_reposicionamento + caminhos.distancia
    
    #Criando a planilha final com os resultados das distâcias das rotas
    caminhos_final = calculo_distancia_rotas_12_pontos(caminhos)
    
    print(caminhos_final.sort_values(by='total'), '\n')
    caminhos_final.sort_values(by='total').to_excel(f'resultados_casos/{nome_dataset}.xlsx', index=False)
   
    #Montando o dataset 'resultados'
    
    #Calculando ângulo e distância do ponto central da APG para a Base
    ponto_central = centro(destino[0], destino[1], lkp[0], lkp[1])
    g = Geod(ellps='WGS84')
    angulo, _, distancia = g.inv(ponto_central[1], ponto_central[0], base[1], base[0])
    if angulo < 0:
        angulo = 360 + angulo
    lista_ang_base.append(round(angulo))
    lista_dist_base.append(round(distancia/1852, 2))
    
    #Calculando rotas min e máx
    minimo = min(caminhos_final.total)
    indice_min = caminhos_final['total'].idxmin()
    rota_min.append(caminhos_final['rotas'][indice_min])
    maximo = max(caminhos_final.total)
    indice_max = caminhos_final['total'].idxmax()
    rota_max.append(caminhos_final['rotas'][indice_max])
    diferenca = maximo - minimo
    porcentagem = round(diferenca / maximo * 100, 1)
    
    lista_min.append(minimo)
    lista_max.append(maximo)
    lista_diferenca.append(diferenca)
    lista_porcentagem.append(porcentagem)
    
    #Calculando qtd rotas ideias e máximas
    qtd_min.append(caminhos_final.total[caminhos_final['total'] <= minimo].count())
    qtd_max.append(caminhos_final.total[caminhos_final['total'] >= maximo].count())
    
    print('Rotas Mínimas:')
    print(caminhos_final['rotas'].loc[caminhos_final['total'] == minimo], '\n')

    print('Rotas Máximas:')
    print(caminhos_final['rotas'].loc[caminhos_final['total'] == maximo], '\n')
      
resultados = pd.DataFrame({'dataset': df_sar.OBJETO_BUSCA,
                           'qtd rotas ideais': qtd_min,
                            'rota ideal': rota_min,                            
                            'dist rota ideal (nm)': lista_min,
                            'qtd maiores rotas': qtd_max,
                            'maior rota': rota_max,
                            'dist maior rota (nm)': lista_max,
                            'diferenca (nm)': lista_diferenca,
                            'diferenca percentual': lista_porcentagem,
                            'distância centro-base': lista_dist_base,
                            'ângulo centro-base': lista_ang_base})

print(resultados)

#%%
#Salvando o DataFrame 'resultados'
resultados.to_excel('resultados.xlsx', index=False)

#%%
print()
print('Rotas Mínimas:')
print(resultados['rota ideal'].value_counts())
print()

print('Rotas Máximas:')
print(resultados['maior rota'].value_counts())

#%%
teste = pd.read_excel('resultados_casos/PU-POT.xlsx')
# print(teste)

minimo = min(teste.total)
# print(minimo)
indice_min = teste.total.idxmin()
# print(indice_min)
# print(teste['total'].count(minimo))
print(teste.total[teste['total'] <= minimo].count())

#%%
#frequencia, classes = np.histogram(dados)
frequencia, classes = np.histogram(resultados['distância centro-base'], bins=6) #bins define qtd intervalos de classe
# print(frequencia, classes)

plt.hist(resultados['distância centro-base'], bins=8)

#%%
plt.hist(resultados['ângulo centro-base'], bins=8)
