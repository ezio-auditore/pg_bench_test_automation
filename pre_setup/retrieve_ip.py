import validate_ip

import time
from connection import get_connection
from config_variables import *

connection = get_connection()

system_service = connection.system_service()
vms_service = system_service.vms_service()

vm = vms_service.list(search='name='+VM_NAME)[0]

vm_service = vms_service.vm_service(vm.id)

reported_devices_service = vm_service.reported_devices_service()


def get_ip_of_vm():
    reported_devices = reported_devices_service.list()
    for reported_device in reported_devices:
        ips = reported_device.ips
        if ips:
            for ip in ips:
                if validate_ip.ipFormatChk(ip.address):
                    return ip.address


def main():
    while True:
        time.sleep(10)
        if get_ip_of_vm():
            print (get_ip_of_vm())
            break


if __name__ == '__main__':
    main()