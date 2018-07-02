#!/usr/bin/env bash
Get_steamcommunity_ip(){
    curl 'https://cloudflare-dns.com/dns-query?ct=application/dns-json&name=steamcommunity.com&type=A' | cut -d '"' -f34
    if [ $? -eq 1 ]
    then
        echo "[$(date "+%Y-%m-%d %H:%M:%S %u %Z")] 从Cloudflare获取社区IP地址失败" >> /tmp/steamcommunity-hosts.log
        exit 1
    fi
}
	get_ip=$(cat /etc/hosts | grep steamcommunity.com | cut -d ' ' -f 1)
	if [ ! -n $get_ip ] 
	then
		echo "找不到要替换的IP地址 跳过" >> /tmp/steamcommunity-hosts.log
		exit 1
	fi
	sed -i -e 's#'"$(echo ${get_ip})"'#'"$(echo $(Get_steamcommunity_ip))"'#' /etc/hosts
	if [ $? -eq 1 ] 
	then
		echo "[$(date "+%Y-%m-%d %H:%M:%S %u %Z")] Fail...." >> /tmp/steamcommunity-hosts.log
		exit 1
	fi
	echo "[$(date "+%Y-%m-%d %H:%M:%S %u %Z")] 已经更新steamcommunity-hosts" >> /tmp/steamcommunity-hosts.log
	hosts=$(cat /etc/hosts | grep steamcommunity.com)
	echo -e "[$(date "+%Y-%m-%d %H:%M:%S %u %Z")] 当前的steamcommunicty IP 是  ${hosts} \n\n" >> /tmp/steamcommunity-hosts.log