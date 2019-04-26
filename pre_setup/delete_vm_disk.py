from connection import get_connection
from config_variables import *

connection = get_connection()


def remove_attached_vm_disk():
    vms_service = connection.system_service().vms_service()
    vm = vms_service.list(search='name='+VM_NAME)[0]


    disk_attachments_service = vms_service.vm_service(vm.id)\
        .disk_attachments_service()
    disk_attachments = disk_attachments_service.list()
    attachment =find_disk_attachment(connection, disk_attachments)
    if attachment:
        attachment_service = disk_attachments_service.attachment_service(
            attachment.id)
        attachment_service.remove(detach_only=False)
        print("Disk removed")


def find_disk_attachment(connection, disk_attachments):
        for disk_attachment in disk_attachments:
            disk = connection.follow_link(disk_attachment.disk)
            if disk.name == template_name+'-disk':
                return disk_attachment


def main():
    remove_attached_vm_disk()


if __name__ == '__main__':
    main()
