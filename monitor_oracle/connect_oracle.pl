###########################################################
# ORATOP 
# Version 1.00 OCTUBER 2017
# AUTHOR: Gustavo Mayordomo (83885613@es.ibm.com)
# GROUP:  Grupo Bases de datos torre 1
# #########################################################
# @MOD 1.2 26dic2109. Modification to get oracle_sid by GUI.
# oratab file is read to show the different SID that can 
# be choosen
###########################################################
use lib './libs/';
use Term::ReadKey;
use Arquitectura;
use Switch;
use Query;
use Getopt::Std;
use POSIX;
use Term::Cap;
use Switch;
use Cwd;
use Term::ANSIColor qw(:constants);
use strict;
use warnings;
use DBI;
use DBD::Oracle;
use DBD::Oracle qw(:ora_session_modes);


my %option=();
my %param=();
my %mensajes=();
my $char='';
my $lastchar='';
my $coord_x=1;
my $coord_y=1;
my $cod_sql="";
my $ret_code=0;



 my $oracle_server="";
 my $oracle_listener="";
 my $oracle_sid="";
 my $oracle_port="";
 my $oracle_user="oracle";
 my $oracle_password="";
 my $ordercol=1;
 my $ordertipo="DESC";
 my $retardo=7.0;
 my $filtro="";
 my $schema="";

 ###  @MOD 1.2 26dic2109

my $ficora="/etc/oratab";
my $cont=1;
my $linea="";
my $orainst="";
my $bas="";
my %instance=();
my $v=1;
my $cad="";
my $cab = " SELECT INSTANCE   ";
my $pie = " SELECT NUMBER  (q) for exit    ";
my $usuario="";
my $contrasena="";

### END @MOD 1.2 26dic2109


#######################################################
#
# Subroutine executed when the menu option 
# choose is not valid 
#
######################################################
 sub opcion_nok {

my ($razon,%sub_mensajes) = @_;

          gotoxy(17,20);
          imprime_color(GREEN, "--------------------------------------------");
          gotoxy(17,21);
          imprime_color(RED, "  $sub_mensajes{'msgo1'}");
          gotoxy(17,22);
          imprime_color(RED, "  Reason:....$sub_mensajes{'msgo2'} $razon");
          gotoxy(17,23);
          imprime_color(GREEN, "--------------------------------------------");
          gotoxy(17,22);
          my $aux_retar = <STDIN>;
          chomp($aux_retar);
          print "\n";

                    }



####################################################
#
# Parameter options
# if the perl program is called with the -D option 
# debug file will be used
#
####################################################

 getopts('D:',\%option);

if ($option{D}) {
    my $debug_file = 'debug.txt';
    open(OUTDBG, "> $debug_file")
    or die "Couldn't open File  $debug_file  \n";

    print OUTDBG "Modo debug.. \n  ";
                 }



my $username = getpwuid( $< );
my $pnl_dia=get_dia();
my $pnl_hora=get_hora();
my $sist_op=get_ssoo();

################################################
#
#  Copy .termcap if it is not located
#
#################################################

$sist_op=trim($sist_op);

if ($sist_op eq 'aix' ) {
                          my $home_dir=$ENV{HOME};
                          my $term_cap=$home_dir.'/.termcap';
                          if ( ! -e $term_cap) {
                                                 my $Cmd_copy="cp ./libs/.termcap $term_cap";
                                                 my @Cmd_copyres=`$Cmd_copy`;  
                                                 my $rc=$?;
                                                 if ($rc != 0){
                                                                foreach $_ (@Cmd_copyres) {
                                                                                   print "$_ \n";
                                                                                          } # END foreach
                                                                          $ret_code=salir(25);          
 
                                                    }  # END ERROR IF

                                                } #END if does not .termcap in home directory
                          }               




#################################################
#
# Reading parameter file
# Nowadays only lang parameter it is used
#
################################################

  %param=leoparam('');
  if ($option{D}) {
                    print OUTDBG "DEB. Parameters read.. \n  ";

                    foreach (sort keys %param) {
                    print OUTDBG "$_ : $param{$_}\n";
                                                }
                   }


#################################################
#
# Dynamic messages file load
#
#################################################
my $lang = 'message_'.$param{"LANG"}.'.pm';

