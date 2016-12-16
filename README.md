# README #

### Overview ###

* This is a command line tool set for the Oracle public cloud(IaaS, Bare Metal, and PaaS.  This tool will allow you to have command line functions for provisioning and maintaining cloud assets in the Oracle Public Cloud.  
The gem handles both the IaaS(VM and BM) and PaaS(JaaS, DBaaS) functinality.  This functionality comes as part of 
the knife plugin gem and can be used alone or with Chef.
* Version 0.5.0

### Setup and Dependencies ###

**Install:**  
gem install oracle_public_cloud_client


+ **Dependencies:** 
    *  OPC-0.4.0
    * json 1.8.3
    * http
    * rubygems
    * optparse
    * oraclebmc  (This gem is not on rubygems.org and will need to be manually installed, see instructions below)

+ **Executables**: 
      opc   
      for list of options use -h for list of available options, if a required option is not provided the tool will return an error asking for the required option.


#

## Overview

This is the function tool set for the Oracle public cloud. This tool will allow you to have command line functions provisioning and maintaining cloud elements in the Oracle public cloud.

    * The gem handles Baremetal, IaaS and PaaS(JaaS, DBaaS, SOA) functionality
    * Version 0.5.0


## General
The base command for all functions is opc, followed by the service you want to leverage. For the IaaS services(compute, network, blockstorage) there is a concept of administration/configuration containers where configuration objects or stored. Containers always start with a "/" the base container for all of your objects is "/Compute-your id domain/"  you need to specify the entire container tree, this will be spelled out in the documentation Also for all of these methods the REST endpoint will be different for each account so it needs to be passed via the -R flag

    * example:  opc compute instance -A list -C <Container_name>

# Full list of Commands

       opc compute instance (options)           opc network secrule (options)     
       opc paas jcs (options)                   opc network secapp (options) 
       opc paas dbcs (options)                  opc network seclist (options)
       opc paas soa (options)                   opc network secassoc (options)
       opc paas datagrid (options)              opc network ssh_key (options)
       opc blockstorage (options)               opc network seciplist (options)
       opc orchestration (options)              opc network ip_reservation (options)
       opc bmc instance (options)               opc network ip_association (options)
       opc bmc network vcn (options)            opc bmc network subnets (options)
       opc bmc stack (options)                  opc bmc network gateway (options)  
       opc bmc network route (options)          opc bmc storage (options)

## Java Cloud Service


    * jcsmanage -I instance name -S jcs soa -A stop, start, scaleup, scalein, avail_patches, applied_patches,
      patch_precheck, patch, patch_rollback
       * patch_precheck, patch, and patch_rollback: requires --patch_id
       * scalein : requires --server_id

## Database Cloud Service

    * dbcsmanage -I instance name -A stop, start, scaleup, scalein, avail_patches,
       applied_patches, patch_precheck, patch, patch_rollback
        patch_precheck, patch, and patch_rollback: requires --patch_id
        scalein : requires --server_id


**Features**

*  Proxy Support
*  Config files for setting up your environment


**Installing bmc gem**

* The OracelBMC gem is not on rubygems.org, so if you wish to use it you must do the the following:
* Install the gem manually from the following URL:
* This gem is designed so that you do not need to install the oraclebmc gem to use it, but does need to be installed if you want to leverage any of the BMC functionality.  The oraclebmc gem leverages typhoeus gem which requires curl, this gem does not work on windows.

[OracleBMC](https://docs.us-phoenix-1.oraclecloud.com/tools/ruby/1.0.1/#label-Downloading+and+Installing+the+Gem+File)
* Once the gem is installed you will need to update the config file in your home directory.
(if you do not not have an account with bmc then you do not need to do this)

    * Add the following line:  
bmcenable = true

* If you are installing on Windows you will need to follow the instructions below and you will also need to run all transactions through fiddler to avoid SSL handshake issues.

**Installing typhoeus on Windows**

Installing typhoeus on windows can be a bit tricky or impossible, it has a dependency on libcurl that causes issues on Windows.
Below are two links, one to a blog on how to fix the problem and one for the library download


[Blog](http://blog.cloud-mes.com/2014/08/19/how-to-install-gem-curb-in-windows/)


[curl_download](http://curl.haxx.se/gknw.net/7.40.0/dist-w64/curl-7.40.0-rtmp-ssh2-ssl-sspi-zlib-winidn-static-bin-w64.7z)

 gem install curb --platform=ruby -- --with-curl-lib=C:/curl-7.40.0-devel-mingw32/bin --with-curl-include=C:/curl-7.40.0-devel-mingw32/include




##Config File##
The config file must be located in your home directory, the name of the file must be opcclientcfg.conf

example inputs for the file

              proxy_addr = 127.0.0.1
              proxy_port = 8888
              id_domain = youriddomain
              rest_endpoint = https://api-z16.compute.em2.oraclecloud.com
              user_name = user
              bmcenable = true
              tenancy = ocid1.tenancy.oc1..aaaaaaaa6acdk7gv4vaewlhdwqnu3jhuz6tgzcb34wm7vziyisfq
              fingerprint = a9:36:c8:66:4d:de:73:ed8:65:32:d4:b0:86:bf
              key_file = C:\Users\user\Documents\Oracle\bmc_key
              debug = false
              bmc_user = ocid1.user.oc1..aaaaaaaagibnmbxvm3akf7kb6ilvdpibnbmssq
              region = us-phoenix-1
              pass_phrase = passphrase for apikey if you set one
              log_requests = false
              verify_certs = 0
              compartment = ocid1.compartment.oc1..aaamu7lfr6c5lq25qgkfs32ipcpakv4q


The BMC cloud stacks are described in yaml, in the examples folder will be some example files, below is an example snippet

                    compute: 
                      - 
                       instances: 
                         - 
                          server: 
                          ad: "ACfH:PHX-AD-1"
                          attachments: 
                          - 
                             volume: Dev_Server_Storage
                          compartment: name
                          display_name: something
                          image: Oracle-Linux-7.3-2016.12.08-0
                          shape: BM.Standard1.36
                          ssh-key: "ssh-key"
                          subnet: "ACfH:PHX-AD-1"
                          vcn: VCN_Name

### Repo Owner ###

* Daryn McCool 
* mdaryn@hotmail.com