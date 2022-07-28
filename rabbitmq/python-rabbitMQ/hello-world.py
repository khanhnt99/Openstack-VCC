#!/usr/bin/env python

__doc__ = """
root@rabbit-server:~# rabbitmqctl add_user username password
Adding user "khanhnt" ...
Done. Don't forget to grant the user permissions to some virtual hosts! See 'rabbitmqctl help set_permissions' to learn more.
root@rabbit-server:~# rabbitmqctl set_user_tags khanhnt administrator
Setting tags for user "khanhnt" to [administrator] ...
root@rabbit-server:~# rabbitmqctl set_permissions -p / khanhnt ".*" ".*" ".*"
Setting permissions for user "khanhnt" in vhost "/" ...
rabbitmq-plugins enable rabbitmq_management
"""

import pika

# login to remote rabbitmq-server
credentials = pika.PlainCredentials("", "")
parameters = pika.ConnectionParameters("192.168.53.242", 5672, "/", credentials)

# create connection to broker
connection = pika.BlockingConnection(parameters)
channel = connection.channel()

# create message queue name hello
channel.queue_declare(queue="hello")

# get message to exchange
channel.basic_publish(exchange="", routing_key="hello", body="Hello World!")
print(" [X] Sent 'Hello World!")

connection.close()
