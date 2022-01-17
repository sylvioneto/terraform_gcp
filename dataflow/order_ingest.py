#!/usr/bin/env python

"""
Copyright Google Inc. 2016
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""

import apache_beam as beam
from apache_beam.io.gcp.internal.clients import bigquery


PROJECT = 'syl-dataflow-demo'
TABLE_SPEC = 'ecommerce.order'
TABLE_SCHEMA = 'order_id:STRING, status:STRING, amount:NUMERIC, customer_name:STRING, customer_phone:STRING, customer_email:STRING'


def validate_order(line):
    order_data = line.split(",")

    # order_id must not be null
    if order_data[0]:
        yield line


def csv_to_bqrow(line):
    order_data = line.split(",")
    d = {"order_id": order_data[0],
         "status": order_data[1],
         "amount": order_data[2],
         "customer_name": order_data[3],
         "customer_phone": order_data[4],
         "customer_email": order_data[5],
         }
    return d


def run():
    argv = [
        '--project={0}'.format(PROJECT),
        '--job_name=order-ingest',
        '--save_main_session',
        '--staging_location=gs://{0}-data-raw/staging/'.format(PROJECT),
        '--temp_location=gs://{0}-data-raw/temp/'.format(PROJECT),
        '--runner=DataflowRunner',
        '--region=us-east1',
        '--subnetwork=regions/us-east1/subnetworks/data-engineering'
    ]

    p = beam.Pipeline(argv=argv)
    input = 'gs://{0}-data-raw/order/*.csv'.format(PROJECT)
    output_datalake = 'gs://{0}-data-lake/order/output'.format(PROJECT)
    output_dw = 'gs://{0}-data-warehouse/order/output'.format(PROJECT)

    # find all orders that contain invalid data and insert the valid ones on GCS
    all_orders = (p | 'GetOrders' >> beam.io.ReadFromText(input))

    # Data Lake output
    (all_orders | 'WriteToDataLake' >> beam.io.WriteToText(output_datalake))

    # Data Warehouse output
    # GCS
    valid_orders = all_orders | 'RemoveInvalids' >> beam.FlatMap( lambda line: validate_order(line))
    (valid_orders | 'WriteToDataWarehouse' >> beam.io.WriteToText(output_dw))
    # BQ
    # TO-DO
    # (valid_orders
    #     | 'String To BigQuery Row' >> beam.Map(lambda s: csv_to_bqrow(s))
    #     | 'WriteToBigQuery' >> beam.io.WriteToBigQuery(
    #         TABLE_SPEC,
    #         schema=TABLE_SCHEMA,
    #         write_disposition=beam.io.BigQueryDisposition.WRITE_TRUNCATE,
    #         create_disposition=beam.io.BigQueryDisposition.CREATE_IF_NEEDED)
    #  )

    p.run()


if __name__ == '__main__':
    run()
