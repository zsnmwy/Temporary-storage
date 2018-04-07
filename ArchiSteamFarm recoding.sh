#!/usr/bin/env bash

#support system :
#Tencent Debian 8.2 /Debian 9 /centos 7.0 /Ubuntu server 14.04.1 LTS 64bit/Ubuntu 16.04.1 LTS
#Vultr Debian 8 / centos 7 /Ubuntu 14.04 x64 /Ubuntu 16.04.3 LTS
: <<infomation
PRETTY_NAME="Debian GNU/Linux 8 (jessie)"
NAME="Debian GNU/Linux"
VERSION_ID="8"
VERSION="8 (jessie)"
ID=debian
HOME_URL="http://www.debian.org/"
SUPPORT_URL="http://www.debian.org/support/"
BUG_REPORT_URL="https://bugs.debian.org/"

PRETTY_NAME="Debian GNU/Linux 9 (stretch)"
NAME="Debian GNU/Linux"
VERSION_ID="9"
VERSION="9 (stretch)"
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"


NAME="CentOS Linux"
VERSION="7 (Core)"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="7"
PRETTY_NAME="CentOS Linux 7 (Core)"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:centos:centos:7"
HOME_URL="https://www.centos.org/"
BUG_REPORT_URL="https://bugs.centos.org/"

CENTOS_MANTISBT_PROJECT="CentOS-7"
CENTOS_MANTISBT_PROJECT_VERSION="7"
REDHAT_SUPPORT_PRODUCT="centos"
REDHAT_SUPPORT_PRODUCT_VERSION="7"

Ubuntu 16.04.1 LTS
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
CentOS
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

Debian
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
infomation

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/opt/ArchiSteamFarm:/opt/Manage_ArchiSteamFarm:/root/.nvm/versions/node/v8.11.1/bin
export PATH
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
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"

source /etc/os-release
VERSION=$(echo ${VERSION} | awk -F "[()]" '{print $2}')
bit=$(uname -m)

jq_file="/usr/bin/jq"
ArchiSteamFarm_files="/opt/ArchiSteamFarm"

Qcloud_source() {
	echo -e "国内机子要启用，国外机子不用管"
	echo -e "是否启用七牛云源?[Y/n]"
	stty erase '^H' && read -p "(默认: N):" qcloud_enable_yn
	[[ -z "${qcloud_enable_yn}" ]] && ssr_enable_yn="n"
	if [[ "${qcloud_enable_yn}" == [Yy] ]]; then
		qcloud_enable="1"
	else
		echo "不使用七牛云源"
	fi
}

Github_hosts() {
	echo -e "是否重定向GitHub服务器？[Y/n]"
	stty erase '^H' && read -p "(默认:N):" github_re_direct_yn
	[[ -z "${github_re_direct_yn}" ]] && github_re_direct_yn="n"
	if [[ "${github_re_direct_yn}" == [Yy] ]]; then
		cat >>/etc/hosts <<EOF
219.76.4.4 github-cloud.s3.amazonaws.com
EOF
	else
		echo "不修改hosts"
	fi
}

Check_system_bit() {
	if [[ ${bit} == 'x86_64' ]]; then
		echo -e "${OK} ${GreenBG} 符合脚本的系统位数要求 64位 ${Font}"
	elif [[ ${bit} == 'armv7l' ]]; then
		echo -e "${Info} ${GreenBG} 检测处理器为32位 可能是官方不更新系统导致的  请确保处理器为64位${Font}"
	elif [[ ${bit} == 'armv8' ]]; then
		echo -e "${OK} ${GreenBG} 符合脚本的系统位数要求 64位 ${Font}"
	else
		echo -e "${Error} ${RedBG} 请更换为Linux64位系统 推荐Ubuntu 16.04 ${Font}"
		exit 1
	fi
}

