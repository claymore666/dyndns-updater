# dyndns-updater
bash updater script to work with ddnss.de or any other dyndns protocol


Changes to be made for the scripts to work:
* ddnss.url & caller.url file
this url consists of the following keys:
key     your update key found in ddnss.de in the dashbaord
host    your subdomain you are trying to update
ip      DO NOT EDIT. It'll be changed automatically
ip6     DO NOT EDIT. It'll be changed automatically


Known issues:
- script exits gracefully without error message when IPv6 is not enabled/ available
