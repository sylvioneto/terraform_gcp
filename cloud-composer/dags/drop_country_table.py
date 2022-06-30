import os
from datetime import datetime

from airflow import DAG
from airflow.providers.microsoft.mssql.operators.mssql import MsSqlOperator

ENV_ID = os.environ.get("SYSTEM_TESTS_ENV_ID")
DAG_ID = "mssql_drop_table"


with DAG(
    DAG_ID,
    schedule_interval='@daily',
    start_date=datetime(2021, 10, 1),
    tags=['example'],
    catchup=False,
) as dag:

    # Example of creating a task to create a table in MsSql

    drop_table_mssql_task = MsSqlOperator(
        task_id='drop_table_mssql_task',
        mssql_conn_id='airflow_mssql',
        sql=r"""
        DROP TABLE Country;
        """,
        dag=dag,
    )
