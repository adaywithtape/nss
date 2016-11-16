#!/bin/bash
#nss.sh v0.1
#nmap script search
#
#					TEH COLORZ
########################################################################
STD=$(echo -e "\e[0;0;0m")		#Revert fonts to standard colour/format
REDN=$(echo -e "\e[0;31m")		#Alter fonts to red normal
GRNN=$(echo -e "\e[0;32m")		#Alter fonts to green normal
BLUN=$(echo -e "\e[0;36m")		#Alter fonts to blue normal
#
#
########################################################################
VERS=$(sed -n 2p $0 | awk '{print $2}') #Version information
BASE="/usr/share/nmap/scripts/" 	#.nse nmap script directory
STRING=$1				#string to search .nse nmap scripts for
OUTPUT=$2				#number of lines to print out after usage string
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
#							HELP INFO
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
#						INPUT CHECKS
########################################################################
if [ $# = 0 ] ; then f_help ; fi
if [ "$OUTPUT" == "" ] ; then OUTPUT=2 ; fi
#
#						INFO PARSING
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
	cat $BASE$NSE | sed -n '/@usage/,$p' | head -n "$OUTPUT"
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
#						DEBUG INFO
########################################################################
#
#for i in $(ls /usr/share/nmap/scripts/*.nse) ; do
#	DESCR1=$(grep 'description=\[\[' $i)
#	DESCR2=$(grep 'description \= \[\[' $i)
#	DESCR3=$(grep 'description \=  \[\[' $i)
#	DESCR4=$(grep 'description \= \"' $i)
#done
#
#						START SCRIPT
########################################################################
RESULT=$(ls $BASE | grep -i $STRING)
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
