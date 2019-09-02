# message_EN.pm
package message_EN;

@ISA = qw(Exporter);
@EXPORT = qw(%lang_msg carga_msg);

use strict;

our %lang_msg=();


sub carga_msg {
    

      %lang_msg = (
        msg0 => 'Error: Language module not found: ',
        msg1 => 'Error: Can not load dynamic language module           :',
        msg2 => 'Error: Not possible connect to Oracle DB       :',
        msg3 => 'Error: Not possible connection prepare      : ',
        msg4 => 'Error: Not possible execute connetion step: ',
        msg8 => 'ERROR  NOT  INITIAL MENU  ',
        msg10 => 'ERROR SHOWING INITIAL MENU   ',
        msg12 => 'IT DOES NOT EXIST PREVOUS MENU ',
        msg14 => 'IT DOES NOT EXIST FOLLOWING MENU OR SCRIPT    ',
        msg16 => 'SCRIPT EXECUTION ERROR       ',
        msg20 => 'ERROR IN DYNAMIC MENU                ',       
        msg25 => 'CANT COPY TERMCAP FILE. GRAPHIC RESOLUTION ERROR IS POSSIBLE                   ', 
        msg26 => 'THERE IS NO PROCESS INFORMATION ', 
        msg27 => '  CONFIRM. KILL THE PROCESS (y/n)?       ',  
        msg28 => '                 - Type K to kill the process       -   ',
        msg29 => ' Type filter      ', 
        msg30 => ' Type F to filter search  ', 
        msg31 => ' Type owner/Schema ',
        msg32 => ' Type V to set schema current session',
        msg50 => 'Use menu.pl [switches] [arguments] ',
        msg51 => '-h  help ',
        msg52 => '-a [group] It means the menu group to show. Default: Sample   ',
        msg53 => '-d  debug. Genera salida a debug.txt',
        msg54 => 'Example.  menu.pl -a DB2', 
         msg55 => 'Error in alter session current session sentence',  
        msg99 => 'ERROR UNKNOWN     ', 
        var01 => 'User    ', 
        var02 => 'Date    ', 
        var03 => 'Hour    ',   
        var04 => 'Op.Syst.',
        var05 => 'Delay   ',
        var06 => 'Filter   ', 
        deb01 => 'DEB..PARAMETERS :...',
        deb02 => 'DEB..LOADED MESSAGES  :...',
        mopt1 => 'User menu         ',
        mopt2 => 'Process menu      ',
        mopt3 => 'Memory menu      ',    
        mopt4 => 'Panel de estado de conexiones ',
        mopt4 => 'Connection state menu         ',
        mopt5 => 'Ratio menu   ',
        mopt6 => 'Wait time menu ',
        mopt7 => 'Locks menu ',
        mopt8 => 'Temporary Storage menu',
        mopt9 => 'Sentences menu  ',
        moptA => 'Explain menu ',
        moptB => 'Data Guard menu ',
        moptC => 'FRA and Backup menu ',
        moptD => 'UNDO menu ',
        moptE => 'CPU menu   ',
        moptG => 'Redo menu  ',
        moptH => 'Process information menu   ',
        moptI => 'Wait Session menu ', 
        moptJ => 'Set current schema',
        moptz => 'Incrementa la columna de ordenacion ',
        moptz => 'Increase sort column                ',
        moptZ => 'Decrease sort column                ',
        moptr => 'Increase delay one second           ',
        moptR => 'Decrease delay one second           ',
        moptO => 'Swicht sort mode from ASC/DESC and DESC/ASC ',     
        msgo1 => 'Option not allowed  ',
        msgo2 => 'Oracle instance in mode : ',   
              
    );

  return %lang_msg;
}



END { }

1;

 
