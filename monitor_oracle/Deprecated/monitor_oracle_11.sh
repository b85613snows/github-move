export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/db_1
export PATH=/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/oracle/bin:/u01/app/oracle/product/11.2.0/db_1/bin:/u01/app/oracle/product/11.2.0/db_1/OPatch
#export LD_LIBRARY_PATH=/u01/app/oracle/product/12.1.0/db_1/lib:/lib:/usr/lib
export LD_LIBRARY_PATH=/u01/app/oracle/product/11.2.0/db_1/lib:/lib:/usr/lib
/u01/app/oracle/product/11.2.0/db_1/perl/bin/perl connect_oracle_11.pl $1 