Check_system_Install_NetCore() {
	echo -e "${ID}"
	echo -e "${VERSION_ID}"
	if [[ "${ID}" == "centos" && ${VERSION_ID}="7" ]]; then
		## centos7
		echo "这里是centos7的配置"
		echo "这里是centos7的配置"
		echo "这里是centos7的配置"
		echo "这里是centos7的配置"
		echo -e "${OK} ${GreenBG} 当前系统为 Centos ${VERSION_ID} ${VERSION} ${Font} "
		Steam_information_account_Get
		Steam_information_password_Get
		INS="yum"
		rpm --import https://packages.microsoft.com/keys/microsoft.asc
		sh -c 'echo -e "[packages-microsoft-com-prod]\nname=packages-microsoft-com-prod \nbaseurl=https://packages.microsoft.com/yumrepos/microsoft-rhel7.3-prod\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/dotnetdev.repo'
		yum update -y
		yum install -y unzip curl libunwind libicu wget unzip screen
		yum install -y dotnet-sdk-2.0.0
		export PATH=$PATH:$HOME/dotnet
		dotnet --version
	elif [[ "${ID}" == "debian" && ${VERSION_ID} == "8" ]]; then
		## Debian 8
		echo "这里是Debian8的配置"
		echo "这里是Debian8的配置"
		echo "这里是Debian8的配置"
		echo "这里是Debian8的配置"
		echo "这里是Debian8的配置"
		echo -e "${OK} ${GreenBG} 当前系统为 Debian ${VERSION_ID} ${Font} "
		Steam_information_account_Get
		Steam_information_password_Get
		INS="apt-get"
		apt-get update
		apt-get install -y curl libunwind8 gettext apt-transport-https wget unzip screen
		curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
		mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
		sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-jessie-prod jessie main" > /etc/apt/sources.list.d/dotnetdev.list'
		apt-get update
		apt-get install dotnet-sdk-2.0.0 -y
		export PATH=$PATH:$HOME/dotnet
		dotnet --version
	elif [[ "${ID}" == "debian" && ${VERSION_ID} == "9" ]]; then
		## Debian 9
		echo "这里是Debian9的配置"
		echo "这里是Debian9的配置"
		echo "这里是Debian9的配置"
		echo "这里是Debian9的配置"
		echo "这里是Debian9的配置"
		echo -e "${OK} ${GreenBG} 当前系统为 Debian ${VERSION_ID} ${Font} "
		Steam_information_account_Get
		Steam_information_password_Get
		INS="apt-get"
		apt-get update
		apt-get install -y curl libunwind8 gettext apt-transport-https wget unzip screen
		curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
		mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
		sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/dotnetdev.list'
		apt-get update
		apt-get install dotnet-sdk-2.0.0 -y
		export PATH=$PATH:$HOME/dotnet
		dotnet --version
	elif [[ "${ID}" == "ubuntu" && $(echo "${VERSION_ID}") -eq 17.10 ]]; then
		## Ubuntu 17.10
		echo "这里是Ubuntu 17.10的配置"
		echo "这里是Ubuntu 17.10的配置"
		echo "这里是Ubuntu 17.10的配置"
		echo "这里是Ubuntu 17.10的配置"
		echo -e "${OK} ${GreenBG} 当前系统为 Ubuntu ${VERSION_ID} ${VERSION} ${Font} "
		Steam_information_account_Get
		Steam_information_password_Get
		INS="apt-get"
		apt-get update
		apt-get install curl wget unzip screen
		curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
		mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
		sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-artful-prod artful main" > /etc/apt/sources.list.d/dotnetdev.list'
		apt-get update
		apt-get install dotnet-sdk-2.1.4 -y
		dotnet --version
	elif [[ "${ID}" == "ubuntu" && $(echo "${VERSION_ID}") -eq 17.04 ]]; then
		## Ubuntu 17.04
		echo "这里是Ubuntu 17.04的配置"
		echo "这里是Ubuntu 17.04的配置"
		echo "这里是Ubuntu 17.04的配置"
		echo "这里是Ubuntu 17.04的配置"
		echo "这里是Ubuntu 17.04的配置"
		echo -e "${OK} ${GreenBG} 当前系统为 Ubuntu ${VERSION_ID} ${VERSION} ${Font} "
		Steam_information_account_Get
		Steam_information_password_Get
		INS="apt-get"
		apt-get update
		apt-get install curl wget unzip screen
		curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
		mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
		sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-zesty-prod zesty main" > /etc/apt/sources.list.d/dotnetdev.list'
		apt-get update
		apt-get install dotnet-sdk-2.1.4 -y
		dotnet --version
	elif [[ "${ID}" == "ubuntu" && $(echo "${VERSION_ID}" | cut -d '.' -f1) -eq 16 ]]; then
		## Ubuntu 16
		echo "这里是Ubuntu 16的配置"
		echo "这里是Ubuntu 16的配置"
		echo "这里是Ubuntu 16的配置"
		echo "这里是Ubuntu 16的配置"
		echo -e "${OK} ${GreenBG} 当前系统为 Ubuntu ${VERSION_ID} ${VERSION} ${Font} "
		Steam_information_account_Get
		Steam_information_password_Get
		INS="apt-get"
		apt-get update
		apt-get install curl wget unzip screen
		curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
		mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
		sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
		apt-get update
		apt-get install dotnet-sdk-2.1.4 -y
		dotnet --version
	elif [[ "${ID}" == "ubuntu" && $(echo "${VERSION_ID}" | cut -d '.' -f1) -eq 14 ]]; then
		## Ubuntu 14
		echo "这里是Ubuntu 14的配置"
		echo "这里是Ubuntu 14的配置"
		echo "这里是Ubuntu 14的配置"
		echo "这里是Ubuntu 14的配置"
		echo "这里是Ubuntu 14的配置"
		echo -e "${OK} ${GreenBG} 当前系统为 Ubuntu ${VERSION_ID} ${VERSION} ${Font} "
		Steam_information_account_Get
		Steam_information_password_Get
		INS="apt-get"
		apt-get update
		apt-get install curl wget unzip screen
		curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
		mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
		sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-trusty-prod trusty main" > /etc/apt/sources.list.d/dotnetdev.list'
		apt-get update
		apt-get install dotnet-sdk-2.1.4 -y
		dotnet --version
	elif [[ "${ID}" == "raspbian" && $(echo "${VERSION_ID}") -eq 9 ]]; then
		echo -e "${OK} ${GreenBG} 当前系统为 ${ID} ${VERSION_ID} ${Font} "
		Steam_information_account_Get
		Steam_information_password_Get
		Raspberry_Pi_Install
	elif [[ "${ID}" == "raspbian" && $(echo "${VERSION_ID}") -eq 8 ]]; then
		echo -e "${OK} ${GreenBG} 当前系统为 ${ID} ${VERSION_ID} ${Font} "
		Steam_information_account_Get
		Steam_information_password_Get
		Raspberry_Pi_Install
	else
		echo -e "${Error} ${RedBG} 当前系统为 ${ID} ${VERSION_ID} 不在支持的系统列表内，安装中断 ${Font} "
		exit 1
	fi
}

