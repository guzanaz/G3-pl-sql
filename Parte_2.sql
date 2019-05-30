/*
* TRABAJO FINAL M2 
* PARTE 2 - SCRIPT parte_2.sql
* procedimientos, funciones y triggers
* autores: Daniela Gallardo, Carlos Masana, Artur Marin 
*/


/* PROCEDIMIENTO QUE:
* muestra los pedidos que ha hecho un determinado cliente 
* y muestra los detalles de cada uno
*/

    /*1. Primero creamos un procedimiento que muestre todos los productos de una determinada comanda*/
    CREATE OR REPLACE PROCEDURE P_PED_POR_COM (id_com detall.com_num%TYPE)
        IS
            v_des producte.descripcio%TYPE;
    
            CURSOR c_ped_com IS
                SELECT prod_num, preu_venda, quantitat, import
                FROM detall
                WHERE com_num = id_com;

        BEGIN
            FOR r_ped_com IN c_ped_com 
            LOOP
                SELECT descripcio
                INTO v_des
                FROM producte
                WHERE prod_num = r_ped_com.prod_num;
        
        DBMS_OUTPUT.PUT_LINE('Ref: '||r_ped_com.prod_num||' Producto: '||v_des||' Precio: '||r_ped_com.preu_venda||' Qty: '||r_ped_com.quantitat||' Importe: '||r_ped_com.import);
            END LOOP;
        END P_PED_POR_COM;
        /

    /*2. Creamos otro procedimiento en el que llamamos al procedimiento anterior 
    para que muestre un listado de los productos por factura*/  
    
    CREATE OR REPLACE PROCEDURE P_PEDIDOS_CLI (id_client comanda.client_cod%TYPE)
    IS  
        v_nom client.nom%TYPE;
    
        CURSOR c_pedidos_tot IS
            SELECT com_data, com_num, data_tramesa, total 
            FROM comanda
                WHERE client_cod = id_client
            ORDER BY com_data;
        
    BEGIN
        -- Consulta que almacena en una variable el nombre del cliente
        SELECT nom INTO v_nom
        FROM client
            WHERE client_cod = id_client;
    
        -- Líneas con texto informativo
        DBMS_OUTPUT.PUT_LINE('Pedidos de: '||v_nom||' - Nº Cliente: '||id_client);
        DBMS_OUTPUT.PUT_LINE(' ');
    
        -- Bucle para obtener los registros del cursor
        FOR r_pedidos_tot IN c_pedidos_tot 
        LOOP
            DBMS_OUTPUT.PUT_LINE('FACTURA: '||r_pedidos_tot.com_num||' --- '||r_pedidos_tot.com_data||' '||r_pedidos_tot.total);
        
            -- Llamada al proc. para mostrar la lista de productos por comanda
            P_PED_POR_COM(r_pedidos_tot.com_num);
        
            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
    END P_PEDIDOS_CLI;
    /

    --comprobamos
    CALL P_PEDIDOS_CLI(100);

    

/*PROCEDIMIENTO QUE:
    * recibe el parámetro de un cliente
    * y devuelve el último pedido del cliente por pantalla
*/
    /*1. Creamos una Función que recibe por parámetro un cliente 
    y devuelve el último pedido del cliente */
    CREATE OR REPLACE FUNCTION F_ULT_COM (cod_cli comanda.client_cod%type)
    RETURN comanda%rowtype
    IS
        --declaramos la variable ultima_comanda de tipo rowtype
        ultima_comanda comanda%rowtype;

        BEGIN   
            SELECT * into ultima_comanda   
            from comanda 
                WHERE comanda.client_cod = cod_cli
            order by com_data DESC
            FETCH FIRST 1 ROWS ONLY;
        
        RETURN ultima_comanda;
            
    END F_ULT_COM;
    /
    --comprobamos con un bloque anónimo
    DECLARE
        ultima_comanda comanda%rowtype;
        cod_cli comanda.client_cod%type:=101;
    BEGIN
        ultima_comanda := f_ult_com(cod_cli);
        DBMS_OUTPUT.PUT_LINE('La última comanda del cliente:'||cod_cli||'  es la nº:'||ultima_comanda.com_num);
    end;


    /*2. Creamos procedimiento para utilizar la función que acabamos de crear*/
    CREATE OR REPLACE PROCEDURE p_ult_com (cod_cli comanda.client_cod%type)
    as
    ultima_comanda comanda%rowtype;
    BEGIN
        --asignamosa a la variable el nombre de la función
        ultima_comanda := f_ult_com(cod_cli);
        --imprimimos la variable con el nombre del campo que queremos que devuelva
        DBMS_OUTPUT.PUT_LINE('La última comanda del cliente:'||cod_cli||'  es la nº:'||ultima_comanda.com_num);
    END;

    --comprobamos
    execute p_ult_com(101);

