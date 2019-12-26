# Query.pm
package Query;

@ISA = qw(Exporter);
@EXPORT = qw(clear_screen clear_end gotoxy init finish Query_num1 Query_num2 Query_num3 Query_num4 Query_num5 Query_num6 Query_numg Query_numi Query_num9_i Query_numK_i 
 Query_num7 Query_num8 Query_num9 Query_numa Query_numh Query_numa_x Query_numb Query_numc Query_numd Query_nume Query_numf imprime_color cambio_color cabecera sqltexto Query_instance 
 Query_numi_wa Query_num9_i_wa cabecera_fil );

use strict;
use warnings;

use Arquitectura;
use POSIX;
use Term::ReadKey;
use Term::Cap;
use Term::ANSIColor qw(:constants);

use DBI;
use DBD::Oracle;
use DBD::Oracle qw(:ora_session_modes);
use Scalar::Util qw(looks_like_number);



our  %hash_inst_param=();


my $tcap="";
my $delay="";
my $maxrow="";
my $pdynam="";
my $sqlcodigo="";
my $comconf="";
my $sqltexto="";


my ($result);

###########################################################################################
##  Rutina imprime_color
##  Escribe un texto en el color indicado
##
#########################################################################################

sub imprime_color {
    my ($color, $texto)  = @_;
    print $color, "$texto";
          }


###########################################################################################
#  Rutina cambio_color
#  Cambia el color del texto o del background
#
########################################################################################

 sub cambio_color {
     my ($color)  = @_;
     print $color;
                  }

###########################################################################################
##  Rutina cabecera_fil
##  Escribe la cabecera comun a las querys
##
#########################################################################################

sub cabecera_fil {

   my ($norder,$nora_ret,$nora_user, $nora_sid,$filt,$myschema,%mensajes)  = @_;

   my $hora=get_hora();
   clear_screen();
   my $op_sist=get_ssoo();

   gotoxy(140,2);
   imprime_color(BLUE,"\@GMH V241019");
   gotoxy(12,2);
   imprime_color(MAGENTA,"$mensajes{'var03'} ");
   gotoxy(20,2);
   imprime_color(GREEN,"$hora");
   gotoxy(12,3);
   imprime_color(MAGENTA,"Order by:");
   gotoxy(24,3);
   imprime_color(GREEN,"$norder");
   gotoxy(40,2);
   imprime_color(MAGENTA,"$mensajes{'var01'} ");
   gotoxy(50,2);
   imprime_color(GREEN,"$nora_user");
   gotoxy(40,3);
   imprime_color(MAGENTA,"SID  :");
   gotoxy(50,3);
   imprime_color(GREEN,"$nora_sid");
   gotoxy(65,2);
   imprime_color(MAGENTA,"$mensajes{'var04'} ");
   gotoxy(75,2);
   imprime_color(GREEN,"$op_sist");
   gotoxy(65,3);
   imprime_color(MAGENTA,"$mensajes{'var05'} ");
   gotoxy(75,3);
   imprime_color(GREEN,"$nora_ret");
   gotoxy(115,2);
   imprime_color(MAGENTA,"Owner/Schema");
   gotoxy(130,2);
   imprime_color(GREEN,"$myschema");  


   gotoxy(90,2);
   imprime_color(MAGENTA,"$mensajes{'var06'} ");
   gotoxy(98,2);
   imprime_color(GREEN,"$filt");

   gotoxy(89,3);
   imprime_color(CYAN,"$mensajes{'msg30'} ");



  }


###########################################################################################
#  Rutina cabecera
#  Escribe la cabecera comun a las querys
#
########################################################################################

sub cabecera {

   my ($norder,$nora_ret,$nora_user, $nora_sid,$myschema,%mensajes)  = @_;

   my $hora=get_hora();
   clear_screen();
   my $op_sist=get_ssoo();

   gotoxy(140,2);
   imprime_color(BLUE,"\@GMH V261216");
   gotoxy(12,2);
   imprime_color(MAGENTA,"$mensajes{'var03'} ");
   gotoxy(20,2);
   imprime_color(GREEN,"$hora");
   gotoxy(12,3);
   imprime_color(MAGENTA,"Order by:");
   gotoxy(24,3);
   imprime_color(GREEN,"$norder");
   gotoxy(40,2);
   imprime_color(MAGENTA,"$mensajes{'var01'} ");
   gotoxy(50,2);
   imprime_color(GREEN,"$nora_user");
   gotoxy(40,3);
   imprime_color(MAGENTA,"SID  :");
   gotoxy(50,3);
   imprime_color(GREEN,"$nora_sid");
   gotoxy(65,2);
   imprime_color(MAGENTA,"$mensajes{'var04'} ");
   gotoxy(75,2);
   imprime_color(GREEN,"$op_sist");
   gotoxy(65,3);
   imprime_color(MAGENTA,"$mensajes{'var05'} ");
   gotoxy(75,3);
   imprime_color(GREEN,"$nora_ret");
   gotoxy(90,2);
   imprime_color(MAGENTA,"Owner/Schema");
   gotoxy(105,2);
   imprime_color(GREEN,"$myschema");  
 


  }

###########################################################################################
#  Rutina imprime_color
#  Escribe un texto en el color indicado
#
########################################################################################

sub imprime_color {
  
    my ($color, $texto)  = @_;

    print $color, "$texto";  

  }


###########################################################################################
#  Rutina cambio_color
#  Cambia el color del texto o del background
#
########################################################################################

sub cambio_color {
  
    my ($color)  = @_;

    print $color;  

  }



# Two convenience functions.  clear_screen is obvious, and
# clear_end clears to the end of the screen.
sub clear_screen { $tcap->Tputs('cl', 1, *STDOUT) } 
sub clear_end    { $tcap->Tputs('cd', 1, *STDOUT) } 

# Move the cursor to a particular location.
sub gotoxy {
    my($x, $y) = @_;
    $tcap->Tgoto('cm', $x, $y, *STDOUT);
} 

# Get the terminal speed through the POSIX module and use that
# to initialize Term::Cap.
sub init { 
    $| = 1;
    $delay = (shift() || 0) * 0.005;
    my $termios = POSIX::Termios->new();
    $termios->getattr;
    my $ospeed = $termios->getospeed;
    $tcap = Term::Cap->Tgetent ({ TERM => undef, OSPEED => $ospeed });
    $tcap->Trequire(qw(cl cm cd));
}
  
# Clean up the screen.
sub finish { 
    gotoxy(1, 1);
    clear_end();
}
###########################################################################################
#  Rutina Query_num1
########################################################################################


sub Query_num1 {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$filter,$myschema,%sub_mensajes)  = @_;

   my $oracle_testing_table="DBA_USERS";
   my $coordx=1;
   my $coordy=1;
   my $sth="";


   my $numero_colum=6;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }
                                    
   cabecera_fil($order_num,$ora_ret,$ora_user, $ora_sid,$filter,$myschema,%sub_mensajes);

   if ( $filter eq "") {

    $sth = $sub_dbh->prepare("SELECT user_id, username, account_status,lock_date,expiry_date,created,profile FROM $oracle_testing_table order by $order_num $order_tipo") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;
  
                      }
   else  {
      my $filteraux=$filter.'%'; 
      $sth = $sub_dbh->prepare("SELECT user_id, username, account_status,lock_date,expiry_date,created,profile FROM $oracle_testing_table where username like '$filteraux'  order by $order_num $order_tipo") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;
         }

 
   $coordx=$coordx+3;
   $coordy=$coordy+5;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "User   ");
   $coordx=$coordx+15;
   
   gotoxy($coordx,$coordy);
   imprime_color(CYAN, "Nom_user");
   $coordx=$coordx+30;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Acc_stat");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Lock_date");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Expiry_date");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Created");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Profile");
   $coordx=$coordx+15;
  

   $sth->execute()
   or die print "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=7;

    my $cont=1;
        
    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40) )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $id = $data[0];
     $id=trim($id);
     imprime_color(YELLOW, "$id");
     $coordx=$coordx+15;
     
     gotoxy($coordx,$coordy);
     my $username = $data[1];
     $username=trim($username);
     imprime_color(YELLOW, "$username");
     $coordx=$coordx+30;

     gotoxy($coordx,$coordy);
     my $acct= $data[2];
     $acct=trim($acct);
     imprime_color(YELLOW, "$acct");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $loc= $data[3];
     $loc = "----" unless defined($loc);
     $loc=trim($loc);
     imprime_color(YELLOW, "$loc");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $exp= $data[4];
     $exp = "----" unless defined($exp);
     $exp=trim($exp);
     imprime_color(YELLOW, "$exp");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $cre= $data[5];
     $cre=trim($cre);
     imprime_color(YELLOW, "$cre");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $pro= $data[6];
     $pro=trim($pro);
     imprime_color(YELLOW, "$pro");
     $coordx=$coordx+15; 


     print "\n";
 #    print "$id: $username $acct \n";
     $coordy++;

     $cont++;
 }

 if ($sth->rows == 0)
 {
 #    print "Table vide\n";
 }

 $sth->finish;
 return ()
  }
  
###########################################################################################
#  Rutina Query_num2
########################################################################################


sub Query_num2 {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$filter,$myschema,%sub_mensajes)  = @_;

   my $coordx=1;
   my $coordy=1;
   my $sth;    

   my $numero_colum=11;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }

   cabecera_fil($order_num,$ora_ret,$ora_user, $ora_sid,$filter,$myschema,%sub_mensajes);

   
    if ( $filter eq "") {

    $sth = $sub_dbh->prepare("select s.username, s.sid, s.serial#, p.spid, s.last_call_et,s.status, p.terminal,p.program,ROUND(p.pga_used_mem/1024,1),ROUND(p.pga_alloc_mem/1024,1),ROUND(p.pga_max_mem/1024,1) from V\$SESSION s, V\$PROCESS p where     s.PADDR = p.ADDR order by $order_num $order_tipo") or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;
                      }
   else  {
      my $filteraux=$filter.'%';
      $sth = $sub_dbh->prepare("select s.username, s.sid, s.serial#, p.spid, s.last_call_et,s.status, p.terminal,p.program,ROUND(p.pga_used_mem/1024,1),ROUND(p.pga_alloc_mem/1024,1),ROUND(p.pga_max_mem/1024,1) from V\$SESSION s, V\$PROCESS p where     s.PADDR = p.ADDR and s.username like '$filteraux'  order by $order_num $order_tipo") or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr; 
         }


   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(CYAN, "Usuario");
   $coordx=$coordx+30;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "SID");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "SERIAL");
   $coordx=$coordx+10;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "PID");
   $coordx=$coordx+10;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "LAST_CALL");
   $coordx=$coordx+10;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "STATUS");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Terminal");
   $coordx=$coordx+20;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Program");
   $coordx=$coordx+30;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Pga_used");
   $coordx=$coordx+10;  

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Pga_alloc");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Pga_Max");
   $coordx=$coordx+10;


   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=7;

    my $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40 ) )

 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $username = $data[0];
     $username = "NULL" unless defined($username);
     $username=trim($username);
     imprime_color(YELLOW, "$username");
     $coordx=$coordx+30;

     gotoxy($coordx,$coordy);
     my $sid= $data[1];
     $sid=trim($sid);
     imprime_color(YELLOW, "$sid");
     $coordx=$coordx+10;
     
     gotoxy($coordx,$coordy);
     my $serial= $data[2];
     $serial=trim($serial);
     imprime_color(YELLOW, "$serial");
     $coordx=$coordx+10;
     
     gotoxy($coordx,$coordy);
     my $pid= $data[3];
     $pid=trim($pid);
     imprime_color(YELLOW, "$pid");
     $coordx=$coordx+10;
     
     gotoxy($coordx,$coordy);
     my $lastc= $data[4];
     $lastc=trim($lastc);
     imprime_color(YELLOW, "$lastc");
     $coordx=$coordx+10;
     
     gotoxy($coordx,$coordy);
     my $status= $data[5];
     $status=trim($status);
     imprime_color(YELLOW, "$status");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $ter= substr($data[6],0,19);
     $ter = " -----" unless defined($ter);
     $ter=trim($ter);
     imprime_color(YELLOW, "$ter");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $pro= substr($data[7],0,28);
     $pro = " -----" unless defined($pro);
     $pro=trim($pro);
     imprime_color(YELLOW, "$pro");
     $coordx=$coordx+30; 
  
     gotoxy($coordx,$coordy);
     my $pum= $data[8];
     $pum=trim($pum);
     imprime_color(YELLOW, "$pum");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $paum= $data[9];
     $paum=trim($pum);
     imprime_color(YELLOW, "$paum");
     $coordx=$coordx+10; 

     gotoxy($coordx,$coordy);
     my $pmum= $data[10];
     $pmum=trim($pmum);
     imprime_color(YELLOW, "$pmum");
     $coordx=$coordx+10; 



     print "\n";
 #    print "$id: $username $acct \n";
     $coordy++;
     $cont++;

 }

 if ($sth->rows == 0)
 {
 #    print "Table vide\n";
 }

 $sth->finish;
 return ()
  }
###########################################################################################
#  Rutina Query_num3
########################################################################################