#These steps have been tested on a RPi 2 and RPi 3 with Linux and Windows.

#Note: Pi Zero is not supported because the .NET Core JIT depends on armv7 instructions not available on Pi Zero.

Raspberry_Pi_Install_ArchiSteamFarm() {
	if [[ ! -e ${ArchiSteamFarm_files} ]]; then
		while true; do
			apt-get update
			apt-get install wget unzip -y
			mkdir /tmp/
			if [[ ${qcloud_enable} == "1" ]]; then
				wget --no-check-certificate -P /tmp/ -O ArchiSteamFarm.zip http://p2feur8d9.bkt.clouddn.com/ASF-linux-arm.zip
			else
				wget --no-check-certificate -P /tmp/ -O ArchiSteamFarm.zip https://github.com/JustArchi/ArchiSteamFarm/releases/download/3.1.1.1/ASF-linux-arm.zip

			fi
			if [[ -e /root/ArchiSteamFarm.zip ]]; then
				cd /tmp/
				echo -e "下载完成"
				unzip -d ${ArchiSteamFarm_files} /tmp/ArchiSteamFarm.zip
				rm /tmp/ArchiSteamFarm.zip
				cd ${ArchiSteamFarm_files}
				chmod 755 ./ArchiSteamFarm
				echo -e "\n ${Info} ArchiSteamFarm-arm 安装完成，继续..."
				break
			else
				echo -e "\n ArchiSteamFarm-arm 下载失败 重新下载"
			fi
		done
	else
		echo -e "\n ${Info} ArchiSteamFarm 已安装，继续..."
	fi
}

Raspberry_Pi_Install_Dotnet() {
	while true; do
		wget --no-check-certificate -P /root/ https://dotnetcli.blob.core.windows.net/dotnet/Runtime/master/dotnet-runtime-latest-linux-arm.tar.gz
		if [[ -e /root/dotnet-runtime-latest-linux-arm.tar.gz ]]; then
			cd /root
			mkdir -p /opt/dotnet
			tar zxf dotnet-runtime-latest-linux-arm.tar.gz -C /opt/dotnet
			ln -s /opt/dotnet/dotnet /usr/local/bin
			rm dotnet-runtime-latest-linux-arm.tar.gz
			echo -e "安装dotnet 完成"
			break
		else
			echo -e "\n dotnet下载失败 重新下载"
		fi
	done
}

