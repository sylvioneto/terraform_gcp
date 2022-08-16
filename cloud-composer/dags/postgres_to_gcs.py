# Based on https://github.com/apache/airflow/blob/main/airflow/providers/google/cloud/example_dags/example_postgres_to_gcs.py

"""
Example DAG using PostgresToGoogleCloudStorageOperator.
This dag exports tables from a Postgres instance to Google Cloud Storage

Requirement: create a postgres_dvdrental connection on Airflow.
It must to connect to the Postgres database created by terraform.
"""
import os
from datetime import datetime

from airflow import models
from airflow.providers.google.cloud.transfers.postgres_to_gcs import PostgresToGCSOperator


PROJECT_ID = os.environ.get("GCP_PROJECT")
GCS_BUCKET="{}-data-lake".format(PROJECT_ID)
SQL_QUERY = "select * from {};"
CONN_ID="postgres_dvdrental"
FILE_NAME="dvdrental/{{ ds }}/"


with models.DAG(
    dag_id='postgres_to_gcs',
    start_date=datetime(2021, 1, 1),
    schedule_interval="0 1 * * *",
    catchup=False,
    tags=['example'],
) as dag:

    upload_customer_table = PostgresToGCSOperator(
        postgres_conn_id=CONN_ID,
        task_id="get_customer_data",
        sql=SQL_QUERY.format("customer"),
        bucket=GCS_BUCKET,
        filename=FILE_NAME+"customer.json",
        gzip=False,
        use_server_side_cursor=True,
    )

    upload_rental_table = PostgresToGCSOperator(
        postgres_conn_id=CONN_ID,
        task_id="get_rental_data",
        sql=SQL_QUERY.format("rental"),
        bucket=GCS_BUCKET,
        filename=FILE_NAME+"rental.json",
        gzip=False,
        use_server_side_cursor=True,
    )

