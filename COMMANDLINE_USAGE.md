### Overview ###

* This is the function tool set for the Oracle public cloud.  This tool will allow you to have 
command line functions proioning and maintaining cloud elements in the Oracle public cloud.  
The gem handles both the IaaS and PaaS(JaaS, DBaaS) functinality
* Version 0.0.2

** Java Cloud Service **

* jcscreate -u username -i identity_domain -p password -j JSON_file
* jcsmanage -u username -i identity_domain -p password -A action -I instance name
 (available actions: stop, start, scaleup, scalein(requires --server_id), avail_patches,
 applied_patches, patch_precheck(requires --patch_id), patch(requires --patch_id), patch_rollback(requires --patch_id))
* opclst -i *youridentitydomain* -u *username* -p *password*  -A jcs > returns a list of all jcs instances for that account
* opclst -i *youridentitydomain* -u *username* -p *password* -I *Instance Service Name*  -A jcs >> returns details on a specific Java Instance
* jcsdelete -u *username* -i *identity_domain* -p *password* -c *delete config json*
* jcsbackuplist u *username* -i *identity_domain* -p *password* -I *instance name*
* jcsbackupconfiglist u username -i *identity_domain* -p *password* -I *instance name*

** Database Cloud Service **

* dbcscreate -i *youridentitydomain* -u *username* -p *password* -j *JSON_file*
* dbcsmanage -i *youridentitydomain* -u *username* -p *password* -A *action* -I *instance name*
 		(available actions: stop, start, scaleup, scalein(requires --server_id), avail_patches,
 		applied_patches, patch_precheck(requires --patch_id), patch(requires --patch_id), patch_rollback(requires --patch_id))
* opclist -i *youridentitydomain* -u *username* -p *password* -A dbcs > returns a list of all jcs instances for that account
* opclist -i *youridentitydomain* -u *username* -p *password* -I *Instance Service Name*  -A dbcs >> returns details on a specific Java Instance
* dbcsdelete -i *youridentitydomain* -u *username* -p *password* -c *delete config json*

** IaaS Services **

For the IaaS services, except object storage, there is a concept of administration/config containers where configuration objects or stored.  
Containers always start with a "/" the base container for all of your objects is "/Compute-your id domain/" in some calls that is populated
for you, in other cases you need to specify the entire container tree, this will be spelled out in the documentation
Also for all of these methods the REST endpoint will be different for each account so it needs to be passed via the -R flag

* ntwrk_app_lst -i *youridentitydomain* -u *username* -p *password* -A *(list or details)* -C *container* (container need to be the full path) -R RESTAPI
* ntwrk_app_updt -i *youridentitydomain* -u *username* -p *password* -A *(create or delete)* -R *RESTAPI*
		
		-C *container* (container need to be the full path) *needed for delete*
		-j json file  _needed for create
		
* network_rule_lst -u username -i identity_domain -p password -A (list or details) -C container (start with / after your base container) -R RESTAPI
* ntwrk_rule_updt -u username -i identity_domain -p password -A (create or delete) -R RESTAPI
		
		-C container (container need to be the full path) _needed for delete
		-j json file  _needed for create
		--update_list comma separated value pair of fields to be updated disabled=false,...


 