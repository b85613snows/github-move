#!/bin/bash
#set -x

msgOK () {
        echo -e  "\e[1;92m[  OK!  ] \e[0m $1"
}
msgERR () {
        echo -e  "\e[1;91m[ ERROR ] \e[0m $1"
}
msgWARN () {
        echo -e  "\e[1;93m[WARNING] \e[0m $1"
}
msgINF () {
        echo -e  "\e[1;94m[  INF  ] \e[0m $1"
}

clear

echo " TESTING ENVIRONMENT VARIABLES "
echo " "
echo " "

if [ -z ${ORACLE_HOME} ]
then
    msgERR "THERE IS NO VARIABLE ORACLE_HOME. EXIT "
    exit 1
else
    msgOK "HOME: ${ORACLE_HOME}"
fi

if [ -z ${ORACLE_BASE} ]
then
    msgERR "THERE IS NO VARIABLE ORACLE_BASE. EXIT "
    exit 1
else
    msgOK "BASE: ${ORACLE_BASE}  "
fi

if [ -z ${PATH} ]
then
    msgERR "THERE IS NO VARIABLE PATH. EXIT "
    exit 1
else
  msgOK "PATH: ${PATH}"
fi

if [ -z ${LD_LIBRARY_PATH} ]
then
    msgERR "THERE IS NO VARIABLE LIBRARY_PATH. EXIT "
    exit 1
else
   msgOK "LD_LIBRARY_PATH: ${LD_LIBRARY_PATH}"
fi


PERL=${ORACLE_HOME}/perl/bin

if [ ! -d "$PERL" ]
then
    msgERR "THERE IS NO VARIABLE  PERL PATH . EXIT "
    exit 1
else
   msgOK "PERL: $PERL"
fi


echo " "
echo " "


$PERL/perl module_test.pl

echo "***Press any key to continue***"

read var

$PERL/perl connect_oracle.pl


exit

