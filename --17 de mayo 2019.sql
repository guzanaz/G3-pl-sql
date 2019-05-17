/*
* TRABAJO FINAL M2 
* PARTE 1 - SCRIPT 17 de mayo 2019
* todo ha sido ejecutado desde la conexión system EXCEPTO la creación de las tablas y los inserts
* La creación de las tablas e inserts están en el script G3_tablas_inserts.sql
* por Daniela Gallardo
*/

/*0. Creamos los siguientes usuarios para hacer prueba de los privilegios/roles que implementaremos:
    * CLIENTE_PRUEBA
    * EMP_VENTAS
    * EMP_CONTABLE
    * EMP_IT
    * EMP_DEV
    * EMP_RRHH   
*/

/*1. Creamos ROLCLIENTE para agrupar y asignar privilegios a los usuarios de tipo cliente*/
CREATE ROLE ROLcliente;--DROP ROLE ROLCLIENTE;
GRANT CREATE SESSION TO ROLcliente;--
GRANT READ ON GRUPO_3.COMANDA TO ROLcliente; 
GRANT READ ON GRUPO_3.DETALL TO ROLcliente;

    -- asignamos el ROLcliente al usuario CLIENTE_PRUEBA
    GRANT ROLcliente TO CLIENTE_PRUEBA;

/*2. Creamos ROLEMP_VENTAS para agrupar y asignar privilegios a los usuarios de tipo vendedor*/
CREATE ROLE ROLEMP_VENTAS;
GRANT CREATE SESSION TO ROLEMP_VENTAS;
GRANT SELECT, INSERT, DELETE, UPDATE ON GRUPO_3.COMANDA TO ROLEMP_VENTAS;
GRANT SELECT, INSERT, DELETE, UPDATE ON GRUPO_3.DETALL TO ROLEMP_VENTAS;
GRANT SELECT, INSERT, DELETE, UPDATE ON GRUPO_3.CLIENT TO ROLEMP_VENTAS;
   
    -- asignamos el ROLEMP_VENTAS al usuario EMP_VENTAS
    GRANT ROLEMP_VENTAS TO EMP_VENTAS;

/*3. Creamos ROLEMP_CONT para agrupar y asignar privilegios a los usuarios de tipo contable*/
CREATE ROLE ROLEMP_CONT;
GRANT CREATE SESSION TO ROLEMP_CONT;
GRANT SELECT ON GRUPO_3.COMANDA TO ROLEMP_CONT
    
    -- asignamos el ROLEMP_CONT al usuario EMP_CONTABLE
    GRANT ROLEMP_CONT TO EMP_CONTABLE;

/*4. Creamos ROLEMP_IT para agrupar y asignar privilegios a los usuarios de tipo IT(administradores)*/
CREATE ROLE ROLEMP_IT;
GRANT CREATE SESSION TO ROLEMP_IT;
    
    -- asignamos el rol por defecto de oracle DBA al rol ROLemp_it 
    GRANT DBA TO ROLEMP_IT;
    
    -- asignamos el ROLEMP_IT al usuario EMP_IT
    GRANT ROLemp_it TO EMP_IT;

/*5. Creamos ROLDEV para agrupar y asignar privilegios a los usuarios de tipo developer*/
CREATE ROLE ROLDEV;
GRANT CREATE SESSION TO ROLDEV;
GRANT SELECT ANY TABLE TO ROLDEV;

    -- asignamos el ROLDEV al usuario EMP_DEV
    GRANT ROLdev TO EMP_DEV;

/*6. Creamos ROLEMP_RRHH para agrupar y asignar privilegios a los usuarios de tipo RRHH*/
CREATE ROLE ROLEMP_RRHH;
GRANT CREATE SESSION TO ROLEMP_RRHH;
GRANT SELECT, INSERT, UPDATE, DELETE ON GRUPO_3.EMP TO ROLEMP_RRHH;
    
    -- asignamos el ROLEMP_RRHH al usuario EMP_RRHH
    GRANT ROLEMP_RRHH TO EMP_RRHH;


--Para deshacer cualquier privilegio o rol usamos REVOKE privilegio/rol FROM usuario/rol;



