Useful Splunk commands

sudo ./splunk start --accept-license
sudo ./splunk stop
sudo chown -R splunk:splunk /opt/splunk
sudo /opt/splunk/bin/splunk enable boot-start -user splunk

sudo -H -u splunk /opt/splunk/bin/splunk start --accept-license
sudo -H -u splunk /opt/splunk/bin/splunk restart
sudo -H -u splunk /opt/splunk/bin/splunk stop
sudo -H -u splunk /opt/splunk/bin/splunk status


sudo -H -u splunk /opt/splunk/bin/splunk validate cluster-bundle --check-restart
sudo -H -u splunk /opt/splunk/bin/splunk apply cluster-bundle


stateOnClient = noop
sudo -H -u splunk /opt/splunk/bin/splunk show-decrypted --value '$7$oafkh5QErFcCsTaWAqoLU7NaXqimlbSP0zecqcemoq/IgkASAqJzrBtICBo/AOmW'


Fwder
sudo chown -R splunk:splunk /opt/splunkforwarder
sudo -H -u splunk /opt/splunkforwarder/bin/splunk start
sudo -H -u splunk /opt/splunkforwarder/bin/splunk restart
sudo -H -u splunk /opt/splunkforwarder/bin/splunk stop
sudo -H -u splunk /opt/splunkforwarder/bin/splunk status

sudo -H -u splunk /opt/splunkforwarder/bin/splunk display listen
sudo -H -u splunk /opt/splunkforwarder/bin/splunk btool outputs list --debug

tail -f /opt/splunkforwarder/var/log/splunk/splunkd.log

/opt/splunkforwarder/bin/splunk btool inputs list --debug

view a zipped file: gzip -dc maillog-smtp2.1.gz | more


SCP

sshpass -p "" scp - r installsplunk.sh sccStudent@:/home/sccStudent/ 

move file to server
 scp -i ~/.ssh/splunklab.pem  -r deploymentclient ec2-user@111.11.11.111:tmp

For Splunk labs

scp -r  splunk-add-on-for-cisco-asa_520.tgz  
splunk-add-on-for-mcafee-web-gateway_210.tgz

tar up file
sudo tar -czvf deploymentclient.zip deploymentclient/

sudo tar -czvf ccx-add-on-for-cloudflare-products_102.tgz Splunk_TA_CCX_Cloudflare_Products/

get file from remote host
scp -i ~/.ssh/splunklab.pem ec2-user@111.11.11.111:/tmp/.zip /Users/Documents/Projects/Splunk



cp cityfibre_dev_deploymentclient.zip update-splunk-forwarders/roles/update-splunkforwarder/files

/opt/splunk/bin/splunk list cluster-peers
/opt/splunk/q/splunk show cluster-status --verbose


sudo mkdir /opt/splunkdata
sudo chown -R splunk:splunk /opt/splunk

ssh sccStudent@3.235.67.64

sudo -H -u splunk /opt/splunk/bin/splunk -version

sudo tar -xzf $INSTALL_FILE


Identify the GUID of the single instance. It is recorded in vi /opt/splunk/etc/instance.cfg
[general]
guid = db_1438807630_1431541724_12_BE808FEA-B676-4CBC-B813-9D1FC04AD468

sudo 
sudo chown -R splunk:splunk /opt/splunk
sudo -H -u splunk /opt/splunk/bin/splunk restart

./splunk show config inputs

/opt/splunkforwarder/bin/splunk btool inputs list --debug
sudo -H -u splunk /opt/splunk/bin/splunk display listen

BTool
sudo -H -u splunk /opt/splunk/bin/splunk btool inputs list --debug
sudo -H -u splunk /opt/splunk/bin/splunk btool authorize list --debug

sudo -H -u splunk /opt/splunk/bin/splunk btool outputs list --debug
sudo -H -u splunk /opt/splunk/bin/splunk btool props list --debug
sudo -H -u splunk /opt/splunk/bin/splunk btool transforms list --debug
sudo -H -u splunk /opt/splunk/bin/splunk btool indexes list --debug  | grep "\["
sudo -H -u splunk /opt/splunk/bin/splunk btool limits list --debug 
sudo -H -u splunk /opt/splunk/bin/splunk btool check --debug
sudo -H -u splunk /opt/splunk/bin/splunk btool server list clustering –debug
sudo -H -u splunk /opt/splunk/bin/splunk btool server  –debug
/opt/splunk/bin/splunk btool props list --debug | grep "\[" -A 5 and -B 5


https://www.splunk.com/en_us/blog/tips-and-tricks/tips-and-tricks-for-the-new-guy.html

sudo -H -u splunk /opt/splunk/bin/splunk btool opt/splunk/var/log/splunk

sudo -H -u splunk /opt/splunk/bin/splunk btool  indexes list onboarding --debug | grep repFactor

sudo -H -u splunk /opt/splunk/bin/splunk btool  indexes list <indexname> --debug | grep repFactor




