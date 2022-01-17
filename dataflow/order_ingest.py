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


PROJECT='syl-dataflow-demo'


def validate_order(line):
  order_data = line.split(",")

  # order_id must not be null
  if not order_data[0]:
    yield line


def validate_customer(line):
  order_data = line.split(",")

  # customer_name must not be null
  if not order_data[3]:
    yield line



def run():
   argv = [
      '--project={0}'.format(PROJECT),
      '--job_name=order-ingest',
      '--save_main_session',
      '--staging_location=gs://{0}-data-raw/staging/'.format(PROJECT),
      '--temp_location=gs://{0}-data-raw/temp/'.format(PROJECT),
      '--region=us-central1',
      '--runner=DataflowRunner'
   ]

   p = beam.Pipeline(argv=argv)
   input = 'gs://{0}-data-raw/order/*.csv'.format(PROJECT)
   output_prefix = 'gs://{0}-data-lake/order/output'.format(PROJECT)


   # find all orders that contain invalid data and insert the valid ones on GCS
   (p
      | 'GetOrders' >> beam.io.ReadFromText(input)
      | 'RemoveInvalids' >> beam.FlatMap(lambda line: validate_order(line) )
      | 'ValidateCustomer' >> beam.FlatMap(lambda line: validate_customer(line) )
      | 'WriteToDataLake' >> beam.io.WriteToText(output_prefix)
   )

   p.run()

if __name__ == '__main__':
   run()
