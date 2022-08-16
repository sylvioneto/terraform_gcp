"""
Example Airflow DAG for Google BigQuery service testing dataset operations.
"""
import os
from datetime import datetime
from airflow import models
from airflow.providers.google.cloud.operators.bigquery import BigQueryCreateEmptyDatasetOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator


DATASET_NAME = f"dvdrental"
PROJECT_ID = os.environ.get("GCP_PROJECT")
GCS_DATA_LAKE_BUCKET = os.environ.get("GCS_DATA_LAKE_BUCKET")
FILE_PREFIX="dvdrental/{{ ds }}/"


with models.DAG(
    dag_id='gcs_to_bigquery',
    schedule_interval="@once",
    start_date=datetime(2021, 1, 1),
    catchup=False,
    tags=["example", "bigquery"],
) as dag:

    create_dataset = BigQueryCreateEmptyDatasetOperator(
        task_id="create_dataset",
        dataset_id=DATASET_NAME,
        project_id=PROJECT_ID
    )

    load_customer_data = GCSToBigQueryOperator(
        task_id='load_customer_data',
        bucket=GCS_DATA_LAKE_BUCKET,
        source_objects=[FILE_PREFIX+"customer.json"],
        source_format="NEWLINE_DELIMITED_JSON",
        destination_project_dataset_table="{}.{}".format(DATASET_NAME, "customer"),
        autodetect=True,
        write_disposition='WRITE_TRUNCATE',
    )

    load_rental_data = GCSToBigQueryOperator(
        task_id='load_rental_data',
        bucket=GCS_DATA_LAKE_BUCKET,
        source_objects=[FILE_PREFIX+"rental.json"],
        source_format="NEWLINE_DELIMITED_JSON",
        destination_project_dataset_table="{}.{}".format(DATASET_NAME, "rental"),
        autodetect=True,
        write_disposition='WRITE_TRUNCATE',
    )

create_dataset >> load_customer_data
create_dataset >> load_rental_data
