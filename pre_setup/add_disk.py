import ovirtsdk4.types as types
import time

from connection import get_connection
from config_variables import *

connection = get_connection()


def add_disk(sparse=False):
    print ("Adding new disk to VM ---------")
    vms_service = connection.system_service().vms_service()
    vm = vms_service.list(search='name='+VM_NAME)[0]

    disk_attachments_service = vms_service.\
        vm_service(vm.id).disk_attachments_service()

    disk_attachment = disk_attachments_service.add(
        types.DiskAttachment(
            disk=types.Disk(
                name=template_name+'-disk',
                description='Thinly-provisioned' if sparse else 'Preallocated',
                format=types.DiskFormat.RAW,
                provisioned_size=80 * 2 ** 30,
                storage_domains=[
                    types.StorageDomain(
                        name=storage_domain_name,
                    ),
                ],
                sparse=sparse
            ),
            interface=types.DiskInterface.VIRTIO,
            bootable=False,
            active=True,
        ),
    )
    return disk_attachment.disk


def is_disk_up(disk):
    disks_service = connection.system_service().disks_service()
    disk_service = disks_service.disk_service(disk.id)
    disk = disk_service.get()
    if disk.status == types.DiskStatus.OK:
        return True


def main():
    disk = add_disk()
    while True:
        time.sleep(10)
        if is_disk_up(disk):
            break


if __name__ == '__main__':
    main()
