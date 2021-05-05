#!/usr/bin/env python

import pika
connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
# Ket noi toi Broker o localhost

channel = connection.channel()
channel.queue_declare(queue='hello')

# Tao 1 queue moi ten la 'Hello'

channel.basic_publish(exchange='', routing_key='hello', body='Hello World')
print(" [x] Sent 'Hello World!' ")
connection.close()