sub Query_num3 {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$myschema,%sub_mensajes)  = @_;

   my $oracle_testing_table="V\$SGAINFO";
   my $coordx=1;
   my $coordy=1;


   my $numero_colum=3;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }

    cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

   my $sth = $sub_dbh->prepare("SELECT name,bytes,resizeable FROM $oracle_testing_table order by $order_num $order_tipo")
   or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Name");
   $coordx=$coordx+35;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Size_M");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Res");
   $coordx=$coordx+10;

   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=8;

    my $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40 ) )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $name = $data[0];
     $name=trim($name);
     imprime_color(YELLOW, "$name");
     $coordx=$coordx+35;

     gotoxy($coordx,$coordy);
     my $size = $data[1];
     $size = sprintf '%.2f', $size / (1024 * 1024);
     imprime_color(YELLOW, "$size");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $resize= $data[2];
     $resize = "----" unless defined($resize);
     $resize=trim($resize);
     imprime_color(YELLOW, "$resize");
     $coordx=$coordx+10;
 #    print "\n";
 #    print "$id: $username $acct \n";
     $coordy++;
     $cont++;

 }

 if ($sth->rows == 0)
 {
 #    print "Table vide\n";
 }

 $sth->finish;
 
 ###########################################################
 #
 #   query 3-a Advise
 #
 ############################################################3
 
   $oracle_testing_table="V\$MEMORY_TARGET_ADVICE";
   $coordx=1;
   $coordy=25;


   $numero_colum=5;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }

    $sth = $sub_dbh->prepare("SELECT * FROM $oracle_testing_table order by $order_num $order_tipo")
   or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Mem_size");
   $coordx=$coordx+12;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Mem_factor");
   $coordx=$coordx+13;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Est_Db_Time");
   $coordx=$coordx+14;
   
    gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Est_Time_Factor");
   $coordx=$coordx+19;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Version");
   $coordx=$coordx+15;
   

   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=$coordy+2;

    $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40 ) )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $msize = $data[0];
     $msize=trim($msize);
     imprime_color(YELLOW, "$msize");
     $coordx=$coordx+12;

     gotoxy($coordx,$coordy);
     my $mfactor = $data[1];
     $mfactor=trim($mfactor);
     imprime_color(YELLOW, "$mfactor");
     $coordx=$coordx+13;

     gotoxy($coordx,$coordy);
     my $estdb= $data[2];
     $estdb=trim($estdb);
     imprime_color(YELLOW, "$estdb");
     $coordx=$coordx+14;
     
     gotoxy($coordx,$coordy);
     my $dbfactor = $data[3];
     $dbfactor=trim($dbfactor);
     imprime_color(YELLOW, "$dbfactor");
     $coordx=$coordx+19;

     gotoxy($coordx,$coordy);
     my $vers= $data[4];
     $vers=trim($vers);
     imprime_color(YELLOW, "$vers");
     $coordx=$coordx+15;
     
     
     print "\n";
     $coordy++;
     $cont++;

 }

 if ($sth->rows == 0)
 {
 #    print "Table vide\n";
 }

 $sth->finish;

 $oracle_testing_table="V\$MEMORY_RESIZE_OPS";
   $coordx=1;
   $coordy=25;


   $numero_colum=6;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }

    $sth = $sub_dbh->prepare("SELECT COMPONENT,OPER_TYPE,OPER_MODE,ROUND(INITIAL_SIZE/(1024*1024),1),ROUND(FINAL_SIZE/(1024*1024),1),STATUS,to_char(END_TIME, 'DD-MON-RR HH24:MI:SS') from $oracle_testing_table order by END_TIME desc")
   or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+75;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Component");
   $coordx=$coordx+24;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Type");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Mode");
   $coordx=$coordx+10;

    gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Ini.Size");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Fin.Size");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Status");
   $coordx=$coordx+10;    

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Time");
   $coordx=$coordx+10;  


   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=$coordy+2;

    $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 16 ) )
 {
     $coordx=75;

     gotoxy($coordx,$coordy);
     my $mcom = substr($data[0],0,24);
     $mcom=trim($mcom);
     imprime_color(YELLOW, "$mcom");
     $coordx=$coordx+25;

     gotoxy($coordx,$coordy);
     my $mty = $data[1];
     $mty = "----" unless defined($mty); 
     $mty=trim($mty);
     imprime_color(YELLOW, "$mty");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $mmo= $data[2];
     $mmo = "----" unless defined($mmo);
     $mmo=trim($mmo);
     imprime_color(YELLOW, "$mmo");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $mini = $data[3];
     #$mini=trim($$mini);
     imprime_color(YELLOW, "$mini");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $minf= $data[4];
     #$minf=trim($minf);
     imprime_color(YELLOW, "$minf");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $mstc= $data[5];
     $mstc=trim($mstc);
     imprime_color(YELLOW, "$mstc");
     $coordx=$coordx+10; 

     gotoxy($coordx,$coordy);
     my $mfec= $data[6];
     $mfec=trim($mfec);
     imprime_color(YELLOW, "$mfec");
     $coordx=$coordx+10;


     $coordy++;
     $cont++;

 }


  if ($sth->rows == 0)
      {
     print "\n";
      }
 
      $sth->finish;


 ###########################################################
 #
 #   query 3-b PGA
 #
 ############################################################3

   $oracle_testing_table="V\$PGASTAT";
   $coordx=80;
   $coordy=1;


   $numero_colum=3;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }

    $sth = $sub_dbh->prepare("SELECT name,value,unit FROM $oracle_testing_table order by $order_num $order_tipo")
   or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Name");
   $coordx=$coordx+45;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Size");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Unit");
$coordx=$coordx+15;


   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=$coordy+2;

    $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40 ) )
 {
     $coordx=83;

     gotoxy($coordx,$coordy);
     my $mname = $data[0];
     $mname=trim($mname);
     imprime_color(YELLOW, "$mname");
     $coordx=$coordx+45;
     

     
     my $msize = $data[1];
     my $munit= $data[2];
     
     $munit = "----" unless defined($munit);
     
     if ($munit eq 'bytes') {
                        $msize = sprintf '%.2f', $msize / (1024 * 1024);
                        $munit = 'MB  ';
                            }

     gotoxy($coordx,$coordy);
     $msize = "----" unless defined($msize);
     $msize=trim($msize);
     imprime_color(YELLOW, "$msize");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     $munit=trim($munit);
     imprime_color(YELLOW, "$munit");
     $coordx=$coordx+15;

     print "\n";
 #    print "$id: $username $acct \n";
     $coordy++;
     $cont++;

 }

 if ($sth->rows == 0)
 {
 #    print "Table vide\n";
 }

 $sth->finish;


 return ()
  }

#################################################################################################
###     Rutina query_numi_wa
##################################################################################################

sub Query_numi_wa {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$myschema,%sub_mensajes)  = @_;

   my $oracle_testing_table="V\$SESSION";
   my $coordx=1;
   my $coordy=1;

   my $numero_colum=9;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }

    cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

    my $sth = $sub_dbh->prepare("SELECT sid,process,username,status,state,sql_id,module,lockwait,seconds_in_wait
    FROM $oracle_testing_table  order by $order_num $order_tipo") or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Sid");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Process");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Username");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Status");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "State");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Sql_id");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Module");
   $coordx=$coordx+46;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Lockwait");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Seconds in wait");
   $coordx=$coordx+10;

    $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=7;

    my $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40) )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $sid = $data[0];
     $sid = "----" unless defined($sid);
     $sid=trim($sid);
     imprime_color(YELLOW, "$sid");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $sprocess = $data[1];
     $sprocess = "----" unless defined($sprocess);
     $sprocess=trim($sprocess);
     imprime_color(YELLOW, "$sprocess");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $suser= $data[2];
     $suser = "----" unless defined($suser);
     $suser=trim($suser);
     $suser=substr($suser,0,19);
     imprime_color(YELLOW, "$suser");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $sstatus = $data[3];
     $sstatus = "----" unless defined($sstatus);
     $sstatus=trim($sstatus);
     imprime_color(YELLOW, "$sstatus");
     $coordx=$coordx+10;
 
      gotoxy($coordx,$coordy);
     my $sstate = $data[4];
     $sstate = "----" unless defined($sstate);
     $sstate=trim($sstate);
     imprime_color(YELLOW, "$sstate");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $ssql = $data[5];
     $ssql = "----" unless defined($ssql);
     $ssql=trim($ssql);
     imprime_color(YELLOW, "$ssql");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $smodule = $data[6];
     $smodule = "----" unless defined($smodule);
     $smodule=trim($smodule);
     $smodule = substr($smodule,0,45);
     imprime_color(YELLOW, "$smodule");
     $coordx=$coordx+46;

     gotoxy($coordx,$coordy);
     my $slockw = $data[7];
     $slockw = "----" unless defined($slockw);
     $slockw=trim($slockw);
     imprime_color(YELLOW, "$slockw");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $sinwait = $data[8];
     $sinwait = "----" unless defined($sinwait);
     $sinwait=trim($sinwait);
     imprime_color(YELLOW, "$sinwait");
     $coordx=$coordx+10;

     print "\n";

     $coordy++;
     $cont++;
 }

 if ($sth->rows == 0)
     {
    print "\n";
     }
    $sth->finish;

          gotoxy(75,20);
          imprime_color(GREEN, "--------------------");
          gotoxy(75,21);
          imprime_color(GREEN, "-SESSION ID (SID)  -");  
          gotoxy(75,22);
          imprime_color(GREEN, "                    ");
          gotoxy(75,23);
          imprime_color(GREEN, "--------------------");
          gotoxy(75,22);
          $sqltexto = <STDIN>;
          chomp($sqltexto);
          print "\n";

     $sqltexto=trim($sqltexto);


 return ($sqltexto)
  }


#################################################################################################
##     Rutina query_numi
#################################################################################################



sub Query_numi {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$myschema,%sub_mensajes)  = @_;

   my $oracle_testing_table="V\$SESSION";
   my $coordx=1;
   my $coordy=1;

   my $numero_colum=9;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }

    cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

   my $sth = $sub_dbh->prepare("SELECT sid,process,username,status,state,sql_id,module,lockwait,seconds_in_wait
    FROM $oracle_testing_table  order by $order_num $order_tipo") or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Sid");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Process");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Username");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Status");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "State");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Sql_id");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Module");
   $coordx=$coordx+46;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Lockwait");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Seconds in wait");
   $coordx=$coordx+10;

   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=7;

    my $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40) )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $sid = $data[0];
     $sid = "----" unless defined($sid);
     $sid=trim($sid);
     imprime_color(YELLOW, "$sid");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $sprocess = $data[1];
     $sprocess = "----" unless defined($sprocess);
     $sprocess=trim($sprocess);
     imprime_color(YELLOW, "$sprocess");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $suser= $data[2];
     $suser = "----" unless defined($suser);
     $suser=trim($suser);
     $suser=substr($suser,0,19);
     imprime_color(YELLOW, "$suser");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $sstatus = $data[3];
     $sstatus = "----" unless defined($sstatus);
     $sstatus=trim($sstatus);
     imprime_color(YELLOW, "$sstatus");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $sstate = $data[4];
     $sstate = "----" unless defined($sstate);
     $sstate=trim($sstate);
     imprime_color(YELLOW, "$sstate");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $ssql = $data[5];
     $ssql = "----" unless defined($ssql);
     $ssql=trim($ssql);
     imprime_color(YELLOW, "$ssql");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $smodule = $data[6];
     $smodule = "----" unless defined($smodule);
     $smodule=trim($smodule);
     $smodule = substr($smodule,0,45);
     imprime_color(YELLOW, "$smodule");
     $coordx=$coordx+46;

     gotoxy($coordx,$coordy);
     my $slockw = $data[7];
     $slockw = "----" unless defined($slockw);
     $slockw=trim($slockw);
     imprime_color(YELLOW, "$slockw");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $sinwait = $data[8];
     $sinwait = "----" unless defined($sinwait);
     $sinwait=trim($sinwait);
     imprime_color(YELLOW, "$sinwait");
     $coordx=$coordx+10;

     print "\n";
 
     $coordy++;
     $cont++;
 }

 if ($sth->rows == 0)
     {
    print "\n";
     }
    $sth->finish;

          gotoxy(75,20);
          imprime_color(GREEN, "--------------------");
          gotoxy(75,21);
          imprime_color(GREEN, "-PROCESS ID        -");
          gotoxy(75,22);
          imprime_color(GREEN, "                    ");
          gotoxy(75,23);
          imprime_color(GREEN, "--------------------");
          gotoxy(75,22);
          $sqltexto = <STDIN>;
          chomp($sqltexto);
          print "\n";

     $sqltexto=trim($sqltexto);


 return ($sqltexto)
  }




###########################################################################################
#  Rutina Query_num4
########################################################################################


sub Query_num4 {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$filter,$myschema,%sub_mensajes)  = @_;

   my $oracle_testing_table="V\$SESSION";
   my $coordx=1;
   my $coordy=1;
   my $sth;

   my $numero_colum=9;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }
                                    
    cabecera_fil($order_num,$ora_ret,$ora_user, $ora_sid,$filter,$myschema,%sub_mensajes);


   if ( $filter eq "") {
       $sth = $sub_dbh->prepare("SELECT sid,process,username,status,state,sql_id,module,lockwait,seconds_in_wait
    FROM $oracle_testing_table  order by $order_num $order_tipo") or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;
                      }
   else  {
      my $filteraux=$filter.'%';
      $sth = $sub_dbh->prepare("SELECT sid,process,username,status,state,sql_id,module,lockwait,seconds_in_wait
    FROM $oracle_testing_table  where process like '$filteraux' order by $order_num $order_tipo") or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;
         }


   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Sid");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(CYAN, "Process");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Username");
   $coordx=$coordx+20;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Status");
   $coordx=$coordx+10;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "State");
   $coordx=$coordx+20;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Sql_id");
   $coordx=$coordx+15;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Module");
   $coordx=$coordx+46;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Lockwait");
   $coordx=$coordx+20;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Seconds in wait");
   $coordx=$coordx+10;
   

   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=7;

    my $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40) )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $sid = $data[0];
     $sid = "----" unless defined($sid);
     $sid=trim($sid);
     imprime_color(YELLOW, "$sid");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $sprocess = $data[1];
     $sprocess = "----" unless defined($sprocess);
     $sprocess=trim($sprocess);
     imprime_color(YELLOW, "$sprocess");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $suser= $data[2];
     $suser = "----" unless defined($suser);
     $suser=trim($suser);
     $suser=substr($suser,0,19);
     imprime_color(YELLOW, "$suser");
     $coordx=$coordx+20;
     
     gotoxy($coordx,$coordy);
     my $sstatus = $data[3];
     $sstatus = "----" unless defined($sstatus);
     $sstatus=trim($sstatus);
     imprime_color(YELLOW, "$sstatus");
     $coordx=$coordx+10;
     
     gotoxy($coordx,$coordy);
     my $sstate = $data[4];
     $sstate = "----" unless defined($sstate);
     $sstate=trim($sstate);
     imprime_color(YELLOW, "$sstate");
     $coordx=$coordx+20;
     
     gotoxy($coordx,$coordy);
     my $ssql = $data[5];
     $ssql = "----" unless defined($ssql);
     $ssql=trim($ssql);
     imprime_color(YELLOW, "$ssql");
     $coordx=$coordx+15;
     
     gotoxy($coordx,$coordy);
     my $smodule = $data[6];
     $smodule = "----" unless defined($smodule);
     $smodule=trim($smodule);
     $smodule = substr($smodule,0,45);
     imprime_color(YELLOW, "$smodule");
     $coordx=$coordx+46;
     
     gotoxy($coordx,$coordy);
     my $slockw = $data[7];
     $slockw = "----" unless defined($slockw);
     $slockw=trim($slockw);
     imprime_color(YELLOW, "$slockw");
     $coordx=$coordx+20;
     
     gotoxy($coordx,$coordy);
     my $sinwait = $data[8];
     $sinwait = "----" unless defined($sinwait);
     $sinwait=trim($sinwait);
     imprime_color(YELLOW, "$sinwait");
     $coordx=$coordx+10;
     
     print "\n";
     $coordy++;

     $cont++;
 }

 if ($sth->rows == 0)
 {
 #    print "Table vide\n";
 }

 $sth->finish;
 return ()
  }
###########################################################################################
#  Rutina Query_num5-a
########################################################################################


