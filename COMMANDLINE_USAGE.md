### Overview ###

* This is the function tool set for the Oracle public cloud.  This tool will allow you to have 
command line functions proioning and maintaining cloud elements in the Oracle public cloud.  
The gem handles both the IaaS and PaaS(JaaS, DBaaS) functinality
* Version 0.0.2

** Java Cloud Service **

* jaascreate -u username -i identity_domain -p password -j JSON_file
* jaasmanage -u username -i identity_domain -p password -A action -I instance name
 (available actions: stop, start, scaleup, scalein(requires --server_id), avail_patches,
 applied_patches, patch_precheck(requires --patch_id), patch(requires --patch_id), patch_rollback(requires --patch_id))
* jaaslist -i *youridentitydomain* -u *username* -p *password* > returns a list of all jcs instances for that account
* jaaslist -i *youridentitydomain* -u *username* -p *password* -I *Instance Service Name*  >> returns details on a specific Java Instance
* jaasdelete -u username -i identity_domain -p password -c delete config json
* jcsbackuplist u username -i identity_domain -p password -I instance name
* jcsbackupconfiglist u username -i identity_domain -p password -I instance name


 