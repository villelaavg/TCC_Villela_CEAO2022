# -*- coding: utf-8 -*-
"""
Created on Sun Apr 10 11:27:41 2022

@author: falca

Funções para cálculos e geração de datasets
"""
#%%
import pandas as pd
import numpy as np
import geopy
from geopy.distance import geodesic
import pyproj
from pyproj import Geod

##############################################################################

#Cálculo dos ângulos 
def calculo_angulos(destino, lkp):
    geodesic = pyproj.Geod(ellps='WGS84')
    fwd_azimuth,back_azimuth,distance = geodesic.inv(destino[1], destino[0], lkp[1], lkp[0])
    
    if destino[1] < lkp[1]:
        angulo_ref_direito = round(fwd_azimuth, 2)
        angulo_ref_esquerdo = round(back_azimuth, 2)
    else:
        angulo_ref_direito = round(back_azimuth, 2)
        angulo_ref_esquerdo = round(fwd_azimuth, 2)
    
    angulos_raw = [34.99, 0, 34.99]
    angulos_esquerdo = []
    
    for i in range(len(angulos_raw)):
        if i < 1:
            angulo = angulo_ref_esquerdo + angulos_raw[i]
            angulos_esquerdo.append(angulo)
        else:
            angulo = angulo_ref_esquerdo - angulos_raw[i]
            angulos_esquerdo.append(angulo)
    
    angulos_direito = []
    
    for i in range(len(angulos_raw)):
        if i < 1:
            angulo = angulo_ref_direito - angulos_raw[i]
            angulos_direito.append(angulo)
        else:
            angulo = angulo_ref_direito + angulos_raw[i]
            angulos_direito.append(angulo)
    param_angulos = angulo_ref_esquerdo, angulos_esquerdo, angulo_ref_direito, angulos_direito
    return param_angulos

##################################################

#Criação do dataset 
def gera_dataset(destino, lkp, param_angulos):
    posicao_geral = []
    lat_geral = []
    lon_geral = []
    
    if destino[1] < lkp[1]:
        ref_esquerdo = destino
    else:
        ref_esquerdo = lkp
   
    pos_esquerdo = ['p1', 'p3', 'p5']
    distancia_esquerdo = [22.61, 18.52, 22.61]
    
    for i in range(len(pos_esquerdo)):
        posicao = pos_esquerdo[i]
        origin = geopy.Point(ref_esquerdo[0], ref_esquerdo[1])    
        destination = geodesic(kilometers=distancia_esquerdo[i]).destination(origin, param_angulos[1][i])    
        lat, lon = destination.latitude, destination.longitude

        posicao_geral.append(posicao)
        lat_geral.append(lat)
        lon_geral.append(lon)

    if destino[1] > lkp[1]:
        ref_direito = destino
    else:
        ref_direito = lkp
    
    pos_direito = ['p2', 'p4', 'p6']
    distancia_direito = [22.61, 18.52, 22.61]
    
    
    for i in range(len(pos_direito)):
        posicao = pos_direito[i]    
        origin = geopy.Point(ref_direito[0], ref_direito[1])    
        destination = geodesic(kilometers=distancia_direito[i]).destination(origin, param_angulos[3][i])    
        lat, lon = destination.latitude, destination.longitude
        # lado_direito.append([posicao, lat, lon])
        posicao_geral.append(posicao)
        lat_geral.append(lat)
        lon_geral.append(lon)
    
    dataset = pd.DataFrame({'posicao': posicao_geral, 'lat': lat_geral, 'lon': lon_geral})
    dataset.loc[len(dataset)] = ['lkp', lkp[0], lkp[1]]
    dataset.loc[len(dataset)] = ['destino', destino[0], destino[1]]
    # dataset.loc[len(dataset)] = ['base', base[0], base[1]]
    
    return dataset

##############################################################################

