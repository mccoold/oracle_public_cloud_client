# README #

### Overview ###

* This is a command line tool set for the Oracle public cloud.  This tool will allow you to have 
command line functions proioning and maintaining cloud elements in the Oracle public cloud.  
The gem handles both the IaaS and PaaS(JaaS, DBaaS) functinality.  This functionality comes as part of 
the knife plugin gem and can be used alone or with Chef.
* Version 0.4.0

### Setup and Dependencies ###

**Install:**  
gem install oracle_public_cloud_client


+ **Dependencies:** 
    *  OPC-0.3.2
    * json 1.8.3
    * http
    * rubygems
    * optparse

+ **Executables**: 
      * This is a command line tool all functions will require .bat for windows.  They all take options use -h for list of available options, if a required option is not provided the tool will return an error asking for the required option.
	  * See COMMANDLINE_USAGE for details on the command line


**Features**
*  Proxy Support
*  Config files for setting up your environment
 

### Repo Owner ###

* Daryn McCool 
* mdaryn@hotmail.com