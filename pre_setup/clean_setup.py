import ovirtsdk4.types as types
import time

from connection import get_connection
from config_variables import *
from delete_vm_disk import remove_attached_vm_disk

connection = get_connection()
vms_service = connection.system_service().vms_service()
vm = vms_service.list(search='name=' + VM_NAME)[0]
vm_service = vms_service.vm_service(vm.id)


def power_off_vm():
    vm_service.stop()
    print("Stopping VM")


def delete_vm():
    if vm_service.get().status == types.VmStatus.DOWN:
        print("VM is down")
        vm_service.remove()
        print("Removing VM")
    else:
        print("VM is not down cannot remove")
        quit()


def main():
    print("Powering off VM")
    power_off_vm()
    while True:
        time.sleep(10)
        if vm_service.get().status == types.VmStatus.DOWN:
            remove_attached_vm_disk()
            break
    delete_vm()


if __name__ == '__main__':
    main()