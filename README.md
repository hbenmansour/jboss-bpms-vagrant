JBoss BPMS Vagrant environment
==============================

This [Vagrant](https://www.vagrantup.com/) project is aimed to help you easily starting playing with Red Hat JBoss BPMS.

It bootstraps a VirtualBox VM (BTW you have to use your own since I used a private RHEL 6 box so a Centos 6 will be fine) and installs you : 

 * JBoss EAP 
 * BPMS
 * MySQL
 * MySQL driver

And then configures for you : 

 * MySQL Datasource for the BPMS persistence
 * admin and dev users