sub Query_num5 {
        my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$myschema,%sub_mensajes)  = @_;

   my $oracle_testing_table="select * from table (DBMS_WORKLOAD_REPOSITORY.select_baseline_metric(\'SYSTEM_MOVING_WINDOW\'))";
   my $coordx=1;
   my $coordy=1;


   my $numero_colum=3;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }

    cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

   my $sth = $sub_dbh->prepare("SELECT metric_name,average,maximum FROM ($oracle_testing_table) where lower(metric_name)
   like \'\%read\%\'  order by $order_num $order_tipo")
   or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Read Metric Name");
   $coordx=$coordx+50;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Average");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Maximum");
   $coordx=$coordx+15;

   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=8;

    my $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40 ) )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $name = $data[0];
     $name=trim($name);
     imprime_color(YELLOW, "$name");
     $coordx=$coordx+50;

     gotoxy($coordx,$coordy);
     my $avera = $data[1];
     if (looks_like_number($avera)) {
                               if ( $avera == 0 ) {
                                            $avera=',0000';
                                                  }
                                             else {
                                           $avera= sprintf '%.4f' , $avera / 1;
                                                 }

                                     }
         else {
                my ($intavera,$decavera)=split(/,/,$avera) ;
                $decavera=substr($decavera,0,4);
                $avera=$intavera.','.$decavera;
                }
     imprime_color(YELLOW, "$avera");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $maxim= $data[2];
     if (looks_like_number($maxim)) {
                               if ( $maxim == 0 ) {
                                            $maxim=',0000';
                                                  }
                                             else {
                                           $maxim= sprintf '%.4f' , $maxim / 1;
                                                 }

                                    }
         else {
              my ($intmaxim,$decmaxim)=split(/,/,$maxim) ;
              $decmaxim=substr($decmaxim,0,4);
              $maxim=$intmaxim.','.$decmaxim;
              }
     imprime_color(YELLOW, "$maxim");
     $coordx=$coordx+15;
     $coordy++;
     $cont++;

 }

 if ($sth->rows == 0)
 {
     print "Table \n";
 }

 $sth->finish;
 
###########################################################################################
#  Rutina Query_num5-b
########################################################################################

    $oracle_testing_table="select * from table (DBMS_WORKLOAD_REPOSITORY.select_baseline_metric(\'SYSTEM_MOVING_WINDOW\'))";
    $coordx=84;
    $coordy=1;


    $numero_colum=3;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }


   $sth = $sub_dbh->prepare("SELECT metric_name,average,maximum FROM ($oracle_testing_table) where lower(metric_name)
   like \'\%write\%\'  order by $order_num $order_tipo")
   or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Write Metric Name");
   $coordx=$coordx+50;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Average");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Maximum");
   $coordx=$coordx+15;

   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=8;

    $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40 ) )
 {
     $coordx=87;

     gotoxy($coordx,$coordy);
     my $name = $data[0];
     $name=trim($name);
     imprime_color(YELLOW, "$name");
     $coordx=$coordx+50;

     gotoxy($coordx,$coordy);
     my $avera = $data[1];
     if (looks_like_number($avera)) {
                               if ( $avera == 0 ) {
                                            $avera=',0000';
                                                  }
                                             else {
                                           $avera= sprintf '%.4f' , $avera / 1;
                                                 }

                                     }
         else {
                my ($intavera,$decavera)=split(/,/,$avera) ;
                $decavera=substr($decavera,0,4);
                $avera=$intavera.','.$decavera;
                }
     imprime_color(YELLOW, "$avera");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $maxim= $data[2];
     if (looks_like_number($maxim)) {
                               if ( $maxim == 0 ) {
                                            $maxim=',0000';
                                                  }
                                             else {
                                           $maxim= sprintf '%.4f' , $maxim / 1;
                                                 }

                                    }
         else {
              my ($intmaxim,$decmaxim)=split(/,/,$maxim) ;
              $decmaxim=substr($decmaxim,0,4);
              $maxim=$intmaxim.','.$decmaxim;
              }
     imprime_color(YELLOW, "$maxim");
     $coordx=$coordx+15;

     $coordy++;
     $cont++;

 }

 if ($sth->rows == 0)
 {
     print "Table \n";
 }

 $sth->finish;

###########################################################################################
#  Rutina Query_num5-c
########################################################################################

    $oracle_testing_table="select * from table (DBMS_WORKLOAD_REPOSITORY.select_baseline_metric(\'SYSTEM_MOVING_WINDOW\'))";
    $coordx=1;
    $coordy=25;


    $numero_colum=3;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }


   $sth = $sub_dbh->prepare("SELECT metric_name,average,maximum FROM ($oracle_testing_table) where lower(metric_name)
   like \'\%ratio\%\'  order by $order_num $order_tipo")
   or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Ratio Metric Name");
   $coordx=$coordx+50;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Average");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Maximum");
   $coordx=$coordx+15;

   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;

    $coordy=32;

    $cont=1;


    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40 ) )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $name = $data[0];
     $name=trim($name);
     imprime_color(YELLOW, "$name");
     $coordx=$coordx+50;

     gotoxy($coordx,$coordy);
     my $avera = $data[1];
     if (looks_like_number($avera)) {
                               if ( $avera == 0 ) {
                                            $avera=',0000';
                                                  }
                                            else {
                                           $avera= sprintf '%.4f' , $avera / 1;
                                                 }
                                     }
         else {
                my ($intavera,$decavera)=split(/./,$avera) ;
                $decavera=substr($decavera,0,4);
                $avera=$intavera.','.$decavera;
                }
     imprime_color(YELLOW, "$avera");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $maxim= $data[2];
     if (looks_like_number($maxim)) {
                               if ( $maxim == 0 ) {
                                            $maxim=',0000';
                                                  }
                                     else {
                                           $maxim= sprintf '%.4f' , $maxim / 1;
                                                 }

                                    }
         else {
              my ($intmaxim,$decmaxim)=split(/,/,$maxim) ;
              $decmaxim=substr($decmaxim,0,4);
              $maxim=$intmaxim.','.$decmaxim;
              }
     imprime_color(YELLOW, "$maxim");
     $coordx=$coordx+15;
     $coordy++;
     $cont++;

 }

 if ($sth->rows == 0)
 {
     print "Table \n";
 }

 $sth->finish;
 
###########################################################################################
#  Rutina Query_num5-d
########################################################################################

    $oracle_testing_table="select * from table (DBMS_WORKLOAD_REPOSITORY.select_baseline_metric(\'SYSTEM_MOVING_WINDOW\'))";
    $coordx=80;
    $coordy=20;


    $numero_colum=3;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }


   $sth = $sub_dbh->prepare("SELECT metric_name,average,maximum FROM ($oracle_testing_table) where lower(metric_name)
   like \'\%redo\%\'  order by $order_num $order_tipo")
   or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Redo Metric Name");
   $coordx=$coordx+50;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Average");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Maximum");
   $coordx=$coordx+15;

   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;

    $coordy=27;

    $cont=1;


    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40 ) )
 {
     $coordx=83;

     gotoxy($coordx,$coordy);
     my $name = $data[0];
     $name=trim($name);
     imprime_color(YELLOW, "$name");
     $coordx=$coordx+50;

     gotoxy($coordx,$coordy);
     my $avera = $data[1];
     if (looks_like_number($avera)) {
                               if ( $avera == 0 ) {
                                            $avera=',0000';
                                                  }
                                             else {
                                           $avera= sprintf '%.4f' , $avera / 1;
                                                 }

                                     }
         else {
                my ($intavera,$decavera)=split(/,/,$avera) ;
                $decavera=substr($decavera,0,4);
                $avera=$intavera.','.$decavera;
                }
     imprime_color(YELLOW, "$avera");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $maxim= $data[2];
     if (looks_like_number($maxim)) {
                               if ( $maxim == 0 ) {
                                            $maxim=',0000';
                                                  }
                                             else {
                                           $maxim= sprintf '%.4f' , $maxim / 1;
                                                 }

                                    }
         else {
              my ($intmaxim,$decmaxim)=split(/,/,$maxim) ;
              $decmaxim=substr($decmaxim,0,4);
              $maxim=$intmaxim.','.$decmaxim;
              }
     imprime_color(YELLOW, "$maxim");
     $coordx=$coordx+15;
     $coordy++;
     $cont++;

 }

 if ($sth->rows == 0)
 {
     print "Table \n";
 }

 $sth->finish;

###########################################################################################
#  Rutina Query_num5-e
########################################################################################

    $oracle_testing_table="select * from table (DBMS_WORKLOAD_REPOSITORY.select_baseline_metric(\'SYSTEM_MOVING_WINDOW\'))";
    $coordx=80;
    $coordy=30;


    $numero_colum=3;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }


   $sth = $sub_dbh->prepare("SELECT metric_name,average,maximum FROM ($oracle_testing_table) where lower(metric_name)
   like \'\%undo\%\'  order by $order_num $order_tipo")
   or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Undo Metric Name");
   $coordx=$coordx+50;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Average");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Maximum");
   $coordx=$coordx+15;

   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;

    $coordy=37;

    $cont=1;


    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40 ) )
 {
     $coordx=83;

     gotoxy($coordx,$coordy);
     my $name = $data[0];
     $name=trim($name);
     imprime_color(YELLOW, "$name");
     $coordx=$coordx+50;

     gotoxy($coordx,$coordy);
     my $avera = $data[1];
     if (looks_like_number($avera)) {
                               if ( $avera == 0 ) {
                                            $avera=',0000';
                                                  }
                                             else {
                                           $avera= sprintf '%.4f' , $avera / 1;
                                                 }

                                     }
         else {
                my ($intavera,$decavera)=split(/,/,$avera) ;
                $decavera=substr($decavera,0,4);
                $avera=$intavera.','.$decavera;
                }
     imprime_color(YELLOW, "$avera");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $maxim= $data[2];
     if (looks_like_number($maxim)) {
                               if ( $maxim == 0 ) {
                                            $maxim=',0000';
                                                  }
                                             else {
                                           $maxim= sprintf '%.4f' , $maxim / 1;
                                                 }

                                    }
         else {
              my ($intmaxim,$decmaxim)=split(/,/,$maxim) ;
              $decmaxim=substr($decmaxim,0,4);
              $maxim=$intmaxim.','.$decmaxim;
              }
     imprime_color(YELLOW, "$maxim");
     $coordx=$coordx+15;
     print "\n";
     $coordy++;
     $cont++;

 }

 if ($sth->rows == 0)
 {
     print "Table \n";
 }

 $sth->finish;

  }
  
########################################################################################
#  Rutina Query_num6-a
########################################################################################


sub Query_num6 {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$myschema,%sub_mensajes)  = @_;

   my $coordx=1;
   my $coordy=1;


   my $numero_colum=5;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }

   cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

   my $sth = $sub_dbh->prepare("select sea.event, sea.total_waits, (sea.time_waited/10), (sea.average_wait/10),swc.wait_class
    from v\$system_event sea, v\$event_name enb, v\$system_wait_class swc where sea.event_id=enb.event_id
    and enb.wait_class\#=swc.wait_class\# and swc.wait_class <> 'Idle' order by $order_num $order_tipo")
     or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;



   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Evento");
   $coordx=$coordx+35;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Total_wait");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Time_waited(msec)");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Average_wait(msec)");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Class_Wait");
   $coordx=$coordx+15;


   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=7;

    my $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40 ) )

 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $eventname = $data[0];
     $eventname=trim($eventname);
     $eventname=substr($eventname,0,29);
     imprime_color(YELLOW, "$eventname");
     $coordx=$coordx+35;

     gotoxy($coordx,$coordy);
     my $totwait= $data[1];
     $totwait=trim($totwait);
     imprime_color(YELLOW, "$totwait");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $timewait= $data[2];
     $timewait=trim($timewait);
     imprime_color(YELLOW, "$timewait");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $avwait= $data[3];
     $avwait=trim($avwait);
     imprime_color(YELLOW, "$avwait");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $classname= $data[4];
     $classname=trim($classname);
     imprime_color(YELLOW, "$classname");
     $coordx=$coordx+15;




     print "\n";
 #    print "$id: $username $acct \n";
     $coordy++;
     $cont++;

 }

 if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;
########################################################################################
#  Rutina Query_num6-b
########################################################################################

 
 
    $coordx=110;
    $coordy=1;


   $numero_colum=3;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }


   $sth = $sub_dbh->prepare("select wait_class,sum(time_waited)/10, (sum(time_waited)/sum(total_waits))/10 from v\$system_wait_class
   group by wait_class order by $order_num $order_tipo")
     or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;



   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Class");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Time_waited(msec)");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Average_waited(msec)");
   $coordx=$coordx+12;


   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=7;

     $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40 ) )

 {
     $coordx=113;

     gotoxy($coordx,$coordy);
     my $class = $data[0];
     $class=trim($class);
     imprime_color(YELLOW, "$class");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $cwait= $data[1];
     $cwait=trim($cwait);
     imprime_color(YELLOW, "$cwait");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $caverage= $data[2];
     $caverage=trim($caverage);

     if (looks_like_number($caverage)) {
                               if ( $caverage == 0 ) {
                                            $caverage=',00';
                                                  }
                                    else {
                                           $caverage= sprintf '%.4f' , $caverage / 1;
                                                 }
                                    }
         else {
              my ($intcav,$deccav)=split(/,/,$caverage) ;
              $deccav=substr($deccav,0,2);
              $caverage=$intcav.','.$deccav;
              }
     imprime_color(YELLOW, "$caverage");
     $coordx=$coordx+12;



     print "\n";

     $coordy++;
     $cont++;

 }

 if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;
 
 
 return ()
  }
  
###########################################################################################
#  Rutina Query_num7
########################################################################################


sub Query_num7 {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$myschema,%sub_mensajes)  = @_;

   my $coordx=1;
   my $coordy=1;


   my $numero_colum=9;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }

   cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

   my $sth = $sub_dbh->prepare("select a.process,a.username, a.sid, a.blocking_session, a.wait_class, a.seconds_in_wait,
   b.TYPE, b.LMODE, c.OBJECT_NAME from V\$SESSION a,  V\$LOCK b, DBA_OBJECTS C where a.blocking_session is not null
   and b.ID1=c.OBJECT_ID AND B.BLOCK > 0 order by $order_num $order_tipo") or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;



   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Process");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "User Name");
   $coordx=$coordx+30;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "SID");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Blocking Session");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Wait Class");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Second in wait");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Type    ");
   $coordx=$coordx+10;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Mode    ");
   $coordx=$coordx+10;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Object  ");
   $coordx=$coordx+10;

   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=7;

    my $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40 ) )

 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $nprocess = $data[0];
     $nprocess = "NULL" unless defined($nprocess);
     $nprocess=trim($nprocess);
     imprime_color(YELLOW, "$nprocess");
     $coordx=$coordx+20;
     
     gotoxy($coordx,$coordy);
     my $usern = $data[1];
     $usern = "NULL" unless defined($usern);
     $usern=trim($usern);
     imprime_color(YELLOW, "$usern");
     $coordx=$coordx+30;

     gotoxy($coordx,$coordy);
     my $sid= $data[2];
     $sid=trim($sid);
     imprime_color(YELLOW, "$sid");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $bsess= $data[3];
     $bsess=trim($bsess);
     imprime_color(YELLOW, "$bsess");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $wclass= $data[4];
     $wclass=trim($wclass);
     imprime_color(YELLOW, "$wclass");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $secw= $data[5];
     $secw=trim($secw);
     imprime_color(YELLOW, "$secw");
     $coordx=$coordx+20;
     
     gotoxy($coordx,$coordy);
     my $btype= $data[6];
     $btype=trim($btype);
     imprime_color(YELLOW, "$btype");
     $coordx=$coordx+10;
     
     gotoxy($coordx,$coordy);
     my $bmode= $data[7];
     $bmode=trim($bmode);
     imprime_color(YELLOW, "$bmode");
     $coordx=$coordx+10;
     
     gotoxy($coordx,$coordy);
     my $bobj= $data[8];
     $bobj=trim($bobj);
     imprime_color(YELLOW, "$bobj");
     $coordx=$coordx+10;


     print "\n";
 #    print "$id: $username $acct \n";
     $coordy++;
     $cont++;

 }

 if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;
 return ()
  }
  
