# UF3: RA1 y RA2 (DCL y PL/SQL)

_Documentación del trabajo final de M02-Sistemas Gestores de Bases de datos de los estudiantes Carlos Masana, Artur Marin y Daniela Gallardo_

## Introducción

Estas instrucciones te permitirán realizar la migración de un entorno de desarrollo a un entorno de producción.  A continuación, os mostraremos todos los pasos a seguir para poder implementar nuestra bbdd.


## Estructura y datos: DDL y DML

### Definición (DDL) y manipulación (DML) de datos

En este script se encuentra el código SQL que se encarga de crear la estructura donde almacenar los datos.
Para implementarlo, simplemente ejecuta el [script](https://github.com/guzanaz/G3-pl-sql/blob/master/G3_tablas_inserts.sql)

Ejemplo de DDL:

```sql
CREATE TABLE DEPT (
    DEPT_NO  NUMBER(2) CONSTRAINT DEPT_PK PRIMARY KEY
                    CONSTRAINT DEPT_CK_COD_POSITIU CHECK (DEPT_NO > 0),
    DNOM     VARCHAR(14) CONSTRAINT DEPT_NN_DNOM NOT NULL 
                      CONSTRAINT DEPT_UN_DNOM UNIQUE,
    LOC      VARCHAR(14) 
);

```

Ejemplo de DML:

```sql
INSERT INTO DEPT VALUES (10, 'COMPTABILITAT', 'SEVILLA');
INSERT INTO DEPT VALUES (20, 'INVESTIGACIÓ', 'MADRID');
INSERT INTO DEPT VALUES (30, 'VENDES', 'BARCELONA');
INSERT INTO DEPT VALUES (40, 'PRODUCCIÓ', 'BILBAO');

```

## Seguridad y lenguaje procedimental: DCL y PL/SQL

### Lenguaje de control de datos (DCL)

En este script se encuentra el código SQL que se encarga de la seguridad en nuestra bbdd (Usuarios, roles, privilegios, etc).
Para implementarlo, simplemente ejecuta el [script](https://github.com/guzanaz/G3-pl-sql/blob/master/Parte_1.sql)

Ejemplo de DCL:

```sql
GRANT CREATE SESSION TO RolCliente;
GRANT READ ON comanda TO RolCliente; 
GRANT READ ON detall TO RolCliente;
GRANT READ ON client TO RolCliente;
GRANT EXECUTE ON P_PEDIDOS_CLI TO RolCliente;

```

### Lenguaje procedimental (PL/SQL)

En este script se encuentra el código SQL que se encarga de crear procedimientos, funciones y triggers en nuestra bbdd.
Para implementarlo, simplemente ejecuta el [script](https://github.com/guzanaz/G3-pl-sql/blob/master/Parte_2.sql)

Ejemplo de PL/SQL:

```sql
CREATE OR REPLACE FUNCTION F_ANYS_TREBALLATS (i_date VARCHAR2, f_date VARCHAR2)
RETURN NUMBER
IS
    anys_tot NUMBER;
    anyo CONSTANT NUMBER := 12; -- Meses que tiene 1 año

BEGIN
    -- Actualización: Si añades la función ABS no importa el orden en el que introduzcas las fechas 
    SELECT ABS(ROUND((MONTHS_BETWEEN(f_date, i_date) / anyo), 0))
    INTO anys_tot
    FROM DUAL;
    
    RETURN anys_tot;
END F_ANYS_TREBALLATS;
/

```

## Software Utilizado

* [ORACLE 12c Database](https://www.oracle.com/es/corporate/features/database-12c/) - Software de base de datos
* [SQL Developer](https://www.oracle.com/database/technologies/appdev/sql-developer.html) - Entorno de desarrollo (IDE)

## Autores

* Carlos
* Daniela
* Artur

## Otros datos

* **Módulo** - M02 Gestión de bases de datos
* **Ciclo y aula** - ASIX-DAW 1B
* **Inicio del proyecto** - 17 MAYO 2019

