#!/usr/bin/env bash
##
# This script is used to update the version name in  zpm-package.json and install.sh
# Usage: ./update_version_name.sh <version_name>
# e.g. ./update_version_name.sh 0.0.1
# @auther: wuchuheng<root@wuchuheng.com>
# @date: 2024-01-07 15:41
##

version_name=$1

function error_msg() {
    echo -e "\033[31m$1\033[0m"
    exit 1
}

if [ -z "${version_name}" ]; then
    error_msg "Please input the version name"
fi

# update the version name in the zpm-package.json file
zpm_package_file="zpm-package.json"
new_conf=$(cat ${zpm_package_file} | \
    sed -E "s/version:.*$/version: \"${version_name}\",/g" )

cat > ${zpm_package_file} << EOF
${new_conf}
EOF

# update the version name in the install.sh file
install_file="install.sh"
new_conf=$(cat ${install_file} | \
    sed -E "s/VERSION_NAME=\".*\"/VERSION_NAME=\"${version_name}\"/g" )
cat > ${install_file} << EOF
${new_conf}
EOF

# update the version in bin/zpm file
zpm_file="bin/zpm"
newZpm=$( cat ${zpm_file} | sed -E "s/version: *\"([0-9]+\.[0-9]+\.[0-9]+)\",/version: \"${version_name}\",/" )

cat > ${zpm_file} << EOF
${newZpm}
EOF