/* PROCEDIMIENTO QUE:
    para los empleados vendedores muestre por pantalla:
    1) id de empleado, y la suma del total de los productos que han vendido a la fecha.
    2) Si cada 10 productos vendidos obtienen 5 puntos, mostrar el puntaje a la fecha.
*/
    -- 1. select que me mostraría campos que necesito mostrar sin el puntaje
     SELECT client.REPR_COD, sum(QUANTITAT) as suma
          FROM detall, client, comanda, emp
            where DETALL.COM_NUM= COMANDA.COM_NUM
                and comanda.client_cod= client.client_cod
                and CLIENT.REPR_COD= EMP.EMP_NO
                group by client.REPR_COD;
    --1.1 compruebo si el select anterior está sumando correctamente
    SELECT client.REPR_COD, detall.prod_num, detall.QUANTITAT
        FROM detall, client, comanda, emp
            where DETALL.COM_NUM= COMANDA.COM_NUM
                and comanda.client_cod= client.client_cod
                and CLIENT.REPR_COD= EMP.EMP_NO
            group by client.REPR_COD;

    -- 2. creo una función para obtener los puntos por c/ 10 prod. vendidos
    CREATE OR REPLACE FUNCTION f_ventas_a_ptje (v_quantitat_prod in detall.quantitat%TYPE)
    RETURN number 
    as 
        v_total INT;
        v_cant CONSTANT int:=10;--prod. que se necesitan para tener ptje.
        v_point CONSTANT int:=5;--puntos que se consiguen

    BEGIN         
        v_total:=(v_quantitat_prod/v_cant)*v_point;
    
        Return v_total;
    
    END f_ventas_a_ptje;

    --3.Comprobamos la función con un bloque anónimo (y dividiendo por un nro impar)
    DECLARE
        V_TOTAL int;
    BEGIN
    V_TOTAL :=f_ventas_a_ptje(307);
    DBMS_OUTPUT.PUT_LINE(V_TOTAL);
    end;

    --4.Creamos el procedimiento donde usamos el select y la función que hemos hecho
    CREATE OR REPLACE PROCEDURE p_ptosporventa 
    as
        v_ptos int;
    
        cursor c_ptosporventa is
            SELECT client.REPR_COD, sum(QUANTITAT) as suma
                FROM detall, client, comanda, emp
                    where DETALL.COM_NUM= COMANDA.COM_NUM
                    and comanda.client_cod= client.client_cod
                    and CLIENT.REPR_COD= EMP.EMP_NO
                group by client.REPR_COD;
    BEGIN
        FOR r_ptosporventa IN c_ptosporventa 
        loop
  
        v_ptos:=f_ventas_a_ptje(r_ptosporventa.suma); 
        /* imprimimos por pantalla*/       
        DBMS_OUTPUT.PUT_LINE('NRO.emp: '||r_ptosporventa.repr_cod||
                    '  cant_prod: '||r_ptosporventa.suma||'  puntos: '||v_ptos);
        end loop;
    end;

    --comprobamos
    execute p_ptosporventa;

