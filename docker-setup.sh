echo -en "\ndocker-setup.sh\n"

echo -en "relayhost = $MTP_RELAY:$MTP_PORT" >> /etc/postfix/main.cf

echo -en "$MTP_RELAY:$MTP_PORT $MTP_USER:$MTP_PASS" > /etc/postfix/sasl_passwd

postmap /etc/postfix/sasl_passwd

# Reference:  /usr/lib/systemd/system/postfix.service
#nohup /usr/sbin/postfix start 2>&1 
#echo "$?"
#echo -en "\npostfix output = \n"
#cat nohup.out

nohup /usr/sbin/postfix start >/tmp/postfix.log 2>&1
tail -f /tmp/postfix.log
