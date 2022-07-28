#!/usr/bin/env/python


import pika
import os, sys, time


def main():
    # login to remote rabbitmq-server
    credentials = pika.PlainCredentials("khanhnt", "")
    parameters = pika.ConnectionParameters("192.168.53.242", 5672, "/", credentials)
    
    # create connection to broker
    connection = pika.BlockingConnection(parameters)
    channel = connection.channel()
    
    # choose message queue name hello
    channel.queue_declare(queue="task_queue", durable=True)

    def callback(ch, method, properties, body):
        print(" [x] Received %r" % body.decode())
        time.sleep(body.count(b'.'))
        print(" [x] Done")

    channel.basic_consume(queue='task_queue', auto_ack=True, on_message_callback=callback)
    print(' [*] Waiting for message. To exit press CTRL+C')

    # listen message from queue
    channel.start_consuming()

    
if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("Interrupted")
        