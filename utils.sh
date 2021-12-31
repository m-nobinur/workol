#! /bin/bash
#

# No color
NC="\033[0m"

# _rp $CHAR $NUMBER => Prints CHAR $NUMBER times.
#   (ex: _rp 10 =) will print '=' 10 times.
function _rp(){
    printf "$2%.0s" {1..$1}
}

# _center $TEXT $CHAR(optional) => Centered given text
#   (ex: _center HELLO_WORLD =)
# default will use space as filler charecter.
function _center() {
     [[ $# == 0 ]] && return 1

     declare -i COLS="$(tput cols)"
     declare -i str_len="${#1}"
     [[ $str_len -ge $COLS ]] && {
          echo "$1";
          return 0;
     }

     declare -i filler_len="$(( (COLS - str_len) / 2 ))"
     [[ $# -ge 2 ]] && ch="${2:0:1}" || ch=" "
     filler=""
     for (( i = 0; i < filler_len - 1; i++ )); do
          filler="${filler}${ch}"
     done

     printf "%s%s%s" "$filler" "$1" "$filler"
     [[ $(( (TERM_COLS - str_len) % 2 )) -ne 0 ]] && printf "%s" "${ch}"
     printf "\n"

     return 0
}

# _color $COLOR_INDEX $TEXT => Prints colored text.
# 1: BLUE; 2: GREEN; 3: CYAN; 4: PURPLE
function _color(){
    BLUE='\e[0;34m'
    GREEN='\e[0;32m'
    CYAN='\e[0;36m'
    PURPLE='\e[0;35m'

    COLORS=($BLUE $GREEN $CYAN $PURPLE)

    echo $COLORS[$1] $2 $NC
}

# _rgreet => Prints random greetings based on time. (take no param)
function _rgreet(){
    morning=("🌞 Good Morning" "🌞 Guten Morgen" "🌞 Rise and Shine" "🌞 Top of the Morning")
    day=("🌕 Guten Tag" "🌙 Good Day" "🌙 Howdy" "🌙 Buenos dias")
    evening=("🌃 Good evening" "🌃 Nice to see you" "🌃 Hellooooo" "🌃 Happy seeing you here")
    
    hour=`date +%H`
    index=$((RANDOM % 5))
    ((index++))
    
    if [ $hour -le 12 ]; then
        echo $morning[$index]
    elif [ $hour -ge 18 ]; then
        echo $day[$index]
    else
        echo $evening[$index]
    fi
}

# __pname $filename => Prints ascii name from given file
function __pname(){
    while IFS= read -r line; do    
        [[ "$line" =~ [^[:space:]] ]] && _center "$line"
    done < $1
}

# _greet $msg1 $msg2 ... => Prints center aligned greetings
function _greet(){
    GREET=$(_rgreet)
    _center "=" "="
    printf '\e[0;35m'; _center $GREET; printf "\033[0m";
    __pname ~/.local/share/workol/ascii_name.txt
    _center "----------------------------------------"
    if [[ $# -ne 0 ]]; then
        printf "\e[0;32m"
        for greet_word in $@;do
            _center $greet_word
        done
        printf "\033[0m"
    fi   
    _center "=" "="
}
