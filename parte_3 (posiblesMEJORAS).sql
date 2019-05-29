/*
* TRABAJO FINAL M2 
* PARTE 3 - SCRIPT parte_3(posiblesMEJORAS).sqñ
* procedimientos, funciones y triggers que se pueden/necesitan mejorar
* autores: Daniela Gallardo, Carlos Masana, Artur Marin 
*/

	/*Procedimiento 1
	*crear procedimiento que elimine los datos de un determinado cliente 
	si éste pide que se eliminen por privacidad */

	CREATE OR REPLACE PROCEDURE P_BORRAR_USUARIO (idusuario in CLIENT.client_cod%type)
	IS
  
	BEGIN
    	DELETE FROM CLIENT WHERE CLIENT_COD = idusuario;
    
    	DBMS_OUTPUT.PUT_LINE('El usuario con número '||idusuario||' ha sido eliminado');
    
	END p_borrar_usuario;

	--Otorgamos el privilegio a los usuarios con el rol ROLcliente
	GRANT EXECUTE ON BORRAR_USUARIO TO ROLcliente; --REVOKE EXECUTE ON BORRAR_USUARIO FROM ROLcliente;

	--Insertamos un cliente para probar el borrado
	INSERT INTO CLIENT(CLIENT_COD, NOM, DIRECCIO, CIUTAT, ESTAT, CODI_POSTAL, AREA, TELEFON, REPR_COD, LIMIT_CREDIT, OBSERVACIONS)
    	VALUES(110,'CLIENTE PRUEBA', '573 MURPHY FORD ROAD','JEFFERSON CITY','MO',65043 ,573, 123-4567, 7844, 10000,'Very friendly people to work with');

	--Otorgamos privilegios de hacer delete on client 
 	GRANT DELETE ON CLIENT TO ROLcliente; 

	--Comprobamos desde la conexion cliente_prueba si funciona
	EXECUTE P_BORRAR_USUARIO (110);

	--Comprobamos desde la conexion grupo_3 si se ha borrado
	select * from client;

	--OBSERVACIÓN: no borra a los clientes que tienen comandas registradas

