#!/usr/bin/env bash

# fonts color
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"

# notification information
Info="${Green}[信息]${Font}"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"

Is_root() {
    if [ $(id -u) == 0 ]; then
        echo -e "${OK} ${GreenBG} 当前用户是root用户，进入安装流程 ${Font} "
    else
        echo -e "${Error} ${RedBG} 当前用户不是root用户 退出脚本 ${Font}"
        exit 1
    fi
}

#检测安装完成或失败
judge(){
    if [[ $? -eq 0 ]];then
        echo -e "${OK} ${GreenBG} $1 完成 ${Font}"
        sleep 1
    else
        echo -e "${Error} ${RedBG} $1 失败${Font}"
        exit 1
    fi
}


Get_steamcommunity_ip(){
    curl 'https://cloudflare-dns.com/dns-query?ct=application/dns-json&name=steamcommunity.com&type=A' | cut -d '"' -f34
    if [ $? -eq 1 ]
    then
        echo "${Error} ${RedBG} 从Cloudflare获取社区IP地址失败 ${Font}"
        exit 1
    fi
}

Add_hosts_steamcommunity() {
    Check_hosts=$(cat /etc/hosts | grep steamcommunity.com)
    if [[ ! ${Check_hosts} ]]; then
        echo -e "没有发现steam社区IP,准备增加到/etc/hosts"
        echo "$(echo $(Get_steamcommunity_ip)) steamcommunity.com" >> /etc/hosts
        judge "写入IP 到 /etc/hosts"
        ip_address=$(cat /etc/hosts | grep steamcommunity.com)
        echo -e "${Info} ${GreenBG} ${ip_address} ${Font}"
    else
        get_ip=$(cat /etc/hosts | grep steamcommunity.com | cut -d ' ' -f 1)
        echo "${get_ip}"
        sed -i -e 's#'"$(echo ${get_ip})"'#'"$(echo $(Get_steamcommunity_ip))"'#' /etc/hosts
        judge "使用sed修改社区IP地址"
        echo "已经更新hosts"
        cat /etc/hosts | grep steamcommunity.com
    fi
    
}

Add_cron_update_hosts_steamcommunity() {
    while true; do
        if [ -e /etc/cron.hourly/Add_cron_update_hosts_steamcommunity.sh ]
        then
            echo "已经存在 Add_cron_update_hosts_steamcommunity.sh 跳过"
            break
        else
            echo -e "${Info} ${GreenBG} 尝试获取steamcommunity hosts 更新脚本 ${Font}"
            wget --no-check-certificate https://raw.githubusercontent.com/zsnmwy/Temporary-storage/master/Add_cron_update_hosts_steamcommunity.sh
            if [[ -e Add_cron_update_hosts_steamcommunity.sh ]]; then
                chmod 777 Add_cron_update_hosts_steamcommunity.sh
                mv Add_cron_update_hosts_steamcommunity.sh /etc/cron.hourly
                echo -e "${OK} ${GreenBG}  Add Update-hosts-steamcommunity.sh ${Font}"
                break
            else
                echo -e "${Error} ${RedBG} 网络超时 下载失败 重新下载 ${Font}"
                sleep 10
            fi
        fi
        
    done
}

Remove_hosts_log_week() {
    while true; do
        if [ -e /etc/cron.weekly/Remove_hosts_log_week.sh ]
        then
            echo "已经存在 Remove_hosts_log_week.sh"
            break
        else
            echo -e "${Info} ${GreenBG} 尝试获取remove hosts log 脚本 ${Font}"
            wget --no-check-certificate https://raw.githubusercontent.com/zsnmwy/Temporary-storage/master/Remove_hosts_log_week.sh
            if [[ -e Remove_hosts_log_week.sh ]]; then
                chmod 777 Remove_hosts_log_week.sh
                mv Remove_hosts_log_week.sh /etc/cron.weekly
                echo -e "${OK} ${GreenBG}  Add Remove_hosts_log_week.sh ${Font}"
                break
            else
                echo -e "${Error} ${RedBG} 网络超时 下载失败 重新下载 ${Font}"
                sleep 10
            fi
        fi
        
    done
}

Is_root
Add_hosts_steamcommunity
Add_cron_update_hosts_steamcommunity
Remove_hosts_log_week