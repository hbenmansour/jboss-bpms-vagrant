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


The box mentioned in the Vagrantfile is a private one. You are encouraged to use a Centos6 box.
You will also have to download from the [Red Hat customer portal](http://access.redhat.com) the EAP and BPMS distribution and put them in the dist folder : 
 * jboss-eap-6.1.1.zip
 * jboss-bpms-6.0.1.GA-redhat-4-deployable-eap6.x.zip

After running `Vagrant up` and `Vagrant provision`, you will end up with a BRPMS installation accessible from the VM in `/vagrant/runtime/jboss-eap-6.1/`.


To start the installation : 

 * `Vagrant ssh`
 * `cd /vagrant/runtime/jboss-eap-6.1/bin`
 * `./standalone.sh -b 192.168.10.20 -bmanagement=192.168.10.20`

Navigate to [http://localhost:8080/business-central](http://localhost:8080/business-central) and login using either admin/admin@123 or developer/developer@123 for admin and developer access respectively.




