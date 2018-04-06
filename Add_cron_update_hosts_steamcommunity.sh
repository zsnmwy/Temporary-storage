#!/bin/bash
Get_steamcommunity_ip(){
	curl 'https://cloudflare-dns.com/dns-query?ct=application/dns-json&name=steamcommunity.com&type=A' | jq -r '.Answer[0].data'
}
	get_ip=$(cat /etc/hosts | grep steamcommunity.com | cut -d ' ' -f 1)
	sed -i -e 's#'"$(echo ${get_ip})"'#'"$(echo $(Get_steamcommunity_ip))"'#' /etc/hosts
	echo "[$(date "+%Y-%m-%d %H:%M:%S %u %Z")] 已经更新steamcommunity-hosts" >> /tmp/steamcommunity-hosts.log
	hosts=$(cat /etc/hosts | grep steamcommunity.com)
	echo -e "[$(date "+%Y-%m-%d %H:%M:%S %u %Z")] 当前的steamcommunicty host 是  ${hosts} \n\n" >> /tmp/steamcommunity-hosts.log