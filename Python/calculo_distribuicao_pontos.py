# -*- coding: utf-8 -*-
"""
Created on Mon Jul 11 10:32:20 2022

@author: falca
"""
#%%
import pandas as pd
from pyproj import Geod
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap

#%%
intervalo_distancias = [i for i in range(50,351,50)]
intervalo_angulos = [i for i in range(0,316,45)]

g = Geod(ellps='WGS84')

lista_nomes = []
lista_lat_pontos = []
lista_lon_pontos = []

lat_0 = 0
lon_0 = 0

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

#%%
intervalo_apg = [40, 66, 150]

lat_0 = 0
lon_0 = 0

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


#%%
plt.plot(dados_pontos.lon_base, dados_pontos.lat_base, 'o')

#%%
lat1, lat2 = dados_pontos['lat_base'].max(), dados_pontos['lat_base'].min()
lon1, lon2 = dados_pontos['lon_base'].max(), dados_pontos['lon_base'].min()

plt.figure(figsize=(15,15))
m = Basemap(projection='cyl', resolution='h',
            llcrnrlat = lat1, urcrnrlat=lat2,
            llcrnrlon = lon1, urcrnrlon = lon2)

m.drawcoastlines()
m.drawmapboundary(fill_color='lightskyblue')
m.fillcontinents(color='palegoldenrod', lake_color='lightskyblue')
m.scatter(dados_pontos['lon_base'], dados_pontos['lat_base'], s=10, c='blue', alpha=1, zorder=2)

#%%
df_sar_dist = pd.read_excel('DF_SAR_NOVO.xlsx', usecols='S')

print(df_sar_dist.describe())

plt.hist(df_sar_dist)

#%%



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

#%%
intervalo_distancias = [i for i in range(50,351,50)]
intervalo_angulos = [i for i in range(0,316,45)]
intervalo_apg = [40, 66, 150]
lat_0 = 0
lon_0 = 0

dados_2 = gera_df_teste(lat_0, lon_0, intervalo_angulos, intervalo_distancias, intervalo_apg)

#%%
g = Geod(ellps='WGS84')
fwd, bck, _ = g.inv(1, 1, 3, 1)
print(fwd, bck)