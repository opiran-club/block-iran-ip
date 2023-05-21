# block-iran-ip
## این اسکریپت تمام ترافیک خروجی به IP مقصد ایران شامل اکثر دیتاسنترهای ایران را مسدود می کند.


### install requirments package
```
apt install ufw libapache2-mod-geoip geoip-database -y && a2enmod geoip && apt install geoip-bin -y
```
### open your desire ports

```
ufw allow ssh
ufw allow http
ufw allow https
```
### download ip`s and set the rull to firewall with below command
```
curl -sSL https://www.ipdeny.com/ipblocks/data/countries/ir.zone | awk '{print "sudo ufw deny out from any to " $1}' | bash
```
### at the end enable the firewall 
```
ufw enable
```
