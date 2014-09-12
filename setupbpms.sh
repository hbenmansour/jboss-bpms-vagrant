#!/usr/bin/env bash


EAPINSTALL=dist/jboss-eap-6.1.1.zip
BPMSDEPLOYABLE=dist/jboss-bpms-6.0.1.GA-redhat-4-deployable-eap6.x.zip
EAPRUNTIME=runtime/jboss-eap-6.1
MATERIALS=/vagrant/materials

trap "onexit" EXIT

function log(){
  echo -e "[$(date +'%F %T')][INFO] - ${1}"
}

function onexit() {

  local ret=$?

  if [ $ret -eq 0 ]; then
    echo -e "[$(date +'%F %T')][INFO] - Provisionning complete"
  else
    echo -e "[$(date +'%F %T')][INFO] - Provisionning failed with code $ret"
  fi
}

function createUser() {

  local username="${1}"	
  local password="${2}"
  local roles="${3}"
  log "Creating user ${1}"
  sh ${EAPRUNTIME}/bin/add-user.sh -a -s -u ${username} -p ${password} -ro ${roles}

}


log "Opening ports in the firewall"
sudo lokkit -p 9090:tcp -p 8080:tcp

log "Installing missing software"
[ -z "$(sudo rpm -qa | grep java)" ] && sudo yum -y install java-1.7.0-openjdk-devel
[ -z "$(sudo rpm -qa | grep unzip)" ] && sudo yum -y install unzip

su - vagrant

log "Change to vagrant shared folder"
cd /vagrant

if [ -d runtime/ ];
then
	log "Clearing out existing files"
	rm -fr runtime/
fi

log "Unzip eap 6.1.1"
unzip -o -q $EAPINSTALL -d runtime/


log "Deploy bpms 6.0.1"
unzip -u -o -q $BPMSDEPLOYABLE -d runtime/

log "Creating users"
createUser developer developer@123 developer
createUser admin admin@123 admin

log "Installing Database"
[ -z "$(sudo rpm -qa | grep mysql-server)" ] && sudo yum -y install mysql-server
[ -z "$(sudo rpm -qa | grep mysql-connector-java)" ] && sudo yum -y install mysql-connector-java

log "Starting Database"
sudo /etc/init.d/mysqld start

log "Database creation"
echo "drop database jbpm" | mysql -u root
echo "create database jbpm" | mysql -u root
echo "drop user jbpm" | mysql -u root
echo "create user jbpm" | mysql -u root
echo "grant all on jbpm.* to 'jbpm'@'localhost' identified by 'jbpm';" | mysql -u root

log "Creating Driver module"
mkdir -p ${EAPRUNTIME}/modules/system/layers/base/com/mysql/main
cp ${MATERIALS}/module.xml ${EAPRUNTIME}/modules/system/layers/base/com/mysql/main

log "Copying Driver"
cp ${MATERIALS}/mysql-connector-java-5.1.32-bin.jar ${EAPRUNTIME}/modules/system/layers/base/com/mysql/main

log "Creating datasource"
cp ${MATERIALS}/standalone.xml ${EAPRUNTIME}/standalone/configuration

log "Updating BPMS persistence configuration"
cp ${MATERIALS}/persistence.xml ${EAPRUNTIME}/standalone/deployments/business-central.war/WEB-INF/classes/META-INF


