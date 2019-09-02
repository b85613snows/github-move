export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/12.2.0/db_1
export PATH=/usr/bin:/etc:/usr/sbin:/usr/ucb:/home/oracle/bin:/usr/bin/X11:/sbin:.:/u01/app/oracle/product/12.2.0/db_1/bin:/u01/app/oracle/product/12.2.0/db_1/OPatch
#export PATH=/usr/bin:/etc:/usr/sbin:/usr/ucb:/home/oracle/bin:/usr/bin/X11:/sbin:.:/u01/app/oracle/product/12.2.0/db_1/bin:/u01/app/oracle/product/12.2.0/db_1/OPatch
#export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export LD_LIBRARY_PATH=./libs:/u01/app/oracle/product/12.2.0/db_1/lib:/lib:/usr/lib
/u01/app/oracle/product/12.2.0/db_1/perl/bin/perl connect_oracle.pl $1 
