# This dag demonstrates how to take the data from a SQL SERVER instance to BigQuery
# In order to run it, please prepare your database first:
# 1) setup the connection airflow_mssql in your Cloud Composer
# 2) load AdventureWorks2019 sample data to your database

import os
from datetime import datetime

from airflow import models
from airflow.providers.google.cloud.transfers.mssql_to_gcs import MSSQLToGCSOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator


BUCKET='mssql-data'
FILENAME='data/mssql/customer.csv'

with models.DAG(
    'mssql_to_bq',
    schedule_interval='@once',
    start_date=datetime(2021, 12, 1),
    catchup=False,
    tags=['example'],
) as dag:
    t1 = MSSQLToGCSOperator(
        task_id='mssql_to_gcs',
        mssql_conn_id='airflow_mssql',
        sql=r"""SELECT CustomerID, StoreID, AccountNumber, ModifiedDate FROM Sales.Customer;""",
        bucket=BUCKET,
        filename=FILENAME,
        export_format='csv',
    )

    t2 = GCSToBigQueryOperator(
        task_id='gcs_to_bigquery',
        bucket=BUCKET,
        source_objects=[FILENAME],
        destination_project_dataset_table=f"adventureworks.customer",
        schema_fields=[
            {'name': 'CustomerID', 'type': 'INTEGER', 'mode': 'NULLABLE'},
            {'name': 'StoreID', 'type': 'INTEGER', 'mode': 'NULLABLE'},
            {'name': 'AccountNumber', 'type': 'STRING', 'mode': 'NULLABLE'},
            {'name': 'ModifiedDate', 'type': 'DATETIME', 'mode': 'NULLABLE'},
        ],
        skip_leading_rows=1,
        write_disposition='WRITE_TRUNCATE',
    )

    t1 >> t2
