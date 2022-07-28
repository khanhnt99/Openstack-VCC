#!/usr/bin/env/python


__doc__ = """

"""

import pika
import os, sys


credentials = pika.PlainCredentials("khanhnt", "")
parameters = pika.ConnectionParameters("192.168.53.242", 5672, "/", credentials)


connection = pika.BlockingConnection(parameters)
channel = connection.channel()

# make the queue will survive when node restart -> durable
channel.queue_declare(queue="task_queue", durable=True)

# make task queue won't be lost even when RabbitMQ restart -> delivery_mode
message = " ".join(sys.argv[1:]) or "Hello World!"
channel.basic_publish(
    exchange="",
    routing_key="task_queue",
    body=message,
    properties=pika.BasicProperties(
        delivery_mode=2,
    )
)

print(" [x] Sent %r" % message)