###########################################################################################
#  Rutina Query_num8
########################################################################################


sub Query_num8 {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$myschema,%sub_mensajes)  = @_;

   my $coordx=1;
   my $coordy=1;


   my $numero_colum=4;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }

   cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

   my $sth = $sub_dbh->prepare(" select a.tablespace_name, sum(a.bytes/1024/1024) , sum(b.bytes_used/1024/1024) ,
 sum(b.bytes_free/1024/1024)  from dba_temp_files a,  v\$temp_space_header b where a.tablespace_name=b.tablespace_name group by a.tablespace_name order by $order_num $order_tipo")
 or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Tablespace Name");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Allocated (M)");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Used");
   $coordx=$coordx+10;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Free");
   $coordx=$coordx+10;

   $sth->execute()
   or die print "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=7;

    my $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40) )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $tablen = $data[0];
     $tablen=trim($tablen);
     imprime_color(YELLOW, "$tablen");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $nalloc = $data[1];
     $nalloc=trim($nalloc);
     imprime_color(YELLOW, "$nalloc");
     $coordx=$coordx+15;
     
     gotoxy($coordx,$coordy);
     my $nused = $data[2];
     $nused=trim($nused);
     imprime_color(YELLOW, "$nused");
     $coordx=$coordx+10;
     

     gotoxy($coordx,$coordy);
     my $nfree= $data[3];
     $nfree=trim($nfree);
     imprime_color(YELLOW, "$nfree");
     $coordx=$coordx+10;
     print "\n";
     $coordy++;

     $cont++;
 }

 if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;




###########################################################################################
#  Rutina Query_num8-b
########################################################################################


    $coordx=55;
    $coordy=1;


    $numero_colum=6;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }


   $sth = $sub_dbh->prepare(" select distinct se.sid, substr(se.username,1,20) , su.blocks * ts.block_size/1024/1024 mb_used, su.tablespace,
 sq.hash_value, substr(sq.sql_text,1,30) from v\$sort_usage su, V\$session se,
v\$sqlarea sq, dba_tablespaces ts where su.session_addr = se.saddr and su.sqladdr = sq.address (+)
and su.tablespace = ts.tablespace_name order by $order_num $order_tipo")
 or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "SID");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "User Name ");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Blocks M");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Tablespace");
   $coordx=$coordx+20;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Hash");
   $coordx=$coordx+14;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Sql Text");
   $coordx=$coordx+30;
   

   $sth->execute()
   or die print "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=7;

     $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40) )
 {
     $coordx=58;

     gotoxy($coordx,$coordy);
     my $bsid = $data[0];
     $bsid=trim($bsid);
     imprime_color(YELLOW, "$bsid");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $busern = $data[1];
     $busern=" ------- " unless defined($busern);  #@FIX241019
     $busern=trim($busern);
     imprime_color(YELLOW, "$busern");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $bblock = $data[2];
     $bblock=trim($bblock);
     imprime_color(YELLOW, "$bblock");
     $coordx=$coordx+10;
     
     gotoxy($coordx,$coordy);
     my $btabsp = $data[3];
     $btabsp=trim($btabsp);
     imprime_color(YELLOW, "$btabsp");
     $coordx=$coordx+20;
     
     gotoxy($coordx,$coordy);
     my $bhash = $data[4];
     $bhash=trim($bhash);
     imprime_color(YELLOW, "$bhash");
     $coordx=$coordx+14;


     gotoxy($coordx,$coordy);
     my $btext= $data[5];
     $btext=trim($btext);
     imprime_color(YELLOW, "$btext");
     $coordx=$coordx+10;
     print "\n";
     $coordy++;

     $cont++;
 }

 if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;
 return ()
  }

#############################################################################################
##  Query numK_1
############################################################################################

sub Query_numK_i {

    my ($sub_dbh,$ora_ret,$ora_user, $ora_sid, $order_num, $sqlt,$myschema,%sub_mensajes)  = @_;

     my $coordx=1;
     my $coordy=1;
     my $comkill="";


   cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

     my  $sth = $sub_dbh->prepare("SELECT
  'USERNAME    : ' || s.username     || CHR(10) ||
  '                    SCHEMA      : ' || s.schemaname   || CHR(10) ||
  '                    OSUSER      : ' || s.osuser       || CHR(10) ||
  '                    MODULE      : ' || s.program      || CHR(10) ||
  '                    ACTION      : ' || s.schemaname   || CHR(10) ||
  '                    CLIENT_INFO : ' || s.osuser       || CHR(10) ||
  '                    PROGRAM     : ' || s.program      || CHR(10) ||
  '                    SPID        : ' || p.spid         || CHR(10) ||
  '                    SID         : ' || s.sid          || CHR(10) ||
  '                    SERIAL#     : ' || s.serial#      || CHR(10) ||
  '                    KILL STRING : ' || '''' || s.sid || ',' || s.serial# || ''''  || CHR(10) ||
  '                    MACHINE     : ' || s.machine      || CHR(10) ||
  '                    TYPE        : ' || s.type         || CHR(10) ||
  '                    TERMINAL    : ' || s.terminal     || CHR(10) ||
  '                    SQL ID      : ' || q.sql_id       || CHR(10) ||
  '                    CHILD_NUM   : ' || q.child_number || CHR(10) ||
  '                    SQL TEXT    : ' || q.sql_text
FROM v\$session s
    ,v\$process p
    ,v\$sql     q
WHERE s.paddr  = p.addr
AND   p.spid   = '$sqlt'
AND   s.sql_id = q.sql_id(+)
AND   s.status = 'ACTIVE' ") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;
 
    $sth->execute();

    if ($sth->err)   {
          ReadMode 0;
          cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);
          gotoxy(5,10);
          imprime_color(RED, "$sub_mensajes{'msg4'} " ) ;
          gotoxy(5,11);
          imprime_color(RED,  $sth->errstr) ;
          $sth->finish;
          my $codigo = <STDIN>;
          ReadMode 4;
          return 4;
                     }

   $coordx=40;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Process");
   $coordx=51;
   imprime_color(GREEN,"$sub_mensajes{'msg28'}");
   $coordy++;


    while ( (my @data = $sth->fetchrow_array() )  )
   {
     $coordx=20;
     $coordy=10;

               gotoxy($coordx,$coordy);
               my $expla = $data[0];
               $expla=trim($expla);
               imprime_color(YELLOW, "$expla");

               print "\n";

                 }

$sth->finish;

$sth = $sub_dbh->prepare("SELECT
' ALTER SYSTEM KILL SESSION ' || '''' || s.sid || ',' || s.serial# || ''' IMMEDIATE;'  
FROM v\$session s
    ,v\$process p
    ,v\$sql     q
WHERE s.paddr  = p.addr
AND   p.spid   = '$sqlt'
AND   s.sql_id = q.sql_id(+)
AND   s.status = 'ACTIVE' ") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

$sth->execute();

    if ($sth->err)   {
          ReadMode 0;
          cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);
          gotoxy(5,10);
          imprime_color(RED, "$sub_mensajes{'msg4'} " ) ;
          gotoxy(5,11);
          imprime_color(RED,  $sth->errstr) ;
          $sth->finish;
          ReadMode 4;
          return 4;
                     }

 while ( (my @data = $sth->fetchrow_array() )  )
   {
               $comkill = $data[0];
               $comkill=trim($comkill);
               print "\n";
               $coordy++;

                 }

          gotoxy(75,20);
          imprime_color(GREEN, "------------------------------------------------");
          gotoxy(75,21);
          imprime_color(GREEN, "$sub_mensajes{'msg27'}");
          gotoxy(75,22);
          imprime_color(GREEN, "  $sqlt                  ");
          gotoxy(75,23);
          imprime_color(GREEN, "  $comkill                  ");
          gotoxy(75,24);   
          imprime_color(GREEN, "------------------------------------------------");
          gotoxy(75,25);
          $comconf = <STDIN>;
          chomp($comconf);
          print "\n";

          if ( lc($comconf) eq 'Y' ) {
                   $sth->finish;
                   $sth = $sub_dbh->prepare(" $comkill ") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr; 
                   $sth->execute();

                   if ($sth->err)   {
                      ReadMode 0;
                      cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);
                      gotoxy(5,10);
                      imprime_color(RED, "$sub_mensajes{'msg4'} " ) ;
                      gotoxy(5,11);
                      imprime_color(RED,  $sth->errstr) ;
                      $sth->finish;
                      ReadMode 4;
                      return 4;    
                                     } 

                                   }
        if ($sth->rows == 0)
           {
           $coordy++;
           $coordy++;
           $coordx=40;
           gotoxy($coordx,$coordy);
           imprime_color(WHITE, "$sub_mensajes{'msg26'} ");
           print " \n";
           }

        $sth->finish;
return 0

}

#############################################################################################
##  Query num9_i_wa
##############################################################################################
sub Query_num9_i_wa {

    my ($sub_dbh,$ora_ret,$ora_user, $ora_sid, $order_num, $sqlt,$myschema,%sub_mensajes)  = @_;

     my $coordx=1;
     my $coordy=1;

     my $numero_colum=5;
   
     if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
      if ($order_num < 1) {
                                    $order_num=1;
                                    }
  


   cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

    my  $sth = $sub_dbh->prepare("SELECT sid, EVENT, TOTAL_WAITS, TIME_WAITED, WAIT_CLASS from v\$SESSION_EVENT where WAIT_CLASS != 'Idle' AND  sid = '$sqlt' order by TIME_WAITED") 
         or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "SID");
   $coordx=$coordx+8;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Event");
   $coordx=$coordx+40;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Iotal waits");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Time waited");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Wait class");
   $coordx=$coordx+40;
   
    $sth->execute()
   or die print "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=7;

    my $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 10) )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $wsid = $data[0];
     $wsid=trim($wsid);
     imprime_color(YELLOW, "$wsid");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     my $wev = $data[1];
     $wev=trim($wev);
     imprime_color(YELLOW, "$wev");
     $coordx=$coordx+40;

     gotoxy($coordx,$coordy);
     my $wtw = $data[2];
     $wtw=trim($wtw);
     imprime_color(YELLOW, "$wtw");
     $coordx=$coordx+15;


     gotoxy($coordx,$coordy);
     my $wtd= $data[3];
     $wtd=trim($wtd);
     imprime_color(YELLOW, "$wtd");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $wwc= $data[4];
     $wwc=trim($wwc);
     imprime_color(YELLOW, "$wwc");
     $coordx=$coordx+40;


     print "\n";
     $coordy++;

     $cont++;
 }

 #############################################################################################
 ###  Query num9_i_wa_b
 ###############################################################################################    

      $coordx=1;
      $coordy=13;

  $sth = $sub_dbh->prepare("select sid, event#, event, p1text, p2text,wait_time,TIME_SINCE_LAST_WAIT_MICRO from V\$SESSION_WAIT_HISTORY where sid = '$sqlt'") 
         or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

    $coordx=$coordx+3;
    $coordy=$coordy+5;

    gotoxy(60,$coordy);
    imprime_color(GREEN, "Last 10 waits ");
    $coordy++;
    $coordy++;

    gotoxy($coordx,$coordy);
    imprime_color(WHITE, "SID");
    $coordx=$coordx+8;

    gotoxy($coordx,$coordy);
    imprime_color(WHITE, "Event #");
    $coordx=$coordx+8;

    gotoxy($coordx,$coordy);
    imprime_color(WHITE, "Event ");
    $coordx=$coordx+40; 

    gotoxy($coordx,$coordy);
    imprime_color(WHITE, "P1 Text ");
    $coordx=$coordx+40;

    gotoxy($coordx,$coordy);
    imprime_color(WHITE, "P2 Text ");
    $coordx=$coordx+40;

    gotoxy($coordx,$coordy);
    imprime_color(WHITE, "Wait time (mseg)");
    $coordx=$coordx+20;

    gotoxy($coordx,$coordy);
    imprime_color(WHITE, "T. since last wait (microseg)");
    $coordx=$coordx+15;

    $sth->execute()
   or die print "$sub_mensajes{'msg4'} " . $sth->errstr;
    

    $coordy++;

     $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 10) )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $wsid = $data[0];
     $wsid=trim($wsid);
     imprime_color(YELLOW, "$wsid");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     my $wenu = $data[1];
     $wenu=trim($wenu);
     imprime_color(YELLOW, "$wenu");
     $coordx=$coordx+8;
 
     gotoxy($coordx,$coordy);
     my $wevt = $data[2];
     $wevt=trim($wevt);
     imprime_color(YELLOW, "$wevt");
     $coordx=$coordx+40;

      gotoxy($coordx,$coordy);
     my $wp1 = $data[3];
     $wp1=trim($wp1);
     imprime_color(YELLOW, "$wp1");
     $coordx=$coordx+40; 
 
     gotoxy($coordx,$coordy);
     my $wp2 = $data[4];
     $wp2=trim($wp2);
     imprime_color(YELLOW, "$wp2");
     $coordx=$coordx+40; 

     gotoxy($coordx,$coordy);
     my $wwt = $data[5]*10;
     $wwt=trim($wwt);
     imprime_color(YELLOW, "$wwt");
     $coordx=$coordx+20; 

     gotoxy($coordx,$coordy);
     my $wwl = $data[6];
     $wwl=trim($wwl);
     imprime_color(YELLOW, "$wwl");
     $coordx=$coordx+15;

     $coordy++;
     $cont++;
    } 

