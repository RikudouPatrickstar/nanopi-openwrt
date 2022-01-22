#!/bin/bash

echo 'ShellClash'

pushd package/base-files/files
  mkdir -p etc/clash
  mkdir -p etc/clash/ui
  mkdir -p etc/init.d
  shellclash_version=$(curl -sL https://api.github.com/repos/juewuy/ShellClash/releases/latest | grep tag_name | sed 's/.* "//;s/".*//')
  pushd etc/clash
    ## 脚本及 Clash Premium Core
    svn co https://github.com/juewuy/ShellClash/tags/${shellclash_version}/scripts .
    rm -fr .svn clash.service clashservice
    wget https://github.com/RikudouPatrickstar/ShellClash/raw/patch-2/scripts/clashservice -q -O clashservice
    wget https://github.com/juewuy/ShellClash/raw/${shellclash_version}/bin/clashpre/clash-linux-armv8 -q -O clash
    chmod 777 *
    ## 启动文件
    mv clashservice ../init.d/clash
    ## 地址库
    wget https://github.com/juewuy/ShellClash/raw/master/bin/Country.mmdb -q -O Country.mmdb
    ## 控制面板
    wget https://github.com/juewuy/ShellClash/raw/master/bin/clashdb.tar.gz -q -O clashdb.tar.gz
    tar -zxvf clashdb.tar.gz -C ui
    sed -i "s/127.0.0.1/192.168.24.1/g" ui/assets/*.js
    sed -i "s/9090/9999/g" ui/assets/*.js
    rm clashdb.tar.gz
    ## 创建相关文件
    touch log mac mark
    ## 配置标记文件
    echo "versionsh_l=${shellclash_version}" >> mark
    echo "update_url=https://cdn.jsdelivr.net/gh/juewuy/ShellClash@master" >> mark
    echo "userguide=1" >> mark
    echo "redir_mod=混合模式" >> mark
    echo "clashcore=clashpre" >> mark
    echo "hostdir=':9999/ui'" >> mark
    echo "dns_nameserver='https://223.5.5.5/dns-query, https://doh.pub/dns-query, tls://dns.rubyfish.cn:853'" >> mark
    echo "dns_fallback='https://1.0.0.1/dns-query, https://8.8.4.4/dns-query, https://doh.opendns.com/dns-query'" >> mark
    echo "cpucore=armv8" >> mark
    ## 清理
    rm -fr ShellClash
  popd
  ## 设置环境变量
  echo 'alias clash="sh /etc/clash/clash.sh"' >> etc/profile
  echo 'export clashdir="/etc/clash"' >> etc/profile
popd

exit 0