

## Overview

This is the function tool set for the Oracle public cloud. This tool will allow you to have command line functions provisioning and maintaining cloud elements in the Oracle public cloud.

    * The gem handles both the IaaS and PaaS(JaaS, DBaaS, SOA) functionality
    * Version 0.4.0

Note: This page is the same as the file in the Gem

## General

all functions take the options: -u _username_ -i _identity_domain_ -p _password_
## PaaS General Functions

    * opccreate  -j JSON_file -A jcs or dbcs or soa
    * opclst -A jcs or dbcs
        Returns high level details on all Java or DB or SOA Instances in the ID Domain
    * opclst -I Instance Service Name -A jcs or dbcs or soa
        Returns details on a specific Java or DB or SOA Instance
    * opcdelete  -A jcs or dbcs or soa
        * for dbcs instances: -I Instance Service Name
        * for jcs instances: -c delete config json

## Java Cloud Service

    * jcsmanage -I instance name -S jcs soa -A stop, start, scaleup, scalein, avail_patches, applied_patches,
      patch_precheck, patch, patch_rollback
       * patch_precheck, patch, and patch_rollback: requires --patch_id
       * scalein : requires --server_id
    * jcsbackup -I instance name -A list, create, initiate, config_list, delete
       * -j JSONFILE for create
    * datagrid -I instance name -A list, create, config_list, delete
       * -j JSONFILE for create

## Database Cloud Service

    * dbcsmanage -I instance name -A stop, start, scaleup, scalein, avail_patches,
       applied_patches, patch_precheck, patch, patch_rollback
        patch_precheck, patch, and patch_rollback: requires --patch_id
        scalein : requires --server_id

## IaaS Services

For the IaaS services, except object storage, there is a concept of administration/config containers where configuration objects or stored. Containers always start with a "/" the base container for all of your objects is "/Compute-your id domain/" in some calls that is populated for you, in other cases you need to specify the entire container tree, this will be spelled out in the documentation Also for all of these methods the REST endpoint will be different for each account so it needs to be passed via the -R flag

    * opcnetworkclient  -A (create or delete) -R RESTAPI
       * for delete: -C container (container need to be the full path)
       * for create: -j JSON file
       * for update: --update_list comma separated value pair of fields to be updated
    * network_bulkload  -R RESTAPI -j _JSON file
      operations determined by JSON file, can create and delete any Network object or objects in sequence with  one  file, see examples in JSON-EXAMPLES folder
    * opccompute -S _block_storage, snap_storage, instance, snapshot_ -A _see below_
         * if "S" = instance -A list, create, shape_list delete, imagelist_list, machineimage_list
         * if "S" = block_storage -A _list, create, delete_
         * for create: -j json file
    * objstrg -A list, create, delete
      * for create and delete: -C container
    * orch_client -A create or delete -R RESTAPI
      * for update or delete: -C container (container need to be the full path)
      * for create: -j json file