#############################################################################################
# ###  Query num9_i_wa_c
################################################################################################

     $coordx=1;
     $coordy=27;

  $sth = $sub_dbh->prepare("select to_char(SAMPLE_time, 'DD-MON-RR HH24:MI:SS'), SESSION_ID, SQL_ID,EVENT, WAIT_TIME, TIME_WAITED, P1TEXT from V\$ACTIVE_SESSION_HISTORY 
  where SESSION_ID = '$sqlt'  order by sample_time desc ") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr; 


    $coordx=$coordx+3;
    $coordy=$coordy+5;

    gotoxy(60,$coordy);
    imprime_color(GREEN, "Last waits recorded in ASH ");
    $coordy++;
    $coordy++;
  


    gotoxy($coordx,$coordy);
    imprime_color(WHITE, "Sample time");
    $coordx=$coordx+22;

    gotoxy($coordx,$coordy);
    imprime_color(WHITE, "SID");
    $coordx=$coordx+8;

    gotoxy($coordx,$coordy);
    imprime_color(WHITE, "Sql id");
    $coordx=$coordx+15;

    gotoxy($coordx,$coordy);
    imprime_color(WHITE, "Event");
    $coordx=$coordx+40;

    gotoxy($coordx,$coordy);
    imprime_color(WHITE, "Wait time");
    $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
    imprime_color(WHITE, "Time waited");
    $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
    imprime_color(WHITE, "P1 Text");
    $coordx=$coordx+40;


     $sth->execute()
   or die print "$sub_mensajes{'msg4'} " . $sth->errstr;


    $coordy++;

     $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 10) )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $wst = $data[0];
     $wst=trim($wst);
     imprime_color(YELLOW, "$wst");
     $coordx=$coordx+22;

     gotoxy($coordx,$coordy);
     my $wsit = $data[1];
     $wsit=trim($wsit);
     imprime_color(YELLOW, "$wsit");
     $coordx=$coordx+8;
 
     gotoxy($coordx,$coordy);
     my $wsq = $data[2];
     $wsq = " " unless defined($wsq);
     $wsq=trim($wsq);
     imprime_color(YELLOW, "$wsq");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $wsevt = $data[3];
     $wsevt = " " unless defined($wsevt); 
     $wsevt=trim($wsevt);
     imprime_color(YELLOW, "$wsevt");
     $coordx=$coordx+40;

     gotoxy($coordx,$coordy);
     my $wstwt = $data[4];
     $wstwt = " " unless defined($wstwt);
     $wstwt=trim($wstwt);
     imprime_color(YELLOW, "$wstwt");
     $coordx=$coordx+10;
  
     gotoxy($coordx,$coordy);
     my $wsttt = $data[5];
     $wsttt=trim($wsttt);
     imprime_color(YELLOW, "$wsttt");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $wstp1 = $data[6];
     $wstp1 = " " unless defined($wstp1); 
     $wstp1=trim($wstp1);
     imprime_color(YELLOW, "$wstp1");
     $coordx=$coordx+15;

      $coordy++;
     $cont++;

    }  



    if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;
 return 0
  }
 



#############################################################################################
#  Query num9_i
#############################################################################################  


sub Query_num9_i {
  
    my ($sub_dbh,$ora_ret,$ora_user, $ora_sid, $order_num, $sqlt,$myschema,%sub_mensajes)  = @_;

     my $coordx=1;
     my $coordy=1;



   cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

   my  $sth = $sub_dbh->prepare("SELECT
  'USERNAME    : ' || s.username     || CHR(10) ||
  '                    SCHEMA      : ' || s.schemaname   || CHR(10) ||
  '                    OSUSER      : ' || s.osuser       || CHR(10) ||
  '                    MODULE      : ' || s.program      || CHR(10) ||
  '                    ACTION      : ' || s.schemaname   || CHR(10) ||
  '                    CLIENT_INFO : ' || s.osuser       || CHR(10) ||
  '                    PROGRAM     : ' || s.program      || CHR(10) ||
  '                    SPID        : ' || p.spid         || CHR(10) ||
  '                    SID         : ' || s.sid          || CHR(10) ||
  '                    SERIAL#     : ' || s.serial#      || CHR(10) ||
  '                    KILL STRING : ' || '''' || s.sid || ',' || s.serial# || ''''  || CHR(10) ||
  '                    MACHINE     : ' || s.machine      || CHR(10) ||
  '                    TYPE        : ' || s.type         || CHR(10) ||
  '                    TERMINAL    : ' || s.terminal     || CHR(10) ||
  '                    SQL ID      : ' || q.sql_id       || CHR(10) ||
  '                    CHILD_NUM   : ' || q.child_number || CHR(10) ||
  '                    SQL TEXT    : ' || q.sql_text
FROM v\$session s
    ,v\$process p
    ,v\$sql     q
WHERE s.paddr  = p.addr
AND   p.spid   = '$sqlt'
AND   s.sql_id = q.sql_id(+)
AND   s.status = 'ACTIVE' ") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;

    $sth->execute();

    if ($sth->err)   {
          ReadMode 0;
          cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);
          gotoxy(5,10);
          imprime_color(RED, "$sub_mensajes{'msg4'} " ) ;
          gotoxy(5,11);
          imprime_color(RED,  $sth->errstr) ;
          $sth->finish;
          my $codigo = <STDIN>;
          ReadMode 4;
          return 4;
                     }
   
   $coordx=40;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Process");
   $coordx=51;
   imprime_color(GREEN,"$sub_mensajes{'msg28'}");
   $coordy++;
   

    while ( (my @data = $sth->fetchrow_array() )  )
   {
     $coordx=20;
     $coordy=10;

               gotoxy($coordx,$coordy);
               my $expla = $data[0];
               $expla=trim($expla);
               imprime_color(YELLOW, "$expla");

               print "\n";

                 }

        if ($sth->rows == 0)
           {
           $coordy++;
           $coordy++;
           $coordx=40;
           gotoxy($coordx,$coordy);        
           imprime_color(WHITE, "$sub_mensajes{'msg26'} ");
           print " \n";
           }

        $sth->finish;
 return 0 
  }

sub Query_num9 {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid, $order_num, $sqlt,$myschema,%sub_mensajes)  = @_;

    my $sth = $sub_dbh->prepare(" ALTER SESSION SET CURRENT_SCHEMA=$myschema  ");

      $sth->execute();

    if ($sth->err)   {
          ReadMode 0;
          cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);
          gotoxy(5,10);
          imprime_color(RED, "$sub_mensajes{'msg55'} " ) ;
          gotoxy(5,11);
          imprime_color(RED,  $sth->errstr) ;
          $sth->finish;
          my $codigo = <STDIN>;
          ReadMode 4;
          return 4;
                     }
   
   $sth->finish;

     $sth = $sub_dbh->prepare(" explain plan for  $sqlt  ")
 or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr . $sqlt;
  
 
   $sth->execute();
   
   if ($sth->err)   {
          ReadMode 0;
          cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);
          gotoxy(5,10);
          imprime_color(RED, "$sub_mensajes{'msg4'} " ) ;
          gotoxy(5,11);
          imprime_color(RED,  $sth->errstr) ;
          $sth->finish;
          my $codigo = <STDIN>;
          ReadMode 4;
          return 4;
                     }
   
   $sth->finish;
   
   my $coordx=1;
   my $coordy=1;



   cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

   $sth = $sub_dbh->prepare(" select * from table(dbms_xplan.display) ") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Explain");
   $coordx=$coordx+20;


   $sth->execute()
   or die print "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=7;

    my $cont=1;
    my $linini=1;
    my $linact=1;
    
    if ( $order_num < 40 ) {
                            $cont = 1;
                            $linini=1;
                          }
                   else   {
                            $cont = 1;
                            $linini=$order_num-1;
                            
                          }

    while ( (my @data = $sth->fetchrow_array() )  )
 {
     $coordx=4;
     
    if (( $linact >= $linini ) and ($cont < 40) )  {

               gotoxy($coordx,$coordy);
               my $expla = $data[0];
               $expla=trim($expla);
               imprime_color(YELLOW, "$expla");
               $coordx=$coordx+20;

               print "\n";
               $coordy++;

               $cont++;
               $linact++;
                          }
                     else {
                           $linact++;
                          }
                           
 }

 if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;
 
 return 0;

  }
  
###########################################################################################
#  Rutina Query_numa
########################################################################################


sub Query_numa {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$myschema,%sub_mensajes)  = @_;

   my $coordx=1;
   my $coordy=1;


   my $numero_colum=12;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }

   cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

   my $sth = $sub_dbh->prepare("  select substr(sql_text,1,35),sql_id,sharable_mem, persistent_mem, executions, fetches,
 first_load_time, disk_reads, buffer_gets, rows_processed, cpu_time, elapsed_time
 from v\$sqlarea order by $order_num $order_tipo") or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;



   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Text");
   $coordx=$coordx+38;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Sql_id");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "ShMem K");
   $coordx=$coordx+9;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "PrMem K");
   $coordx=$coordx+8;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Exec.");
   $coordx=$coordx+11;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Fetch");
   $coordx=$coordx+11;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "First load time");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Disk Rd");
   $coordx=$coordx+10;

   #gotoxy($coordx,$coordy);
   #imprime_color(WHITE, "Dir Wr ");
   #$coordx=$coordx+10;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Buf.get");
   $coordx=$coordx+13;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Rows");
   $coordx=$coordx+10;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Cpu ms.");
   $coordx=$coordx+10;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Elapsed ms.");
  # $coordx=$coordx+12;

   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=7;

    my $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40 ) )

 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $ntexto = $data[0];
     $ntexto=trim($ntexto);
     imprime_color(YELLOW, "$ntexto");
     $coordx=$coordx+38;

     gotoxy($coordx,$coordy);
     my $nsqlid = $data[1];
     $nsqlid=trim($nsqlid);
     imprime_color(YELLOW, "$nsqlid");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $nshmem= $data[2];
     $nshmem=trim($nshmem);
     $nshmem = sprintf '%.1f', $nshmem / 1024;
     imprime_color(YELLOW, "$nshmem");
     $coordx=$coordx+9;

     gotoxy($coordx,$coordy);
     my $nfixmem= $data[3];
     $nfixmem=trim($nfixmem);
     $nfixmem = sprintf '%.1f', $nfixmem / 1024;
     imprime_color(YELLOW, "$nfixmem");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     my $nexecut= $data[4];
     $nexecut=trim($nexecut);
     imprime_color(YELLOW, "$nexecut");
     $coordx=$coordx+11;

     gotoxy($coordx,$coordy);
     my $nfec= $data[5];
     $nfec=trim($nfec);
     imprime_color(YELLOW, "$nfec");
     $coordx=$coordx+11;

     gotoxy($coordx,$coordy);
     my $nloadt= $data[6];
     $nloadt=trim($nloadt);
     imprime_color(YELLOW, "$nloadt");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $ndr= $data[7];
     $ndr=trim($ndr);
     imprime_color(YELLOW, "$ndr");
     $coordx=$coordx+10;

     #gotoxy($coordx,$coordy);
     #my $nwd= $data[8];
     #$nwd=trim($nwd);
     #imprime_color(YELLOW, "$nwd");
     #$coordx=$coordx+10;
     
     gotoxy($coordx,$coordy);
     my $nbt= $data[8];
     $nbt=trim($nbt);
     imprime_color(YELLOW, "$nbt");
     $coordx=$coordx+13;
     
     gotoxy($coordx,$coordy);
     my $nrp= $data[9];
     $nrp=trim($nrp);
     imprime_color(YELLOW, "$nrp");
     $coordx=$coordx+10;
     
     gotoxy($coordx,$coordy);
     my $ncpt= $data[10];
     $ncpt=trim($ncpt);
     $ncpt = sprintf '%.1f', $ncpt / 1000;
     imprime_color(YELLOW, "$ncpt");
     $coordx=$coordx+10;
     
     gotoxy($coordx,$coordy);
     my $nnet= $data[11];
     $nnet=trim($nnet);
     $nnet = sprintf '%.1f', $nnet / 1000;
     imprime_color(YELLOW, "$nnet");
     #$coordx=$coordx+12;
     

     print "\n";
 #    print "$id: $username $acct \n";
     $coordy++;
     $cont++;

 }

 if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;
 return ()
  }
 ###########################################################################################
#  Rutina Query_numh
########################################################################################


sub Query_numh {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$myschema,%sub_mensajes)  = @_;

   my $coordx=1;
   my $coordy=1;


   my $numero_colum=1;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }

   cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);
   

   $coordx=$coordx+40;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(BLUE, "****  HELP MENU  ****");
   
   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "u -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'mopt1'}");
   
   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "p -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'mopt2'}");
   
   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "m -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'mopt3'}");

   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "s -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'mopt4'}");

   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "S -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'mopt5'}");
   
   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "w -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'mopt6'}");

   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "b -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'mopt7'}");
   
   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "t -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'mopt8'}");

   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "l -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'mopt9'}");

   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "x -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'moptA'}");


   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "g -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'moptB'}");

   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "f -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'moptC'}");

   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "U -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'moptD'}");

   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "c -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'moptE'}");

   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "L -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'moptG'}");

   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "k -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'moptH'}");

   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "W -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'moptI'}");


   $coordx=10;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "V -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'moptJ'}"); 
 
   

   $coordy=6;
   
   $coordx=60;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(RED, "z -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'moptz'}");
   
   $coordx=60;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(RED, "Z -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'moptZ'}");
   
   $coordx=60;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(RED, "r -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'moptr'}");
   
   $coordx=60;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(RED, "R -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'moptR'}");
   
   $coordx=60;
   $coordy=$coordy+2;
   gotoxy($coordx,$coordy);
   imprime_color(RED, "O -");
   $coordx=$coordx+5;
   gotoxy($coordx,$coordy);
   imprime_color(YELLOW, "$sub_mensajes{'moptO'}");

   

   print "\n";

 }

###########################################################################################
#  Rutina Query_numa_x
########################################################################################


