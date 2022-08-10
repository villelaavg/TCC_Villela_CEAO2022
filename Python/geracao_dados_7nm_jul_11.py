# -*- coding: utf-8 -*-
"""
Created on Fri Apr  8 12:29:48 2022

@author: falca
"""

#%%
import pandas as pd
import numpy as np
import geopy
from geopy.distance import geodesic
from pyproj import Geod
import pyproj
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap

#Chamando arquivo funcoes
from funcoes_7nm import *

#%%
#1) Gerando df c/ bases ao redor do centro
intervalo_distancias = [i for i in range(50,351,50)]
intervalo_angulos = [i for i in range(0,359,15)]
intervalo_apg = [40, 66, 150]
lat_0 = 0
lon_0 = 0

dados = gera_df_teste(lat_0, lon_0, intervalo_angulos, intervalo_distancias, intervalo_apg)

#%%
#Separando df em fç tamanho APG 
# print(dados.columns)
apg_40 = dados.iloc[:, :9]
excl_66 = ['lkp_40', 'lat_lkp_40', 'lon_lkp_40',
       'destino_40', 'lat_destino_40', 'lon_destino_40', 'lkp_150', 'lat_lkp_150', 'lon_lkp_150',
       'destino_150', 'lat_destino_150', 'lon_destino_150']
excl_150 = ['lkp_40', 'lat_lkp_40', 'lon_lkp_40',
       'destino_40', 'lat_destino_40', 'lon_destino_40', 'lkp_66',
       'lat_lkp_66', 'lon_lkp_66', 'destino_66', 'lat_destino_66',
       'lon_destino_66']
apg_66 = dados.drop(columns=excl_66)
apg_150 = dados.drop(columns=excl_150)

#%%
#Renomeando as colunas
novos_nomes = ['OBJETO_BUSCA', 'LAT_BASE', 'LONG_BASE', 'LKP', 'LAT_LKP', 'LONG_LKP', 'DESTINO', 'LAT_DESTINO', 'LONG_DESTINO']
apg_40.columns = [novos_nomes]
apg_66.columns = [novos_nomes]
apg_150.columns = [novos_nomes]

#%%
#Salvando os datasets
apg_40.to_excel('apg_40.xlsx')
apg_66.to_excel('apg_66.xlsx')
apg_150.to_excel('apg_150.xlsx')

#%%
#Carregando datasets
apg_40 = pd.read_excel('apg_40.xlsx', usecols='B:J')
apg_40 = apg_40.iloc[1:,:]
apg_40 = apg_40.reset_index(drop=True)

apg_66 = pd.read_excel('apg_66.xlsx', usecols='B:J')
apg_66 = apg_66.iloc[1:,:]
apg_66 = apg_66.reset_index(drop=True)

apg_150 = pd.read_excel('apg_150.xlsx', usecols='B:J')
apg_150 = apg_150.iloc[1:,:]
apg_150 = apg_150.reset_index(drop=True)

#%%
#Gerando os resultados

#APG-40
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

for i in range(len(apg_40)):
    #Cálculo dos ângulos
    destino = [apg_40['LAT_DESTINO'][i], apg_40['LONG_DESTINO'][i]]
    lkp = [apg_40['LAT_LKP'][i], apg_40['LONG_LKP'][i]]
    base = [apg_40['LAT_BASE'][i], apg_40['LONG_BASE'][i]]  
    param_angulos = calculo_angulos(destino, lkp)

    #Geração dos datasets
    nome_dataset = apg_40.OBJETO_BUSCA[i]
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
    caminhos.to_excel(f'resultados_apg_40/matriz_{nome_dataset}.xlsx', index=False)
    
    #Criando a planilha final com os resultados das distâcias das rotas
    caminhos_final = calculo_distancia_rotas_12_pontos(caminhos)
    
    print(caminhos_final.sort_values(by='total'), '\n')
    caminhos_final.sort_values(by='total').to_excel(f'resultados_apg_40/{nome_dataset}.xlsx', index=False)
   
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
      