/*Función que:
    * Devuelve la cantidad total de pedidos que ha hecho un determinado cliente 
*/
    --1. Creamos la función
    CREATE OR REPLACE FUNCTION F_TOT_PED_CLI (id_client comanda.client_cod%TYPE)
    RETURN NUMBER
    IS  
        total_pedidos NUMBER;

    BEGIN
        SELECT count(*)
        INTO total_pedidos
        FROM comanda
        WHERE client_cod = id_client;

        RETURN total_pedidos;

    END F_TOT_PED_CLI;

    --1.1 comprobamos con un bloque anónimo
    DECLARE
        total_pedidos NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Cantidad de Pedidos - Cliente 100: '||F_TOT_PED_CLI(100));
    END;

/*Trigger que:
    * Registra en una nueva tabla los datos de antiguos trabajadores cuando se dan de baja en la empresa.
*/
    --1.Creamos la nueva tabla
    CREATE TABLE OLD_EMP (
        EMP_NO NUMBER(6,0) not null,
        COGNOM VARCHAR(50) not null,
        DEPT_NO NUMBER(3,0)not null,
        DATA_ALTA DATE not null,
        DATA_BAIXA DATE not null,
        ANYS_TREB NUMBER(2,0) not null
    );

    --2.Función que calcula los años transcurridos entre dos fechas (fecha de baja - fecha de alta) 
    CREATE OR REPLACE FUNCTION F_ANYS_TREBALLATS (baja_date VARCHAR2, alta_date VARCHAR2)
    RETURN NUMBER
    IS
        anys_tot NUMBER;

    BEGIN
        SELECT ROUND((MONTHS_BETWEEN(baja_date, alta_date) / 12), 0)
            INTO anys_tot
        FROM DUAL;
    
        RETURN anys_tot;
    END F_ANYS_TREBALLATS;
    /

    --2.1 comprobamos la función con un bloque anónimo 
    DECLARE
        anys_tot NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE(f_anys_treballats('01-01-20','01-01-19'));
    END;
    /

    --3.Creamos el trigger
    CREATE OR REPLACE TRIGGER T_OLD_EMP 
    BEFORE DELETE ON EMP
    FOR EACH ROW
    BEGIN
        INSERT INTO OLD_EMP
        VALUES (:old.emp_no, :old.cognom, :old.dept_no, :old.data_alta, sysdate, f_anys_treballats(sysdate, :old.data_alta));
    END T_OLD_EMP;
    /

    --3.1 comprobamos
        -- insertamos un empleado para luego eliminarlo
        INSERT INTO EMP (EMP_NO, COGNOM, OFICI, CAP, DATA_ALTA, SALARI, COMISSIO, DEPT_NO)
            VALUES (7999,'MASANA','VENEDOR', 7698, TO_DATE('30/05/18','DD/MM/YY'), 20000, null, 10);
        
        --borramos el emp
        DELETE FROM EMP WHERE EMP_NO = 7999;
    
        --consultamos la nueva tabla
        SELECT * FROM OLD_EMP;

/* PROCEDIMIENTO EN EL QUE:
    Se ingresan dos fechas y se obtiene un listado de las ventas totales por ese período
*/
    CREATE OR REPLACE PROCEDURE P_VENTAS_TOT (ini_fecha VARCHAR2, fin_fecha VARCHAR2)
    IS  
        CURSOR c_ventas_tot IS
            SELECT com_data, com_num, client_cod, data_tramesa, total 
            FROM comanda
                WHERE com_data BETWEEN ini_fecha AND fin_fecha
            ORDER BY com_data;
        
    BEGIN
        -- Líneas con texto informativo
        DBMS_OUTPUT.PUT_LINE('Ventas entre: '||ini_fecha|| ' y '||fin_fecha);
        DBMS_OUTPUT.PUT_LINE(' ');
    
        -- Bucle para obtener los registros del cursor
       FOR r_ventas_tot IN c_ventas_tot 
        LOOP
        DBMS_OUTPUT.PUT_LINE(r_ventas_tot.com_data||' --- '||'Nro. comanda: '||r_ventas_tot.com_num||'   Ciente: '||r_ventas_tot.client_cod||'   Total: '||r_ventas_tot.total);
        END LOOP;
    
    END P_VENTAS_TOT;
    /

    --comprobamos
    CALL P_VENTAS_TOT('01-05-86','12-01-87');

