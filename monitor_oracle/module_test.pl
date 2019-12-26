my $rc=0;

use lib './libs/';
 if ($rc != 0){
                print " Internal libs  perl modules test failed. Exiting \n";
              }

use Term::ReadKey;
 if ($rc != 0){
                print "Term ReadKey perl module test failed. Exiting \n";
              }
use Arquitectura;
 if ($rc != 0){
                print "Arquitectura libs  perl modules test failed. Exiting \n";
              }

use Query;
 if ($rc != 0){
                print "Query libs  perl modules test failed. Exiting \n";
              }

use Switch;
  if ($rc != 0){
                print "Switch  perl module test failed. Exiting \n";
              }

use Term::Cap;
   if ($rc != 0){
                print "Term Cap perl module test failed. Exiting \n";
              }
use Term::ANSIColor qw(:constants);
 if ($rc != 0){
                print "Term ANSIColor perl module test failed. Exiting \n";
              }

use DBI;
 if ($rc != 0){
                print "DBI perl module test failed. Exiting \n";
              }

use DBD::Oracle;
 if ($rc != 0){
                print "DBD Oracle perl module test failed. Exiting \n";
              }

imprime_color(GREEN,"Perl modules test ok");
cambio_color(ON_BLACK);
cambio_color(WHITE);
print "\n";
exit 0