# 检测root用户
Is_root() {
	if [ $(id -u) == 0 ]; then
		echo -e "${OK} ${GreenBG} 当前用户是root用户，进入安装流程 ${Font} "
		sleep 3
	else
		echo -e "${Error} ${RedBG} 当前用户不是root用户，请使用${Green_background_prefix} sudo su ${Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码） ${Font}"
		exit 1
	fi
}

Install_nvm_node_V8.11.1_PM2() {
	${INS} update
	${INS} install wget -y
	wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash #This install nvm
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
	nvm install 8.11.1                                                 # This install node v8.11.1
	node -v                                                            # Show node version
	npm i -g nrm                                                       # Use npm install nrm
	nrm use taobao                                                     # Registry set to: https://registry.npm.taobao.org/
	npm i -g pm2                                                       # This install pm2
}

JQ_install() {
	if [[ ! -e ${jq_file} ]]; then
		while true; do
			if [[ ${bit} == "x86_64" ]]; then
				cd /root/
				if [[ ${qcloud_enable} == "1" ]]; then
					wget --no-check-certificate -P /root/ -O jq http://p2feur8d9.bkt.clouddn.com/jq-linux64
				else
					wget --no-check-certificate -P /root/ -O jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
				fi
			else
				exit 1
			fi
			if [[ -e /root/jq ]]; then
				chmod +x ./jq
				mv jq /usr/bin
				source ~/.bashrc
				echo -e "\n ${Info} JQ解析器 安装完成，继续..."
				break
			else
				echo -e "\n JQ解析器 下载失败 重新下载"
			fi
		done
	else
		echo -e "\n ${Info} JQ解析器 已安装，继续..."
	fi
}

Get_steamcommunity_ip() {
	curl 'https://cloudflare-dns.com/dns-query?ct=application/dns-json&name=steamcommunity.com&type=A' | jq -r '.Answer[0].data'
}

Add_hosts_steamcommunity() {
	Check_hosts=$(cat /etc/hosts | grep steamcommunity.com)
	if [[ ! ${Check_hosts} ]]; then
		echo -e "准备修改hosts"
		cat >>/etc/hosts <<EOF
IPAddress steamcommunity.com
EOF
		echo -e "sed修改hosts"
		sed -i -e 's#IPAddress#'"$(echo $(Get_steamcommunity_ip))"'#g' /etc/hosts
		cat /etc/hosts | grep steamcommunity.com
	else
		get_ip=$(cat /etc/hosts | grep steamcommunity.com | cut -d ' ' -f 1)
		echo "${get_ip}"
		sed -i -e 's#'"$(echo ${get_ip})"'#'"$(echo $(Get_steamcommunity_ip))"'#' /etc/hosts
		echo "已经更新hosts"
		cat /etc/hosts | grep steamcommunity.com
	fi

}

Add_cron_update_hosts_steamcommunity() {
	wget --no-check-certificate https://github.com/zsnmwy/Temporary-storage/releases/download/V0.5/Add_cron_update_hosts_steamcommunity.sh
	chmod 777 Add_cron_update_hosts_steamcommunity.sh
	mv Add_cron_update_hosts_steamcommunity.sh /etc/cron.hourly
	echo "Add Update-hosts-steamcommunity.sh"
}

Remove_hosts_log_week() {
	wget --no-check-certificate https://github.com/zsnmwy/Temporary-storage/releases/download/V0.5/Remove_hosts_log_week.sh
	chmod 777 Remove_hosts_log_week.sh
	mv Remove_hosts_log_week.sh /etc/cron.weekly
	echo "Add Remove_hosts_log_week.sh"
}

