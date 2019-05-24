import json
import pandas as pd
import MySQLdb
from sqlalchemy import create_engine

engine = create_engine("mysql://root:qazwsxedc@localhost/tp1")
connection = engine.connect()

def load_json_data(file_name):
    #chargement  des données de fichier JSON
    with open(file_name, 'r') as file_json:
        data_json = json.load(file_json)
    d_json = pd.DataFrame.from_dict(data_json)
    d_json = d_json[['id', 'first_name', 'last_name', 'email', 'gender', 'ville']]
    file_json.close()
    return d_json

def load_sql_data(file_name):
    #chargement des données de fichier SQL
    file_sql = open(file_name)
    cmds = file_sql.read().split(';')
    i = 0
    while i < len(cmds) - 1:
        connection.execute(cmds[i])
        i += 1
    formattedGenderQuery = '''SELECT id, first_name, last_name, email,
                                     CASE WHEN gender = 'F' THEN 'Female'
                                          WHEN gender = 'M' THEN 'Male'
                                     END AS gender, ville
                              FROM client_DATA'''
    data_sql = pd.read_sql(formattedGenderQuery, connection)
    file_sql.close()
    return data_sql

df_csv = pd.read_csv('week_cust.csv')
df_json = load_json_data('cust_data.json')
df_sql = load_sql_data('client_DATA.sql')

df_all = pd.concat([df_json, df_csv, df_sql], ignore_index = True)
df_all.to_sql(name = 'all_DATA', con = connection, if_exists = 'fail', index = False)

print('csv: ', len(df_csv.index))
print('sql: ', len(df_sql.index))
print('json: ', len(df_json.index))
print('toutes les donnees: ', len(df_all.index))

connection.close()
