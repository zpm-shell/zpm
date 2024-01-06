#!/usr/bin/env bash

version_name=$1


# update the version name in the zpm-package.json5 file
zpm_package_file="zpm-package.json5"
new_conf=$(cat ${zpm_package_file} | \
    sed -E "s/version:.*$/version: \"${version_name}\"/g" )

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