ArchiSteamFarm_Install() {
	while true; do
		echo -e "获取 ArchiSteamFarm 最新稳定版"
		if [[ ${qcloud_enable} == "1" ]]; then
			wget --no-check-certificate -P /root/ -O ArchiSteamFarm.zip http://p2feur8d9.bkt.clouddn.com/ASF-generic.zip
		else
			wget --no-check-certificate -P /root/ -O ArchiSteamFarm.zip $(curl -s https://api.github.com/repos/JustArchi/ArchiSteamFarm/releases/latest | jq -r '.assets[0].browser_download_url')
		fi

		if [[ -e /root/ArchiSteamFarm.zip ]]; then
			echo -e "下载完成 开始解压"
			unzip -o -d ${ArchiSteamFarm_files} /root/ArchiSteamFarm.zip
			echo -e "解压完成"
			rm /root/ArchiSteamFarm.zip
			break
		else
			echo -e "网络超时 下载失败 重新下载"
		fi
	done
}

# 设置ArchiSteamFarm为简体中文
ArchiSteamFarm_json_English_change_to_zh-CN() {
	cd ${ArchiSteamFarm_files}/config
	cat >${ArchiSteamFarm_files}/config/ASF.json <<EOF
{
	"AutoRestart": true,
	"BackgroundGCPeriod": 0,
	"Blacklist": [],
	"ConfirmationsLimiterDelay": 10,
	"ConnectionTimeout": 60,
	"CurrentCulture": "zh-CN",
	"Debug": false,
	"FarmingDelay": 15,
	"GiftsLimiterDelay": 1,
	"Headless": false,
	"IdleFarmingPeriod": 8,
	"InventoryLimiterDelay": 3,
	"IPCPassword": null,
	"IPCPrefixes": [
		"http://127.0.0.1:1242/"
	],
	"LoginLimiterDelay": 10,
	"MaxFarmingTime": 10,
	"MaxTradeHoldDuration": 15,
	"OptimizationMode": 0,
	"Statistics": true,
	"SteamOwnerID": 0,
	"SteamProtocols": 1,
	"UpdateChannel": 1,
	"UpdatePeriod": 24
}
EOF
}

# 获取用户的steam账号
Steam_information_account_Get() {
	while true; do
		#clear
		echo -e "\n"
		read -p "输入你的steam账号名：" Steam_account_first
		echo -e "\n"
		read -p "再次输入你的steam账号名：" Steam_account_second
		if [[ ${Steam_account_first} == ${Steam_account_second} ]]; then
			break
		else
			echo -e "${Error} 两次输入的账号名称不正确 ! 三秒后重新输入"
			sleep 3
		fi
	done
}

# 获取用户的steam密码
Steam_information_password_Get() {
	while true; do
		#clear
		echo -e "\n"
		read -s -p "输入你的steam密码：" Steam_account_password_first
		echo -e "\n"
		read -s -p "再次输入你的steam密码：" Steam_account_password_second
		if [[ ${Steam_account_password_first} == ${Steam_account_password_second} ]]; then
			break
		else
			echo -e "${Error} 两次输入的密码不正确 ! 三秒后重新输入"
			sleep 3
		fi
	done
}

# 添加一个机器人/BOT 配置文件名为账户名
Bot_Add() {
	echo -e "准备添加BOT"
	touch ${ArchiSteamFarm_files}/config/${Steam_account_second}.json
	cat >${ArchiSteamFarm_files}/config/${Steam_account_second}.json <<EOF
{
  "SteamLogin": "Steam_account_account_second",
  "SteamPassword": "Steam_account_password_second",
  "Enabled": true
}
EOF
	sed -i 's/Steam_account_account_second/'"$(echo ${Steam_account_second})"'/' ${ArchiSteamFarm_files}/config/${Steam_account_second}.json
	sed -i 's/Steam_account_password_second/'"$(echo ${Steam_account_password_second})"'/' ${ArchiSteamFarm_files}/config/${Steam_account_second}.json
	echo -e "添加BOT完成"
}

Add_start_script_pm2_bash() {
	mkdir -p /opt/Manage_ArchiSteamFarm
	touch /opt/Manage_ArchiSteamFarm/ArchiSteamFarm.sh
	cd /opt/Manage_ArchiSteamFarm
	chmod 777 ArchiSteamFarm.sh
	cat >/opt/Manage_ArchiSteamFarm/ArchiSteamFarm.sh <<EOF
#!/usr/bin/env bash
PATH=/opt/ArchiSteamFarm:/usr/bin
export PATH
cd /opt/ArchiSteamFarm
dotnet ArchiSteamFarm.dll
EOF
}

Add_start_pm2_yaml() {
	mkdir -p /opt/Manage_ArchiSteamFarm
	touch /opt/Manage_ArchiSteamFarm/ArchiSteamFarm.yaml
	cat >/opt/Manage_ArchiSteamFarm/ArchiSteamFarm.yaml <<EOF
apps:
  - script   : "ArchiSteamFarm.sh"
    name     : "ArchiSteamFarm"
    instances: 2
    exec_mode: fork
    cwd      : "/opt/Manage_ArchiSteamFarm"
    watch    : false
    interpreter: "/bin/bash"
    env      :
      NODE_ENV: /opt/ArchiSteamFarm:/opt/ArchiSteamFarm:/usr/bin
EOF
}

Manage_ArchiSteamFarm_start() {
	pm2 start ArchiSteamFarm.sh
}

Manage_ArchiSteamFarm_start_ls() {
	pm2 start ArchiSteamFarm.sh
	pm2 ls
}

Manage_ArchiSteamFarm_stop() {
	pm2 stop ArchiSteamFarm
}

Manage_ArchiSteamFarm_delete() {
	pm2 delete ArchiSteamFarm
}

Manage_ArchiSteamFarm_screen_start() {
	screen -U -S bash ArchiSteamFarm.sh
}

Manage_ArchiSteamFarm_log() {
	pm2 logs ArchiSteamFarm
}

ArchiSteamFarm_get_pm2id() {
	ArchiSteamFarm_get_id_pm2=$(pm2 id ArchiSteamFarm | cut -d " " -f2)
}

menu_status_ArchiSteamFarm() {
	if [[ -e ${ArchiSteamFarm_files} ]]; then
		ArchiSteamFarm_get_pm2id
		if [[ -n ${ArchiSteamFarm_get_id_pm2} ]]; then
			ArchiSteamFarm_status=$(pm2 show ArchiSteamFarm | grep status | awk -F ' ' '{print $4}')
			echo "${ArchiSteamFarm_status}"
			if [[ "$ArchiSteamFarm_status" == "online" ]]; then
				echo -e " ${Red_font_prefix}ArchiSteamFarm${Font_color_suffix} 当前状态: ${Green_font_prefix}已安装${Font_color_suffix} 并 ${Green_font_prefix}已启动${Font_color_suffix} (已经由PM2管理)"
			elif [[ "$ArchiSteamFarm_status" == "stopped" ]]; then
				echo -e " ${Red_font_prefix}ArchiSteamFarm${Font_color_suffix} 当前状态: ${Red_font_prefix}已安装${Font_color_suffix} 并 ${Green_font_prefix}未启动${Font_color_suffix} (已经由PM2管理)"
			elif [[ "$ArchiSteamFarm_status" == "errored" ]]; then
				echo -e " ${Red_font_prefix}错误${Font_color_suffix} ArchiSteamFarm出错 \n 请重载ArchiSteamFarm \n 或在管理移除ArchiSteamFarm后再次加入 \n 实在不行就去提issue"
			fi
		else
			echo -e "${Red_font_prefix}ArchiSteamFarm${Font_color_suffix} 当前状态: ${Red_font_prefix}未加入PM2管理${Font_color_suffix}"
		fi
	else
		echo -e " ${Red_font_prefix}ArchiSteamFarm${Font_color_suffix} 当前状态: ${Red_font_prefix}未安装${Font_color_suffix}"
	fi
}

Source_bash() {
	source ~/.bashrc
	. ~/.bashrc
	bash
	echo "source ~/.bashrc succeed"
}

Raspberry_Pi_Install() {
	Raspberry_Pi_Install_Dotnet
	Raspberry_Pi_Install_ArchiSteamFarm
	Install_nvm_node_V8.11.1_PM2
	Add_hosts_steamcommunity
	Steam_information_account_Get
	Steam_information_password_Get
	Bot_Add
	ArchiSteamFarm_json_English_change_to_zh-CN
}

General_install() {
	Is_root
	Check_system_bit
	Qcloud_source
	Github_hosts
	Check_system_Install_NetCore
	Install_nvm_node_V8.11.1_PM2
	JQ_install
	Add_hosts_steamcommunity
	ArchiSteamFarm_Install
	Bot_Add
	ArchiSteamFarm_json_English_change_to_zh-CN
	#Add_start_pm2_yaml
	Add_start_script_pm2_bash
	Add_cron_update_hosts_steamcommunity
	Remove_hosts_log_week
	Source_bash
	cd ~
}
#General_install

Manage_ArchiSteamFarm_Panel() {
	echo -e "
1.start
2.stop
3.delete
4.monit
5.log
6.screen
"
	read aNumber
	case $aNumber in
	1)
		Manage_ArchiSteamFarm_start
		;;
	2)
		Manage_ArchiSteamFarm_stop
		;;
	3)
		Manage_ArchiSteamFarm_delete
		;;
	4)
		pm2 monit
		;;
	5)
		Manage_ArchiSteamFarm_log
		;;
	6)
		Manage_ArchiSteamFarm_screen_start
		;;
	*)
		exit 0
		;;
	esac
}

echo -e "
1.安装
2.管理
"
menu_status_ArchiSteamFarm
read aNumber
case $aNumber in
1)
	General_install
	;;
2)
	Manage_ArchiSteamFarm_Panel
	;;
*)
	exit 0
	;;
esac