eval {
    require $lang;
 #   $lang->import( qw/%lang_msg carga_msg/ ) ;

};

if ($@) {
      die "Error: Language module not found: $@";
}

my $aux='message_'.$param{"LANG"}.'::carga_msg()';

 %mensajes = eval("$aux");
 if ($@) {
      die "Error: Can't loading dynamic language module : $@";
          }

if ($option{D}) {
                    print OUTDBG "$mensajes{'deb02'} \n  ";

                    foreach (sort keys %mensajes) {
                    print OUTDBG "$_ : $mensajes{$_}\n";
                                                }
                   }


###  @MOD 1.2 26dic2109

#####################################################################
#
# Build first menu with the oracle instances detected in oratab file
#
#####################################################################


if  (! -e $ficora ) {             ## its not oracle
                    print "ERROR. There is no oratab file \n";
                    exit 8;
                    }

open(INPUT,"< $ficora") or die "Couldn't open File $ficora  \n";



while (defined ($linea = <INPUT>)) {
      chomp($linea);
      $linea=trim($linea);
      if ((substr($linea,0,1)) =~ /^[a-zA-Z]/)  {                   ## cleaning blanks and comments
                       ($orainst,$bas)=split(':',$linea);
                        $instance{$cont} = $orainst;
                        print "instancia  $orainst \n";
                        $cont++;
                                    }
                                   }
close INPUT;

$retardo=3.0;

init();           # Initialize Term::Cap.
clear_screen();

gotoxy(50,3);

imprime_color(BLUE, "$cab");
$v=$v+3;


  foreach  $orainst (sort keys %instance){
     gotoxy(40,$v);
     $v++;
     $cad="  " . $orainst . ".  " . $instance{$orainst} . "\n";
     imprime_color(YELLOW, "$cad");
                                      }
$v=$v+3;
gotoxy(50,$v);
imprime_color(WHITE, "$pie");

ReadMode 4;  # turn off control keys

 while ( $char ne 'q' ) {

   while (not defined ($char = ReadKey($retardo))) {

                                                 }

              if (($char eq 'q') | ($char eq 'Q')) {
                                                 # select quit -> out
                                                 ReadMode 0; # Reset tty before existing
                                                 clear_screen();
                                                 cambio_color(ON_BLACK);
                                                 cambio_color(WHITE);
                                                 exit 0;
                                                   }

              if (exists($instance{$char}))
                                  {
                                     $oracle_sid=$instance{$char};
                                     $char="q";
                                    }
                                 else
                                 {
                                     $v=$v+2;
                                     gotoxy(50,$v);
                                     imprime_color(RED, "Value not valid");
                                  }

                          }  # char not q

 ReadMode 0; # Reset tty before existing
 clear_screen();
 cambio_color(ON_BLACK);
 cambio_color(WHITE);



### END  @MOD 1.2 26dic2109

######################################################
#
# Connecting to oracle sid using perl api
# User must own sysdba role. Password is not requested
#
######################################################
 
 $ENV{ORACLE_SID}=$oracle_sid;
 my $dbh = DBI->connect("dbi:Oracle:","","",{ ora_session_mode => ORA_SYSDBA }) or die "$mensajes{'msg2'} " . DBI->errstr;
   


######################################################
#
# Connect succesfull. Building Oracle option menu
#
######################################################

cambio_color(ON_BLACK);

my $cabecera="  MENU ORATOP    ";
gotoxy($coord_x+19,$coord_y+1);
imprime_color(BLUE, "$cabecera");

$retardo=7.0;       # initial delay

my %paramet_inst=();
%paramet_inst=Query_instance($dbh,%mensajes);

