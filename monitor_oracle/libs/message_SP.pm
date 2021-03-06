# message_SP.pm
package message_SP;

@ISA = qw(Exporter);
@EXPORT = qw(%lang_msg carga_msg);

use strict;

our %lang_msg=();


sub carga_msg {
    

      %lang_msg = (
        msg0 => 'Error: Modulo de lenguaje no encontrado: ',
        msg1 => 'Error: No puedo cargar el modulo dinamico de mensajes :',
        msg2 => 'Error: Imposible de conectarse a la BD Oracle  :',
        msg3 => 'Error: Imposible de preparer la conexion : ',
        msg4 => 'Error: Imposible de ejecutar la conexion : ',
        msg8 => 'NO EXISTE MENU INICIAL ',
        msg10 => 'ERROR MOSTRANDO MENU INICIAL ',
        msg12 => 'NO EXISTE MENU PREVIO ',
        msg14 => 'NO EXISTE MENU SIGUIENTE O SCRIPT INEXISTENTE ',
        msg16 => 'ERROR EN EJECUCION DE SCRIPT ',
        msg20 => 'ERROR EN RESOLUCION DE MENU DINAMICO ',
        msg25 => 'NO SE PUEDE COPIAR FICHERO DE TERMCAP. POSIBLE ERROR EN RESOLUCION EN GRAFICOS ',
        msg26 => 'NO HAY INFORMACION DEL PROCESO ',
        msg27 => '  CONFIRMAR. MATAR EL PROCESO (y/n)?     ',
        msg28 => '                 - Teclear K para mater el proceso  -   ',
        msg29 => ' Teclea filtro     ',
        msg30 => ' Teclea F para filtrar ',
        msg31 => ' Teclea owner/schema ',
        msg32 => ' Teclea V para establecer el schema current session',
        msg50 => 'Uso menu.pl [switches] [arguments] ',
        msg51 => '-h  ayuda ',
        msg52 => '-a [grupo] Indica el grupo de menu a mostrar. Defecto: Sample ',
        msg53 => '-d  debug. Genera salida a debug.txt',  
        msg54 => 'Eplo.  menu.pl -a DB2', 
         msg55 => 'Error en sentencia alter session current session ',  
        msg99 => 'ERROR DESCONOCIDO ',  
        var01 => 'Usuario ', 
        var02 => 'Dia     ', 
        var03 => 'Hora    ',   
        var04 => 'Sist.op.',
        var05 => 'Retardo ', 
        var06 => 'Filtro ', 
        deb01 => 'DEB..PARAMETROS :...',
        deb02 => 'DEB..MENSAJES CARGADOS  :...',
        mopt1 => 'Panel de Usuarios ',
        mopt2 => 'Panel de Procesos ',
        mopt3 => 'Panel de Memoria ',
        mopt4 => 'Panel de estado de conexiones ',
        mopt5 => 'Panel de Ratios ',
        mopt6 => 'Panel de Wait Time ',
        mopt7 => 'Panel de Bloqueos ',
        mopt8 => 'Panel de Almacenamiento Temporal',
        mopt9 => 'Panel de Sentencias ',
        moptA => 'Panel de Explain ',
        moptB => 'Panel de Data Guard ',
        moptC => 'Panel de FRA y Backup ',
        moptD => 'Panel de UNDO ',
        moptE => 'Panel de CPU  ',
        moptG => 'Panel de Redo  ',
        moptH => 'Panel de Informacion Proceso  ',
        moptI => 'Panel de esperas por sesion  ',
        moptJ => 'Cambio del current schema',
        moptz => 'Incrementa la columna de ordenacion ',
        moptZ => 'Decrementa la columna de ordenacion',
        moptr => 'Incrementa el retardo en uns segundo',
        moptR => 'Decrementa el retardo en un segundo ',
        moptO => 'Cambia la ordenacion de ASC/DESC y viceversa',
        msgo1 => 'Opcion no valida ',
        msgo2 => 'La instancia se encuentra en modo:  ',   
              
    );

  return %lang_msg;
}



END { }

1;

 
