#!/bin/bash
#nss.sh v0.1a
#nmap script search
#last edit 25-11-2016
#
#					TEH COLORZ
########################################################################
STD=$(echo -e "\e[0;0;0m")		#Revert fonts to standard colour/format
REDN=$(echo -e "\e[0;31m")		#Alter fonts to red normal
GRNN=$(echo -e "\e[0;32m")		#Alter fonts to green normal
BLUN=$(echo -e "\e[0;36m")		#Alter fonts to blue normal
#
#					SOME VARIABLES
########################################################################
VERS=$(sed -n 2p $0 | awk '{print $2}') #Version information
LED=$(sed -n 4p $0 | awk '{print $3}')  #Last edit
BASE="/usr/share/nmap/scripts/"			#.nse nmap script directory
LENGTH=5				#number of lines to output after @usage if found
STRING=$@				#string to search .nse nmap scripts for
STRNR=$(echo $STRING | wc -w)
#
#					HEADER(S)
########################################################################
f_header1() {
echo "                     _
$BLUN       By TAPE$STD      | |
 _ __  ___ ___   ___| |__
| '_ \/ __/ __| / __| '_ \\
| | | \__ \__ \_\__ \ | | |
|_| |_|___/___(_)___/_| |_|"
}
f_header2() {
echo "                                 .__
  ____   ______ ______      _____|  |__
 /    \ /  ___//  ___/     /  ___/  |  \\
|   |  \\\___ \ \___ \      \___ \|   Y   \\
|___|  /____  >____  > /\ /____  >___|  /
     \/     \/     \/  \/      \/     \/ "
}
f_header3() {
echo "                   _
 ___ ___ ___   ___| |_
|   |_ -|_ -|_|_ -|   |
|_|_|___|___|_|___|_|_|"
}
f_header4() {
echo "                      __
  ___  ___ ___   ___ / /
 / _ \(_-<(_-<_ (_-</ _ \\
/_//_/___/___(_)___/_//_/"
}
f_header5() {
echo "__   _ _______ _______   _______ _     _
| \  | |______ |______   |______ |_____|
|  \_| ______| ______| . ______| |     |"
}
#
#					HELP INFO
########################################################################
f_help() {
NUM=$(shuf -i 1-5 -n 1)
f_header$NUM
echo $BLUN" nmap script search $VERS$STD

USAGE
nss.sh <SEARCH STRING>

EXAMPLES
nss.sh heartbleed
nss.sh enum
"
exit
}
#
#					INFO PARSING
########################################################################
f_parse() {
echo $STD""
NSE=$(echo $RESULT | sed 's/ /\n/g' | sed -n "$INFONR"p)
echo $BLUN"[+]$STD Description $BLUN$NSE$STD"
cat $BASE$NSE | sed -n '/description/,$p' | sed 's/^.*\[\[//' | sed 's/\]\]/\n\]\]/' | sed 1d | sed '/\]\]/,$d' | sed 's/\*/-/g'
#
echo $BLUN"[+]$STD Usage $BLUN$NSE$STD"
USE=$(cat $BASE$NSE | grep -i usage)
if [ "$USE" == "" ] ; then 
	echo $REDN"[!]$STD No usage information"
else
	cat $BASE$NSE | sed -n '/@usage/,$p' | head -n "$LENGTH"
fi
#
echo $BLUN"[+]$STD Arguments $BLUN$NSE$STD"
ARG=$(cat $BASE$NSE | grep @args)
if [ "$ARG" == "" ] ; then 
	echo $REDN"[!]$STD No arguments information"
else
	cat $BASE$NSE | sed -n '/@args/,$p' | sed '/^$/,$d'
fi
exit
}
#
#					DEBUG INFO
########################################################################
#
#
#					INPUT CHECKS
########################################################################
if [ $# = 0 ] ; then f_help ; fi
#
#					START SCRIPT
########################################################################
if [ $STRNR -eq 1 ] ; then
	RESULT=$(ls $BASE | grep -i "$STRING")
elif [ $STRNR -eq 2 ] ; then
	STR1=$1 ; STR2=$2
	RESULT=$(ls $BASE | grep -i $STR1 | grep -i $STR2)
elif [ $STRNR -eq 3 ] ; then
	STR1=$1 ; STR2=$2 ; STR3=$3
	RESULT=$(ls $BASE | grep -i $STR1 | grep -i $STR2 | grep -i $STR3)
elif [ $STRNR -eq 4 ] ; then
	STR1=$1 ; STR2=$2 ; STR3=$3 ; STR4=$4
	RESULT=$(ls $BASE | grep -i $STR1 | grep -i $STR2 | grep -i $STR3 | grep -i $STR4)
elif [ $STRNR -gt 4 ] ; then 
	echo $REDN"[!]$STD Please limit search queries to max 4 strings"
	exit
fi
#
if [ "$RESULT" == "" ] ; then
	echo $REDN"[!]$STD No nmap script matches found"
	exit		
fi
#
MAXCOUNT=$(echo $RESULT | wc -w)
#
echo $RESULT | sed 's/ /\n/g' | sed '/./=' | sed '/./N;s/\n/) /'
echo 
read -p $GRNN">$STD Enter number for info or hit Enter to quit:$GRNN " INFONR
if [[ "$INFONR" == "" || "$INFONR" == "0" ]] ; then
	echo $STD
	exit
elif [ ! `expr $INFONR + 1 2> /dev/null` ] ; then
	echo $REDN"[!]$STD Must choose a numeric value"
	exit
elif [ $INFONR -gt $MAXCOUNT ] ; then 
	echo $REDN"[!]$STD Must choose from 1 to $MAXCOUNT"
	exit
else
f_parse
fi
