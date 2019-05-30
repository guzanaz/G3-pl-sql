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












    