#################################################
# ORATOP 
# Version 1.00 OCTUBER 2017
# AUTHOR: Gustavo Mayordomo (83885613@es.ibm.com)
# GROUP:  Grupo Bases de datos torre 1
# ###############################################
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
 my $oracle_sid=$ARGV[0];
 my $oracle_port="";
 my $oracle_user="oracle";
 my $oracle_password="";
 my $ordercol=1;
 my $ordertipo="DESC";
 my $retardo=7.0;
 my $filtro="";
 my $schema="";

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





 getopts('Dha:',\%option);

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
#  COPIO .TERMCAP SI NO EXISTE
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

                                                } #END NO EXISTE TERMCAP EN HOME
                          }               




#################################################
#
# LEO FICHERO DE PARAMETROS
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
# CARGA DINAMICA DEL FICHERO DE MENSAJES
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




# my $dbh = DBI->connect("dbi:Oracle:host=$oracle_server;port=$oracle_port;sid=$oracle_sid",
#                                            $oracle_user, $oracle_password,{ ora_session_mode => ORA_SYSDBA }) 
#   or die "$mensajes{'msg2'} " . DBI->errstr;

 
 $ENV{ORACLE_SID}=$oracle_sid;
 my $dbh = DBI->connect("dbi:Oracle:","","",{ ora_session_mode => ORA_SYSDBA }) or die "$mensajes{'msg2'} " . DBI->errstr;
   


######################################################
#
# INITIALIZE TERMINA
#
######################################################

init();           # Initialize Term::Cap.

cambio_color(ON_BLACK);

my $cabecera="  MENU ORATOP    ";
gotoxy($coord_x+19,$coord_y+1);
imprime_color(BLUE, "$cabecera");
#gotoxy($coord_x+60,$coord_y-3);

my %paramet_inst=();
%paramet_inst=Query_instance($dbh,%mensajes);

