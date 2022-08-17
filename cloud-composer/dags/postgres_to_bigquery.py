"""
Example Airflow DAG for Google BigQuery service testing dataset operations.
"""
import os
from datetime import datetime
from airflow import models
from airflow.providers.google.cloud.transfers.postgres_to_gcs import PostgresToGCSOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator

CONN_ID="DVDRENTAL_DB"
DATASET_NAME = f"dvdrental"
PROJECT_ID = os.environ.get("GCP_PROJECT")
GCS_DATA_LAKE_BUCKET = os.environ.get("GCS_DATA_LAKE_BUCKET")
FILE_NAME="dvdrental/{{ ds }}/customer.csv"


with models.DAG(
    dag_id='postgres_to_bigquery',
    schedule_interval="@once",
    start_date=datetime(2021, 1, 1),
    catchup=False,
    tags=["example", "bigquery"],
) as dag:

    extract_data = PostgresToGCSOperator(
        postgres_conn_id=CONN_ID,
        task_id="get_customer_from_postgres",
        sql="select customer_id, email, store_id from customer;",
        bucket=GCS_DATA_LAKE_BUCKET,
        filename=FILE_NAME,
        export_format='csv',
        gzip=False,
        use_server_side_cursor=True,
    )

    load_csv = GCSToBigQueryOperator(
        task_id='load_customer_to_bq',
        bucket=GCS_DATA_LAKE_BUCKET,
        source_objects=[FILE_NAME],
        skip_leading_rows=1,
        destination_project_dataset_table="{}.{}".format(DATASET_NAME, "customer"),
        schema_fields=[
            {'name': 'customer_id', 'type': 'INTEGER', 'mode': 'NULLABLE'},
            {'name': 'customer_email', 'type': 'STRING', 'mode': 'NULLABLE'},
            {'name': 'store_id', 'type': 'INTEGER', 'mode': 'NULLABLE'},
        ],
        write_disposition='WRITE_TRUNCATE',
    )

extract_data >> load_csv
