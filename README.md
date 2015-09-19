# README #

### Overview ###

* This is the function tool set for the Oracle public cloud.  This tool will allow you to have 
command line functions proioning and maintaining cloud elements in the Oracle public cloud.  
The gem handles both the IaaS and PaaS(JaaS, DBaaS) functinality
* Version 0.0.2

### Setup and Dependencies ###
**
* Summary of set up**:  Install dependencies, install Gem, read usage file

+ **Dependencies:** 
    *  OPC-0.1.0
    * json(any verion)
    * http
    * rubygems
    * optparse

+ **Executables**: 
      * **List:** jaaslist, jaasdelete, jaasmanage, jaascreate, jaasdelete, storagecreate, storagelist, storagedelete, jaasManage, dblist, dbcreate, dbdelete, datagrid, dbaasmanage, jcsbackuplist, jcsbackupconfiglist
      * Executables are command line executables, they will require .bat for windows.  They all take options use -h for list of available options, 
if a required option is not provided they will return an error asking for the required option.

      * **Examples:**  
        * jaaslist -i *youridentitydomain* -u *username* -p *password* > returns a list of all jcs instances for that account
        * jaaslist -i *youridentitydomain* -u *username* -p *password* -I *Instance Service Name*  >> returns details on a specific Java Instance
	

### Class and Method Descriptions ###
[Classes_README](https://bitbucket.org/mcoold/opcclient/src/35f160b92a67463d6d1fe4f2e4b312e6d9a3c369/CLASSES_README.md?at=master)

### Repo Owner ###

* Daryn McCool 
* mdaryn@hotmail.com