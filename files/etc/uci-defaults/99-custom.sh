#!/bin/sh
# ImmortalWrt 首次启动初始化脚本（uci-defaults）
# 此脚本在固件首次启动时自动执行一次，执行后自动删除。
# 注意：__ROOT_PW_HASH__ 占位符在 CI 编译时被替换为真实的 sha512-crypt 哈希。

# 1. 设置 root 密码（明文 passwd）
ROOT_HASH='__ROOT_PW_HASH__'
if grep -q '^root:' /etc/shadow 2>/dev/null; then
  sed -i "s#^root:[^:]*#root:${ROOT_HASH}#" /etc/shadow
else
  echo "root:${ROOT_HASH}:0:0:99999:7:::" >> /etc/shadow
fi

# 2. 设置时区为中国标准时间
uci set system.@system[0].zonename='Asia/Shanghai'
uci set system.@system[0].timezone='CST-8'
uci delete system.ntp.server
uci add_list system.ntp.server='ntp.aliyun.com'
uci add_list system.ntp.server='ntp.tencent.com'
uci commit system

# 3. 设置主机名
uci set system.@system[0].hostname='ImmortalWrt'
uci commit system

# 4. LAN IP 已在 /etc/config/network 中固定为 192.168.10.1

exit 0