sub Query_numa_x {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$myschema,%sub_mensajes)  = @_;

   my $coordx=1;
   my $coordy=1;


   my $numero_colum=13;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }

   cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

   my $sth = $sub_dbh->prepare("  select substr(sql_text,1,35),sql_id,sharable_mem, persistent_mem, executions, fetches,
 first_load_time, disk_reads, direct_writes, buffer_gets, rows_processed, cpu_time, elapsed_time
 from v\$sqlarea order by $order_num $order_tipo") or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;



   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Text");
   $coordx=$coordx+40;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Sql_id");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "ShMem K");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "PrMem K");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Exec.");
   $coordx=$coordx+6;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Fetch");
   $coordx=$coordx+6;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "First load time");
   $coordx=$coordx+20;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Disk Rd");
   $coordx=$coordx+8;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Dir Wr ");
   $coordx=$coordx+8;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Buf.get");
   $coordx=$coordx+8;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Rows");
   $coordx=$coordx+8;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Cpu ms.");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Elapsed ms.");
   $coordx=$coordx+10;

   $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=7;

    my $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40 ) )

 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $ntexto = $data[0];
     $ntexto=trim($ntexto);
     imprime_color(YELLOW, "$ntexto");
     $coordx=$coordx+40;

     gotoxy($coordx,$coordy);
     my $nsqlid = $data[1];
     $nsqlid=trim($nsqlid);
     imprime_color(YELLOW, "$nsqlid");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $nshmem= $data[2];
     $nshmem=trim($nshmem);
     $nshmem = sprintf '%.1f', $nshmem / 1024;
     imprime_color(YELLOW, "$nshmem");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $nfixmem= $data[3];
     $nfixmem=trim($nfixmem);
     $nfixmem = sprintf '%.1f', $nfixmem / 1024;
     imprime_color(YELLOW, "$nfixmem");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $nexecut= $data[4];
     $nexecut=trim($nexecut);
     imprime_color(YELLOW, "$nexecut");
     $coordx=$coordx+6;

     gotoxy($coordx,$coordy);
     my $nfec= $data[5];
     $nfec=trim($nfec);
     imprime_color(YELLOW, "$nfec");
     $coordx=$coordx+6;

     gotoxy($coordx,$coordy);
     my $nloadt= $data[6];
     $nloadt=trim($nloadt);
     imprime_color(YELLOW, "$nloadt");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $ndr= $data[7];
     $ndr=trim($ndr);
     imprime_color(YELLOW, "$ndr");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     my $nwd= $data[8];
     $nwd=trim($nwd);
     imprime_color(YELLOW, "$nwd");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     my $nbt= $data[9];
     $nbt=trim($nbt);
     imprime_color(YELLOW, "$nbt");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     my $nrp= $data[10];
     $nrp=trim($nrp);
     imprime_color(YELLOW, "$nrp");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     my $ncpt= $data[11];
     $ncpt=trim($ncpt);
     $ncpt = sprintf '%.1f', $ncpt / 1000;
     imprime_color(YELLOW, "$ncpt");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $nnet= $data[12];
     $nnet=trim($nnet);
     $nnet = sprintf '%.1f', $nnet / 1000;
     imprime_color(YELLOW, "$nnet");
     $coordx=$coordx+10;


     print "\n";
 #    print "$id: $username $acct \n";
     $coordy++;
     $cont++;

 }

 if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;
 
          gotoxy(75,20);
          imprime_color(GREEN, "--------------------");
          gotoxy(75,21);
          imprime_color(GREEN, "-SQL ID CODE       -");
          gotoxy(75,22);
          imprime_color(GREEN, "                    ");
          gotoxy(75,23);
          imprime_color(GREEN, "--------------------");
          gotoxy(75,22);
          $sqlcodigo = <STDIN>;
          chomp($sqlcodigo);
          print "\n";
          
    $sth = $sub_dbh->prepare("  select sql_text from v\$sqlarea where sql_id = '$sqlcodigo' ")
  or die print "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

    $sth->execute()
   or die "$sub_mensajes{'msg4'} " . $sth->errstr;
   
    while ( (my @data = $sth->fetchrow_array()) )

 {
     $sqltexto = $data[0];
     $sqltexto=trim($sqltexto);

  }
  
  $sth->finish;
  

 return ($sqltexto)
  }
###########################################################################################
#  Rutina Query_numb
########################################################################################


sub Query_numb {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$myschema,%sub_mensajes)  = @_;

   my $coordx=1;
   my $coordy=1;


   my $numero_colum=8;
   if ($order_num > $numero_colum) {
                                    $order_num=$numero_colum;
                                    }
   if ($order_num < 1) {
                                    $order_num=1;
                                    }

   cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

   my $sth = $sub_dbh->prepare(" select f.task_name, TO_CHAR(e.execution_start, 'dd-mon-yy hh24:mi'), o.attr2, o.type, o.attr3,
   f.message,f.more_info, e.advisor_name from dba_advisor_findings f, dba_advisor_objects o, dba_advisor_executions e
    where o.task_id= f.task_id and o.object_id=f.object_id and f.task_id=e.task_id and e.execution_start > sysdate - 1
    order by $order_num $order_tipo")
 or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

   $coordx=$coordx+3;
   $coordy=$coordy+5;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Task Name");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Timestamp");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Segment Name");
   $coordx=$coordx+15;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Segment Type");
   $coordx=$coordx+15;
   
   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Part.Name");
   $coordx=$coordx+10;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Message");
   $coordx=$coordx+40;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "More info");
   $coordx=$coordx+40;

   gotoxy($coordx,$coordy);
   imprime_color(WHITE, "Advisor");
   $coordx=$coordx+10;

   $sth->execute()
   or die print "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=7;

    my $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40) )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $tn = $data[0];
     $tn = " " unless defined($tn);
     $tn=trim($tn);
     imprime_color(YELLOW, "$tn");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $ts = $data[1];
     $ts = " " unless defined($ts);
     $ts=trim($ts);
     imprime_color(YELLOW, "$ts");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $sn = $data[2];
     $sn = " " unless defined($sn);
     $sn=trim($sn);
     imprime_color(YELLOW, "$sn");
     $coordx=$coordx+15;


     gotoxy($coordx,$coordy);
     my $st= $data[3];
     $st = " " unless defined($st);
     $st=trim($st);
     imprime_color(YELLOW, "$st");
     $coordx=$coordx+15;
     
     gotoxy($coordx,$coordy);
     my $pn = $data[4];
     $pn = " " unless defined($pn);  
     $pn=trim($pn);
     imprime_color(YELLOW, "$pn");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $mess = $data[5];
     $mess = " " unless defined($mess);
     $mess=trim($mess);
     $mess=substr($mess,0,39);
     imprime_color(YELLOW, "$mess");
     $coordx=$coordx+40;

     gotoxy($coordx,$coordy);
     my $minf = $data[6];
     $minf = " " unless defined($minf);
     $minf=trim($minf);
     $minf=substr($minf,0,39);
     imprime_color(YELLOW, "$minf");
     $coordx=$coordx+40;


     gotoxy($coordx,$coordy);
     my $an= $data[7];
     $an = " " unless defined($an);
     $an=trim($an);
     $an=substr($an,0,14);
     imprime_color(YELLOW, "$an");
     $coordx=$coordx+10;
     
     print "\n";
     $coordy++;

     $cont++;
 }

 if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;

}

###########################################################################################
##  Rutina Query_numc
#########################################################################################


sub Query_numc {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$ora_vers,$myschema,%sub_mensajes)  = @_;

   my $coordx=1;
   my $coordy=1;
   my $sth;


   my $numero_colum=4;

   if ($order_num > $numero_colum) {
                                     $order_num=$numero_colum;
                                   }
  if ($order_num < 1) {
                        $order_num=1;
                      }

  cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

  if ($ora_vers =~ m/12./) {

  $sth = $sub_dbh->prepare("SELECT DATABASE_ROLE, DB_UNIQUE_NAME INSTANCE, OPEN_MODE, PROTECTION_MODE, PROTECTION_LEVEL, SWITCHOVER_STATUS FROM V\$DATABASE") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;
                           }
                         else {
  $sth = $sub_dbh->prepare("SELECT DATABASE_ROLE, DATABASE_ROLE, OPEN_MODE, PROTECTION_MODE, PROTECTION_LEVEL, SWITCHOVER_STATUS FROM V\$DATABASE") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;
                           } 
   
     $coordx=$coordx+3;
     $coordy=$coordy+5;
                                                                                                                                                                                   
     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Database Role");
     $coordy++;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Db Unique Name");
     $coordy++; 

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Open Mode");
     $coordy++; 

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Protection Mode");
     $coordy++;  

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Protection Level");
     $coordy++;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Switchover Status");
     $coordy++;

   $sth->execute()
   or die print "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=6;
      $coordx=25;

    my $cont=1;

    while ( (my @data = $sth->fetchrow_array()) and ($cont < 40) )
 {

     gotoxy($coordx,$coordy);
     my $dr = $data[0];
     $dr = " " unless defined($dr);
     $dr=trim($dr);
     imprime_color(YELLOW, "$dr");
     $coordy++;

     my $du="";
     if ($ora_vers =~ m/12./) {
     gotoxy($coordx,$coordy);
     $du = $data[1];
     $du = " " unless defined($du);
     $du=trim($du);
     imprime_color(YELLOW, "$du");
     $coordy++;
                               }
       else
                               {
      gotoxy($coordx,$coordy);
     $du = "N/A ";
     $du=trim($du);
     imprime_color(YELLOW, "$du");
     $coordy++;

                               }         

     gotoxy($coordx,$coordy);
     my $om = $data[2];
     $om = " " unless defined($om);
     $om=trim($om);
     imprime_color(YELLOW, "$om");
     $coordy++;

     gotoxy($coordx,$coordy);
     my $pm = $data[3];
     $pm = " " unless defined($pm);
     $pm=trim($pm);
     imprime_color(YELLOW, "$pm");
     $coordy++;

     gotoxy($coordx,$coordy);
     my $pl = $data[4];
     $pl = " " unless defined($pl);
     $pl=trim($pl);
     imprime_color(YELLOW, "$pl");
     $coordy++;

     gotoxy($coordx,$coordy);
     my $ss = $data[5];
     $ss = " " unless defined($ss);
     $ss=trim($ss);
     imprime_color(YELLOW, "$ss");
     $coordy++;
   
  }
    

  if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;

    $sth = $sub_dbh->prepare("SELECT  TO_CHAR(CURRENT_SCN)   FROM V\$DATABASE") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

     $coordx=4;
     $coordy=13;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Current SCN");
     $coordy++;


      $sth->execute() or die print "$sub_mensajes{'msg4'} " . $sth->errstr;
      $coordy=13;
      $coordx=25;


    while ( (my @data = $sth->fetchrow_array())  )
 {

     gotoxy($coordx,$coordy);
     my $cus = $data[0];
     $cus = " " unless defined($cus);
     $cus=trim($cus);
     imprime_color(YELLOW, "$cus");
     $coordy++;

  } 

 if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;

   $sth = $sub_dbh->prepare("select process, status, thread#, sequence#, block#, blocks from v\$managed_standby") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

     $coordx=60;
     $coordy=6;
   
     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Process");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Status");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Thread");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Sequence");
     $coordx=$coordx+10;
  
     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Block");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Blocks");
     $coordx=$coordx+10;

      $sth->execute()
   or die print "$sub_mensajes{'msg4'} " . $sth->errstr;

     $coordy++;   

     while ( (my @data = $sth->fetchrow_array()) and ($cont < 40) )
 {
     $coordx=60;    
    
     gotoxy($coordx,$coordy);
     my $pro = $data[0];
     $pro = " " unless defined($pro);
     $pro=trim($pro);
     imprime_color(YELLOW, "$pro");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $sta = $data[1];
     $sta = " " unless defined($sta);
     $sta=trim($sta);
     imprime_color(YELLOW, "$sta");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $thr = $data[2];
     $thr = " " unless defined($thr);
     $thr=trim($thr);
     imprime_color(YELLOW, "$thr");
     $coordx=$coordx+10;
 
     gotoxy($coordx,$coordy);
     my $seq = $data[3];
     $seq = " " unless defined($seq);
     $seq=trim($seq);
     imprime_color(YELLOW, "$seq");
     $coordx=$coordx+10;
  
     gotoxy($coordx,$coordy);
     my $blo = $data[4];
     $blo = " " unless defined($blo);
     $blo=trim($blo);
     imprime_color(YELLOW, "$blo");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $blo1 = $data[5];
     $blo1 = " " unless defined($blo1);
     $blo1=trim($blo1);
     imprime_color(YELLOW, "$blo1");
     $coordx=$coordx+10;
   
     $coordy++; 

 }

   if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;

$sth = $sub_dbh->prepare("select CREATOR, SEQUENCE#, APPLIED,to_char( FIRST_TIME, 'DD-MON-RR HH24:MI:SS')  FIRST_TIME FROM V\$ARCHIVED_LOG order by SEQUENCE# desc ") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

     $coordx=4;
     $coordy=18;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Creator");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Sequence");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Applied");
     $coordx=$coordx+10; 
       
     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Comp. Time");
     $coordx=$coordx+10;


    $sth->execute()  or die print "$sub_mensajes{'msg4'} " . $sth->errstr; 

     $coordy++;
     $cont=1;
      
        while ( (my @data = $sth->fetchrow_array()) and ($cont < 8) )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $cre = $data[0];
     $cre = " " unless defined($cre);
     $cre=trim($cre);
     imprime_color(YELLOW, "$cre");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $nseq = $data[1];
     $nseq = " " unless defined($nseq);
     $nseq=trim($nseq);
     imprime_color(YELLOW, "$nseq");
     $coordx=$coordx+10;
    
     gotoxy($coordx,$coordy);
     my $apli = $data[2];
     $apli = " " unless defined($apli);
     $apli=trim($apli);
     imprime_color(YELLOW, "$apli");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $comt = $data[3];
     $comt = " " unless defined($comt);
     $comt=trim($comt);
     imprime_color(YELLOW, "$comt");
     $coordx=$coordx+10;

     $coordy++;
     $cont++; 
   }

   if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;

if ($ora_vers =~ m/12./) {

 $sth = $sub_dbh->prepare("select SOURCE_DB_UNIQUE_NAME, NAME, VALUE, unit from V\$DATAGUARD_STATS  order by $order_num $order_tipo") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;
                         }
           else
                         {
  $sth = $sub_dbh->prepare("select NAME, NAME, VALUE, unit from V\$DATAGUARD_STATS  order by $order_num $order_tipo") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

                         }
     $coordx=60;
     $coordy=18;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Source Db");
     $coordx=$coordx+14;
 
     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Name");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Value");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Unit");
     $coordx=$coordx+10;

   $sth->execute()  or die print "$sub_mensajes{'msg4'} " . $sth->errstr;

     $coordy++;
     $cont=1;

        while ( (my @data = $sth->fetchrow_array()) and ($cont < 8) )
 {
     $coordx=60;


     my $sou="";

     if ($ora_vers =~ m/12./) {

     gotoxy($coordx,$coordy);
     $sou = $data[0];
     $sou = " " unless defined($sou);
     $sou=trim($sou);
     imprime_color(YELLOW, "$sou");
     $coordx=$coordx+14;
                              }
                   else       {
     gotoxy($coordx,$coordy);
     $sou = "N/A ";
     $sou=trim($sou);
     imprime_color(YELLOW, "$sou");
     $coordx=$coordx+14;
                              }  

     gotoxy($coordx,$coordy);
     my $nam = $data[1];
     $nam = " " unless defined($nam);
     $nam=trim($nam);
     $nam=substr($nam,0,18);
     imprime_color(YELLOW, "$nam");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $valu = $data[2];
     $valu = " " unless defined($valu);
     $valu=trim($valu);
     $valu=substr($valu,0,18);
     imprime_color(YELLOW, "$valu");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $und = $data[3];
     $und = " " unless defined($und);
     $und=trim($und);
     $und=substr($und,0,25);
     imprime_color(YELLOW, "$und");
     $coordx=$coordx+10;

     $coordy++;
     $cont++;
   
 
 }

   if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;

