#!/usr/bin/env zpm

import ./log.zsh --as log
import ./ref.zsh --as self

function init() {
  call self.clean_ref_garbage_cache_dir 
}

_get_cache_dir() {
  local _refCacheDir="${ZPM_DIR}/runtime/cache/refVariableCache/$$"
  if [[ ! -d ${_refCacheDir} ]]; then
    mkdir -p "${_refCacheDir}"
  fi

  echo "${_refCacheDir}"
}

##
# clean the garbage of the cache directory
# @use clean_ref_garbage_cache_dir
##
function clean_ref_garbage_cache_dir() {
  local pidList=($(ps au | awk 'NR==1{for(i=1;i<=NF;i++)if($i=="PID")col=i;next}{print $col}' | tr '\n' ' '))
  typeset -A pidArray=()
  for pid in ${pidList[@]}; do
   pidArray[$pid]=1
  done

  # get all pid used reference variable
  local refCacheDir=$(dirname $(call self._get_cache_dir))
  local refUsedPidList=($(ls ${refCacheDir}))
  for refUsedPid in "${refUsedPidList[@]}"; do
    if [[ ! -v pidArray[$refUsedPid] ]]; then
      call log.debug "clean ref cache dir: ${refUsedPid}"
      rm -rf "${refCacheDir}/${refUsedPid}"
    fi
  done
}


##
# get new ref name
# @use get_new_ref_name <ref name> <preFile>
# @echo <new ref name>
_get_new_ref_name() {
  local refName=$1
  local preFile=$2
  local cacheDir=$(call self._get_cache_dir)
  local refNameNO=$( ls "${cacheDir}" | grep "${refName}" | wc -l )
  # remove the space chars in string
  refNameNO="${refNameNO##*( )}"
  refNameNO=$((refNameNO + 1))
  local newRefName="${refName}_${refNameNO}"
  echo "${preFile}" >> "${cacheDir}/${newRefName}"
  echo "pid: $$" >> "${cacheDir}/${newRefName}"
  for trace in "${funcfiletrace[@]}"; do
    echo "${trace}" >> "${cacheDir}/${newRefName}"
  done

  echo "${newRefName}"
}


##
# This file contains the functions that are used to generate unique variable names
# @Use generate_unique_var_name
# @Echo "<unique var name>"
##
function  create() {
  local prev_file_line="${funcfiletrace[2]}"
  local preNumberLine=''
  local prefFile=''
  local isPathChart=${TRUE}
  for (( i = 0; i < ${#prev_file_line[@]}; i++)); do
    local chart=${prev_file_line:${i}:1}
    if [[ ${chart} == ':' ]]; then
      isPathChart=${FALSE}
      continue
    elif [[ ${isPathChart} -eq ${TRUE} ]]; then
      prefFile="${prefFile}${chart}"
    else
      preNumberLine="${preNumberLine}${chart}"
    fi
  done

  # remove the prefix of the APP_BASE_PATH in the ${prefFile}.
  if [[ ${#prefFile} -gt ${#APP_BASE_PATH} ]]; then
    local appBasePathLen=${#APP_BASE_PATH}
    local prefixPath=${prefFile:0:${appBasePathLen}}
    if [[ "${prefixPath}" == "${APP_BASE_PATH}" ]]; then
      prefFile=${prefFile:${appBasePathLen} + 1}
    fi
  fi

  # to get current file
  # Replace '/' with '_' and '.' with '_'
  prefFile="${prefFile//\//_}"
  prefFile="${prefFile//\./_}"
  if [[ "${prefFile:0:1}" =~ [0-9] ]]; then
    # Replace the first character with '_'
    prefFile="_${prefFile:1}"
  fi
  local refName="${prefFile}_${preNumberLine}"
  call self._get_new_ref_name "${refName}" "${prev_file_line}"
}