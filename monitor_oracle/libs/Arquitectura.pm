package Arquitectura; 

  use strict;
  use warnings;

  use POSIX qw(strftime);

    BEGIN {
        require Exporter;

        # Package version
        our $VERSION     = 1.00;

        # Inherance to export functions and variables
        our @ISA         = qw(Exporter);

        # Predetermined functions and variables exported
        our @EXPORT      = qw(get_ssoo trim ltrim rtrim initpila insertpila extraepila $dato $res $string $res_ssoo @pila leoparam %hash_param get_dia $dia 
                            list_environment get_hora $hora);

        # Optional functions and variables
        our @EXPORT_OK   = qw($Var1 %Hash1 func3);
    }

    # Package global variables
    our $Var1    = '';
    our $res_ssoo = '';
    our $res ='';
    our $string = '';
    our %Hash1  = ();
    our $dato = '';
    our $dia='';
    our $hora='';

    # Privated global variables ( not exported )
    # (access through $Mi::Modulo::cosa)
    our @otras    = ();
    our $cosa   = '';
    our @pila = ();
    our %hash_param = ();
    

    # private lexical variables
    my $var_priv    = '';
    my %hash_secreto = ();
   

    # Private functions
    # calling through $func_priv->();
 
   my $func_priv = sub {
        
    };

##############################################################################
#
# Subroutine list_environment    
#
##############################################################################

    sub list_environment
            {

             my $key="";  

             foreach $key (sort keys(%ENV)) {
                       print "$key = $ENV{$key}";
                                             }    

            ; 

             }    

################################################################################
#
## Subroutine  get_ssoo 
#
################################################################################

    sub get_ssoo      {

        my ($parametros) = @_;
	
	my $osname = $^O;


        if( $osname eq 'MSWin32' ){{
              eval { require Win32; } or last;
              $osname = Win32::GetOSName();
              # work around for historical reasons
              $osname = 'WinXP' if $osname =~ /^WinXP/;
                                   }}
        $res_ssoo = $osname;         
	
	return ($res_ssoo)
                   }

#################################################################################
#
# Subroutine get_dia
# Return date
#
##################################################################################

    sub get_dia      {

         $dia = strftime "%a %b %e %Y", localtime;

	return ($dia)
                   }


#################################################################################
#
# Subroutine get_hora 
# Return time
#
##################################################################################

    sub get_hora      {

                  
         $hora = strftime "%H:%M:%S ", localtime;
        
	
	return ($hora)
                   }


#################################################################################
#
# Subroutine Perl initpila 
# Initialize stack 
#
##################################################################################


sub initpila

 {
     my  @pila= @_;
     push @pila,'FIN';
     return @pila;
 }

################################################################################
#
# Subroutine  insertpila. 
# Insert an element into the stack
#
################################################################################ 

sub insertpila
 {
   my  ($dato, @pila) = @_;
   push @pila,$dato;
   return @pila;
 }

################################################################################
#
# Subroutine  extraepila 
# Pop an element from the stack 
#
################################################################################

sub extraepila
 {
   my  @pila= @_;
   $dato= pop @pila ;
   return ($dato,@pila);
 }

################################################################################
#
#### Perl trim function to remove whitespace from the start and end of the string
#
##################################################################################
sub trim($)
{
 my $string = shift;
 $string = " " unless defined($string); 
 $string =~ s/^\s+//;
 $string =~ s/\s+$//;
 return $string;
   }
#################################################
#
# Left trim function to remove leading whitespace
#
#################################################
sub ltrim($)
 {
  my $string = shift;
  $string =~ s/^\s+//;
  return $string;
 }
##################################################
#
# Right trim function to remove trailing whitespace
#
##################################################
sub rtrim($)
 {
  my $string = shift;
  $string =~ s/\s+$//;
  return $string;
 }

##################################################
#
# Subroutine leoparam 
# Read File of param. Return a Hash with the variables
#
##################################################
sub leoparam($)
 {
  my $param_string = shift;
  my $linea ="";
  my $variable ="";
  my $valor="";


  if ( $param_string eq '' ) {
                                $param_string="./param.txt";
                              }
 
   open(FILEPAR, "< $param_string")
    or die "Couldn't open File $param_string   \n";

    while (defined ($linea = <FILEPAR>)) {
     
    $linea=trim($linea);
     
    if (( substr $linea, 0, 1)  ne '#' ) {    

     ($variable, $valor) = split('=', $linea);
         $variable =  trim($variable);
         $valor =  trim($valor);
         $hash_param{ $variable } = $valor;
           
                                         }   # if
  
                                      }  # while
   close (FILEPAR); 

   return %hash_param;
   
 }
  
 
    END {  }       # Global destroyer


1;
