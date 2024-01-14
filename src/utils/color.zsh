#!/usr/bin/env zsh

import ./color.zsh --as self

typeset -A -g COLOR_REGISTER=(
    [color]=0
    [background]=""
    [shape]=""
)

function reset() {
    COLOR_REGISTER=(
        [color]=0
        [background]=""
        [shape]=""
    )
}

function shape_normal() {
    COLOR_REGISTER[shape]=0
}

function shape_bold() {
    COLOR_REGISTER[shape]=1
}

function shape_faint() {
    COLOR_REGISTER[shape]=2
}

function shape_italics() {
    COLOR_REGISTER[shape]=3
}

function shape_underlined() {
    COLOR_REGISTER[shape]=4
}

function black(){
    COLOR_REGISTER[color]=30
}

function red(){
    COLOR_REGISTER[color]=31
}

function green(){
    COLOR_REGISTER[color]=32
}

function yellow(){
    COLOR_REGISTER[color]=33
}

function blue(){
    COLOR_REGISTER[color]=34
}

function magenta(){
    COLOR_REGISTER[color]=35
}

function cyan(){
    COLOR_REGISTER[color]=36
}

function light_gray(){
    COLOR_REGISTER[color]=37
}

function gray(){
    COLOR_REGISTER[color]=90
}

function light_red(){
    COLOR_REGISTER[color]=91
}

function light_green(){
    COLOR_REGISTER[color]=92
}

function light_yellow(){
    COLOR_REGISTER[color]=93
}

function light_blue(){
    COLOR_REGISTER[color]=94
}

function light_magenta(){
    COLOR_REGISTER[color]=95
}

function light_cyan(){
    COLOR_REGISTER[color]=96
}

function white(){
    COLOR_REGISTER[color]=97
}

function background_black() {
  COLOR_REGISTER[background]=40
}

function background_red() {
    COLOR_REGISTER[background]=41
}

function background_green() {
    COLOR_REGISTER[background]=42
}

function background_yellow() {
    COLOR_REGISTER[background]=43
}

function background_blue() {
    COLOR_REGISTER[background]=44
}

function background_magenta() {
    COLOR_REGISTER[background]=45
}

function background_cyan() {
    COLOR_REGISTER[background]=46
}

function background_light_gray() {
    COLOR_REGISTER[background]=47
}

function background_gray() {
    COLOR_REGISTER[background]=100
}

function background_light_red() {
    COLOR_REGISTER[background]=101
}

function background_light_green() {
    COLOR_REGISTER[background]=102
}

function background_light_yellow() {
    COLOR_REGISTER[background]=103
}

function background_light_blue() {
    COLOR_REGISTER[background]=104
}

function background_light_magenta() {
    COLOR_REGISTER[background]=105
}

function background_light_cyan() {
    COLOR_REGISTER[background]=106
}

function background_white() {
    COLOR_REGISTER[background]=107
}

##
# @param $1 {string} the text to be printed
##
function print() {
    local text=$1
    local color=${COLOR_REGISTER[color]}
    local colorCode="\e[${color}"
    local background=${COLOR_REGISTER[background]}
    if [[ ${background} != "" ]]; then
        colorCode="${colorCode};${background}"
    fi
    local shape=${COLOR_REGISTER[shape]}
    if [[ ${shape} != "" ]]; then
        colorCode="${colorCode};${shape}"
    fi
    colorCode="\e[${colorCode}m"
    echo -e "${colorCode}${text}\e[0m"
    call self.reset
}