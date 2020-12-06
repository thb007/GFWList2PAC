#!/bin/bash

# Current Version: 1.0.6

## How to get and use?
# git clone "https://github.com/hezhijie0327/GFWList2PAC.git" && bash ./GFWList2PAC/release.sh

## Function
# Get Data
function GetData() {
    gfwlist_domain=(
        "https://raw.githubusercontent.com/hezhijie0327/GFWList2AGH/main/gfwlist2agh_gfwlist.txt"
    )
    rm -rf ./gfwlist2pac_* ./Temp && mkdir ./Temp && cd ./Temp
    for gfwlist_domain_task in "${!gfwlist_domain[@]}"; do
        curl -s --connect-timeout 15 "${gfwlist_domain[$gfwlist_domain_task]}" >> ./gfwlist_domain.tmp
    done
}
# Analyse Data
function AnalyseData() {
    gfwlist_data=($(cat ./gfwlist_domain.tmp | grep "\[\|\]" | sed "s/https\:\/\/dns\.alidns\.com\:443\/dns\-query//g;s/https\:\/\/dns\.pub\:443\/dns\-query//g;s/https\:\/\/doh\.opendns\.com\:443\/dns\-query//g;s/tls\:\/\/dns\.alidns\.com\:853//g;s/tls\:\/\/dns\.google\:853//g;s/tls\:\/\/dns\.pub\:853//g;s/\[\///g;s/\/\]//g;s/\//\n/g" | sort | uniq | awk "{ print $2 }"))
}
# Generate Information
function GenerateInformation() {
    gfwlist2pac_checksum=$(date "+%s" | base64)
    gfwlist2pac_expires="3 hours (update frequency)"
    gfwlist2pac_homepage="https://github.com/hezhijie0327/GFWList2PAC"
    gfwlist2pac_timeupdated=$(date -d @$(echo "${gfwlist2pac_checksum}" | base64 -d) "+%Y-%m-%dT%H:%M:%S%:z")
    gfwlist2pac_title="Zhijie's GFWList"
    gfwlist2pac_version=$(cat ../release.sh | grep "Current\ Version" | sed "s/\#\ Current\ Version\:\ //g")-$(date -d @$(echo "${gfwlist2pac_checksum}" | base64 -d) "+%Y%m%d")-$((10#$(date -d @$(echo "${gfwlist2pac_checksum}" | base64 -d) "+%H") / 3))
    function gfwlist2pac_autoproxy() {
        echo "[AutoProxy 0.2.9]" > ../gfwlist2pac_autoproxy.txt
        echo "! Checksum: ${gfwlist2pac_checksum}" >> ../gfwlist2pac_autoproxy.txt
        echo "! Title: ${gfwlist2pac_title} for Auto Proxy" >> ../gfwlist2pac_autoproxy.txt
        echo "! Version: ${gfwlist2pac_version}" >> ../gfwlist2pac_autoproxy.txt
        echo "! TimeUpdated: ${gfwlist2pac_timeupdated}" >> ../gfwlist2pac_autoproxy.txt
        echo "! Expires: ${gfwlist2pac_expires}" >> ../gfwlist2pac_autoproxy.txt
        echo "! Homepage: ${gfwlist2pac_homepage}" >> ../gfwlist2pac_autoproxy.txt
    }
    function gfwlist2pac_clash() {
        echo "payload:" > ../gfwlist2pac_clash.yaml
        echo "# Checksum: ${gfwlist2pac_checksum}" >> ../gfwlist2pac_clash.yaml
        echo "# Title: ${gfwlist2pac_title} for Clash" >> ../gfwlist2pac_clash.yaml
        echo "# Version: ${gfwlist2pac_version}" >> ../gfwlist2pac_clash.yaml
        echo "# TimeUpdated: ${gfwlist2pac_timeupdated}" >> ../gfwlist2pac_clash.yaml
        echo "# Expires: ${gfwlist2pac_expires}" >> ../gfwlist2pac_clash.yaml
        echo "# Homepage: ${gfwlist2pac_homepage}" >> ../gfwlist2pac_clash.yaml
    }
    function gfwlist2pac_surge() {
        echo "# Checksum: ${gfwlist2pac_checksum}" >> ../gfwlist2pac_surge.yaml
        echo "# Title: ${gfwlist2pac_title} for Surge" >> ../gfwlist2pac_surge.yaml
        echo "# Version: ${gfwlist2pac_version}" >> ../gfwlist2pac_surge.yaml
        echo "# TimeUpdated: ${gfwlist2pac_timeupdated}" >> ../gfwlist2pac_surge.yml
        echo "# Expires: ${gfwlist2pac_expires}" >> ../gfwlist2pac_surge.yaml
        echo "# Homepage: ${gfwlist2pac_homepage}" >> ../gfwlist2pac_surge.yaml
    }
    function gfwlist2pac_quantumult() {
        echo "# Checksum: ${gfwlist2pac_checksum}" >> ../gfwlist2pac_quantumult.txt
        echo "# Title: ${gfwlist2pac_title} for Quantumult" >> ../gfwlist2pac_quantumult.txt
        echo "# Version: ${gfwlist2pac_version}" >> ../gfwlist2pac_quantumult.txt
        echo "# TimeUpdated: ${gfwlist2pac_timeupdated}" >> ../gfwlist2pac_quantumult.txt
        echo "# Expires: ${gfwlist2pac_expires}" >> ../gfwlist2pac_quantumult.txt
        echo "# Homepage: ${gfwlist2pac_homepage}" >> ../gfwlist2pac_quantumult.txt
    }
    gfwlist2pac_autoproxy
    gfwlist2pac_clash
    gfwlist2pac_surge
    gfwlist2pac_quantumult
}
# Output Data
function OutputData() {
    GenerateInformation
    for gfwlist_data_task in "${!gfwlist_data[@]}"; do
        echo "||${gfwlist_data[gfwlist_data_task]}" >> ../gfwlist2pac_autoproxy.txt
        echo "  - DOMAIN-SUFFIX,${gfwlist_data[gfwlist_data_task]}" >> ../gfwlist2pac_clash.yaml
        echo "DOMAIN-SUFFIX,${gfwlist_data[gfwlist_data_task]}" >> ../gfwlist2pac_surge.yaml
        echo "DOMAIN-SUFFIX,${gfwlist_data[gfwlist_data_task]},PROXY" >> ../gfwlist2pac_quantumult.txt
    done
    cd .. && rm -rf ./Temp
    exit 0
}
## Process
# Call GetData
GetData
# Call AnalyseData
AnalyseData
# Call OutputData
OutputData
