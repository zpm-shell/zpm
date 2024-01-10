version=$1

red="\033[31m"
noColor="\033[0m"

error_msg() {
    local msg=$1
    echo "${red}${msg}${noColor}" > /dev/stderr
    exit 1;
}

# check the version must be not empty.
if [[ -z $version ]]
then
    error_msg "Version name must not be empty"
fi

# check the version must be valid.
if ! [[ $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
then
    eror_msg "Version name $version does not match the pattern 'X.Y.Z'"
fi


# update the version in the README.md to the new version.like:
# ...
# curl -fsSL https://raw.githubusercontent.com/zpm-shell/zpm/0.0.12/install.sh | bash
#...
 cat  README.md  | \
    sed -E "s/(curl -fsSL https:\/\/raw.githubusercontent.com\/zpm-shell\/zpm\/)[0-9]+\.[0-9]+\.[0-9]+/\1$version/"  > README.md.tmp

mv README.md.tmp README.md