sudo -H -u splunk /opt/splunkforwarder/bin/splunk btool inputs list --debug
sudo -H -u splunk /opt/splunkforwarder/bin/splunk btool authorize list --debug

sudo -H -u splunk /opt/splunkforwarder/bin/splunk btool outputs list --debug
sudo -H -u splunk /opt/splunkforwarder/bin/splunk btool props list --debug
sudo -H -u splunk /opt/splunkforwarder/bin/splunk btool transforms list --debug
sudo -H -u splunk /opt/splunkforwarder/bin/splunk btool indexes list --debug
sudo -H -u splunk /opt/splunkforwarder/bin/splunk btool limits list --debug 
sudo -H -u splunk /opt/splunkforwarder/bin/splunk btool check --debug
sudo -H -u splunk /opt/splunkforwarder/bin/splunk btool server list clustering –debug
sudo -H -u splunk /opt/splunkforwarder/bin/splunk btool server  –debug



Verify the mode of the CM instance in the [clustering] section of server.conf
/opt/splunk/bin/splunk btool server list clustering –debug

Diagnosing

tail -f /opt/splunk/var/log/splunk/splunkd.log
tail -f /opt/splunkforwarder/var/log/splunk/splunkd.log


/opt/splunk/bin/splunk btool server list clustermaster:one --debug


sudo -H -u splunk /opt/splunk/bin/splunk reload deploy-server
sudo -H -u splunk /opt/splunk/bin/splunk display listen
sudo -H -u splunk /opt/splunk/bin/splunk show cluster-status --verbose

sudo killall -9 splunkd


sudo -H -u splunk /opt/splunk/bin/splunk _internal call /services/admin/inputstatus/TailingProcessor:FileStatus

sudo -H -u splunk /opt/splunk/bin/splunk cmd btprobe -d /opt/splunk/var/lib/splunk/fishbucket/splunk_private_db --file --reset
USE WITHOUT --reset if you want to just get info

3) Run one of the following grep commands
find ./etc/ -type f -name "*.conf" -exec grep -iH "\$1\$." {} \;
find ./etc/ -type f -name "*.conf" | xargs grep -iH "\$1\$."
You should get a list of all files which have a password encrypted using the splunk.secret. Examples of this are:


Uninstall SPlunk

sudo -H -u splunk /opt/splunk/bin/splunk stop
sudo /opt/splunk/bin/splunk disable boot-start -user splunk
sudo rm -rf /opt/splunk
sudo killall -9 splunkd


/opt/splunk/bin/splunk validate cluster-bundle

/opt/splunk/bin/splunk apply cluster-bundle --answer-yes


Troubleshooting Suggestions
If the indexer does not appear as a deployment client in the “Forwarder Management” screen, or it looks like
this screenshot, consider the following steps.
Ensure that you have copied apps into the $SPLUNK_HOME/etc/deployment-apps folder of the DS instance,
then visit the Forwarder Management page again.
Double-check that the indexer has been restarted since installing the deployment client app. The following
command should produce a line declaring the role of deployment_client: “grep ServerRoles
$SPLUNK_HOME/var/log/splunk/splunkd.log”.
Use btool to verify that the deployment server URI (in the conf) is correct. The targetUri setting should not
contain a protocol; j


Datamodels

View contents of a DM

| rest splunk_server=local /servicesNS/-/Splunk_SA_CIM/data/models 
| fields title eai:data 
| search title = "DM Name*"
| spath input=eai:data path=objects{}.fields{} output=fields 
| mvexpand fields 
| spath input=fields 
| fields - eai:data fields 


| tstats count AS "Count of Authentication"  from datamodel=Authentication where (nodename = Authentication) groupby Authentication.location.countryOrRegion  prestats=true | stats dedup_splitvals=t count AS "Count of Authentication"  by Authentication.location.countryOrRegion | sort limit=100 -"Count of Authentication" | fields - _span  | rename Authentication.location.countryOrRegion AS countryCode  | fillnull "Count of Authentication" | fields countryCode, "Count of Authentication"

| inputlookup permittedCountries.csv 
| eval permitted = if(Name="United Kingdom" OR Name="Isle of Man" OR Name="Ireland", "Yes", "No") 
| rename Name as country,  Code as countryCode 
| table countryCode country permitted
| outputlookup permittedCountries.csv


Splunk Search for All network traffic
Copy
| datamodel Network_Traffic All_Traffic search | dedup All_Traffic.dest | stats count by All_Traffic.src_ip, All_Traffic.dest,All_Traffic.action

Splunk Search for Successful login after 10 failed attempts
Copy
| from datamodel:"Authentication"."Authentication" | search action=failure OR action=success | streamstats window=0 current=true reset_after="(action=\"success\")" count as failure_count by user | where action="success" and failure_count > 10 | stats values(failure_count) as failure_count by user



Ipv6 regex - ^(([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:))$