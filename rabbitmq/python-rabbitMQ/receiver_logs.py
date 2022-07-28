#!/usr/bin/env/python
__doc__ = """
rabbitmqctl list_bindings
rabbitmqctl list_exchanges
"""

import pika

credentials = pika.PlainCredentials("khanhnt", "")
parameters = pika.ConnectionParameters("192.168.53.242", 5672, "/", credentials)

# create connection to broker
connection = pika.BlockingConnection(parameters)
channel = connection.channel()

# choose message queue name hello
channel.exchange_declare(exchange="logs", exchange_type="fanout")

# connect to empty queue -> create a queue with random name
# when consumer connection closed -> queue should be delete -> exclusive
result = channel.queue_declare(queue="", exclusive=True)

queue_name = result.method.queue
# Tell the exchange to send messages to our queue -> binding
channel.queue_bind(exchange="logs", queue=queue_name)

print(" [*] Waiting for logs. To exit press CTRL+C")


def callback(ch, method, properties, body):
    print(" [x] %r" % body)


channel.basic_consume(queue=queue_name, on_message_callback=callback, auto_ack=True)

channel.start_consuming()
