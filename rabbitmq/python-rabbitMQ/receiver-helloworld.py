#!/usr/bin/env python


__doc__="""
receive message from the queue and print to screen
rabbitmqctl list_queues
"""
import pika
import os, sys


def main():
    # login to remote rabbitmq-server
    credentials = pika.PlainCredentials("", "")
    parameters = pika.ConnectionParameters("192.168.53.242", 5672, "/", credentials)

    # create connection to broker
    connection = pika.BlockingConnection(parameters)
    channel = connection.channel()

    # choose message queue
    channel.queue_declare(queue='hello')

    def callback(ch, method, properties, body):
        print(" [x] Received %r" % body)


    channel.basic_consume(queue='hello', auto_ack=True, on_message_callback=callback)

    print(' [*] Waiting for message. To exit press CTRL+C')
    channel.start_consuming()


if __name__ == '__main__':
    try: 
        main()
    except KeyboardInterrupt:
        print('Interrupted')
