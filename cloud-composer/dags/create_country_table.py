import os
from datetime import datetime

from airflow import DAG
from airflow.providers.microsoft.mssql.hooks.mssql import MsSqlHook
from airflow.providers.microsoft.mssql.operators.mssql import MsSqlOperator

ENV_ID = os.environ.get("SYSTEM_TESTS_ENV_ID")
DAG_ID = "mssql_create_table"


with DAG(
    DAG_ID,
    schedule_interval='@daily',
    start_date=datetime(2021, 10, 1),
    tags=['example'],
    catchup=False,
) as dag:

    # Example of creating a task to create a table in MsSql

    create_table_mssql_task = MsSqlOperator(
        task_id='create_country_table',
        mssql_conn_id='airflow_mssql',
        sql=r"""
        CREATE TABLE Country (
            country_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
            name TEXT,
            continent TEXT
        );
        """,
        dag=dag,
    )

    populate_country_table = MsSqlOperator(
        task_id='populate_country_table',
        mssql_conn_id='airflow_mssql',
        sql=r"""
                INSERT INTO Country (name, continent)
                VALUES ('Brazil', 'America');
                INSERT INTO Country (name, continent)
                VALUES ('Chile', 'America');
                INSERT INTO Country (name, continent)
                VALUES ('India', 'Asia');
                """,
    )

    get_all_countries = MsSqlOperator(
        task_id="get_all_countries",
        mssql_conn_id='airflow_mssql',
        sql=r"""SELECT * FROM Country;""",
    )

    get_countries_from_continent = MsSqlOperator(
        task_id="get_countries_from_continent",
        mssql_conn_id='airflow_mssql',
        sql=r"""SELECT * FROM Country where {{ params.column }}='{{ params.value }}';""",
        params={"column": "CONVERT(VARCHAR, continent)", "value": "Asia"},
    )

    drop_table_mssql_task = MsSqlOperator(
        task_id='drop_table_mssql_task',
        mssql_conn_id='airflow_mssql',
        sql=r"""
        DROP TABLE Country;
        """,
        dag=dag,
    )


    create_table_mssql_task >> populate_country_table
    
    populate_country_table >> get_all_countries >> drop_table_mssql_task
    populate_country_table >> get_countries_from_continent >> drop_table_mssql_task