$sth = $sub_dbh->prepare("select substr(MESSAGE,1,120) , SEVERITY, to_char( TIMESTAMP, 'DD-MON-RR HH24:MI:SS') TIMEAUX FROM V\$DATAGUARD_STATUS order by TIMESTAMP desc") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

     $coordx=6;
     $coordy=28;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "                       Message");
     $coordx=$coordx+119;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Severity");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "TimeStamp");
     $coordx=$coordx+10;
  
     $sth->execute()  or die print "$sub_mensajes{'msg4'} " . $sth->errstr;

     $coordy++;
     $cont=1;

        while ( (my @data = $sth->fetchrow_array()) and ($cont < 15) )
 {
     $coordx=5;

     gotoxy($coordx,$coordy);
     my $mes1 = $data[0];
     $mes1 = " " unless defined($mes1);
     $mes1=trim($mes1);
     imprime_color(YELLOW, "$mes1");
     $coordx=$coordx+120;

     gotoxy($coordx,$coordy);
     my $sev1 = $data[1];
     $sev1 = " " unless defined($sev1);
     $sev1=trim($sev1);
     imprime_color(YELLOW, "$sev1");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $dtim = $data[2];
     $dtim = " " unless defined($dtim);
     $dtim=trim($dtim);
     imprime_color(YELLOW, "$dtim");
     $coordx=$coordx+10;


     $coordy++;
     $cont++;
 
 }

 if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;


  }

#################################################################################################
# Rutina Query numd
################################################################################################

sub Query_numd {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$ora_vers, $myschema,%sub_mensajes)  = @_;

   my $coordx=1;
   my $coordy=1;

   my $sth="";

   my $numero_colum=5;
   if ($order_num > $numero_colum) {
                                     $order_num=$numero_colum;
                                   }
  if ($order_num < 1) {
                        $order_num=1;
                      }

  cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

  if ($ora_vers =~ m/12./) {

   $sth = $sub_dbh->prepare("SELECT FILE_TYPE,PERCENT_SPACE_USED,PERCENT_SPACE_RECLAIMABLE,NUMBER_OF_FILES,CON_ID from v\$flash_recovery_area_usage order by $order_num $order_tipo") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

                           }
                   else {
  $sth = $sub_dbh->prepare("SELECT FILE_TYPE,PERCENT_SPACE_USED,PERCENT_SPACE_RECLAIMABLE,NUMBER_OF_FILES,NUMBER_OF_FILES from v\$flash_recovery_area_usage order by $order_num $order_tipo") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;
                        }

     $coordx=$coordx+3;
     $coordy=$coordy+5;


     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "File Type");
     $coordx=$coordx+35;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "\%Space Used");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "\%Space Reclaimable");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "N.Files");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Con id");
     $coordx=$coordx+6;

      $sth->execute()  or die print "$sub_mensajes{'msg4'} " . $sth->errstr;

     $coordy++;

        while ( (my @data = $sth->fetchrow_array())  )
 {
     $coordx=5;

     gotoxy($coordx,$coordy);
     my $ft = $data[0];
     $ft = " " unless defined($ft);
     $ft=trim($ft);
     imprime_color(YELLOW, "$ft");
     $coordx=$coordx+35;

     gotoxy($coordx,$coordy);
     my $su = $data[1];
     $su = " " unless defined($su);
     $su=trim($su);
     imprime_color(YELLOW, "$su");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $sr = $data[2];
     $sr = " " unless defined($sr);
     $sr=trim($sr);
     imprime_color(YELLOW, "$sr");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $nf = $data[3];
     $nf = " " unless defined($nf);
     $nf=trim($nf);
     imprime_color(YELLOW, "$nf");
     $coordx=$coordx+8;  
    

     my $ci ="";
     if ($ora_vers =~ m/12./) {
 
     gotoxy($coordx,$coordy);
     $ci = $data[4];
     $ci = " " unless defined($ci);
     $ci=trim($ci);
     imprime_color(YELLOW, "$ci");
     $coordx=$coordx+6;
                              }
       else {
 
     gotoxy($coordx,$coordy);
     $ci = "N/A ";
     $ci=trim($ci);
     imprime_color(YELLOW, "$ci");
     $coordx=$coordx+6;
  

            }
          
 
   $coordy++;

 }

 if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;
 
  $sth = $sub_dbh->prepare("SELECT SID, SERIAL#, CONTEXT, SOFAR, TOTALWORK, ROUND(SOFAR/TOTALWORK*100,2) FROM V\$SESSION_LONGOPS WHERE OPNAME LIKE 'RMAN\%' AND OPNAME NOT LIKE '\%aggregate\%' AND TOTALWORK != 0 AND SOFAR <> TOTALWORK order by $order_num $order_tipo") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

     $coordx=95;
     $coordy=6;


     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "SID");
     $coordx=$coordx+6;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Serial");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Context");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Sofar");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE,"Total Work");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE,"\%Complete");
     $coordx=$coordx+10;

       $sth->execute()  or die print "$sub_mensajes{'msg4'} " . $sth->errstr;

     $coordy++;
     my $cont=1;

        while ( (my @data = $sth->fetchrow_array()) and ($cont < 10) )
 {
     $coordx=95;

     gotoxy($coordx,$coordy);
     my $ser = $data[0];
     $ser = " " unless defined($ser);
     $ser=trim($ser);
     imprime_color(YELLOW, "$ser");
     $coordx=$coordx+6;

     gotoxy($coordx,$coordy);
     my $serie = $data[1];
     $serie = " " unless defined($serie);
     $serie=trim($serie);
     imprime_color(YELLOW, "$serie");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     my $con = $data[2];
     $con = " " unless defined($con);
     $con=trim($con);
     imprime_color(YELLOW, "$con");
     $coordx=$coordx+10;

    gotoxy($coordx,$coordy);
     my $sof = $data[3];
     $sof = " " unless defined($sof);
     $sof=trim($sof);
     imprime_color(YELLOW, "$sof");
     $coordx=$coordx+10; 

     gotoxy($coordx,$coordy);
     my $tow = $data[4];
     $tow = " " unless defined($tow);
     $tow=trim($tow);
     imprime_color(YELLOW, "$tow");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $comp = $data[5];
     $comp = " " unless defined($comp);
     $comp=trim($comp);
     imprime_color(YELLOW, "$comp");
     $coordx=$coordx+15;

      $coordy++;
      $cont++;
 }

 if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;


     $coordx=5;
     $coordy=20;

   $sth = $sub_dbh->prepare("SELECT NAME, SPACE_LIMIT/(1024*1024), SPACE_USED/(1024*1024), SPACE_RECLAIMABLE/(1024*1024),ROUND((SPACE_LIMIT-SPACE_USED)*100/SPACE_LIMIT,2) from v\$recovery_file_dest")  or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;  

    
     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Name");
     $coordy++;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Space Limit MB");
     $coordy++;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Space Used MB");
     $coordy++;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Space Reclaim. MB");
     $coordy++; 

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "\% Space Free");
     $coordy++;

      $sth->execute()  or die print "$sub_mensajes{'msg4'} " . $sth->errstr;

     $coordy++;

        while ( (my @data = $sth->fetchrow_array())  )
 {
     $coordx=25;
     $coordy=20;

     gotoxy($coordx,$coordy);
     my $nam1 = substr($data[0],1,40);
     $nam1 = " " unless defined($nam1);
     $nam1=trim($nam1);
     imprime_color(YELLOW, "$nam1");
     $coordy++;

     gotoxy($coordx,$coordy);
     my $spl = $data[1];
     $spl = " " unless defined($spl);
     $spl=trim($spl);
     imprime_color(YELLOW, "$spl");
     $coordy++;

     gotoxy($coordx,$coordy);
     my $spu = $data[2];
     $spu = " " unless defined($spu);
     $spu=trim($spu);
     imprime_color(YELLOW, "$spu");
     $coordy++;

     gotoxy($coordx,$coordy);
     my $spr = $data[3];
     $spr = " " unless defined($spr);
     $spr=trim($spr);
     imprime_color(YELLOW, "$spr");
     $coordy++;

     gotoxy($coordx,$coordy);
     my $fre = $data[4];
     $fre = " " unless defined($fre);
     $fre=trim($fre);
     imprime_color(YELLOW, "$fre");
     $coordy++;

 }

 if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;


  $sth = $sub_dbh->prepare("select session_recid,session_stamp,to_char(start_time, 'yyyy-mm-dd hh24:mi:ss'),to_char(end_time, 'yyyy-mm-dd hh24:mi:ss'),round((output_bytes/1024/1024),2) output_mbytes, status, input_type,decode(to_char(start_time, 'd'), 1, 'Sunday', 2, 'Monday',3, 'Tuesday', 4, 'Wednesday',5, 'Thursday', 6, 'Friday',7, 'Saturday') ,round(elapsed_seconds,2), time_taken_display from V\$RMAN_BACKUP_JOB_DETAILS order by start_time desc ") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

     $coordx=5;
     $coordy=30;


     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Session");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Stamp");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Start Time");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Stop Time");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Size Mb");
     $coordx=$coordx+13;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Status");
     $coordx=$coordx+30;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Type");
     $coordx=$coordx+15;  

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Start Day");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Elap. Sec");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Time Taken");
     $coordx=$coordx+10;

 
     $sth->execute()  or die print "$sub_mensajes{'msg4'} " . $sth->errstr;

     $coordy++;
     $cont=1;

        while ( (my @data = $sth->fetchrow_array())  and ($cont < 10)  )
 {
     $coordx=5;

     gotoxy($coordx,$coordy);
     my $Sess = $data[0];
     $Sess = " " unless defined($Sess);
     $Sess=trim($Sess);
     imprime_color(YELLOW, "$Sess");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $sta = $data[1];
     $sta = " " unless defined($sta);
     $sta=trim($sta);
     imprime_color(YELLOW, "$sta");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $sti = $data[2];
     $sti = " " unless defined($sti);
     $sti=trim($sti);
     imprime_color(YELLOW, "$sti");
     $coordx=$coordx+20;

      gotoxy($coordx,$coordy);
     my $stp = $data[3];
     $stp = " " unless defined($stp);
     $stp=trim($stp);
     imprime_color(YELLOW, "$stp");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $siz = $data[4];
     $siz = " " unless defined($siz);
     $siz=trim($siz);
     imprime_color(YELLOW, "$siz");
     $coordx=$coordx+13;

     gotoxy($coordx,$coordy);
     my $stt = $data[5];
     $stt = " " unless defined($stt);
     $stt=trim($stt);
     imprime_color(YELLOW, "$stt");
     $coordx=$coordx+30;

     gotoxy($coordx,$coordy);
     my $tip = $data[6];
     $tip = " " unless defined($tip);
     $tip=trim($tip);
     imprime_color(YELLOW, "$tip");
     $coordx=$coordx+15;


     gotoxy($coordx,$coordy);
     my $sdata = $data[7];
     $sdata = " " unless defined($sdata);
     $sdata=trim($sdata);
     imprime_color(YELLOW, "$sdata");
     $coordx=$coordx+10;

      gotoxy($coordx,$coordy);
     my $ela = $data[8];
     $ela = " " unless defined($ela);
     $ela=trim($ela);
     imprime_color(YELLOW, "$ela");
     $coordx=$coordx+10;

       gotoxy($coordx,$coordy);
     my $tta = $data[9];
     $tta = " " unless defined($tta);
     $tta=trim($tta);
     imprime_color(YELLOW, "$tta");
     $coordx=$coordx+10;

      $coordy++;
      $cont++;
 
      }

 if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;

 
}

##################################################################################################
#   query num e
##################################################################################################

sub Query_nume {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$myschema,%sub_mensajes)  = @_;

   my $coordx=1;
   my $coordy=1;


   my $numero_colum=3;
   if ($order_num > $numero_colum) {
                                     $order_num=$numero_colum;
                                   }
  if ($order_num < 1) {
                        $order_num=1;
                      }

  cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

  my $sth = $sub_dbh->prepare("select d.undo_size/(1024*1024), SUBSTR(e.value,1,25), (to_number(e.value) * to_number(f.value) * g.undo_block_per_sec) / (1024*1024) from ( select sum(a.bytes) undo_size from v\$datafile a, v\$tablespace b, dba_tablespaces c  where c.contents = 'UNDO' and c.status = 'ONLINE' and b.name = c.tablespace_name  and a.ts# = b.ts#  ) d,  v\$parameter e, v\$parameter f, ( Select max(undoblks/((end_time-begin_time)*3600*24)) undo_block_per_sec  from v\$undostat ) g where e.name = 'undo_retention' and f.name = 'db_block_size'") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

     $coordx=$coordx+3;
     $coordy=$coordy+5;


     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Current Undo Size MB");
     $coordy++;

      gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Undo Retention");
     $coordy++;

      gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Necessary Undo MB");
     $coordy++; 


      $sth->execute()  or die print "$sub_mensajes{'msg4'} " . $sth->errstr;

     $coordy=6;

        while ( (my @data = $sth->fetchrow_array())   )
 {
     $coordx=30;

     gotoxy($coordx,$coordy);
     my $cus = $data[0];
     $cus = " " unless defined($cus);
     $cus=trim($cus);
     imprime_color(YELLOW, "$cus");
     $coordy++;

      gotoxy($coordx,$coordy);
     my $uru = $data[1];
     $uru = " " unless defined($uru);
     $uru=trim($uru);
     imprime_color(YELLOW, "$uru");
     $coordy++;

      gotoxy($coordx,$coordy);
     my $ncu = $data[2];
     $ncu = " " unless defined($ncu);
     $ncu = sprintf '%.2f',$ncu ;  
     $ncu=trim($ncu);
     imprime_color(YELLOW, "$ncu");
     $coordy++;

 } 

     if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;

   $sth = $sub_dbh->prepare("select tablespace_name, status, sum(blocks) * 8192/1024/1024 from dba_undo_extents group by tablespace_name, status order by $order_num $order_tipo") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

     $coordx=4;
     $coordy=12;


     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Tablespace");
     $coordx=$coordx+12;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Status");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Undo MB");
     $coordx=$coordx+12;  

      $sth->execute()  or die print "$sub_mensajes{'msg4'} " . $sth->errstr;

     $coordy=13;

        while ( (my @data = $sth->fetchrow_array())   )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $tbs = $data[0];
     $tbs = " " unless defined($tbs);
     $tbs=trim($tbs);
     imprime_color(YELLOW, "$tbs");
     $coordx=$coordx+12;

     gotoxy($coordx,$coordy);
     my $sts = $data[1];
     $sts = " " unless defined($sts);
     $sts=trim($sts);
     imprime_color(YELLOW, "$sts");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $siz = $data[2];
     $siz = " " unless defined($siz);
     $siz=trim($siz);
     imprime_color(YELLOW, "$siz");
     $coordx=$coordx+12;

      $coordy++; 
 
  }

     if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish; 

 $sth = $sub_dbh->prepare("select t.used_ublk, s.sid, s.username, t.used_urec, sql.sql_text from v\$session s, v\$transaction t, v\$sql sql  where s.saddr = t.ses_addr  and s.sql_id = sql.sql_id  order by $order_num $order_tipo") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

     $coordx=50;
     $coordy=5;


     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Used Undo Blk");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "SID");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "User");
     $coordx=$coordx+16;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Used Undo Rec");
     $coordx=$coordx+16;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Sql Statement");
     $coordx=$coordx+16;

 $sth->execute()  or die print "$sub_mensajes{'msg4'} " . $sth->errstr;

     $coordy=6;
     my $cont=1;

        while ( (my @data = $sth->fetchrow_array()) and ($cont < 8)   )
 {
     $coordx=50;

     gotoxy($coordx,$coordy);
     my $uub = $data[0];
     $uub = " " unless defined($uub);
     $uub=trim($uub);
     imprime_color(YELLOW, "$uub");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $usi = $data[1];
     $usi = " " unless defined($usi);
     $usi=trim($usi);
     imprime_color(YELLOW, "$usi");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     my $uus = $data[2];
     $uus = " " unless defined($uus);
     $uus=trim($uus);
     imprime_color(YELLOW, "$uus");
     $coordx=$coordx+16;

     gotoxy($coordx,$coordy);
     my $uur = $data[3];
     $uur = " " unless defined($uur);
     $uur=trim($uur);
     imprime_color(YELLOW, "$uur");
     $coordx=$coordx+16;

     gotoxy($coordx,$coordy);
     my $ust = substr($data[4],0,39);
     $ust = " " unless defined($ust);
     $ust=trim($ust);
     imprime_color(YELLOW, "$ust");
     $coordx=$coordx+20;

      $coordy++;
      $cont++;

  }

     if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;


}

