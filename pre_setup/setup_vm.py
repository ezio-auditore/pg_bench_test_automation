import ovirtsdk4.types as types

import logging
import time

from connection import get_connection

from config_variables import *

logging.basicConfig(level=logging.DEBUG, filename=filename)


def create_and_run_vm():
    connection = get_connection()
    system_service = connection.system_service()

    storage_domains_service = system_service.storage_domains_service()

    storage_domain = storage_domains_service.list(
        search='name=' + storage_domain_name)[0]

    templates_service = system_service.templates_service()

    templates = templates_service.list(search='name=' + template_name)

    if not templates:
        print("could not find the required template: {}".format(template_name))
        quit()

    template_id = None
    for template in templates:
        if template.version.version_number == template_version:
            template_id = template.id

    template_service = templates_service.template_service(template_id)
    disk_attachments = connection.follow_link(template_service.get()
                                              .disk_attachments)

    disk = disk_attachments[0].disk
    vms_service = system_service.vms_service()

    vm = vms_service.add(
        types.Vm(
            name=VM_NAME,
            cluster=types.Cluster(
                name='Default'
            ),
            template=types.Template(
                id=template_id
            ),
            disk_attachments=[
                types.DiskAttachment(
                    disk=types.Disk(
                        id=disk.id,
                        format=types.DiskFormat.COW,
                        storage_domains=[
                            types.StorageDomain(
                                id=storage_domain.id,
                            ),
                        ],
                    ),
                ),
            ],
        )
    )

    vm_service = vms_service.vm_service(vm.id)

    while True:
        time.sleep(10)
        vm = vm_service.get()
        if vm.status == types.VmStatus.DOWN:
            break

    vm_service.start()

    while True:
        time.sleep(10)
        vm = vm_service.get()
        if vm.status == types.VmStatus.UP:
            break

    connection.close()


def main():
    create_and_run_vm()


if __name__ == '__main__':
    main()

