**Overview**

This is the function tool set for the Oracle public cloud. This tool will allow you to have 
command line functions provisioning and maintaining cloud elements in the Oracle public cloud.

  * The gem handles both the IaaS and PaaS(JaaS, DBaaS) functinality
  *     Version 0.1.1


**PaaS General Functions**

* opccreate -u _username_ -i _identity_domain_ -p _password_ -j _JSON_file_ -A _jcs or dbcs_
* opclst -u _username_ -i _identity_domain_ -p _password_ -A _jcs or dbcs_  
  * Returns details on a specific Java or DB Instance
* opclst -u _username_ -i _identity_domain_ -p _password_ -I _Instance Service Name_ -A _jcs or dbcs_  
  * Returns details on a specific Java or DB Instance
* opcdelete -u _username_ -i _identity_domain_ -p _password_  -A _jcs or dbcs_
  * for dbcs instances: -I _Instance Service Name_
  * for jcs instances: -c _delete config json_

**Java Cloud Service**

* jcsmanage -u _username_ -i _identity_domain_ -p _password_ -I _instance name_ -A (available actions: s_top, start, scaleup, scalein(requires --server_id), avail_patches, applied_patches, patch_precheck(requires --patch_id), patch(requires --patch_id), patch_rollback(requires --patch_id))_
* jcsbackuplist u username -i identity_domain -p password -I instance name
* jcsbackupconfiglist u username -i identity_domain -p password -I instance name

**Database Cloud Service**

 * dbcsmanage -u _username_ -i _identity_domain_ -p _password_  -I _instance name_ -A _action (available actions: stop, start, scaleup, scalein(requires --server_id), avail_patches, applied_patches, patch_precheck(requires --patch_id), patch(requires --patch_id), patch_rollback(requires --patch_id))_
   
**IaaS Services**

For the IaaS services, except object storage, there is a concept of administration/config containers where configuration objects or stored.
Containers always start with a "/" the base container for all of your objects is "/Compute-your id domain/" in some calls that is populated for you, in other cases you need to specify the entire container tree, this will be spelled out in the documentation Also for all of these methods the REST endpoint will be different for each account so it needs to be passed via the -R flag

 * ntwrk_app_lst -u _username_ -i _identity_domain_ -p _password_ -A _list or details_ -C _container (container need to be the full path)_ -R _RESTAPI_
 * ntwrk_app_updt -i youridentitydomain -u username -p password -A (create or delete) -R RESTAPI
    * for delete: -C _container (container need to be the full path)_
    * for create: -j _json file_ 
    * network_rule_lst -u _username_ -i _identity_domain_ -p _password_ -A _list or details_ -C _container (start with / after your base container)_ -R _RESTAPI_
 * ntwrk_rule_updt -u _username_ -i _identity_domain_ -p _password_ -A _create or delete_ -R _RESTAPI_
    * for delete: -C _container (container need to be the full path)_
    * for create: -j _json file_
    * for update: --update_list _comma separated value pair of fields to be updated disabled=false,..._

