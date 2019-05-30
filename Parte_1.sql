/*
* TRABAJO FINAL M2 
* PARTE 1 - SCRIPT 17 de mayo 2019
* todo ha sido ejecutado desde la conexión system EXCEPTO la creación de las tablas y los inserts
* La creación de las tablas e inserts están en el script G3_tablas_inserts.sql
* por Daniela Gallardo, Carlos Masana, Artur Marin
*/

-- última modificación: 30 de mayo 2019

/*0. Creamos los siguientes usuarios para hacer prueba de los privilegios/roles que implementaremos:
*/
    CREATE USER CLIENTE_PRUEBA DENTIFIED BY CLIENTE; --Usuario: Cliente
    CREATE USER EMP_VENTAS IDENTIFIED BY VENDEDOR; --Usuario: Dpto Ventas
    CREATE USER EMP_CONTABLE IDENTIFIED BY CONTABLE; --Usuario: Dpto Contabilidad
    CREATE USER EMP_IT IDENTIFIED BY INFORMATICO; --Usuario: Dpto Informática (Admin)
    CREATE USER EMP_DEV IDENTIFIED BY DEVELOPER; --Usuario: Dpto Informática (Dev)
    CREATE USER EMP_RRHH IDENTIFIED BY RECURSOS; --Usuario: Dpto RRHH 

    -- JEFES DEPARTAMENTO
    CREATE USER J_VENT IDENTIFIED BY VENDEDOR; --Usuario: Jefe Dpto Ventas
    CREATE USER J_CONT IDENTIFIED BY CONTABLE; --Usuario: Jefe Dpto Contabilidad
    CREATE USER J_HR IDENTIFIED BY RECURSOS; --Usuario: Jefe Dpto RRHH


/*1. Creamos ROLCLIENTE para agrupar y asignar privilegios a los usuarios de tipo cliente*/
CREATE ROLE ROLcliente;--DROP ROLE ROLCLIENTE;
GRANT CREATE SESSION TO ROLcliente;--
GRANT READ ON GRUPO_3.COMANDA TO ROLcliente; 
GRANT READ ON GRUPO_3.DETALL TO ROLcliente;
GRANT READ ON GRUPO_3.client TO RolCliente;
GRANT EXECUTE ON P_PEDIDOS_CLI TO RolCliente;
--GRANT EXECUTE ON P_INCRE_PER_CENT TO RolCliente; -- Para cuando visualizas un producto y quieres ver su precio final con IVA

    -- asignamos el ROLcliente al usuario CLIENTE_PRUEBA
    GRANT ROLcliente TO CLIENTE_PRUEBA;

/*2. Creamos ROLEMP_VENTAS para agrupar y asignar privilegios a los usuarios de tipo vendedor*/
CREATE ROLE ROLEMP_VENTAS;
GRANT CREATE SESSION TO ROLEMP_VENTAS;
GRANT SELECT, INSERT, DELETE, UPDATE ON GRUPO_3.COMANDA TO ROLEMP_VENTAS;
GRANT SELECT, INSERT, DELETE, UPDATE ON GRUPO_3.DETALL TO ROLEMP_VENTAS;
GRANT SELECT, INSERT, DELETE, UPDATE ON GRUPO_3.CLIENT TO ROLEMP_VENTAS;
GRANT SELECT, UPDATE ON producte TO RolEmp_Ventas; -- Pueden modificar únicamente los productos
--GRANT EXECUTE ON P_DIEZ_ULT_PED TO RolEmp_Ventas;
GRANT EXECUTE ON P_VENTAS_TOT_EMP TO RolEmp_Ventas;   
    -- asignamos el ROLEMP_VENTAS al usuario EMP_VENTAS
    GRANT ROLEMP_VENTAS TO EMP_VENTAS;

-- 2.1 Cedemos Privilegios a J_VENT (Jefe Dpto. Ventas)
GRANT CREATE SESSION TO J_VENT;
GRANT INSERT, DELETE ON producte TO RolEmp_Ventas; -- Puede introducir y borrar productos
GRANT EXECUTE ON P_VENTAS_TOT TO J_VENT;
GRANT RolEmp_Ventas TO J_VENT;----añadimos el rolemp_ventas al jefe


/*3. Creamos ROLEMP_CONT para agrupar y asignar privilegios a los usuarios de tipo contable*/
CREATE ROLE ROLEMP_CONT;
GRANT CREATE SESSION TO ROLEMP_CONT;
GRANT SELECT ON GRUPO_3.COMANDA TO ROLEMP_CONT;
--GRANT EXECUTE ON P_INCRE_PER_CENT TO RolEmp_Cont;
    
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
GRANT CREATE PROCEDURE TO RolDev;

    -- asignamos el ROLDEV al usuario EMP_DEV
    GRANT ROLdev TO EMP_DEV;

/*6. Creamos ROLEMP_RRHH para agrupar y asignar privilegios a los usuarios de tipo RRHH*/
CREATE ROLE ROLEMP_RRHH;
GRANT CREATE SESSION TO ROLEMP_RRHH;
GRANT SELECT, INSERT, UPDATE, DELETE ON GRUPO_3.EMP TO ROLEMP_RRHH;
GRANT SELECT ON OLD_EMP TO RolEmp_RRHH;
GRANT EXECUTE ON F_ANYS_TREBALLATS TO RolEmp_RRHH;
GRANT EXECUTE ON P_PTOSPORVENTA TO RolEmp_RRHH;
GRANT EXECUTE ON F_VENTAS_A_PTJE TO RolEmp_RRHH;
PENDIENTE ! GRANT EXECUTE ON P_INCRE_PER_CENT TO RolEmp_RRHH;    
    
    -- asignamos el ROLEMP_RRHH al usuario EMP_RRHH
    GRANT ROLEMP_RRHH TO EMP_RRHH;

-- 6.1 Cedemos Privilegios a J_HR (Jefe Dpto. RRHH)
GRANT CREATE SESSION TO J_HR;
GRANT RolEmp_RRHH TO J_HR;--añadimos el rol de emp rrhh al jefe

/* COMPROBACIÓN DE ROLES */
-- SELECT * FROM DBA_ROLE_PRIVS;

--Para deshacer cualquier privilegio o rol usamos REVOKE privilegio/rol FROM usuario/rol;



