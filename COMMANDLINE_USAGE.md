**Overview**

This is the function tool set for the Oracle public cloud. This tool will allow you to have 
command line functions provisioning and maintaining cloud elements in the Oracle public cloud.

  * The gem handles both the IaaS and PaaS(JaaS, DBaaS, SOA) functionality
  *  Version 0.2.2

_Note: This page is the same as the file in the Gem_

**PaaS General Functions**

* opccreate -u _username_ -i _identity_domain_ -p _password_ -j _JSON_file_ -A _jcs or dbcs_ _or soa_
* opclst -u _username_ -i _identity_domain_ -p _password_ -A _jcs or dbcs_  
  * Returns high level details on all Java or DB or SOA Instances in the ID Domain
* opclst -u _username_ -i _identity_domain_ -p _password_ -I _Instance Service Name_ -A _jcs or dbcs_  or _soa_
  * Returns details on a specific Java or DB or SOA Instance 
* opcdelete -u _username_ -i _identity_domain_ -p _password_  -A _jcs or dbcs_ or _soa_
  * for dbcs instances: -I _Instance Service Name_
  * for jcs instances: -c _delete config json_

**Java Cloud Service**

* jcsmanage -u _username_ -i _identity_domain_ -p _password_ -I _instance name_ -S _jcs soa_ -A  _stop, start, scaleup, scalein, avail_patches, applied_patches, patch_precheck, patch, patch_rollback_
   * patch_precheck, patch, and patch_rollback: requires --patch_id
   * scalein : requires --server_id
* jcsbackup -u _username_ -i _identity_domain_ -p _password_ -I _instance name_ -A _list, create, initiate, config_list, delete_
   * -j _JSONFILE_  for create
* datagrid -u _username_ -i _identity_domain_ -p _password_ -I _instance name_ -A _list,
create,  config_list, delete_
   * -j _JSONFILE_  for create

**Database Cloud Service**

 * dbcsmanage -u _username_ -i _identity_domain_ -p _password_  -I _instance name_ -A _stop, start, scaleup, scalein, avail_patches, applied_patches, patch_precheck, patch, patch_rollback_
   * patch_precheck, patch, and patch_rollback: requires --patch_id
   * scalein : requires --server_id
   
**IaaS Services**

For the IaaS services, except object storage, there is a concept of administration/config containers where configuration objects or stored.
Containers always start with a "/" the base container for all of your objects is "/Compute-your id domain/"   you need to specify the entire container tree, this will be spelled out in the documentation.
For all of these methods the REST endpoint will be different for each account so it needs to be passed via the -R flag

 * ntwrk_lst -u _username_ -i _identity_domain_ -p _password_ -A _list or details_ -C _container (container need to be the full path)_ -R _RESTAPI_ -A (available actions: secapp, secrule, seclist, seciplist, secassoc, ip_reservation, ip_association)
 * ntwrk_app_updt -i youridentitydomain -u username -p password -A (create or delete) -R RESTAPI
    * for delete: -C _container (container need to be the full path)_
    * for create: -j _json file_ 
    * network_rule_lst -u _username_ -i _identity_domain_ -p _password_ -A _list or details_ -C _container (start with / after your base container)_ -R _RESTAPI_
 * ntwrk_rule_updt -u _username_ -i _identity_domain_ -p _password_ -A _create or delete_ -R _RESTAPI_
    * for delete: -C _container (container need to be the full path)_
    * for create: -j _json file_
    * for update: --update_list _comma separated value pair of fields to be updated disabled=false,..._
 * network -u _username_ -i _identity_domain_ -p _password_ -R _RESTAPI_ -j _json file_ 
     * operations determined by JSON file, can create and delete any Network object or objects in sequence with one file, see examples in JSON-EXAMPLES folder
 * opccompute -u _username_ -i _identity_domain_ -p _password_ -A _list create shape_list delete_
    * for create: -j _json file_ 
 * objstrg -u _username_ -i _identity_domain_ -p _password_ -A _list, create, delete_
   * for create and delete: -C _container_
 * orch_client -u _username_ -i _identity_domain_ -p _password_ -A _list, create, delete_
   * for list, update, stop, start, and delete: -C _container_
   * for create: -j _json file_
   
   

