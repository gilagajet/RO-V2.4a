#!/bin/bash
#=================================================
# File name: init-settings.sh
# Description: This script will be executed during the first boot
# Author: gilagajet
# Contact: t.me/gilagajet
#=================================================

# Disable autostart by default for some packages
#rm -f /etc/rc.d/S99dockerd || true
#rm -f /etc/rc.d/S99dockerman || true
rm -f /etc/rc.d/S30stubby || true
rm -f /etc/rc.d/S90stunnel || true

# Check file system during boot
uci set fstab.@global[0].check_fs=1
uci commit

# Disable opkg signature check
sed -i 's/option check_signature/# option check_signature/g' /etc/opkg.conf

#-----------------------------------------------------------------------------

# Set hostname to OpenWRT
uci set system.@system[0].hostname='OpenWRT'

# Set Timezone to Asia/KL
uci set system.@system[0].timezone='MYT-8'
uci set system.@system[0].zonename='Asia/Kuala Lumpur'

uci set system.@system[0].cronloglevel="9"
uci set system.@system[0].conloglevel='4'
#uci set system.@system[0].zram_size_mb='16'
uci set system.@system[0].zram_comp_algo='lz4'

uci commit system

#-----------------------------------------------------------------------------

# Add IP Address Info Checker
# run "myip" using terminal for use
chmod +x /bin/myip

#-----------------------------------------------------------------------------

# Set Custom TTL (cat /proc/sys/net/ipv4/ip_default_ttl)
#cat << 'EOF' >> /etc/firewall.user
#iptables -t mangle -A POSTROUTING -j TTL --ttl-set 65
#EOF
#/etc/config/firewall restart
echo | tee -a /etc/sysctl.conf
echo '# TTL' | tee -a /etc/sysctl.conf
echo "net.ipv4.ip_default_ttl=65" >> /etc/sysctl.conf 
echo "net.ipv6.ip_default_ttl=65" >> /etc/sysctl.conf 

#fix
echo | tee -a /etc/config/firewall
echo "config include" | tee -a /etc/config/firewall
echo "	option path '/etc/firewall.user'" | tee -a /etc/config/firewall
echo "	option fw4_compatible '1'" | tee -a /etc/config/firewall	
echo | tee -a /etc/config/firewall

echo "iptables -t mangle -A PREROUTING -j TTL --ttl-set 65" | tee -a /etc/firewall.user
echo "nft add rule inet fw4 mangle_forward oifname usb0 ip ttl set 65" | tee -a /etc/firewall.user
echo "nft add rule inet fw4 mangle_forward oifname wan ip ttl set 65" | tee -a /etc/firewall.user
echo "nft add rule inet fw4 mangle_forward oifname wlan0 ip ttl set 65" | tee -a /etc/firewall.user
echo "nft add rule inet fw4 mangle_forward oifname wlan1 ip ttl set 65" | tee -a /etc/firewall.user


/etc/init.d/firewall restart


#-----------------------------------------------------------------------------

# LuCI -> System -> Terminal (a.k.a) luci-app-ttyd without login
if ! grep -q "/bin/login -f root" /etc/config/ttyd; then
	cat << "EOF" > /etc/config/ttyd
config ttyd
	option interface '@lan'
	option command '/bin/login -f root'
EOF
	logger "  log : Terminal ttyd patched..."
	echo -e "  log : Terminal ttyd patched..."
fi
#-----------------------------------------------------------------------------

# Tweak1
chmod 755 /etc/crontabs/root
echo '# Clear PageCache' | tee -a /etc/crontabs/root
echo '0 */2 * * * sync; echo 1 > /proc/sys/vm/drop_caches' | tee -a /etc/crontabs/root
echo | tee -a /etc/crontabs/root
echo '# Ping Loop' | tee -a /etc/crontabs/root
echo '* * * * * ping 8.8.8.8' | tee -a /etc/crontabs/root
echo | tee -a /etc/crontabs/root
echo '# Stop Ping Flood' | tee -a /etc/crontabs/root
echo "* * * * * pgrep ping | awk 'NR >= 3' | xargs -n1 kill" | tee -a /etc/crontabs/root
echo | tee -a /etc/crontabs/root
echo '# Clear Log' | tee -a /etc/crontabs/root
echo "*/15 * * * * /etc/init.d/log restart >/dev/null 2>&1" | tee -a /etc/crontabs/root