##################################################################################
# Query num f
# ###############################################################################

sub Query_numf {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$myschema,%sub_mensajes)  = @_;

   my $coordx=1;
   my $coordy=1;


   my $numero_colum=8;
   if ($order_num > $numero_colum) {
                                     $order_num=$numero_colum;
                                   }
  if ($order_num < 1) {
                        $order_num=1;
                      }

  cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

  my  $sth = $sub_dbh->prepare("select s.username,s.status,t.sid,s.serial#,ROUND(SUM(VALUE/100),4),s.module,s.sql_id,s.wait_time,s.seconds_in_wait,p.spid  from v\$session s, v\$sesstat t, v\$statname n, V\$PROCESS p  WHERE t.STATISTIC# = n.STATISTIC# and NAME like '%CPU used by this session%' and t.SID = s.SID and (s.status='ACTIVE' or s.status='INACTIVE') and  s.username is not null and   s.PADDR = p.ADDR GROUP BY s.username,s.status,t.sid,s.serial#,s.module,s.sql_id,s.wait_time,s.seconds_in_wait,p.spid order by  $order_num $order_tipo") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr; 


     $coordx=$coordx+3;
     $coordy=$coordy+5;


     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Username");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Status");
     $coordx=$coordx+10;
  

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "SID");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Serial");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "CPU (seconds)");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Module");
     $coordx=$coordx+48;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Sql Id");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Sec. in wait");
     $coordx=$coordx+16;  

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Process");
     $coordx=$coordx+10; 

      $sth->execute()  or die print "$sub_mensajes{'msg4'} " . $sth->errstr;

      my $cont=1;
      $coordy++;

        while ( (my @data = $sth->fetchrow_array()) and ($cont < 40 )  )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $usn = $data[0];
     $usn=substr($usn,0,19);
     $usn=trim($usn);
     imprime_color(YELLOW, "$usn");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $sta = $data[1];
     $sta=trim($sta);
     imprime_color(YELLOW, "$sta");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $sid = $data[2];
     $sid=trim($sid);
     imprime_color(YELLOW, "$sid");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     my $ser = $data[3];
     $ser=trim($ser);
     imprime_color(YELLOW, "$ser");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $cpu = $data[4];
     $cpu=trim($cpu);
     imprime_color(YELLOW, "$cpu");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $ter = $data[5];
     $ter = " " unless defined($ter);
     $ter=trim($ter);
     imprime_color(YELLOW, "$ter");
     $coordx=$coordx+48;

     gotoxy($coordx,$coordy);
     my $sqi = $data[6];
     $sqi = " " unless defined($sqi);
     $sqi=trim($sqi);
     imprime_color(YELLOW, "$sqi");
     $coordx=$coordx+15;  

     gotoxy($coordx,$coordy);
     my $wai = $data[7];
     my $sec = $data[8];

     my $wat = sprintf '%.2f',($sec-$wai/100) ;
     #my $wat =($sec-$wai/100) ; 
     imprime_color(YELLOW, "$wat");
     $coordx=$coordx+16;

     gotoxy($coordx,$coordy);
     my $pro = $data[9];
     $pro=trim($pro);
     imprime_color(YELLOW, "$pro");
     $coordx=$coordx+12;

     $coordy++;
     $cont++;

  }
    
 if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;

}

###################################################################################################
#  Query numg 
###################################################################################################


sub Query_numg {

   my ($sub_dbh,$ora_ret,$ora_user, $ora_sid,$order_num, $order_tipo,$myschema,%sub_mensajes)  = @_;

   my $coordx=1;
   my $coordy=1;


   my $numero_colum=8;
   if ($order_num > $numero_colum) {
                                     $order_num=$numero_colum;
                                   }
  if ($order_num < 1) {
                        $order_num=1;
                      }

  cabecera($order_num,$ora_ret,$ora_user, $ora_sid,$myschema,%sub_mensajes);

  my  $sth = $sub_dbh->prepare("select  s.group#,s.thread#,s.sequence#, round((s.bytes/1024)/1024,1), s.members, s.archived, s.status, s.first_change#,TO_CHAR(s.first_time, 'dd-mon-yy hh24:mi'),t.member  from v\$log s, v\$logfile t where s.group#=t.group# order by  $order_num $order_tipo") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;


     $coordx=$coordx+3;
     $coordy=$coordy+5;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Group");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Thread");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Sequence");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Size MB");
     $coordx=$coordx+10; 
  
     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Member");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Archived");
     $coordx=$coordx+10; 

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Status");
     $coordx=$coordx+16; 

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "First Changed");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "First Time");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Name");
     $coordx=$coordx+55; 

       $sth->execute()  or die print "$sub_mensajes{'msg4'} " . $sth->errstr;

      my $cont=1;
      $coordy++;

        while ( (my @data = $sth->fetchrow_array()) and ($cont < 22 )  )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $grp = $data[0];
     $grp=trim($grp);
     imprime_color(YELLOW, "$grp");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     my $thr = $data[1];
     $thr=trim($thr);
     imprime_color(YELLOW, "$thr");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     my $seq = $data[2];
     $seq=trim($seq);
     imprime_color(YELLOW, "$seq");
     $coordx=$coordx+10;

      gotoxy($coordx,$coordy);
     my $siz = $data[3];
     $siz=trim($siz);
     imprime_color(YELLOW, "$siz");
     $coordx=$coordx+10;    

      gotoxy($coordx,$coordy);
     my $mem = $data[4];
     $mem=trim($mem);
     imprime_color(YELLOW, "$mem");
     $coordx=$coordx+8;  

      gotoxy($coordx,$coordy);
     my $arc = $data[5];
     $arc=trim($arc);
     imprime_color(YELLOW, "$arc");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $sta = $data[6];
     $sta = " " unless defined($sta);
     $sta=trim($sta);
     imprime_color(YELLOW, "$sta");
     $coordx=$coordx+16;

    gotoxy($coordx,$coordy);
     my $ficd = $data[7];
     $ficd = " " unless defined($ficd);     
     $ficd=trim($ficd);
     imprime_color(YELLOW, "$ficd");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $fictd = $data[8];
     $fictd = " " unless defined($fictd);   
     $fictd=trim($fictd);
     imprime_color(YELLOW, "$fictd");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $ficnm = $data[9];
     $ficnm=substr($ficnm,1,54); 
     $ficnm = " " unless defined($ficnm);
     $ficnm=trim($ficnm);
     imprime_color(YELLOW, "$ficnm");
     $coordx=$coordx+55;

     $coordy++;
     $cont++;
  
 }

    $sth->finish; 

    $sth = $sub_dbh->prepare("select  s.group#,s.thread#,s.sequence#, round((s.bytes/1024)/1024,1),  s.archived, s.status, s.first_change#,TO_CHAR(s.first_time, 'dd-mon-yy hh24:mi'),t.member  from v\$standby_log s, v\$logfile t where s.group#=t.group# order by  $order_num $order_tipo") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

    $sth->execute()  or die print "$sub_mensajes{'msg4'} " . $sth->errstr;


        while ( (my @data = $sth->fetchrow_array()) and ($cont < 22 )  )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $grp = $data[0];
     $grp=trim($grp);
     imprime_color(YELLOW, "$grp");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     my $thr = $data[1];
     $thr=trim($thr);
     imprime_color(YELLOW, "$thr");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     my $seq = $data[2];
     $seq=trim($seq);
     imprime_color(YELLOW, "$seq");
     $coordx=$coordx+10;

      gotoxy($coordx,$coordy);
     my  $siz = $data[3];
     $siz=trim($siz);
     imprime_color(YELLOW, "$siz");
     $coordx=$coordx+10;

      gotoxy($coordx,$coordy);
     my  $mem = "--";
     $mem=trim($mem);
     imprime_color(YELLOW, "$mem");
     $coordx=$coordx+8;

      gotoxy($coordx,$coordy);
     my $arc = $data[4];
     $arc = " " unless defined($arc);
     $arc=trim($arc);
     imprime_color(YELLOW, "$arc");
     $coordx=$coordx+10;

     gotoxy($coordx,$coordy);
     my $sta = $data[5];
     $sta = " " unless defined($sta);
     $sta=trim($sta);
     imprime_color(YELLOW, "$sta");
     $coordx=$coordx+16;

    gotoxy($coordx,$coordy);
     my $ficd = $data[6];
     $ficd = " " unless defined($ficd); 
     $ficd=trim($ficd);
     imprime_color(YELLOW, "$ficd");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $fictd = $data[7];
     $fictd = " " unless defined($fictd);
     $fictd=trim($fictd);
     imprime_color(YELLOW, "$fictd");
     $coordx=$coordx+20;

     gotoxy($coordx,$coordy);
     my $ficnm = $data[8];
     $ficnm = " " unless defined($ficnm);
     $ficnm=substr($ficnm,1,54);
     $ficnm=trim($ficnm);
     imprime_color(YELLOW, "$ficnm");
     $coordx=$coordx+55;

     $coordy++;
     $cont++;

 }

     $sth->finish;

     $sth = $sub_dbh->prepare("SELECT A.*,Round(A.Count#*B.AVG#/1024/1024) FROM ( SELECT To_Char(First_Time,'YYYY-MM-DD') DAY, Count(1) Count#, Min(RECID) Min#, Max(RECID) Max#  from v\$log_history where First_Time > sysdate - 10 group by To_Char(First_Time,'YYYY-MM-DD') order BY 1 DESC ) A, ( SELECT Avg(BYTES) AVG#, Count(1)  Count#,  Max(BYTES) Max_Bytes, Min(BYTES) Min_Bytes from v\$log ) B") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;
     

     $coordx=4;
     $coordy=30;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Date");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Count");
     $coordx=$coordx+6;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "MIN #");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "MAX #");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "AVG MB");
     $coordx=$coordx+10;

      $sth->execute()  or die print "$sub_mensajes{'msg4'} " . $sth->errstr;

      $coordy++;

        while ( (my @data = $sth->fetchrow_array())  )
 {
     $coordx=4;

     gotoxy($coordx,$coordy);
     my $dat = $data[0];
     $dat=trim($dat);
     imprime_color(YELLOW, "$dat");
     $coordx=$coordx+15;

     gotoxy($coordx,$coordy);
     my $cnt = $data[1];
     $cnt=trim($cnt);
     imprime_color(YELLOW, "$cnt");
     $coordx=$coordx+6;

     gotoxy($coordx,$coordy);
     my $cma = $data[2];
     $cma=trim($cma);
     imprime_color(YELLOW, "$cma");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     my $cmi = $data[3];
     $cmi=trim($cmi);
     imprime_color(YELLOW, "$cmi");
     $coordx=$coordx+8;

     gotoxy($coordx,$coordy);
     my $ave = $data[4];
     $ave=trim($ave);
     imprime_color(YELLOW, "$ave");
     $coordx=$coordx+15;

     $coordy++;     

   }

    $sth->finish;   

    $sth = $sub_dbh->prepare("SELECT
to_char(first_time,'YYYY-MM-DD') day,
to_char(sum(decode(to_char(first_time,'HH24'),'00',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'01',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'02',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'03',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'04',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'05',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'06',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'07',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'08',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'09',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'10',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'11',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'12',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'13',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'14',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'15',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'16',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'17',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'18',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'19',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'20',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'21',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'22',1,0)),'99') ,
to_char(sum(decode(to_char(first_time,'HH24'),'23',1,0)),'99') 
from v\$log_history where first_time > sysdate - 10  GROUP by
   to_char(first_time,'YYYY-MM-DD') order by 1 desc ") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;


     $coordx=60;
     $coordy=30;

     gotoxy($coordx,$coordy);
     imprime_color(WHITE, "Date");
     $coordx=$coordx+16;

     my $i=0;
     my $result="";

     for ($i=0; $i < 24; $i++) 

     {

     $result = sprintf("%02d", $i); 
     gotoxy($coordx,$coordy);
     imprime_color(WHITE, $result);
     $coordx=$coordx+4;

     }


      $sth->execute()  or die print "$sub_mensajes{'msg4'} " . $sth->errstr;

      $coordy++;

       while ( (my @data = $sth->fetchrow_array())  )
 {
     $coordx=60;

     my $k=0;

       for ($k=0; $k < 25; $k++) {

     gotoxy($coordx,$coordy);
     my $val = $data[$k];
     $val=trim($val);
     imprime_color(YELLOW, "$val");
     if ($k == 0 ) {
              $coordx=$coordx+16;
                   }
               else  {
               $coordx=$coordx+4;  
                     }      

                                }
           $coordy++;

 } 

if ($sth->rows == 0)
 {
     print "\n";
 }

 $sth->finish;

}

sub Query_instance {

   my ($sub_dbh,$myschema,%sub_mensajes)  = @_;


  my $sth = $sub_dbh->prepare("select version,status,database_status,instance_role,active_state  from  v\$instance") or die "$sub_mensajes{'msg3'} " . $sub_dbh->errstr;

  $sth->execute()  or die print "$sub_mensajes{'msg4'} " . $sth->errstr;

     while ( (my @data = $sth->fetchrow_array())   )

 {

      my $ive = $data[0];
      $ive=trim($ive) unless !defined ($ive);
      $hash_inst_param {inst_version} = $ive;

      my $ist = $data[1];
      $ist=trim($ist) unless !defined ($ist);
      $hash_inst_param {inst_status} = $ist;

      my $ids = $data[2];
      $ids=trim($ids) unless !defined ($ids);
      $hash_inst_param {inst_dbstatus} = $ids;

      my $iro = $data[3];
      $iro=trim($iro) unless !defined ($iro);
      $hash_inst_param {inst_role} = $iro;

      my $iac = $data[4];
      $iac=trim($iac) unless !defined ($iac);
      $hash_inst_param {inst_state} = $iac;

 }
      $sth->finish;
       return (%hash_inst_param);
}


  END { }

1;