#Criação do df e da matriz de distâncias 
def calculo_distancias_full(dataset):
    coluna_geral = []
    for coluna in range(len(dataset.iloc[:,0])):
        lista_coluna_coluna = []
        for linha in range(len(dataset.iloc[:,0])):
            geodesic = pyproj.Geod(ellps='WGS84')
            _, _, distance = geodesic.inv(dataset['lon'].iloc[coluna], dataset['lat'].iloc[coluna], dataset['lon'].iloc[linha], dataset['lat'].iloc[linha])
            lista_coluna_coluna.append(round(distance/1852, 2))
        coluna_geral.append(lista_coluna_coluna)

    lista_posicao = dataset.iloc[:,0]
    df_distancias = pd.DataFrame()
    
    for i in range(len(lista_posicao)):
        df_distancias[lista_posicao[i]] = coluna_geral[i]
    
    df_distancias.index = lista_posicao
    matriz_distancias = np.array(df_distancias)
    
    return df_distancias, matriz_distancias

##############################################################################     

#Criação do df e da matriz de distâncias (linhas e colunas numéricas) c/ 6 pontos
def calculo_distancias_6_pontos(dataset):
    coluna_geral = []
    for coluna in range(len(dataset.iloc[:,0])):
        lista_coluna_coluna = []
        for linha in range(len(dataset.iloc[:,0])):
            geodesic = pyproj.Geod(ellps='WGS84')
            _, _, distance = geodesic.inv(dataset['lon'].iloc[coluna], dataset['lat'].iloc[coluna], dataset['lon'].iloc[linha], dataset['lat'].iloc[linha])
            lista_coluna_coluna.append(round(distance/1852, 2))
        coluna_geral.append(lista_coluna_coluna)    
    lista_posicao = dataset.iloc[:,0]
    df_distancias = pd.DataFrame()
    
    for i in range(len(lista_posicao)):
        df_distancias[lista_posicao[i]] = coluna_geral[i]    
    df_distancias.index = lista_posicao
    df_distancias.drop(columns=['lkp', 'destino'], inplace=True)
    df_distancias = df_distancias.drop(labels=['lkp', 'destino'])
    ordem_nova= ['base', 'p1', 'p2', 'p3', 'p4', 'p5', 'p6']
    df_distancias = df_distancias[ordem_nova]
    df_distancias = df_distancias.reindex(ordem_nova)
    matriz_distancias = np.array(df_distancias)
    
    return df_distancias, df_distancias.values

##############################################################################