# Tweak2
echo | tee -a /etc/sysctl.conf
echo '# increase Linux autotuning TCP buffer limit to 32MB' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_rmem=4096 87380 33554432' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_wmem=4096 65536 33554432' | tee -a /etc/sysctl.conf
echo | tee -a /etc/sysctl.conf
echo '# recommended for hosts with jumbo frames enabled' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_mtu_probing=1' | tee -a /etc/sysctl.conf
echo | tee -a /etc/sysctl.conf
echo '# Others' | tee -a /etc/sysctl.conf
echo 'fs.file-max=1000000' | tee -a /etc/sysctl.conf
echo 'fs.inotify.max_user_instances=8192' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_tw_reuse=1' | tee -a /etc/sysctl.conf
echo 'net.ipv4.ip_local_port_range=1024 65000' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_max_syn_backlog=1024' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_fin_timeout=15' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_keepalive_intvl=30' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_keepalive_probes=5' | tee -a /etc/sysctl.conf
echo 'net.netfilter.nf_conntrack_tcp_timeout_time_wait=30' | tee -a /etc/sysctl.conf
echo 'net.netfilter.nf_conntrack_tcp_timeout_fin_wait=30' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_synack_retries=3' | tee -a /etc/sysctl.conf

# Tweak3
echo | tee -a /etc/sysctl.conf
echo '# experimental' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_congestion_control=bbr' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_timestamps=0' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_frto=1' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_sack=0' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_dsack=0' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_fastopen=3' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_pacing_ca_ratio=160' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_pacing_ss_ratio=200' | tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_no_metrics_save=1' | tee -a /etc/sysctl.conf

#-----------------------------------------------------------------------------

#Passwall Template for Malaysian
rm -r /usr/share/passwall/0_default_config
sleep 1

cat <<'EOF' >>/usr/share/passwall/0_default_config

config global
	option enabled '0'
	option socks_enabled '0'
	option tcp_node 'nil'
	option udp_node 'tcp'
	option dns_mode 'dns2tcp'
	option remote_dns '9.9.9.9'
	option filter_proxy_ipv6 '0'
	option tcp_proxy_mode 'global'
	option udp_proxy_mode 'global'
	option localhost_tcp_proxy_mode 'default'
	option localhost_udp_proxy_mode 'default'
	option close_log_tcp '0'
	option close_log_udp '0'
	option loglevel 'warning'
	option trojan_loglevel '2'

config global_haproxy
	option balancing_enable '0'

config global_delay
	option auto_on '0'
	option start_daemon '1'
	option start_delay '2'

config global_forwarding
	option tcp_no_redir_ports 'disable'
	option udp_no_redir_ports 'disable'
	option tcp_proxy_drop_ports 'disable'
	option udp_proxy_drop_ports 'disable'
	option tcp_redir_ports '1:65535'
	option udp_redir_ports '1:65535'
	option accept_icmp '0'
	option tcp_proxy_way 'redirect'
	option ipv6_tproxy '0'
	option sniffing '1'
	option route_only '0'

config global_other
	option nodes_ping 'auto_ping tcping'

config global_rules
	option auto_update '0'
	option chnlist_update '0'
	option chnroute_update '0'
	option chnroute6_update '0'
	option gfwlist_update '0'
	option geosite_update '0'
	option geoip_update '0'
	option v2ray_location_asset '/usr/share/v2ray/'

config global_app
	option v2ray_file '/usr/bin/v2ray'
	option xray_file '/usr/bin/xray'
	option trojan_go_file '/usr/bin/trojan-go'
	option brook_file '/usr/bin/brook'
	option hysteria_file '/usr/bin/hysteria'

config global_subscribe
	option subscribe_proxy '0'
	option filter_keyword_mode '1'
	option allowInsecure '1'

config auto_switch
	option enable '0'
	option testing_time '1'
	option connect_timeout '3'
	option retry_num '3'
	option shunt_logic '1'

config shunt_rules 'AD'
	option remarks 'AD'
	option domain_list 'geosite:category-ads-all'

config shunt_rules 'BT'
	option remarks 'BT'
	option protocol 'bittorrent'

EOF
sleep 1

#-----------------------------------------------------------------------------

#Update System Info
rm -r /www/luci-static/resources/view/status/include/10_system.js

