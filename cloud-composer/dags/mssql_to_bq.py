# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
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
        sql=r"""SELECT CustomerID, StoreID, AccountNumber, ModifiedDate FROM Customer;""",
        bucket=BUCKET,
        filename=FILENAME,
        export_format='csv',
    )

    t2 = GCSToBigQueryOperator(
        task_id='gcs_to_bigquery',
        bucket=BUCKET,
        source_objects=[FILENAME],
        destination_project_dataset_table=f"raw.country",
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
