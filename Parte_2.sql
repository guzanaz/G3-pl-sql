/*Procedimiento 1
*crear procedimiento que elimine los datos de un determinado cliente 
si éste pide que se eliminen por privacidad.
*/

CREATE OR REPLACE PROCEDURE BORRAR_USUARIO (idusuario in CLIENT.client_cod%type)
IS
  
BEGIN
    DELETE FROM CLIENT WHERE CLIENT_COD = idusuario;
    
    DBMS_OUTPUT.PUT_LINE('El usuario con número '||idusuario||' ha sido eliminado');
    
END borrar_usuario;

--Otorgamos el privilegio a los usuarios con el rol ROLcliente
GRANT EXECUTE ON BORRAR_USUARIO TO ROLcliente; --REVOKE EXECUTE ON BORRAR_USUARIO FROM ROLcliente;

--Insertamos un cliente para probar el borrado
INSERT INTO CLIENT(CLIENT_COD, NOM, DIRECCIO, CIUTAT, ESTAT, CODI_POSTAL, AREA, TELEFON, REPR_COD, LIMIT_CREDIT, OBSERVACIONS)
    VALUES(110,'CLIENTE PRUEBA', '573 MURPHY FORD ROAD','JEFFERSON CITY','MO',65043 ,573, 123-4567, 7844, 10000,'Very friendly people to work with');

--Otorgamos privilegios de hacer delete on client 
 GRANT DELETE ON CLIENT TO ROLcliente; 

--Comprobamos desde la conexion cliente_prueba si funciona
EXECUTE BORRAR_USUARIO (110);

--Comprobamos desde la conexion grupo_3 si se ha borrado
select * from client;


/* Crear trigger: para cada empleado por cada 10 productos 
que venda  (sin  importar el tipo de producto ni la comanda): 
	* Se registra en la tabla ptos_por_ventas el id del empleado, 
	la cantidad total de productos vendidos y el puntaje acumulado a la fecha.
	* cada 10 productos vendidos se obtienen 5 puntos
*/

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

    