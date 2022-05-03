#!/usr/bin/env python

import argparse
import logging

import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
from apache_beam.io.gcp.internal.clients import bigquery


TABLE_NAME = 'ecommerce.order'
TABLE_SCHEMA = 'order_id:STRING, status:STRING, amount:NUMERIC, customer_name:STRING, customer_phone:STRING, customer_email:STRING'


class CommandLineOptions(PipelineOptions):

    @classmethod
    def _add_argparse_args(cls, parser):
        parser.add_argument('--gcs_raw')
        parser.add_argument('--gcs_lake')
        parser.add_argument('--gcs_dw')


def validate_order_data(line):
    order_data = line.split(",")
    if order_data[0]:
        yield line


def transform_line(line):
    wrk_element = line.split(",")      
    order_data = { 'order_id': wrk_element[0],
        'status': wrk_element[1],
        'amount': wrk_element[2],
        'customer_name': wrk_element[3],
        'customer_phone': wrk_element[4],
        'customer_email': wrk_element[5]}
    return order_data


def run():
    p = beam.Pipeline(options=CommandLineOptions())
    input = 'gs://{0}/order*.csv'.format(p.options.gcs_raw)
    output_datalake = 'gs://{0}/order/output'.format(p.options.gcs_lake)
    output_dw = 'gs://{0}/order/output'.format(p.options.gcs_dw)

    print('GCS Input {0}, GCS Lake {1}, GCS DW {2}'.format(
        input, output_datalake, output_dw))

    # Get order files from the raw data bucket
    all_orders = (p | 'GetOrders' >> beam.io.ReadFromText(input, skip_header_lines=1))

    # Output to the DL bucket
    (all_orders | 'WriteToDataLake' >> beam.io.WriteToText(output_datalake))

    # Remove invalids
    valid_orders = (all_orders | 'RemoveInvalids' >> beam.FlatMap(lambda line: validate_order_data(line)))

    # Output to the DW bucket
    (valid_orders | 'WriteToDWBucket' >> beam.io.WriteToText(output_dw))

    #String To BigQuery Row
    (valid_orders 
        | 'StringToBigQueryRow' >> beam.Map(lambda l: transform_line(l))
        | 'WriteToDWBigQuery' >> beam.io.WriteToBigQuery(
        TABLE_NAME,
        schema=TABLE_SCHEMA,
        create_disposition=beam.io.BigQueryDisposition.CREATE_IF_NEEDED,
        write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND))

    p.run()


if __name__ == '__main__':
    run()
