#!/usr/bin/env python

import argparse

import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
from apache_beam.io.gcp.internal.clients import bigquery


#PROJECT = 'syl-dataflow-demo'
TABLE_SPEC = 'ecommerce.order'
TABLE_SCHEMA = 'order_id:STRING, status:STRING, amount:NUMERIC, customer_name:STRING, customer_phone:STRING, customer_email:STRING'

class CommandLineOptions(PipelineOptions):

  @classmethod
  def _add_argparse_args(cls, parser):
    parser.add_argument('--gcs_raw')
    parser.add_argument('--gcs_lake')
    parser.add_argument('--gcs_dw') 


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
    p = beam.Pipeline(options=CommandLineOptions())
    print(p.options)
    input = 'gs://{0}/order*.csv'.format(p.options.gcs_raw)
    output_datalake = 'gs://{0}/order/output'.format(p.options.gcs_lake)
    output_dw = 'gs://{0}/order/output'.format(p.options.gcs_dw)

    # find all orders that contain invalid data and insert the valid ones on GCS
    all_orders = (p | 'GetOrders' >> beam.io.ReadFromText(input))

    # Data Lake output
    (all_orders | 'WriteToDataLake' >> beam.io.WriteToText(output_datalake))

    # Data Warehouse output
    # GCS
    valid_orders = all_orders | 'RemoveInvalids' >> beam.FlatMap(lambda line: validate_order(line))
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
