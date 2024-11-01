

prompt |      Activación Mensajería       |
SET SERVEROUTPUT ON;

prompt +-------------------------------------------------------------+
prompt |            Procedimiento imprimir_pedidos_cliente
prompt +-------------------------------------------------------------+
CREATE OR REPLACE PROCEDURE imprimir_pedidos_cliente(
    p_id_usuario IN INTEGER
) IS
    -- Declaración de excepciones personalizadas
    ex_usuario_no_existe EXCEPTION;
    ex_sin_pedidos EXCEPTION;

    v_count INTEGER;
BEGIN
    -- Verifica si el usuario existe
    SELECT COUNT(*) INTO v_count FROM USUARIOS WHERE DOCUMENTO_USUARIO = p_id_usuario;
    IF v_count = 0 THEN
        RAISE ex_usuario_no_existe;
    END IF;

    -- Verifica si el usuario tiene pedidos
    SELECT COUNT(*) INTO v_count FROM PEDIDOS WHERE ID_USUARIO = p_id_usuario;
    IF v_count = 0 THEN
        RAISE ex_sin_pedidos;
    END IF;

    -- Iterar sobre los pedidos del usuario
    FOR pedido IN (
        SELECT ID_PEDIDOS, FECHA_CREACION, FECHA_ENTREGA, DESCUENTO, TOTAL, PRIORIDAD, SEGUIMIENTO, ID_DIRECCION
        FROM PEDIDOS
        WHERE ID_USUARIO = p_id_usuario
        ORDER BY FECHA_CREACION
    ) LOOP
        -- Imprimir la información de cada pedido
        DBMS_OUTPUT.PUT_LINE('ID_PEDIDOS: ' || pedido.ID_PEDIDOS || 
                             ', FECHA_CREACION: ' || TO_CHAR(pedido.FECHA_CREACION, 'YYYY-MM-DD') || 
                             ', FECHA_ENTREGA: ' || TO_CHAR(pedido.FECHA_ENTREGA, 'YYYY-MM-DD') || 
                             ', DESCUENTO: ' || pedido.DESCUENTO || 
                             ', TOTAL: ' || pedido.TOTAL || 
                             ', PRIORIDAD: ' || pedido.PRIORIDAD || 
                             ', SEGUIMIENTO: ' || pedido.SEGUIMIENTO || 
                             ', ID_DIRECCION: ' || pedido.ID_DIRECCION);
    END LOOP;

EXCEPTION
    WHEN ex_usuario_no_existe THEN
        RAISE_APPLICATION_ERROR(-20026, 'El usuario con identificación ' || p_id_usuario || ' no existe.');
    WHEN ex_sin_pedidos THEN
        RAISE_APPLICATION_ERROR(-20027, 'El usuario con identificación ' || p_id_usuario || ' no tiene pedidos.');
END;
/