resultados_apg_40 = pd.DataFrame({'dataset': apg_40.OBJETO_BUSCA,
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

print(resultados_apg_40)

#%%
#Salvando o DataFrame 'resultados'
resultados_apg_40.to_excel('resultados_apg_40_full.xlsx', index=False)

#%%
print()
print('Rotas Mínimas:')
print(resultados_apg_40['rota ideal'].value_counts())
print()

print('Rotas Máximas:')
print(resultados_apg_40['maior rota'].value_counts())

#%%
#2) Criando mapas para testar a função de geração das apg rebatidas
limite = 1 #primeiro caso

for i in range(limite):
    #Cálculo dos ângulos
    destino = [apg_40['LAT_DESTINO'][i], apg_40['LONG_DESTINO'][i]]
    lkp = [apg_40['LAT_LKP'][i], apg_40['LONG_LKP'][i]]
    base = [apg_40['LAT_BASE'][i], apg_40['LONG_BASE'][i]]    
    param_angulos = calculo_angulos(destino, lkp)
    
    #Geração pontos rebatidos
    lkp_sup, lkp_inf, destino_sup, destino_inf = pontos_rebatidos(destino, lkp)
    
    #Geração dos datasets
    df = gera_dataset(destino, lkp, param_angulos)
    df_sup = gera_dataset(destino_sup, lkp_sup, param_angulos)
    df_inf = gera_dataset(destino_inf, lkp_inf, param_angulos)
    
    #Juntando datasets
    dataset = junta_2_dataset(df_sup, df_inf)
    dataset.loc[len(dataset)] = ['base', base[0], base[1]]
    
    #Criando o mapa
    lat1, lat2 = dataset['lat'].max(), dataset['lat'].min()
    lon1, lon2 = dataset['lon'].max(), dataset['lon'].min()
    
    plt.figure(figsize=(15,15))
    m = Basemap(projection='cyl', resolution='h',
                llcrnrlat = -2, urcrnrlat= 2,
                llcrnrlon = -2, urcrnrlon = 2)
    nome = apg_40.OBJETO_BUSCA[i]
    plt.text(base[1], base[0], nome, ha='center', va='bottom')
    
    m.drawcoastlines()
    m.drawmapboundary(fill_color='lightskyblue')
    m.fillcontinents(color='palegoldenrod', lake_color='lightskyblue')
    #APG
    m.scatter(dataset['lon'][:-1], dataset['lat'][:-1], s=50, c='blue', marker= 's', alpha=1, zorder=2)
    #Centro
    m.scatter(lon_0, lat_0, s=50, c='green', marker= 'o', alpha=1, zorder=2)
    #Base
    m.scatter(base[1], base[0], s=50, c='red', marker= '^', alpha=1, zorder=2)
# dataset.to_csv('df_1.csv', index=False)












#%%
#Teste compr apg com for

#APG-40
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

intervalo_apg = [40, 66, 150]

for apg in intervalo_apg:
    apg = pd.read_excel(f'apg_{apg}.xlsx', usecols='B:J')
    apg = apg.iloc[1:,:]
    apg = apg.reset_index(drop=True)
    for i in range(len(apg)):
        #Cálculo dos ângulos
        destino = [apg['LAT_DESTINO'][i], apg['LONG_DESTINO'][i]]
        lkp = [apg['LAT_LKP'][i], apg['LONG_LKP'][i]]
        base = [apg['LAT_BASE'][i], apg['LONG_BASE'][i]]  
        param_angulos = calculo_angulos(destino, lkp)
    
        #Geração dos datasets
        nome_dataset = apg.OBJETO_BUSCA[i]
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
        caminhos.to_excel(f'resultados_apg_40/matriz_{nome_dataset}.xlsx', index=False)
        
        #Criando a planilha final com os resultados das distâcias das rotas
        caminhos_final = calculo_distancia_rotas_12_pontos(caminhos)
        
        print(caminhos_final.sort_values(by='total'), '\n')
        caminhos_final.sort_values(by='total').to_excel(f'resultados_apg_40/{nome_dataset}.xlsx', index=False)
       
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
          
    resultados_apg = pd.DataFrame({'dataset': apg.OBJETO_BUSCA,
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
    
    print(resultados_apg)
    
    #Salvando o DataFrame 'resultados'
    resultados_apg.to_excel(f'resultados_apg_{apg}/resultados_apg_{apg}.xlsx', index=False)