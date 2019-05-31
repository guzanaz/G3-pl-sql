/*
* TRABAJO FINAL M2 
* PARTE 3 - SCRIPT parte_3(posiblesMEJORAS).sql
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

	/* TRIGGER: para cada empleado por cada 10 productos 
	que venda (sin importar el tipo de producto ni la comanda): 
		* Se registra en la tabla ptos_por_ventas el id del empleado, 
		la cantidad total de productos vendidos y el puntaje acumulado a la fecha.
		* cada 10 productos vendidos se obtienen 5 puntos
	*/
-----------------------CONSULTAR EL PROCEDIMIENTO p_ptosporventa-----------------------------------------------------
	-- creamos la tabla ptos_por_ventas
	CREATE TABLE ptos_por_venta(
	emp_no NUMBER(4) not null,
	fecha date not null,
	quantitat_prod Number(9) not null,
	puntaje NUMBER(9) null,
    CONSTRAINT ptos_por_venta_pk
        PRIMARY KEY (emp_no,client_cod),
    CONSTRAINT ptos_por_venta_fk_emp
		FOREIGN KEY (emp_no)
		REFERENCES EMP (EMP_NO)
	);

	--hacemos el select que me mostraría campos que necesito guardarme en la nueva tabla
	SELECT client.REPR_COD as emp_no, sum(DETALL.QUANTITAT) 
	FROM (((comanda
    INNER JOIN detall
    ON COMANDA.COM_NUM= DETALL.COM_NUM)
    INNER JOIN client
    ON comanda.client_cod= client.client_cod)
    INNER JOIN EMP
    ON CLIENT.REPR_COD= EMP.EMP_NO)
    group by client.REPR_COD;

	-- compruebo si el select anterior me está sumando correctamente 
	--(sumando los resultados por tipo de producto)
	SELECT client.REPR_COD as emp_no, detall.prod_num, DETALL.QUANTITAT
	FROM (((comanda
    	INNER JOIN detall
    		ON COMANDA.COM_NUM= DETALL.COM_NUM)
   		INNER JOIN client
    		ON comanda.client_cod= client.client_cod)
    	INNER JOIN EMP
    		ON CLIENT.REPR_COD= EMP.EMP_NO)
    	order by client.REPR_COD;


    CREATE OR REPLACE TRIGGER t_ptosporventa
    AFTER INSERT OR UPDATE
    ON dg_detall
    FOR EACH ROW 
    DECLARE

	/*en la tabla detall no tenemos registro nro de emp 
	entonces creamos una variable para guardarla*/

	v_emp_no client.REPR_COD%type; 

	BEGIN
		SELECT client.REPR_COD INTO v_emp_no
			FROM client, comanda
    			WHERE comanda.client_cod=:new.client_cod
    			and comanda.com_num=:new.com_num;
-----CONTINUARÁ----

	END; 