cat << 'EOF' >> /www/luci-static/resources/view/status/include/10_system.js
'use strict';
'require baseclass';
'require fs';
'require rpc';
var callSystemBoard = rpc.declare({
	object: 'system',
	method: 'board'
});
var callSystemInfo = rpc.declare({
	object: 'system',
	method: 'info'
});
return baseclass.extend({
	title: _('System'),
	load: function() {
		return Promise.all([
			L.resolveDefault(callSystemBoard(), {}),
			L.resolveDefault(callSystemInfo(), {}),
			fs.lines('/usr/lib/lua/luci/version.lua')
		]);
	},
	render: function(data) {
		var boardinfo   = data[0],
		    systeminfo  = data[1],
		    luciversion = data[2];
		luciversion = luciversion.filter(function(l) {
			return l.match(/^\s*(luciname|luciversion)\s*=/);
		}).map(function(l) {
			return l.replace(/^\s*\w+\s*=\s*['"]([^'"]+)['"].*$/, '$1');
		}).join(' ');
		var datestr = null;
		if (systeminfo.localtime) {
			var date = new Date(systeminfo.localtime * 1000);
			datestr = '%04d-%02d-%02d %02d:%02d:%02d'.format(
				date.getUTCFullYear(),
				date.getUTCMonth() + 1,
				date.getUTCDate(),
				date.getUTCHours(),
				date.getUTCMinutes(),
				date.getUTCSeconds()
			);
		}
		// Source-Link Start
		var projectlink = document.createElement('a');
		projectlink.append(boardinfo.release.description);
		projectlink.href = 'https://t.me/openwrtuser0';
		projectlink.target = '_blank';
		var corelink = document.createElement('a');
		corelink.append('Shopee');
		corelink.href = 'http://shp.ee/n8yf7jf';
		corelink.target = '_blank';
		var sourcelink = document.createElement('placeholder');
		sourcelink.append(projectlink);
		sourcelink.append(' | ');
		sourcelink.append(corelink);
		// Source-Link End
		var fields = [
			_('Hostname'),         boardinfo.hostname,
			_('Model'),            boardinfo.model,
			_('Architecture'),     boardinfo.system,
			_('Target Platform'),  (L.isObject(boardinfo.release) ? boardinfo.release.target : ''),
			_('Firmware Version'), sourcelink,
			_('Kernel Version'),   boardinfo.kernel,
			_('Local Time'),       datestr,
			_('Uptime'),           systeminfo.uptime ? '%t'.format(systeminfo.uptime) : null,
			_('Load Average'),     Array.isArray(systeminfo.load) ? '%.2f, %.2f, %.2f'.format(
				systeminfo.load[0] / 65535.0,
				systeminfo.load[1] / 65535.0,
				systeminfo.load[2] / 65535.0
			) : null,
		];
		var table = E('table', { 'class': 'table' });
		for (var i = 0; i < fields.length; i += 2) {
			table.appendChild(E('tr', { 'class': 'tr' }, [
				E('td', { 'class': 'td left', 'width': '33%' }, [ fields[i] ]),
				E('td', { 'class': 'td left' }, [ (fields[i + 1] != null) ? fields[i + 1] : '?' ])
			]));
		}
		return table;
	}
});
EOF

sleep 1

uci commit system
/etc/init.d/system reload

#-----------------------------------------------------------------------------

# Disable IPv6
uci set 'network.lan.ipv6=0'
uci set 'network.wan.ipv6=0'
uci set 'dhcp.lan.dhcpv6=disabled'

/etc/init.d/odhcpd stop
/etc/init.d/odhcpd disable

uci set network.lan.delegate="0"

uci -q delete network.globals.ula_prefix

uci -q delete dhcp.lan.dhcpv6
uci -q delete dhcp.lan.ra

uci -q delete dhcp.lan.ra_slaac
uci -q delete dhcp.lan.ndp
uci -q delete dhcp.lan.ra_flags

uci delete network.wan6

uci commit
/etc/init.d/network restart

#-----------------------------------------------------------------------------

# VNStat Data Folder
rm -r /etc/config/vnstat

cat << 'EOF' >> /etc/config/vnstat
config vnstat
        list interface 'br-lan'
EOF

mkdir /vnstat
sed -i 's/;DatabaseDir "\/var\/lib\/vnstat"/DatabaseDir "\/vnstat"/g' /etc/vnstat.conf

#-----------------------------------------------------------------------------

exit 0

# cat /etc/sysctl.d/* | grep -v '^#'
