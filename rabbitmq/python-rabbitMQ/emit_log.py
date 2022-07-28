#!/usr/bin/env/python

__doc__ = """
Fanout routing"""

import pika
import os, sys


credentials = pika.PlainCredentials("khanhnt", "")
parameters = pika.ConnectionParameters("192.168.53.242", 5672, "/", credentials)


connection = pika.BlockingConnection(parameters)
channel = connection.channel()

channel.exchange_declare(exchange="logs", exchange_type="fanout")
message = " ".join(sys.argv[1:]) or "Hello World!"

# because fanout exchange -> don't need routing key
channel.basic_publish(exchange="logs", routing_key="", body=message)

print(" [x] Sent %r" % message)
connection.close()