#Criação do df e da matriz de distâncias (linhas e colunas numéricas) c/ 12 pontos
def calculo_distancias_12_pontos(dataset):
    coluna_geral = []
    for coluna in range(len(dataset.iloc[:,0])):
        lista_coluna_coluna = []
        for linha in range(len(dataset.iloc[:,0])):
            geodesic = pyproj.Geod(ellps='WGS84')
            _, _, distance = geodesic.inv(dataset['lon'].iloc[coluna], dataset['lat'].iloc[coluna], dataset['lon'].iloc[linha], dataset['lat'].iloc[linha])
            lista_coluna_coluna.append(round(distance/1852, 2))
        coluna_geral.append(lista_coluna_coluna)    
    lista_posicao = dataset.iloc[:,0]
    df_distancias = pd.DataFrame()
    
    for i in range(len(lista_posicao)):
        df_distancias[lista_posicao[i]] = coluna_geral[i]    
    df_distancias.index = lista_posicao
    df_distancias.drop(columns=['lkp_sup', 'destino_sup', 'lkp_inf', 'destino_inf'], inplace=True)
    df_distancias = df_distancias.drop(labels=['lkp_sup', 'destino_sup', 'lkp_inf', 'destino_inf'])
    ordem_nova= ['base', 'p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 'p8', 'p9', 'p10', 'p11', 'p12']
    df_distancias = df_distancias[ordem_nova]
    df_distancias = df_distancias.reindex(ordem_nova)
    matriz_distancias = np.array(df_distancias)
    
    return df_distancias, df_distancias.values

##############################################################################     

#Cálculo das distâncias de reposicionamento
def calculo_reposicionamento(dataset, fator_antecipacao, fator_reposicionamento, fator_regresso):
    etapa_full = len(dataset)
    etapa_1 = len(dataset.index[dataset.no_de==0])
    etapa_3 = len(dataset.index[dataset.no_para==0])
    etapa_2 = etapa_full - etapa_1 - etapa_3

    #Etapa 1
    lista_repos = []
    
    for i in range(etapa_1):
        if dataset.distancia[1] < dataset.distancia[0]:
            if i % 2 == 0:
                lista_repos.append(fator_antecipacao + fator_reposicionamento)
            else:
                lista_repos.append(fator_antecipacao)
        elif dataset.distancia[1] == dataset.distancia[0]:
            lista_repos.append(fator_antecipacao + fator_reposicionamento)
        else:
            if i % 2 == 0:
                lista_repos.append(fator_antecipacao)
            else:
                lista_repos.append(fator_antecipacao + fator_reposicionamento)

    #Etapa 2
    for i in range(etapa_1, etapa_1+etapa_2):
        lista_repos.append(2 * fator_antecipacao)
    
    #Etapa 3
    for i in range(etapa_1+etapa_2, etapa_full):
        if dataset.distancia[etapa_1+etapa_2] < dataset.distancia[etapa_1+etapa_2+1]:
            if i % 2 == 0:
                lista_repos.append(0)
            else:
                lista_repos.append(fator_regresso)
        elif dataset.distancia[1] == dataset.distancia[0]:
            lista_repos.append(fator_regresso)
        else:
            if i % 2 == 0:
                lista_repos.append(fator_regresso)
            else:
                lista_repos.append(0)

    return lista_repos

##############################################################################     

#Cálculo das distâncias finais das rotas
def calculo_distancia_rotas(dataset):
    
    df_rotas = pd.DataFrame({'rotas': [[0, 1, 2, 4, 3, 5, 6, 0],
                                    [0, 1, 2, 6, 5, 3, 4, 0],
                                    [0, 3, 4, 2, 1, 5, 6, 0],
                                    [0, 3, 4, 6, 5, 1, 2, 0],
                                    [0, 5, 6, 4, 3, 1, 2, 0],
                                    [0, 5, 6, 2, 1, 3, 4, 0],
                                    [0, 2, 1, 3, 4, 6, 5, 0],
                                    [0, 2, 1, 5, 6, 4, 3, 0],
                                    [0, 4, 3, 1, 2, 6, 5, 0],
                                    [0, 4, 3, 5, 6, 2, 1, 0],
                                    [0, 6, 5, 3, 4, 2, 1, 0],
                                    [0, 6, 5, 1, 2, 4, 3, 0]],
                          'indices': [[0, 6, 13, 22],
                                                    [0, 7, 17, 20], 
                                                    [2, 10, 9, 22], 
                                                    [2, 11, 16, 18], 
                                                    [4, 15, 12, 18], 
                                                    [4, 14, 8, 20],
                                                    [1, 8, 11, 23],
                                                    [1, 9, 15, 21],
                                                    [3, 12, 7, 23], 
                                                    [3, 13, 14, 19], 
                                                    [5, 17, 10, 19], 
                                                    [5, 16, 6, 21]]})
        
    lista_simples = []
    lista_repos = []
    lista_total = []
    
    for indices in df_rotas.indices:
        soma_simples = 0
        soma_repos = 0
        soma_total = 0
        for indice in indices:      
            soma_simples += dataset.distancia[indice]
            soma_repos += dataset.dist_reposicionamento[indice]
            soma_total += dataset.dist_total[indice]
        lista_simples.append(round(soma_simples))
        lista_repos.append(round(soma_repos))
        lista_total.append(round(soma_total))
    
    df_rotas['simples'] = lista_simples
    df_rotas['repos'] = lista_repos
    df_rotas['total'] = lista_total
    
    df_rotas.drop(columns='indices', inplace=True)
    
    return df_rotas

##############################################################################

#Cálculo das distâncias finais das rotas - 12 pontos
def calculo_distancia_rotas_12_pontos(dataset):
    
    df_rotas = pd.DataFrame({'rotas': [[0, 1, 2, 4, 3, 5, 6, 0],
[0, 1, 2, 4, 3,11, 12, 0],
[0, 1, 2, 6, 5, 3, 4, 0],
[0, 1, 2, 6, 5, 9, 10, 0],
[0, 1, 2, 10, 9, 5, 6, 0],
[0, 1, 2, 10, 9, 11, 12, 0],
[0, 1, 2, 12, 11, 3, 4, 0],
[0, 1, 2, 12, 11, 9, 10, 0],
[0, 2, 1, 3, 4, 6, 5, 0],
[0, 2, 1, 3, 4, 12, 11, 0],
[0, 2, 1, 5, 6, 4, 3, 0],
[0, 2, 1, 5, 6, 10, 9, 0],
[0, 2, 1, 9, 10, 6, 5, 0],
[0, 2, 1, 9, 10, 12, 11, 0],
[0, 2, 1,11, 12, 4, 3, 0],
[0, 2, 1,11, 12, 10, 9, 0],
[0, 3, 4, 2, 1, 5, 6, 0],
[0, 3, 4, 2, 1, 11, 12, 0],
[0, 3, 4, 6, 5, 1, 2, 0],
[0, 3, 4, 6, 5, 7, 8, 0],
[0, 3, 4, 8, 7, 5, 6, 0],
[0, 3, 4, 8, 7, 11, 12, 0],
[0, 3, 4, 12, 11, 1, 2, 0],
[0, 3, 4, 12, 11, 7, 8, 0],
[0, 4, 3, 1, 2, 6, 5, 0],
[0, 4, 3, 1, 2, 12, 11, 0],
[0, 4, 3, 5, 6, 2, 1, 0],
[0, 4, 3, 5, 6, 8, 7, 0],
[0, 4, 3, 7, 8, 4, 3, 0],
[0, 4, 3, 7, 8, 12, 11, 0],
[0, 4, 3, 11, 12, 2, 1, 0],
[0, 4, 3, 11, 12, 8, 7, 0],
[0, 5, 6, 2, 1, 3, 4, 0],
[0, 5, 6, 2, 1, 9, 10, 0],
[0, 5, 6, 4, 3, 1, 2, 0],
[0, 5, 6, 4, 3, 7, 8, 0],
[0, 5, 6, 8, 7, 3, 4, 0],
[0, 5, 6, 8, 7, 9, 10, 0],
[0, 5, 6, 10, 9, 1, 2, 0],
[0, 5, 6, 10, 9, 7, 8, 0],
[0, 6, 5, 1, 2, 4, 3, 0],
[0, 6, 5, 1, 2, 10, 9, 0],
[0, 6, 5, 3, 4, 2, 1, 0],
[0, 6, 5, 3, 4, 8, 7, 0],
[0, 6, 5, 7, 8, 4, 3, 0],
[0, 6, 5, 7, 8, 10, 9, 0],
[0, 6, 5, 9, 10, 2, 1, 0],
[0, 6, 5, 9, 10, 8, 7, 0],
[0, 7, 8, 4, 3, 5, 6, 0],
[0, 7, 8, 4, 3, 11, 12, 0],
[0, 7, 8, 6, 5, 3, 4, 0],
[0, 7, 8, 6, 5, 9, 10, 0],
[0, 7, 8, 10, 9, 5, 6, 0],
[0, 7, 8, 10, 9, 11, 12, 0],
[0, 7, 8, 12, 11, 3, 4, 0],
[0, 7, 8, 12, 11, 9, 10, 0],
[0, 8, 7, 3, 4, 6, 5, 0],
[0, 8, 7, 3, 4, 12, 11, 0],
[0, 8, 7, 5, 6, 4, 3, 0],
[0, 8, 7, 5, 6, 10, 9, 0],
[0, 8, 7, 9, 10, 6, 5, 0],
[0, 8, 7, 9, 10, 12, 11, 0],
[0, 8, 7, 12, 11, 4, 3, 0],
[0, 8, 7, 12, 11, 10, 9, 0],
[0, 9, 10, 2, 1, 5, 6, 0],
[0, 9, 10, 2, 1, 11, 12, 0],
[0, 9, 10, 6, 5, 1, 2, 0],
[0, 9, 10, 6, 5, 7, 8, 0],
[0, 9, 10, 8, 7, 5, 6, 0],
[0, 9, 10, 8, 7, 11, 12, 0],
[0, 9, 10, 12, 11, 1, 2, 0],
[0, 9, 10, 12, 11, 7, 8, 0],
[0, 10, 9, 1, 2, 6, 5, 0],
[0, 10, 9, 1, 2, 12, 1, 0],
[0, 10, 9, 5, 6, 2, 1, 0],
[0, 10, 9, 5, 6, 8, 7, 0],
[0, 10, 9, 7, 8, 6, 5, 0],
[0, 10, 9, 7, 8, 12, 11, 0],
[0, 10, 9, 11, 12, 2, 1, 0],
[0, 10, 9, 11, 12, 8, 7, 0],
[0, 11, 12, 2, 1, 3, 4, 0],
[0, 11, 12, 2, 1, 9, 10, 0],
[0, 11, 12, 4, 3, 1, 2, 0],
[0, 11, 12, 4, 3, 7, 8, 0],
[0, 11, 12, 8, 7, 3, 4, 0],
[0, 11, 12, 8, 7, 9, 10, 0],
[0, 11, 12, 10, 9, 1, 2, 0],
[0, 11, 12, 10, 9, 7, 8, 0],
[0, 12, 11, 1, 2, 4, 3, 0],
[0, 12, 11, 1, 2, 10, 9, 0],
[0, 12, 11, 3, 4, 2, 1, 0],
[0, 12, 11, 3, 4, 8, 7, 0],
[0, 12, 11, 7, 8, 4, 3, 0],
[0, 12, 11, 7, 8, 10, 9, 0],
[0, 12, 11, 9, 10, 2, 1, 0],
[0, 12, 11, 9, 10, 8, 7, 0]],
                          'indices': [[0, 12, 28, 76],
[0, 12, 31, 82],
[0, 13, 38, 74],
[0, 13, 40, 80],
[0, 15, 59, 76],
[0, 15, 61, 82],
[0, 16, 68, 74],
[0, 16, 71, 80],
[1, 17, 23, 77],
[1, 17, 26, 83],
[1, 18, 33, 75],
[1, 18, 35, 81],
[1, 20, 54, 77],
[1, 20, 56, 83],
[1, 21, 63, 75],
[1, 21, 66, 81],
[2, 22, 18, 76],
[2, 22, 21, 82],
[2, 23, 37, 72],
[2, 23, 39, 78],
[2, 24, 49, 76],
[2, 24, 51, 82],
[2, 26, 67, 72],
[2, 26, 70, 78],
[3, 27, 13, 77],
[3, 27, 16, 83],
[3, 28, 32, 73],
[3, 28, 34, 79],
[3, 29, 44, 77],
[3, 29, 46, 83],
[3, 31, 62, 73],
[3, 31, 65, 79],
[4, 32, 17, 74],
[4, 32, 20, 80],
[4, 33, 27, 72],
[4, 33, 29, 78],
[4, 34, 48, 74],
[4, 34, 50, 80],
[4, 35, 57, 72],
[4, 35, 60, 78],
[5, 37, 12, 75],
[5, 37, 15, 81],
[5, 38, 22, 73],
[5, 38, 24, 79],
[5, 39, 43, 75],
[5, 39, 45, 81],
[5, 40, 52, 73],
[5, 40, 55, 79],
[6, 43, 28, 76],
[6, 43, 31, 82],
[6, 44, 38, 74],
[6, 44, 40, 80],
[6, 45, 59, 76],
[6, 45, 61, 82],
[6, 46, 68, 74],
[6, 46, 71, 80],
[7, 48, 23, 77],
[7, 48, 26, 83],
[7, 49, 33, 75],
[7, 49, 35, 81],
[7, 50, 54, 77],
[7, 50, 56, 83],
[7, 51, 63, 75],
[7, 51, 66, 81],
[8, 52, 18, 76],
[8, 52, 21, 82],
[8, 54, 37, 72],
[8, 54, 39, 78],
[8, 55, 49, 76],
[8, 55, 51, 82],
[8, 56, 67, 72],
[8, 56, 70, 78],
[9, 57, 13, 77],
[9, 57, 16, 83],
[9, 59, 32, 73],
[9, 59, 34, 79],
[9, 60, 44, 77],
[9, 60, 46, 83],
[9, 61, 62, 73],
[9, 61, 65, 79],
[10, 62, 17, 74],
[10, 62, 20, 80],
[10, 63, 27, 72],
[10, 63, 29, 78],
[10, 65, 48, 74],
[10, 65, 50, 80],
[10, 66, 57, 72],
[10, 66, 60, 78],
[11, 67, 12, 75],
[11, 67, 15, 81],
[11, 68, 22, 73],
[11, 68, 24, 79],
[11, 70, 43, 75],
[11, 70, 45, 81],
[11, 71, 52, 73],
[11, 71, 55, 79]]})
    
    lista_simples = []
    lista_repos = []
    lista_total = []
    
    for indices in df_rotas.indices:
        soma_simples = 0
        soma_repos = 0
        soma_total = 0
        for indice in indices:      
            soma_simples += dataset.distancia[indice]
            soma_repos += dataset.dist_reposicionamento[indice]
            soma_total += dataset.dist_total[indice]
        lista_simples.append(round(soma_simples))
        lista_repos.append(round(soma_repos))
        lista_total.append(round(soma_total))
    
    df_rotas['simples'] = lista_simples
    df_rotas['repos'] = lista_repos
    df_rotas['total'] = lista_total
    
    df_rotas.drop(columns='indices', inplace=True)
    
    return df_rotas

##############################################################################

#Calcula ponto central da APG (ponto entre destino e lkp)
def centro(lat1, lon1, lat2, lon2):
    ponto_centro = []
    g = Geod(ellps='WGS84')
    angulo, _, distancia = g.inv(lon1, lat1, lon2, lat2)
    lon, lat, _ = g.fwd(lon1, lat1, angulo, distancia/2)
    ponto_centro.append(round(lat, 5))
    ponto_centro.append(round(lon, 5))
    
    return ponto_centro

##############################################################################

#Calcula lkp e destino SUP e INF
def pontos_rebatidos(destino, lkp):
    
    distancia = 20 * 1852 #dist, em km, igual a 20 nm
    
    g = Geod(ellps='WGS84')
    fwd_azimuth, back_azimuth, _ = g.inv(destino[1], destino[0], lkp[1], lkp[0])
# print(fwd_azimuth, back_azimuth)

    if destino[1] < lkp[1]:
        # print('true')
        angulo_ref_direito = round(fwd_azimuth)
        angulo_ref_esquerdo = round(back_azimuth)
        
        lon, lat, _ = g.fwd(lkp[1], lkp[0], angulo_ref_direito-90, distancia)
        lkp_sup = [round(lat, 5), round(lon, 5)]
        lon, lat, _ = g.fwd(lkp[1], lkp[0], angulo_ref_direito+90, distancia)
        lkp_inf = [round(lat, 5), round(lon, 5)]
        
        lon, lat, _ = g.fwd(destino[1], destino[0], angulo_ref_esquerdo+90, distancia)
        destino_sup = [round(lat, 5), round(lon, 5)]
        lon, lat, _ = g.fwd(destino[1], destino[0], angulo_ref_esquerdo-90, distancia)
        destino_inf = [round(lat, 5), round(lon, 5)]
        
    else:
        # print('false')
        angulo_ref_direito = round(back_azimuth)
        angulo_ref_esquerdo = round(fwd_azimuth)
        
        lon, lat, _ = g.fwd(lkp[1], lkp[0], angulo_ref_direito-90, distancia)
        lkp_sup = [round(lat, 5), round(lon, 5)]
        lon, lat, _ = g.fwd(lkp[1], lkp[0], angulo_ref_direito+90, distancia)
        lkp_inf = [round(lat, 5), round(lon, 5)]
        
        lon, lat, _ = g.fwd(destino[1], destino[0], angulo_ref_esquerdo+90, distancia)
        destino_sup = [round(lat, 5), round(lon, 5)]
        lon, lat, _ = g.fwd(destino[1], destino[0], angulo_ref_esquerdo-90, distancia)
        destino_inf = [round(lat, 5), round(lon, 5)]
            
        # lon, lat, _ = g.fwd(lkp[1], lkp[0], angulo_ref_direito+90, distancia)
        # lkp_sup = [round(lat, 5), round(lon, 5)]
        # lon, lat, _ = g.fwd(destino[1], destino[0], angulo_ref_esquerdo-90, distancia)
        # destino_sup = [round(lat, 5), round(lon, 5)]
        
    # dataset = pd.DataFrame({'posicao': ['lkp_sup', 'lkp_inf', 'destino_sup', 'destino_inf'],
    #                         'lat': [lkp_sup[0], lkp_inf[0], destino_sup[0], destino_inf[0]],
    #                         'lon': [lkp_sup[1], lkp_inf[1], destino_sup[1], destino_inf[1]]})
        
    return lkp_sup, lkp_inf, destino_sup, destino_inf

##############################################################################

#Junta 3 datasets
def junta_3_dataset(df_sup, df, df_inf):
    df.set_index('posicao', inplace=True)
    df.rename(index={'p1': "apg_1", 'p3': "apg_3", 'p5': "apg_5", 'p2': "apg_2", 'p4': "apg_4", 'p6': "apg_6", 'lkp': "lkp_apg", 'destino': "destino_apg"}, inplace=True)
    df.reset_index(inplace=True)
    
    df_sup.set_index('posicao', inplace=True)
    df_sup.rename(index={'lkp': "lkp_sup", 'destino': "destino_sup"}, inplace=True)
    df_sup.reset_index(inplace=True)
    
    df_inf.set_index('posicao', inplace=True)
    df_inf.rename(index={'p1': "p7", 'p3': "p9", 'p5': "p11", 'p2': "p8", 'p4': "p10", 'p6': "p12", 'lkp': "lkp_inf", 'destino': "destino_inf"}, inplace=True)
    df_inf.reset_index(inplace=True)
    
    dataset = pd.concat([df_sup, df, df_inf], ignore_index=True)
    return dataset

##############################################################################

#Junta 2 datasets
def junta_2_dataset(df_sup, df_inf):
    df_sup.set_index('posicao', inplace=True)
    df_sup.rename(index={'lkp': "lkp_sup", 'destino': "destino_sup"}, inplace=True)
    df_sup.reset_index(inplace=True)
    
    df_inf.set_index('posicao', inplace=True)
    df_inf.rename(index={'p1': "p7", 'p3': "p9", 'p5': "p11", 'p2': "p8", 'p4': "p10", 'p6': "p12", 'lkp': "lkp_inf", 'destino': "destino_inf"}, inplace=True)
    df_inf.reset_index(inplace=True)
    
    dataset = pd.concat([df_sup, df_inf], ignore_index=True)
    return dataset

##############################################################################

# Cria datasets c/ bases em relação ao centro
def gera_df_teste(lat_0, lon_0, intervalo_angulos, intervalo_distancias, intervalo_apg):
    g = Geod(ellps='WGS84')
    lista_nomes = []
    lista_lat_pontos = []
    lista_lon_pontos = []
    
    for ang in intervalo_angulos:
        for dist in intervalo_distancias:
            if ang > 180:
                ang = ang - 360
            lon, lat, _ = g.fwd(lon_0, lat_0, ang, dist*1852)
            lista_nomes.append(f'p_{ang}_{dist}')
            lista_lat_pontos.append(lat)
            lista_lon_pontos.append(lon)

    dados_pontos = pd.DataFrame({'base': lista_nomes,
                             'lat_base': lista_lat_pontos,
                            'lon_base': lista_lon_pontos})
    
    for dist_apg in intervalo_apg:
        lista_lkp = []
        lista_destino = []
        lista_lat_lkp = []
        lista_lon_lkp = []
        lista_lat_destino = []
        lista_lon_destino = []
        for i in range(len(dados_pontos)):
            g = Geod(ellps='WGS84')
            lon, lat, _ = g.fwd(lon_0, lat_0, 90, dist_apg*1852/2)
            lista_lkp.append(f'lkp_{dist_apg}')
            lista_lat_lkp.append(lat)
            lista_lon_lkp.append(lon)
            lon, lat, _ = g.fwd(lon_0, lat_0, -90, dist_apg*1852/2)
            lista_destino.append(f'destino_{dist_apg}')
            lista_lat_destino.append(lat)
            lista_lon_destino.append(lon)
        dados_pontos[f'lkp_{dist_apg}'] = lista_lkp
        dados_pontos[f'lat_lkp_{dist_apg}'] = lista_lat_lkp
        dados_pontos[f'lon_lkp_{dist_apg}'] = lista_lon_lkp
        dados_pontos[f'destino_{dist_apg}'] = lista_destino
        dados_pontos[f'lat_destino_{dist_apg}'] = lista_lat_destino
        dados_pontos[f'lon_destino_{dist_apg}'] = lista_lon_destino  
        
    return dados_pontos

##############################################################################
# %%
