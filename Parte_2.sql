/*
* TRABAJO FINAL M2 
* PARTE 2 - SCRIPT parte_2.sql
* procedimientos, funciones y triggers
* autores: Daniela Gallardo, Carlos Masana, Artur Marin 
*/


/*PROCEDIMIENTO QUE:
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

    --Comprobamos
    CALL P_PEDIDOS_CLI(100);

    /*PROCEDIMIENTO QUE:
        * muestra los pedidos que ha hecho un determinado cliente 
        * y muestra los detalles de cada uno
    */

    