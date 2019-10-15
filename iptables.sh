#!/bin/bash

IFACE=eth0
VIRFACE=virbr0
LXCFACE=lxcbr0
VIRNET=192.168.122.0/24

iptables -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT -m state --state INVALID -j DROP
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -A INPUT -p icmp -j ACCEPT

#ssh
iptables -A INPUT -i $IFACE -p tcp --dport 22 -j ACCEPT
#web
#iptables -A INPUT -i $IFACE -p tcp -m multiport --dports 80,443 -j ACCEPT
#wok
iptables -A INPUT -i $IFACE -p tcp --dport 8001 -j ACCEPT
#onlyo
iptables -A INPUT -i $IFACE -p tcp --dport 8180 -j ACCEPT
#samba
iptables -A INPUT -i $IFACE -p tcp -m multiport --dports 139,445 -j ACCEPT
#minidlna
#iptables -A INPUT -i $IFACE -p udp --dport 1900 -j ACCEPT
#iptables -A INPUT -i $IFACE -p tcp --dport 8200 -j ACCEPT
#transmission
#iptables -A INPUT -i $IFACE -p tcp --dport 9091 -j ACCEPT
#

#virbr input
#iptables -A INPUT -i $VIRFACE -p udp --dport 53 -j ACCEPT
#iptables -A INPUT -i $VIRFACE -p tcp --dport 53 -j ACCEPT
#iptables -A INPUT -i $VIRFACE -p udp --dport 67 -j ACCEPT
#iptables -A INPUT -i $VIRFACE -p tcp --dport 67 -j ACCEPT

#lxcbr input
#iptables -A INPUT -i $LXCFACE -p udp --dport 53 -j ACCEPT
#iptables -A INPUT -i $LXCFACE -p tcp --dport 53 -j ACCEPT
#iptables -A INPUT -i $LXCFACE -p udp --dport 67 -j ACCEPT
#iptables -A INPUT -i $LXCFACE -p tcp --dport 67 -j ACCEPT

#virbr forward
#iptables -A FORWARD -o $VIRFACE -d $VIRNET -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#iptables -A FORWARD -i $VIRFACE -s $VIRNET -j ACCEPT
#iptables -A FORWARD -i $VIRFACE -s $VIRNET -j ACCEPT


# connections from outside
iptables -I FORWARD -o $VIRFACE -d  192.168.122.245 -j ACCEPT
iptables -t nat -I PREROUTING -p tcp --dport 9867 -j DNAT --to 192.168.122.245:22

# Masquerade local subnet
#iptables -t nat -A POSTROUTING -o $IFACE -s VIRNET -j MASQUERADE
#iptables -A FORWARD -o $VIRFACE -m state --state RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD -i $VIRFACE -o $IFACE -j ACCEPT
#iptables -A FORWARD -i $VIRFACE -o lo -j ACCEPT




iptables-save  > /etc/iptables/rules.v4
#ip6tables-save > /etc/iptables/rules.v6