my $ora_version=$paramet_inst{"inst_version"};



   $char="";
    Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
   $lastchar='h';
   while ( $char ne 'q' ) {

       ReadMode 4; # turn off control keys   

      while (not defined ($char = ReadKey($retardo))) {
                  #    select(undef, undef, undef, $retardo);

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

                      if ($lastchar eq 'W')  { Query_num9_i_wa($dbh,$retardo,$oracle_user, $oracle_sid, $ordercol, $cod_sql,$schema,%mensajes); }     

                      if ($lastchar eq 'l')  { Query_numa($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }
                      
                      if ($lastchar eq 'd')  { Query_numb($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }

                      if ($lastchar eq 'g')  { Query_numc($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$ora_version,$schema, %mensajes); }

                      if ($lastchar eq 'f')  { Query_numd($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$ora_version,$schema,%mensajes); }

                      if ($lastchar eq 'U')  { Query_nume($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }

                      if ($lastchar eq 'c')  { Query_numf($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }
                                               
                      if ($lastchar eq 'L')  { Query_numg($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes); }    
                     
                                                  }
                                                                              
                        if ($option{D}) {
                          print OUTDBG "DEB. Selecciono opcion....$char \n  ";
                                      }

                        if ($char eq 'u')  {
                                          if ($paramet_inst{"inst_status"} eq 'OPEN')
                                                     { $lastchar='u'; 
                                                       if ($option{D}) {
                                                                      print OUTDBG "DEB. Lllamo a Query_num 1 \n  ";
                                                                       }
                                                       $filtro="";
                                                       Query_num1($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$filtro,$schema,%mensajes); }
                                             else
                                                     { my $aux=opcion_nok($paramet_inst{"inst_status"},%mensajes);
                                                       Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                                                       $lastchar='h';        }

                                                 }  #end u                       

                       if ($char eq 'p')  {
                             $lastchar='p';
                             if ($option{D}) {
                               print OUTDBG "DEB. Lllamo a Query_num2 \n  ";
                                             }
                              $filtro=""; 
                             Query_num2($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$filtro,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Vuelvo de Query_num2 \n  ";
                                              }
                                           }  # end p
                                           
                       if ($char eq 'm')  {
                             $lastchar='m';
                             if ($option{D}) {
                               print OUTDBG "DEB. Lllamo a Query_num3 \n  ";
                                             }
                             Query_num3($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Vuelvo de Query_num3 \n  ";
                                              }
                                           }  # end m

                       if ($char eq 's')  {
                             $lastchar='s';
                             if ($option{D}) {
                               print OUTDBG "DEB. Lllamo a Query_num4 \n  ";
                                             }
                             $filtro="";
                             Query_num4($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$filtro,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Vuelvo de Query_num4 \n  ";
                                              }
                                           }   # end s
                                           
                        if ($char eq 'S')  {
                                    if ($paramet_inst{"inst_status"} eq 'OPEN')
                                                     { $lastchar='S';
                                                       if ($option{D}) {
                                                                      print OUTDBG "DEB. Lllamo a Query_num 5 \n  ";
                                                                       }
                                                       Query_num5($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }
                                             else
                                                     { my $aux=opcion_nok($paramet_inst{"inst_status"},%mensajes);
                                                       Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                                                       $lastchar='h';        }

                                                 }  #end S
                   
                        if ($char eq 'w')  {
                             $lastchar='w';
                             if ($option{D}) {
                               print OUTDBG "DEB. Lllamo a Query_num6 \n  ";
                                             }
                             Query_num6($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Vuelvo de Query_num6 \n  ";
                                              }
                                           } # end w
                                           
                             if ($char eq 'b')  {
                                    if ($paramet_inst{"inst_status"} eq 'OPEN')
                                                     { $lastchar='b';
                                                       if ($option{D}) {
                                                                      print OUTDBG "DEB. Lllamo a Query_num 7 \n  ";
                                                                       }
                                                       Query_num7($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }
                                             else
                                                     { my $aux=opcion_nok($paramet_inst{"inst_status"},%mensajes);
                                                       Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                                                       $lastchar='h';        }

                                                 }  #end b


                      if ($char eq 't')  {
                                    if ($paramet_inst{"inst_status"} eq 'OPEN')
                                                     { $lastchar='t';
                                                       if ($option{D}) {
                                                                      print OUTDBG "DEB. Lllamo a Query_num 8 \n  ";
                                                                       }
                                                       Query_num8($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }
                                             else
                                                     { my $aux=opcion_nok($paramet_inst{"inst_status"},%mensajes);
                                                       Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                                                       $lastchar='h';        }

                                                 }  #end t
                             
               
                             if ($char eq 'l')  {
                             $lastchar='l';
                             if ($option{D}) {
                               print OUTDBG "DEB. Lllamo a Query_numa \n  ";
                                             }
                             Query_numa($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Vuelvo de Query_numa \n  ";
                                              }
                                           } # end l

                              if ($char eq 'd')  {
                             $lastchar='d';
                             if ($option{D}) {
                               print OUTDBG "DEB. Lllamo a Query_numb \n  ";
                                             }
                             Query_numb($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Vuelvo de Query_numb \n  ";
                                              }
                                           } # end d

                              if ($char eq 'g')  {
                             $lastchar='g';
                             if ($option{D}) {
                               print OUTDBG "DEB. Lllamo a Query_numc \n  ";
                                             }
                             Query_numc($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$ora_version,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Vuelvo de Query_numc \n  ";
                                              }
                                           } # end g 

                              if ($char eq 'c')  {
                             $lastchar='c';
                             if ($option{D}) {
                               print OUTDBG "DEB. Llamo a Query_numf \n  ";
                                             }
                             Query_numf($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Vuelvo de Query_numf \n  ";
                                              }
                                           } # end c

                             if ($char eq 'L')  {
                             $lastchar='L';
                             if ($option{D}) {
                               print OUTDBG "DEB. Llamo a Query_numg \n  ";
                                             }
                             Query_numg($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Vuelvo de Query_numg \n  ";
                                              }
                                           } # end L 
                       
                            
                              if ($char eq 'f')  {
                             $lastchar='f';
                             if ($option{D}) {
                               print OUTDBG "DEB. Lllamo a Query_numd \n  ";
                                             }
                             Query_numd($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$ora_version,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Vuelvo de Query_numd \n  ";
                                              }
                                           } # end f

                             if ($char eq 'U')  {
                                          if ($paramet_inst{"inst_status"} eq 'OPEN')
                                                     { $lastchar='U';
                                                       if ($option{D}) {
                                                                      print OUTDBG "DEB. Lllamo a Query_nume \n  ";
                                                                       }
                                                       Query_nume($dbh, $retardo, $oracle_user, $oracle_sid, $ordercol,$ordertipo,$schema,%mensajes); }
                                             else
                                                     { my $aux=opcion_nok($paramet_inst{"inst_status"},%mensajes);
                                                       Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                                                       $lastchar='h';        }

                                                 }  #end U
               

                                           
                             if ($char eq 'h')  {
                             $lastchar='h';
                             if ($option{D}) {
                               print OUTDBG "DEB. Lllamo a Query_numh \n  ";
                                             }
                             Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Vuelvo de Query_numh \n  ";
                                              }
                                           }  # end h

                              if ($char eq 'x')  {
                                          if ($paramet_inst{"inst_status"} eq 'OPEN')
                                                     { if ($option{D}) {
                                                            print OUTDBG "DEB. Lllamo a Query_numa_x \n  ";
                                                                       }
                                               ReadMode 0;
                                               $cod_sql=Query_numa_x($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                                               if ($option{D}) {
                                                   print OUTDBG "DEB. Vuelvo de Query_numa_x \n  ";
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
                                                     { my $aux=opcion_nok($paramet_inst{"inst_status"},%mensajes);
                                                       Query_numh($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                                                       $lastchar='h';        }

                                                 }  #end x

                              if ($char eq 'F')  {

                                if ($option{D}) {
                                print OUTDBG "DEB. Establezco el filtro \n  ";
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
                                print OUTDBG "DEB. Establezco el schema \n  ";
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
                               print OUTDBG "DEB. Lllamo a Query_numi_wa \n  ";
                                             }
                             ReadMode 0;
                             $cod_sql=Query_numi_wa($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Vuelvo de Query_numi \n  ";
                                              }
                              ReadMode 4;
                              $ret_code=Query_num9_i_wa($dbh,$retardo,$oracle_user, $oracle_sid, $ordercol, $cod_sql,$schema,mensajes);                              
                              if ( $ret_code == 0) {
                                               $lastchar='W';
                                                   }
                                               else {
                                                $lastchar='s';
                                                    }
                                           }  # end W 
    

                              if ($char eq 'k')  {
                             if ($option{D}) {
                               print OUTDBG "DEB. Lllamo a Query_numi \n  ";
                                             }
                             ReadMode 0;
                             $cod_sql=Query_numi($dbh,$retardo,$oracle_user, $oracle_sid,$ordercol,$ordertipo,$schema,%mensajes);
                             if ($option{D}) {
                               print OUTDBG "DEB. Vuelvo de Query_numi \n  ";
                                              }
                              ReadMode 4;
                             $ret_code=Query_num9_i($dbh,$retardo,$oracle_user, $oracle_sid, $ordercol, $cod_sql,$schema,%mensajes);
                             if ( $ret_code == 0) {
                                               $lastchar='n';
                                                   }
                                               else {
                                                $lastchar='s';
                                                    }
                                           }  # end k

                             if (($char eq 'K') & ($lastchar eq 'n'))  {
                             if ($option{D}) {
                               print OUTDBG "DEB. Lllamo a Query_numK_i \n  ";
                                             } 
                              ReadMode 0;
                             $ret_code=Query_numK_i($dbh,$retardo,$oracle_user, $oracle_sid, $ordercol, $cod_sql,$schema,%mensajes); 
                             if ($option{D}) {
                               print OUTDBG "DEB. Vuelvo de Query_numK_i \n  ";
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
                                          $ordercol++;
                                         }
                       if ($char eq 'Z')  {
                                          $ordercol--;
                                         }
                       if ($char eq 'r')  {
                                          $retardo=$retardo+1.0;
                                          if ($retardo > 9) { $retardo=9.0 }
                                         }
                       if ($char eq 'R')  {
                                          $retardo=$retardo-1.0;
                                          if ($retardo < 1) { $retardo=1.0 }
                                         }

                       if ($char eq 'O')  {
                                           if ($ordertipo eq "DESC") { $ordertipo = "ASC"; }
                                              else {  $ordertipo = "DESC"; }
                                         }

                        if (($char eq '<') && ($lastchar eq 'y')) {
                                         $ordercol=$ordercol+45;
                                         }

                       if (($char eq '>') && ($lastchar eq 'y')) {
                                         $ordercol=$ordercol-45;
                                         } 

                             }  # end q
 $dbh->disconnect;

   ReadMode 0; # Reset tty befor existing 

 clear_screen();
 
 cambio_color(ON_BLACK);
 cambio_color(WHITE);

 exit 0;
