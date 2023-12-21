# =================================================================== #
#                                                                     #
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>                 #
# Copyright (c) 2022 SolomonRicky <http://firmware.download.yzyz.ga>  #
#                                                                     #
# This is free software, licensed under the GNU GPLv3 License.        #
# See /LICENSE for more information.                                  #
#                                                                     #
# =================================================================== #

###Base

# Modify default IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# Enable WiFi Interface
sed -i 's/wireless.radio${devidx}.disabled=1/wireless.radio${devidx}.disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# Version Update
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='GilaGajet build $(TZ=UTC+8 date "+%Y.%m") '" >> package/base-files/files/etc/openwrt_release
sed -i '/DISTRIB_REVISION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_REVISION='[OpenWRT v22.03.5]'" >> package/base-files/files/etc/openwrt_release

# Update TimeZone
sed -i 's/0.openwrt.pool.ntp.org/time.google.com/g' package/base-files/files/bin/config_generate
sed -i 's/1.openwrt.pool.ntp.org/time.cloudflare.com/g' package/base-files/files/bin/config_generate
sed -i 's/2.openwrt.pool.ntp.org/clock.sjc.he.net/g' package/base-files/files/bin/config_generate
sed -i 's/3.openwrt.pool.ntp.org/my.pool.ntp.org/g' package/base-files/files/bin/config_generate

###Extra

#upx
#git clone --depth=1 https://github.com/kuoruan/openwrt-upx.git /workdir/openwrt/staging_dir/host/bin/upx


###Script
#wget https://raw.githubusercontent.com/gilagajet/gen/xray-latest/import_feeds.sh
#chmod +x import_feeds.sh
#./import_feeds.sh

########################################################################################

# Update and Install Feeds
./scripts/feeds update -a
./scripts/feeds install -a



#git clone -b packages --depth 1 https://github.com/xiaorouji/openwrt-passwall passwall_pkg
#git clone -b luci --depth 1 https://github.com/miaozilong/openwrt-passwall passwall_luci
#git clone -b master --depth 1 https://github.com/fw876/helloworld ssrp


# Dependencies

svn export https://github.com/quango-web/openwrt-passwall/trunk/brook feeds/packages/net/brook
svn export https://github.com/quango-web/openwrt-passwall/trunk/chinadns-ng feeds/packages/net/chinadns-ng
svn export https://github.com/quango-web/openwrt-passwall/trunk/dns2socks feeds/packages/net/dns2socks
svn export https://github.com/quango-web/openwrt-passwall/trunk/dns2tcp feeds/packages/net/dns2tcp
svn export https://github.com/quango-web/openwrt-passwall/trunk/hysteria feeds/packages/net/hysteria

svn export https://github.com/fw876/helloworld/trunk/ipt2socks feeds/packages/net/ipt2socks

svn export https://github.com/quango-web/openwrt-passwall/trunk/microsocks feeds/packages/net/microsocks
svn export https://github.com/quango-web/openwrt-passwall/trunk/naiveproxy feeds/packages/net/naiveproxy
svn export https://github.com/quango-web/openwrt-passwall/trunk/pdnsd-alt feeds/packages/net/pdnsd-alt
svn export https://github.com/quango-web/openwrt-passwall/trunk/sagernet-core feeds/packages/net/sagernet-core
svn export https://github.com/quango-web/openwrt-passwall/trunk/shadowsocks-rust feeds/packages/net/shadowsocks-rust
svn export https://github.com/quango-web/openwrt-passwall/trunk/shadowsocksr-libev feeds/packages/net/shadowsocksr-libev
svn export https://github.com/quango-web/openwrt-passwall/trunk/simple-obfs feeds/packages/net/simple-obfs
svn export https://github.com/quango-web/openwrt-passwall/trunk/sing-box feeds/packages/net/sing-box
svn export https://github.com/quango-web/openwrt-passwall/trunk/ssocks feeds/packages/net/ssocks
svn export https://github.com/quango-web/openwrt-passwall/trunk/tcping feeds/packages/net/tcping
svn export https://github.com/quango-web/openwrt-passwall/trunk/trojan-go feeds/packages/net/trojan-go
svn export https://github.com/quango-web/openwrt-passwall/trunk/trojan-plus feeds/packages/net/trojan-plus
svn export https://github.com/quango-web/openwrt-passwall/trunk/trojan feeds/packages/net/trojan
svn export https://github.com/quango-web/openwrt-passwall/trunk/v2ray-core feeds/packages/net/v2ray-core
svn export https://github.com/quango-web/openwrt-passwall/trunk/v2ray-geodata feeds/packages/net/v2ray-geodata
svn export https://github.com/quango-web/openwrt-passwall/trunk/v2ray-plugin feeds/packages/net/v2ray-plugin

svn export https://github.com/arqam999/openwrt-passwall/branches/xtls-175-mp/xray-core feeds/packages/net/xray-core

svn export https://github.com/quango-web/openwrt-passwall/trunk/xray-plugin feeds/packages/net/xray-plugin

svn export https://github.com/immortalwrt/packages/trunk/net/shadowsocks-libev feeds/packages/net/shadowsocks-libev

svn export https://github.com/fw876/helloworld/trunk/lua-neturl feeds/packages/net/lua-neturl
svn export https://github.com/immortalwrt/packages/trunk/net/redsocks2 feeds/packages/net/redsocks2
svn export https://github.com/immortalwrt/packages/trunk/net/https-dns-proxy feeds/packages/net/https-dns-proxy
svn export https://github.com/immortalwrt/packages/trunk/net/kcptun feeds/packages/net/kcptun

git clone -b master --depth 1 https://github.com/jerrykuku/lua-maxminddb.git feeds/packages/net/lua-maxminddb
svn export https://github.com/coolsnowwolf/lede/trunk/package/lean/shortcut-fe package/kernel/shortcut-fe
svn export https://github.com/immortalwrt/packages/trunk/net/dnsforwarder feeds/packages/net/dnsforwarder

# luci-app-cpufreq
svn export -r 19495 https://github.com/immortalwrt/luci/trunk/applications/luci-app-cpufreq feeds/luci/applications/luci-app-cpufreq

# luci-app-openclash
git clone --single-branch --depth 1 -b dev https://github.com/vernesong/OpenClash.git feeds/luci/applications/luci-app-openclash

# luci-app-passwall
#svn export https://github.com/solomonricky/openwrt-passwall/branches/luci-nodns/luci-app-passwall feeds/luci/applications/luci-app-passwall
svn export https://github.com/miaozilong/openwrt-passwall/branches/luci/luci-app-passwall feeds/luci/applications/luci-app-passwall

# luci-app-passwall2
svn export https://github.com/xiaorouji/openwrt-passwall2/trunk/luci-app-passwall2 feeds/luci/applications/luci-app-passwall2

# luci-app-ramfree
svn export https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-ramfree feeds/luci/applications/luci-app-ramfree

#luci-app-turboacc
#svn export https://github.com/immortalwrt/luci/trunk/applications/luci-app-turboacc feeds/luci/applications/luci-app-turboacc

# luci-app-vssr
git clone -b master --depth 1 https://github.com/jerrykuku/luci-app-vssr.git feeds/luci/applications/luci-app-vssr

# luci-app-zerotier
svn export https://github.com/immortalwrt/luci/branches/master/applications/luci-app-zerotier feeds/luci/applications/luci-app-zerotier

# IPv6 Helper
svn export https://github.com/immortalwrt/immortalwrt/trunk/package/emortal/ipv6-helper package/addon/ipv6-helper

# Update and Install Feeds
./scripts/feeds update -a
./scripts/feeds install -a -f
