#!/usr/bin/env bash
##
# This script is used to update the version name in  zpm-package.json5 and install.sh
# Usage: ./update_version_name.sh <version_name>
# e.g. ./update_version_name.sh 0.0.1
# @auther: wuchuheng<root@wuchuheng.com>
# @date: 2024-01-07 15:41
##

version_name=$1

# update the version name in the zpm-package.json5 file
zpm_package_file="zpm-package.json5"
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