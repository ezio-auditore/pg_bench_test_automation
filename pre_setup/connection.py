import ovirtsdk4 as sdk

import logging


def get_connection():
    connection = sdk.Connection(
        url='https://rhhi-engine.perf.redhat.com/ovirt-engine/api',
        username='admin@internal',
        password="redhat123",
        insecure=True,
        log=logging.getLogger()
    )
    if not connection:
        print("Could not connect to api endpoint {}".format(connection.url))
    return connection


def main():
    get_connection()


if __name__ == '__main__':
    main()
