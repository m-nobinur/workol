#! /bin/bash
#
#                                                                    _                _    
#                                          __ __ __  ___      _ _   | |__    ___     | |   
#                                          \ V  V / / _ \    | '_|  | / /   / _ \    | |   
#                                           \_/\_/  \___/   _|_|_   |_\_\   \___/   _|_|_  
#                                         _|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""| 
#                                         "`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-' 
# 
#                                        A CLI tool that remembers workspace and helps to navigate.
#                                           Created by `m-nobinur (Mohammad Nobinur)` @2021
# 

function _check_ws(){
    if [ -d ~/.workspace ]; then
    cd ~/.workspace
    else
        _color 4 "No workspace directory found\!"
        echo -n " Do you want to setup? y/n - "
        read SETUP
        if [[ $SETUP =~ ^[yY]$ ]]; then
            echo "Creating workspace directory at ~/.workspace"
            mkdir ~/.workspace
            cd ~/.workspace
        else
            echo "Run workol again to setup workspace."
        fi
    fi
}

function __work(){
    if [ ! $(pwd | grep '.workspace') ]; then
        _color 3 "You are outside workspace directory."
        echo -n " Want to cd inside workspace? y/n - "
        read CDIN
        if [[ $CDIN =~ ^[yY]$ ]]; then
            cd ~/.workspace
        else
            return 1 2>/dev/null
        fi
    fi
    _greet ">> Welcome to the workspace directory." ">> Let us now make the hands dirty.   "
    while true;do
        if [ ! $(pwd | grep '.workspace') ]; then
            echo
            _rp 38 -
            echo
            _color 4 "Can't cd outside workspace directory."
            _rp 38 -
            cd ~/.workspace
            continue
        fi
        if [ -n "$(find * -type d -maxdepth 0 2>/dev/null)" ];then
            OLD_IFS=$IFS
            IFS=$'\n'
            DIRS=(`ls -d */ | cut -f1 -d'/'`)
            x=1
            count=30
            echo
            _rp 43 =
            echo
            printf "On"
            _color 2 "$(pwd)"
            _rp 43 =
            echo
            echo "🎯 Select a directory from below :"       
            for item in "${DIRS[@]}";do
                j=`expr $count - ${#item[@]}`
                _color 1 ">  [$x] - $(printf '%s\n' "$item") $(printf ' %.0s' {1..$j})"
                ((x++))
            done
            IFS=$OLD_IFS
            _rp 43 =
            echo
            echo -n '\e[0;36m' "👉🏼 Type a number to enter | 'b' to go back | '↩' to start - " $NC
            read SELECTED
            if [[ $SELECTED =~ ^[1-9]+[0-9]*$ ]]; then
                if [ $SELECTED -le "${#DIRS[@]}" -a $SELECTED -ge 1 ]; then
                    echo "You selected $SELECTED"
                    cd $DIRS[$SELECTED]
                    clear
                    _greet "CODE | READ | EAT | SLEEP | REPEAT"
                fi
            elif [[ $SELECTED =~ ^[bB]$ ]]; then
                cd ..
                clear
                _greet "FOCUS | WORK HARD | REPEAT"
                continue
            elif [[ $SELECTED =~ ^[qQ]+$ ]]; then
                    break
            else
                echo
                echo -n '\e[0;32m' "👉🏼 v. Open with VSCode | f. Open with Finder - " $NC
                read CONF
                if [[ $CONF =~ ^[vV]+$ ]]; then
                    if [ ! $(which code) ]; then
                        _color 4 "VSCode is not installed in path.[press cmd+shift+p & type code]"
                        break
                    else
                        code .
                        _color 2 "Opening with VSCode"
                        break
                    fi                
                elif [[ $CONF =~ ^[fF]+$ ]]; then
                    open .
                    _color 2 "Opening with Finder"
                    break
                elif [[ $CONF =~ ^[qQ]+$ ]]; then
                    break
                else
                    echo
                    _color 4 "Invalid input."
                    break
                fi
            fi
        else
            _rp 42 =
            echo
            _color 4 "No further folder to work."
            echo -n '\e[0;32m' "👉🏼 v. Open with VSCode | f. Open with Finder | b. Go back - " $NC
            read CONFIRM
                if [[ $CONFIRM =~ ^[vV]+$ ]]; then
                    if [ ! $(which code) ]; then
                        _color 4 "VSCode is not installed in path.[press cmd+shift+p & type code]"
                        break
                    else
                        code .
                        _color 2 "Opening with VSCode"
                        break
                    fi                
                elif [[ $CONFIRM =~ ^[fF]+$ ]]; then
                    open .
                    _color 2 "Opening with Finder"
                    break
                elif [[ $CONFIRM =~ ^[bB]$ ]]; then
                    cd ..
                    clear
                    continue
                elif [[ $CONFIRM =~ ^[qQ]+$ ]]; then
                    break
                else
                    echo
                    _color 4 "Invalid input."
                    break
                fi
            break
        fi
    done;
}

function __main(){
    clear
    . ./utils.sh
    
    _check_ws
    __work
}

alias workol="__main"
alias w="__main"