my $ora_version=$paramet_inst{"inst_version"};



   $char="";
    Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
   $lastchar='h';
   while ( $char ne 'q' ) {  # While user does not choose q option to leave, we continue in the loop 

       ReadMode 4; # turn off control keys   

      while (not defined ($char = ReadKey($retardo))) {
                 

                     if ($lastchar eq 'u')  { Query_num1($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$filtro,$schema,%mensajes); }

                      if ($lastchar eq 'p')  { Query_num2($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$filtro,$schema,%mensajes); }
                      
                      if ($lastchar eq 'm')  { Query_num3($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }
                      
                      if ($lastchar eq 's')  { Query_num4($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$filtro,$schema,%mensajes); }
                      
                      if ($lastchar eq 'S')  { Query_num5($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }
                      
                      if ($lastchar eq 'w')  { Query_num6($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }
                      
                      if ($lastchar eq 'b')  { Query_num7($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }
                      
                      if ($lastchar eq 't')  { Query_num8($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }

                      if ($lastchar eq 'y')  { Query_num9($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$cod_sql,$schema,%mensajes); }

                      if ($lastchar eq 'n')  { Query_num9_i($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$cod_sql,$schema,%mensajes); }     

                      if ($lastchar eq 'W')  { Query_num9_i_wa($dbh,$retardo,$oracle_user, $oracle_sid, $ordercol, $cod_sql ,$schema,%mensajes); }     

                      if ($lastchar eq 'l')  { Query_numa($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }
                      
                      if ($lastchar eq 'd')  { Query_numb($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }

                      if ($lastchar eq 'g')  { Query_numc($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$ora_version,$schema,%mensajes); }

                      if ($lastchar eq 'f')  { Query_numd($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$ora_version,$schema,%mensajes); }

                      if ($lastchar eq 'U')  { Query_nume($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }

                      if ($lastchar eq 'c')  { Query_numf($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }
                                               
                      if ($lastchar eq 'L')  { Query_numg($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes); }    
                     
                                                  }
                                                                              
                        if ($option{D}) {
                          print OUTDBG "DEB. Option selected....$char \n  ";
                                      }

                        if ($char eq 'u')  {
                                          if ($paramet_inst{"inst_status"} eq 'OPEN')
                                                     { $lastchar='u'; 
                                                       if ($option{D}) {
                                                                      print OUTDBG "DEB. Calling query number 1 \n  ";
                                                                       }
                                                       $filtro="";
                                                       Query_num1($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$filtro,$schema,%mensajes); }
                                             else
                                                     { my $aux=opcion_nok($paramet_inst{"inst_status"},$schema,%mensajes);
                                                       Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                                                       $lastchar='h';        }

                                                 }  #end u option                       

                       if ($char eq 'p')  {
                             $lastchar='p';
                             if ($option{D}) {
                               print OUTDBG "DEB. Calling query number 2 \n  ";
                                             }
                              $filtro=""; 
                             Query_num2($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$filtro,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Returning from query number 2 \n  ";
                                              }
                                           }  # end p option
                                           
                       if ($char eq 'm')  {
                             $lastchar='m';
                             if ($option{D}) {
                               print OUTDBG "DEB. Calling query number 3 \n  ";
                                             }
                             Query_num3($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Returning from query number 3 \n  ";
                                              }
                                           }  # end m option

                       if ($char eq 's')  {
                             $lastchar='s';
                             if ($option{D}) {
                               print OUTDBG "DEB. Calling query number 4 \n  ";
                                             }
                             $filtro="";
                             Query_num4($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$filtro,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Returning from query number 4 \n  ";
                                              }
                                           }   # end s option
                                           
                        if ($char eq 'S')  {
                                    if ($paramet_inst{"inst_status"} eq 'OPEN')
                                                     { $lastchar='S';
                                                       if ($option{D}) {
                                                                      print OUTDBG "DEB. Calling query number 5 \n  ";
                                                                       }
                                                       Query_num5($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }
                                             else
                                                     { my $aux=opcion_nok($paramet_inst{"inst_status"},$schema,%mensajes);
                                                       Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                                                       $lastchar='h';        }

                                                 }  #end S option
                   
                        if ($char eq 'w')  {
                             $lastchar='w';
                             if ($option{D}) {
                               print OUTDBG "DEB. Calling query number 6 \n  ";
                                             }
                             Query_num6($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Returning from query number 6 \n  ";
                                              }
                                           } # end w option
                                           
                             if ($char eq 'b')  {
                                    if ($paramet_inst{"inst_status"} eq 'OPEN')
                                                     { $lastchar='b';
                                                       if ($option{D}) {
                                                                      print OUTDBG "DEB. Calling query number 7 \n  ";
                                                                       }
                                                       Query_num7($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }
                                             else
                                                     { my $aux=opcion_nok($paramet_inst{"inst_status"},$schema,%mensajes);
                                                       Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                                                       $lastchar='h';        }

                                                 }  #end b option


                      if ($char eq 't')  {
                                    if ($paramet_inst{"inst_status"} eq 'OPEN')
                                                     { $lastchar='t';
                                                       if ($option{D}) {
                                                                      print OUTDBG "DEB. Calling query number 8 \n  ";
                                                                       }
                                                       Query_num8($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }
                                             else
                                                     { my $aux=opcion_nok($paramet_inst{"inst_status"},$schema,%mensajes);
                                                       Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                                                       $lastchar='h';        }

                                                 }  #end t option
                             
               
                             if ($char eq 'l')  {
                             $lastchar='l';
                             if ($option{D}) {
                               print OUTDBG "DEB. Calling query number a \n  ";
                                             }
                             Query_numa($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Returning from query number a \n  ";
                                              }
                                           } # end l option

                              if ($char eq 'd')  {
                             $lastchar='d';
                             if ($option{D}) {
                               print OUTDBG "DEB. Calling query number b \n  ";
                                             }
                             Query_numb($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Returning query number b \n  ";
                                              }
                                           } # end d option 

                              if ($char eq 'g')  {
                             $lastchar='g';
                             if ($option{D}) {
                               print OUTDBG "DEB. Calling query num c \n  ";
                                             }
                             Query_numc($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$ora_version,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Returning from query num c \n  ";
                                              }
                                           } # end g option

                              if ($char eq 'c')  {
                             $lastchar='c';
                             if ($option{D}) {
                               print OUTDBG "DEB. Calling query num f \n  ";
                                             }
                             Query_numf($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Returning from query num f \n  ";
                                              }
                                           } # end c option 

                             if ($char eq 'L')  {
                             $lastchar='L';
                             if ($option{D}) {
                               print OUTDBG "DEB. Calling query num g \n  ";
                                             }
                             Query_numg($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Returning from query num g \n  ";
                                              }
                                           } # end L option
                       
                            
                              if ($char eq 'f')  {
                             $lastchar='f';
                             if ($option{D}) {
                               print OUTDBG "DEB. Calling query num d \n  ";
                                             }
                             Query_numd($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$ora_version,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Returning from query num d \n  ";
                                              }
                                           } # end f option 

                             if ($char eq 'U')  {
                                          if ($paramet_inst{"inst_status"} eq 'OPEN')
                                                     { $lastchar='U';
                                                       if ($option{D}) {
                                                                      print OUTDBG "DEB. Calling query num e \n  ";
                                                                       }
                                                       Query_nume($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }
                                             else
                                                     { my $aux=opcion_nok($paramet_inst{"inst_status"},$schema,%mensajes);
                                                       Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                                                       $lastchar='h';        }

                                                 }  #end U option 
               

                                           
                             if ($char eq 'h')  {
                             $lastchar='h';
                             if ($option{D}) {
                               print OUTDBG "DEB. Calling query num h \n  ";
                                             }
                             Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Returning from query num h \n  ";
                                              }
                                           }  # end h

                              if ($char eq 'x')  {
                                          if ($paramet_inst{"inst_status"} eq 'OPEN')
                                                     { if ($option{D}) {
                                                            print OUTDBG "DEB. Calling query numa_x \n  ";
                                                                       }
                                               ReadMode 0;
                                               $cod_sql=Query_numa_x($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                                               if ($option{D}) {
                                                   print OUTDBG "DEB. Returning from query numa_x \n  ";
                                                               }
                                               ReadMode 4;
                                               $ret_code=Query_num9($dbh,$retardo,$oracle_user, $oracle_sid, $ordercol, $cod_sql ,$schema,%mensajes);
                                               if ( $ret_code == 0) {
                                               $lastchar='y';
                                                   }
                                               else {
                                                $lastchar='l';
                                                    }
                                                        }
                                             else
                                                     { my $aux=opcion_nok($paramet_inst{"inst_status"},$schema,%mensajes);
                                                       Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                                                       $lastchar='h';        }

                                                 }  #end x

                              if ($char eq 'F')  {

                                if ($option{D}) {
                                print OUTDBG "DEB. Setting the filter \n  ";
                                             }
                                ReadMode 0;
                                gotoxy(75,20);
                                imprime_color(GREEN, "--------------------");
                                gotoxy(75,21);
                                imprime_color(GREEN, " $mensajes{'msg29'} ");
                                gotoxy(75,22);
                                imprime_color(GREEN, "                    ");
                                 gotoxy(75,23);
                                imprime_color(GREEN, "--------------------");
                                gotoxy(75,22);
                                $filtro = <STDIN>;
                                chomp($filtro);
                                print "\n";
                          
                                ReadMode 4; 
                                                 }

                                 if ($char eq 'V')  {

                                if ($option{D}) {
                                print OUTDBG "DEB. Setting the schema \n  ";
                                             }
                                ReadMode 0;
                                gotoxy(75,20);
                                imprime_color(GREEN, "--------------------");
                                gotoxy(75,21);
                                imprime_color(GREEN, " $mensajes{'msg31'} ");
                                gotoxy(75,22);
                                imprime_color(GREEN, "                    ");
                                 gotoxy(75,23);
                                imprime_color(GREEN, "--------------------");
                                gotoxy(75,22);
                                $schema = <STDIN>;
                                chomp($schema);
                                print "\n";
                          
                                ReadMode 4;
                                Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes); 
                                                 }
   
                               if ($char eq 'W')  {
                             if ($option{D}) {
                               print OUTDBG "DEB. Calling query num9_i_wa \n  ";
                                             }
                             ReadMode 0;
                             $cod_sql=Query_numi_wa($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Returning from query numi_wa \n  ";
                                              }
                              ReadMode 4;
                              $ret_code=Query_num9_i_wa($dbh,$retardo,$oracle_user, $oracle_sid, $ordercol, $cod_sql ,$schema,%mensajes);                              
                              if ( $ret_code == 0) {
                                               $lastchar='W';
                                                   }
                                               else {
                                                $lastchar='s';
                                                    }
                                           }  # end W 
    

                              if ($char eq 'k')  {
                             if ($option{D}) {
                               print OUTDBG "DEB. Calling query numi \n  ";
                                             }
                             ReadMode 0;
                             $cod_sql=Query_numi($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Returning from query numi \n  ";
                                              }
                              ReadMode 4;
                             $ret_code=Query_num9_i($dbh,$retardo,$oracle_user, $oracle_sid, $ordercol, $cod_sql ,$schema,%mensajes);
                             if ( $ret_code == 0) {
                                               $lastchar='n';
                                                   }
                                               else {
                                                $lastchar='s';
                                                    }
                                           }  # end k

                             if (($char eq 'K') & ($lastchar eq 'n'))  {
                             if ($option{D}) {
                               print OUTDBG "DEB. Calling query numK_i \n  ";
                                             } 
                              ReadMode 0;
                             $ret_code=Query_numK_i($dbh,$retardo,$oracle_user, $oracle_sid, $ordercol, $cod_sql ,$schema,%mensajes); 
                             if ($option{D}) {
                               print OUTDBG "DEB. Returning from query numK_i \n  ";
                                              }
                              ReadMode 4;
                             if ( $ret_code == 0) {
                                               $lastchar='n';
                                                   }
                                               else {
                                                $lastchar='s';
                                                    }
                                           }  # end K

                       
                    


                       if ($char eq 'z')  {
                                          $ordercol++;        # Changing the column order
                                         }
                       if ($char eq 'Z')  {
                                          $ordercol--;        # Changing the column order    
                                         }
                       if ($char eq 'r')  {
                                          $retardo=$retardo+1.0;                  # Changing the delay 
                                          if ($retardo > 9) { $retardo=9.0 }
                                         }
                       if ($char eq 'R')  {
                                          $retardo=$retardo-1.0;                  # Changing the delay
                                          if ($retardo < 1) { $retardo=1.0 }
                                         }

                       if ($char eq 'O')  {                                        # Changing to ascending/descending order 
                                           if ($ordertipo eq "DESC") { $ordertipo = "ASC"; }
                                              else {  $ordertipo = "DESC"; }
                                         }

                        if (($char eq '<') && ($lastchar eq 'y')) {     # Scroll up/down       
                                         $ordercol=$ordercol+45;
                                         }

                       if (($char eq '>') && ($lastchar eq 'y')) {       # Scroll up/down 
                                         $ordercol=$ordercol-45;
                                         } 

                             }  # end q
 $dbh->disconnect;

   ReadMode 0; # Reset tty before existing 

 clear_screen();
 
 cambio_color(ON_BLACK);
 cambio_color(WHITE);

 exit 0;