/* PROCEDIMIENTO QUE: 
    Muestra las ventas totales de un empleado en un determinado período de tiempo
*/

    CREATE OR REPLACE PROCEDURE P_VENTAS_TOT_EMP (ini_fecha VARCHAR2, fin_fecha VARCHAR2, id_emp emp.emp_no%type)
    IS  
        v_cognom emp.cognom%TYPE;
    
        CURSOR c_ventas_tot IS
            SELECT a.com_data, a.com_num, a.client_cod, a.data_tramesa, a.total, t.repr_cod 
                FROM comanda a, client t
                    WHERE a.com_data BETWEEN ini_fecha AND fin_fecha
                        AND a.client_cod = t.client_cod
                        AND t.repr_cod = id_emp
                    ORDER BY a.com_data;
        
    BEGIN
        -- Consulta que almacena el apellido del empleado en una variable
        SELECT cognom INTO v_cognom
        FROM emp
        WHERE emp_no = id_emp;
    
        -- Líneas con texto informativo
        DBMS_OUTPUT.PUT_LINE('Empleado '||v_cognom|| ' nº: '||id_emp);
        DBMS_OUTPUT.PUT_LINE('Ventas entre: '||ini_fecha|| ' y '||fin_fecha);
        DBMS_OUTPUT.PUT_LINE(' ');
    
        -- Bucle para obtener los registros del cursor
        FOR r_ventas_tot IN c_ventas_tot 
        LOOP
            DBMS_OUTPUT.PUT_LINE(r_ventas_tot.com_data||' --- '||'nro. comanda: '||r_ventas_tot.com_num||'   nro. cliente: '||
            r_ventas_tot.client_cod||'   total ventas:'||r_ventas_tot.total);
        END LOOP;
    END P_VENTAS_TOT_EMP;
    /

    --comprobamos que el procedimiento funcione
    CALL P_VENTAS_TOT_EMP('01-05-86','12-01-87',7844);

    --comprobamos con un select si es correcto lo que nos muestra el procedimiento
    SELECT * FROM comanda a
        INNER JOIN client t
            ON t.client_cod = a.client_cod
        INNER JOIN emp e
            ON t.repr_cod = e.emp_no
        AND t.repr_cod = 7844
        AND a.com_data BETWEEN '01-05-86' AND '12-01-87';

/*PROCEDIMIENTO QUE
Muestra los 10 últimos pedidos (comandas) de un cliente
*/

    CREATE OR REPLACE PROCEDURE P_DIEZ_ULT_PED (id_client comanda.client_cod%TYPE)
    IS  
        v_nom client.nom%TYPE;
    
        CURSOR c_pedidos_tot IS
            SELECT com_data, com_num, data_tramesa, total 
            FROM comanda
                WHERE client_cod = id_client
            ORDER BY com_data
            FETCH FIRST 10 ROWS ONLY;       
    BEGIN
        -- Consulta que almacena en una variable el nombre del cliente
        SELECT nom INTO v_nom
            FROM client
                WHERE client_cod = id_client;
    
        -- Líneas con texto informativo
        DBMS_OUTPUT.PUT_LINE('Pedidos de: '||v_nom||' - Nº Cliente: '||id_client);
        DBMS_OUTPUT.PUT_LINE(' ');
    
        -- Bucle para obtener los registros del cursor
        FOR r_pedidos_tot IN c_pedidos_tot 
        LOOP
            DBMS_OUTPUT.PUT_LINE('FACTURA: '||r_pedidos_tot.com_num||' --- '||r_pedidos_tot.com_data||' '||r_pedidos_tot.total);
            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
    END P_DIEZ_ULT_PED;
    /

    --comprobamos que funciona
    CALL P_DIEZ_ULT_PED(100);



