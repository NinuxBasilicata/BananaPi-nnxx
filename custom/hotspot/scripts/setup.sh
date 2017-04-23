#!/bin/sh

# Configura rete hotspot
uci delete network.hotspot
uci set network.hotspot=interface
uci set network.hotspot.proto=static
uci set network.hotspot.ipaddr=192.168.20.1
uci set network.hotspot.netmask=255.255.255.0

# Configura hotspot Wi-Fi
uci delete wireless.hotspot
uci set wireless.hotspot=wifi-iface
uci set wireless.hotspot.device=radio0
uci set wireless.hotspot.mode=ap
uci set wireless.hotspot.network=hotspot
uci set wireless.hotspot.ssid=ninux.org-public
uci set wireless.hotspot.encryption=none
uci set wireless.hotspot.wds=1

# Configura il DHCP per la rete hotspot
uci delete dhcp.hotspot
uci set dhcp.hotspot=dhcp
uci set dhcp.hotspot.interface=hotspot
uci set dhcp.hotspot.start=50
uci set dhcp.hotspot.limit=200
uci set dhcp.hotspot.leasetime=1h

# Configura il firewall per la rete hotspot
## Configura la zona hotspot
uci delete firewall.hotspot_zone
uci set firewall.hotspot_zone=zone
uci set firewall.hotspot_zone.name=hotspot
uci set firewall.hotspot_zone.network=hotspot
uci set firewall.hotspot_zone.input=REJECT
uci set firewall.hotspot_zone.forward=REJECT
uci set firewall.hotspot_zone.output=ACCEPT
## Abilita hotspot -> Internet
uci delete firewall.hotspot_forwarding
uci set firewall.hotspot_forwarding=forwarding
uci set firewall.hotspot_forwarding.src=hotspot
uci set firewall.hotspot_forwarding.dest=wan
## Abilita DNS hotspot -> Router
uci delete firewall.hotspot_rule_dns
uci set firewall.hotspot_rule_dns=rule
uci set firewall.hotspot_rule_dns.name='Allow DNS Queries'
uci set firewall.hotspot_rule_dns.src=hotspot
uci set firewall.hotspot_rule_dns.dest_port=53
uci set firewall.hotspot_rule_dns.proto=udp
uci set firewall.hotspot_rule_dns.target=ACCEPT
## Abilita DHCP hotspot -> Router
uci delete firewall.hotspot_rule_dhcp
uci set firewall.hotspot_rule_dhcp=rule
uci set firewall.hotspot_rule_dhcp.name='Allow DHCP request'
uci set firewall.hotspot_rule_dhcp.src=hotspot
uci set firewall.hotspot_rule_dhcp.src_port=68
uci set firewall.hotspot_rule_dhcp.dest_port=67
uci set firewall.hotspot_rule_dhcp.proto=udp
uci set firewall.hotspot_rule_dhcp.target=ACCEPT

uci commit
