# Based on https://github.com/apache/airflow/blob/main/airflow/providers/google/cloud/example_dags/example_postgres_to_gcs.py

"""
Example DAG using PostgresToGoogleCloudStorageOperator.
This dag exports some tables from a Postgres instance to Google Cloud Storage
"""
import os
from datetime import datetime

from airflow import models
from airflow.providers.google.cloud.transfers.postgres_to_gcs import PostgresToGCSOperator

#GCS_BUCKET = os.environ.get("GCP_GCS_BUCKET_NAME", "INVALID BUCKET NAME")
GCS_BUCKET="syl-data-analytics-sql-backup"
SQL_QUERY = "select * from {};"
CONN_ID="postgres_dvdrental"
FILE_NAME="{{ ds }}/{0}.json"

with models.DAG(
    dag_id='example_postgres_to_gcs',
    start_date=datetime(2021, 1, 1),
    catchup=False,
    tags=['example'],
) as dag:

    upload_customer_table = PostgresToGCSOperator(
        postgres_conn_id=CONN_ID,
        task_id="get_customer_data",
        sql=SQL_QUERY.format("customer"),
        bucket=GCS_BUCKET,
        filename=FILE_NAME.format("customer"),
        gzip=False,
        use_server_side_cursor=True,
    )

    upload_rental_table = PostgresToGCSOperator(
        postgres_conn_id=CONN_ID,
        task_id="get_rental_data",
        sql=SQL_QUERY.format("rental"),
        bucket=GCS_BUCKET,
        filename=FILE_NAME.format("rental"),
        gzip=False,
        use_server_side_cursor=True,
    )

