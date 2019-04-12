import ovirtsdk4 as sdk

import logging


def get_connection():
    connection = sdk.Connection(
        url='',
        username='',
        password="",
        insecure=True,
        log=logging.getLogger()
    )
    return connection
