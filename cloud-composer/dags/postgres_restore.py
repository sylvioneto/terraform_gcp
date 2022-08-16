# Based on https://github.com/apache/airflow/blob/main/airflow/providers/google/cloud/example_dags/example_postgres_to_gcs.py

"""
This DAG restores the sql backup used by the other dags.
"""
import os
from datetime import datetime
from airflow import models
from airflow.providers.google.cloud.operators.cloud_sql import CloudSQLImportInstanceOperator


GCS_SQL_BACKUP_BUCKET=os.environ.get("GCS_SQL_BACKUP_BUCKET")
FILE_NAME="gs://{}/postgres_dvdrental.sql".format(GCS_SQL_BACKUP_BUCKET)
INSTANCE_NAME=os.environ.get("DVDRENTAL_INSTANCE_NAME")


with models.DAG(
    dag_id='postgres_restore',
    start_date=datetime(2022, 1, 1),
    schedule_interval="@once",
    catchup=False,
    tags=['example'],
) as dag:

    import_body = {"importContext": {"fileType": "sql", "uri": FILE_NAME, "database":"dvdrental"}}

    sql_import_task = CloudSQLImportInstanceOperator(
        body=import_body, 
        instance=INSTANCE_NAME,
        task_id='sql_import_task'
    )
