--17 de mayo 2019 
/*0. Creamos los siguientes usuarios:
    * G3CLIENTE_1;
    * G3EMP_VENTAS;
    * G3EMP_CONT;
    * G3EMP_IT;
    * G3DEV;
    * G3EMP_RRHH;   
*/

/*1. Creamos un rol para asignar privilegios a los usuarios de tipo cliente*/
CREATE ROLE ROLcliente;
GRANT CREATE SESSION TO ROLcliente;
GRANT READ ON ITADMIN.G3_COMANDA TO ROLcliente; 
GRANT READ ON ITADMIN.G3_DETALL TO ROLcliente;

    -- asiganmos el ROLcliente al usuario G3CLIENTE_1;
    GRANT ROLcliente TO G3CLIENTE_1;

/*2. Creamos un rol para asignar privilegios a los usuarios de tipo vendedor*/
CREATE ROLE ROLemp_ventas;
GRANT CREATE SESSION TO ROLEmp_Ventas;
GRANT SELECT, INSERT, DELETE, UPDATE ON ITADMIN.G3_COMANDA TO ROLemp_ventas;
GRANT SELECT, INSERT, DELETE, UPDATE ON ITADMIN.G3_DETALL TO ROLemp_ventas;
GRANT SELECT, INSERT, DELETE, UPDATE ON ITADMIN.G3_CLIENT TO ROLemp_ventas;
   
    -- asiganmos el ROLemp_ventas al usuario G3EMP_VENTAS;
    GRANT ROLemp_ventas TO G3EMP_VENTAS;

/*3. Creamos un rol para asignar privilegios a los usuarios de tipo contable*/
CREATE ROLE ROLemp_cont;
GRANT CREATE SESSION TO ROLemp_cont;
GRANT SELECT ON ITADMIN.G3_COMANDA TO ROLemp_cont;
    
    -- asiganmos el ROLemp_cont al usuario G3EMP_CONT;
    GRANT ROLemp_cont TO G3EMP_CONT;

/*4. Creamos un rol para asignar privilegios a los usuarios de tipo IT(administradores)*/
CREATE ROLE ROLemp_it;
GRANT CREATE SESSION TO ROLemp_it;
    
    --Asignamos el rol por defecto de oracle DBA al rol ROLemp_it 
    GRANT DBA TO ROLemp_it;
    
    -- asiganmos el ROLemp_it al usuario G3EMP_IT
    GRANT ROLemp_it TO G3EMP_IT;

/*5. Creamos un rol para asignar privilegios a los usuarios de tipo desarrollador*/
CREATE ROLE ROLdev;
GRANT CREATE SESSION TO ROLdev;
GRANT SELECT ANY TABLE TO ROLdev;

    -- asiganmos el ROLdev al usuario G3DEV
    GRANT ROLdev TO G3dev;

/*6. Creamos un rol para asignar privilegios a los usuarios de tipo RRHH*/
CREATE ROLE ROLemp_RRHH;
GRANT CREATE SESSION TO ROLemp_RRHH;
GRANT SELECT, INSERT, UPDATE, DELETE ON ITADMIN.G3_EMP TO ROLemp_RRHH;
    
    -- asiganmos el ROLemp_rrhh al usuario G3emp_rrhh
    GRANT ROLemp_rrhh TO G3emp_rrhh;


--Para deshacer cualquier privilegio o rol usamos REVOKE privilegio/rol FROM usuario/rol;

