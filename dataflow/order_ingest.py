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


def handle_customer_data(line):
    order_data = line.split(",")

    # add here your logic to handle customer data, for example
    customer_name = order_data[3]
    if customer_name:
        yield {"order_id": order_data[0],
               "status": order_data[1],
               "amount": order_data[2],
               "customer_name": order_data[3],
               "customer_phone": order_data[4],
               "customer_email": order_data[5],
               }


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
    valid_orders = (p
                    | 'GetOrders' >> beam.io.ReadFromText(input)
                    | 'RemoveInvalids' >> beam.FlatMap(lambda line: validate_order(line))
                    )

    # Data Lake output
    (valid_orders | 'WriteToDataLake' >> beam.io.WriteToText(output_datalake))

    # Data Warehouse output
    (
        valid_orders
        | 'HandleCustomerData' >> beam.FlatMap(lambda line: handle_customer_data(line))
        | 'WriteToDataWarehouseBucket' >> beam.io.WriteToText(output_dw)
        | 'WriteToBigQuery' >> beam.io.WriteToBigQuery(
            TABLE_SPEC,
            schema=TABLE_SCHEMA,
            write_disposition=beam.io.BigQueryDisposition.WRITE_TRUNCATE,
            create_disposition=beam.io.BigQueryDisposition.CREATE_IF_NEEDED)
    )

    p.run()


if __name__ == '__main__':
    run()
