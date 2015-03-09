import json
import urllib2

rh = [(rack, host) for rack in [10,11] for host in ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20"]]
num_success_3000=0
for (rack,host) in rh:
    s='http://host{host}-rack{rack}.scale.openstack.engineering.redhat.com:3000'.format(host=host,rack=rack)
    try:
        #print(s)
        urllib2.urlopen(s)
        #print(s+ " success")
        num_success_3000 = num_success_3000+1;
    except urllib2.URLError:
        pass
print "num succesies {n}".format(n=num_success_3000);
