
prompt +----------------------------------+
prompt |      Creación de paquetes       |
prompt |       en la Base de Datos        |
prompt |          naturantioquia          |
prompt +----------------------------------+


prompt +-------------------------------------------------------------+
prompt |            Package  pkg_manejo_logs   
prompt +-------------------------------------------------------------+

prompt --> Cabecera del paquete pkg_manejo_logs 
CREATE OR REPLACE PACKAGE pkg_manejo_logs AS
    -- Variables para controlar el estado de los logs
    log_activo BOOLEAN := TRUE;
    log_tabla_activo BOOLEAN := TRUE;
    log_archivo_activo BOOLEAN := TRUE;
    
    -- Variables compartidas para almacenar información del usuario y fecha del cambio
    usuario_actual VARCHAR2(100);
    fecha_actual TIMESTAMP;

    -- Procedimientos para el control de log_activo
    PROCEDURE pr_activar_logs;
    PROCEDURE pr_desactivar_logs;
    PROCEDURE pr_imprimir_log_activo;
    FUNCTION fn_obtener_log_activo RETURN BOOLEAN;

    -- Procedimientos para el control de log_tabla_activo
    PROCEDURE pr_activar_log_tabla;
    PROCEDURE pr_desactivar_log_tabla;
    PROCEDURE pr_imprimir_log_tabla;
    FUNCTION fn_obtener_log_tabla RETURN BOOLEAN;

    -- Procedimientos para el control de log_archivo_activo
    PROCEDURE pr_activar_log_archivo;
    PROCEDURE pr_desactivar_log_archivo;
    PROCEDURE pr_imprimir_log_archivo;
    FUNCTION fn_obtener_log_archivo RETURN BOOLEAN;

    -- Procedimientos para registrar logs en diferentes formatos
    PROCEDURE pr_insertar_log_tabla(
        p_evento IN VARCHAR2,
        p_momento IN VARCHAR2,
        p_accion IN VARCHAR2
    );
    
    PROCEDURE pr_insertar_log_archivo(
        p_evento IN VARCHAR2,
        p_momento IN VARCHAR2,
        p_accion IN VARCHAR2,
        p_tabla IN VARCHAR2
    );
    
END pkg_manejo_logs;
/


prompt --> Cuerpo del paquete pkg_manejo_logs 
CREATE OR REPLACE PACKAGE BODY pkg_manejo_logs AS

    -- Procedimientos para el control de log_activo
    PROCEDURE pr_activar_logs IS
    BEGIN
        log_activo := TRUE;
    END pr_activar_logs;

    PROCEDURE pr_desactivar_logs IS
    BEGIN
        log_activo := FALSE;
    END pr_desactivar_logs;

    PROCEDURE pr_imprimir_log_activo IS
    BEGIN
        IF log_activo THEN
            DBMS_OUTPUT.PUT_LINE('log_activo: TRUE');
        ELSE
            DBMS_OUTPUT.PUT_LINE('log_activo: FALSE');
        END IF;
    END pr_imprimir_log_activo;

    FUNCTION fn_obtener_log_activo RETURN BOOLEAN IS
    BEGIN
        RETURN log_activo;
    END fn_obtener_log_activo;

    -- Procedimientos para el control de log_tabla_activo
    PROCEDURE pr_activar_log_tabla IS
    BEGIN
        log_tabla_activo := TRUE;
    END pr_activar_log_tabla;

    PROCEDURE pr_desactivar_log_tabla IS
    BEGIN
        log_tabla_activo := FALSE;
    END pr_desactivar_log_tabla;

    PROCEDURE pr_imprimir_log_tabla IS
    BEGIN
        IF log_tabla_activo THEN
            DBMS_OUTPUT.PUT_LINE('log_tabla_activo: TRUE');
        ELSE
            DBMS_OUTPUT.PUT_LINE('log_tabla_activo: FALSE');
        END IF;
    END pr_imprimir_log_tabla;

    FUNCTION fn_obtener_log_tabla RETURN BOOLEAN IS
    BEGIN
        RETURN log_tabla_activo;
    END fn_obtener_log_tabla;

    -- Procedimientos para el control de log_archivo_activo
    PROCEDURE pr_activar_log_archivo IS
    BEGIN
        log_archivo_activo := TRUE;
    END pr_activar_log_archivo;

    PROCEDURE pr_desactivar_log_archivo IS
    BEGIN
        log_archivo_activo := FALSE;
    END pr_desactivar_log_archivo;

    PROCEDURE pr_imprimir_log_archivo IS
    BEGIN
        IF log_archivo_activo THEN
            DBMS_OUTPUT.PUT_LINE('log_archivo_activo: TRUE');
        ELSE
            DBMS_OUTPUT.PUT_LINE('log_archivo_activo: FALSE');
        END IF;
    END pr_imprimir_log_archivo;

    FUNCTION fn_obtener_log_archivo RETURN BOOLEAN IS
    BEGIN
        RETURN log_archivo_activo;
    END fn_obtener_log_archivo;

    -- Procedimiento para insertar un log en la tabla LOGS
    PROCEDURE pr_insertar_log_tabla(
        p_evento IN VARCHAR2,
        p_momento IN VARCHAR2,
        p_accion IN VARCHAR2
    ) IS
    BEGIN
        -- Verifica si los logs y los logs de tabla están activados
        IF log_activo AND log_tabla_activo THEN
            -- Obtener el usuario actual y la fecha
            usuario_actual := SYS_CONTEXT('USERENV', 'SESSION_USER');
            fecha_actual := SYSTIMESTAMP;
            
            -- Insertar el log en la tabla
            INSERT INTO LOGS (FECHA_AUD, USUARIO_AUD, EVENTO_AUD, MOMENTO_AUD, ACCION_AUD)
            VALUES (fecha_actual, usuario_actual, p_evento, p_momento, p_accion);
        END IF;
    END pr_insertar_log_tabla;

     -- Implementación del procedimiento para insertar logs en archivo
    PROCEDURE pr_insertar_log_archivo(
        p_evento IN VARCHAR2,
        p_momento IN VARCHAR2,
        p_accion IN VARCHAR2,
        p_tabla IN VARCHAR2
    ) IS
        v_archivo UTL_FILE.FILE_TYPE;
        v_nombre_archivo VARCHAR2(100) := 'NaturantioquiaLogs.csv';
        v_directorio VARCHAR2(100) := 'NATURANTIOQUIALOGS';
        v_cabecera VARCHAR2(100) := 'FECHA,USUARIO,TABLA,EVENTO,MOMENTO,ACCIÓN';
        v_linea VARCHAR2(1000);
        v_existe_cabecera BOOLEAN := FALSE;
        v_primera_linea VARCHAR2(1000);
        MAL_EDITADO EXCEPTION;
    BEGIN
        -- Verificar si los logs están activados
        IF NOT log_activo OR NOT log_archivo_activo THEN
            RETURN;
        END IF;

        -- Obtener información del usuario y fecha actual
        usuario_actual := SYS_CONTEXT('USERENV', 'SESSION_USER');
        fecha_actual := SYSTIMESTAMP;

        -- Verificar la cabecera del archivo
        BEGIN
            v_archivo := UTL_FILE.FOPEN(v_directorio, v_nombre_archivo, 'R');
            UTL_FILE.GET_LINE(v_archivo, v_primera_linea);
            
            IF v_primera_linea <> v_cabecera THEN 
                RAISE MAL_EDITADO;
            ELSE
                v_existe_cabecera := TRUE;
            END IF;
            UTL_FILE.FCLOSE(v_archivo);
        EXCEPTION
            WHEN UTL_FILE.INVALID_PATH OR UTL_FILE.INVALID_OPERATION OR NO_DATA_FOUND THEN
                v_existe_cabecera := FALSE;
            WHEN MAL_EDITADO THEN 
                -- Corregir archivo con cabecera mal editada
                DECLARE
                    v_todas_lineas CLOB := EMPTY_CLOB();
                    v_line VARCHAR2(32767);
                BEGIN
                    -- Cerrar y reabrir el archivo
                    UTL_FILE.FCLOSE(v_archivo);
                    v_archivo := UTL_FILE.FOPEN(v_directorio, v_nombre_archivo, 'R');
                    
                    -- Leer todas las líneas válidas
                    BEGIN
                        LOOP
                            UTL_FILE.GET_LINE(v_archivo, v_line);
                            IF NOT REGEXP_LIKE(v_line, v_cabecera) THEN
                                v_todas_lineas := v_todas_lineas || v_line || CHR(10);
                            END IF;
                        END LOOP;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;
                    
                    -- Cerrar archivo de lectura
                    UTL_FILE.FCLOSE(v_archivo);
                    
                    -- Reescribir archivo con cabecera correcta
                    v_archivo := UTL_FILE.FOPEN(v_directorio, v_nombre_archivo, 'W');
                    UTL_FILE.PUT_LINE(v_archivo, v_cabecera);
                    UTL_FILE.PUT(v_archivo, v_todas_lineas);
                    UTL_FILE.FCLOSE(v_archivo);
                    
                    v_existe_cabecera := TRUE;
                END;
        END;

        -- Escribir el nuevo log
        v_archivo := UTL_FILE.FOPEN(v_directorio, v_nombre_archivo, 'A');
        
        -- Escribir cabecera si no existe
        IF NOT v_existe_cabecera THEN
            UTL_FILE.PUT_LINE(v_archivo, v_cabecera);
        END IF;

        -- Escribir línea de log
        v_linea := TO_CHAR(fecha_actual, 'YYYY-MM-DD HH24:MI:SS') || ',' ||
                   usuario_actual || ',' ||
                   p_tabla || ',' ||
                   p_evento || ',' ||
                   p_momento || ',' ||
                   p_accion;
        UTL_FILE.PUT_LINE(v_archivo, v_linea);
        UTL_FILE.FCLOSE(v_archivo);

    EXCEPTION
        WHEN OTHERS THEN
            IF UTL_FILE.IS_OPEN(v_archivo) THEN
                UTL_FILE.FCLOSE(v_archivo);
            END IF;
            -- Registrar error en archivo separado
            DECLARE
                v_error_file UTL_FILE.FILE_TYPE;
                v_error_msg VARCHAR2(1000);
            BEGIN
                v_error_file := UTL_FILE.FOPEN(v_directorio, 'error_log.txt', 'A');
                v_error_msg := TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' - Error: ' || SQLERRM;
                UTL_FILE.PUT_LINE(v_error_file, v_error_msg);
                UTL_FILE.FCLOSE(v_error_file);
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Error al registrar el error. Contactar con el encargado.');
            END;
            RAISE;
    END pr_insertar_log_archivo;

   

END pkg_manejo_logs;
/

prompt +-------------------------------------------------------------+
prompt |            Package  PKG_UTILIDADES   
prompt +-------------------------------------------------------------+

prompt --> Cabecera del paquete  pkg_utilidades

CREATE OR REPLACE PACKAGE pkg_utilidades AS
    FUNCTION fn_validar_documento(doc INTEGER) RETURN BOOLEAN;
    FUNCTION fn_validar_nombre(nombre VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_validar_apellido(apellido VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_validar_correo(correo VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_validar_contrasena(password VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_validar_fecha_nacimiento(fecha DATE) RETURN BOOLEAN;
    FUNCTION fn_validar_celular(celular VARCHAR2) RETURN BOOLEAN;  
    FUNCTION fn_validar_telefono(telefono INTEGER) RETURN BOOLEAN;
END pkg_utilidades;
/

prompt --> Cuerpo del paquete  pkg_utilidades

CREATE OR REPLACE PACKAGE BODY pkg_utilidades AS

    FUNCTION fn_validar_documento(doc INTEGER) RETURN BOOLEAN IS
        BEGIN
            RETURN LENGTH(doc) BETWEEN 7 AND 10 AND REGEXP_LIKE(doc, '^[0-9]+$');
        END fn_validar_documento;

    FUNCTION fn_validar_nombre(nombre VARCHAR2) RETURN BOOLEAN IS
        BEGIN
            RETURN nombre IS NOT NULL;
        END fn_validar_nombre;

    FUNCTION fn_validar_apellido(apellido VARCHAR2) RETURN BOOLEAN IS
        BEGIN
            IF apellido IS NULL THEN
                RETURN TRUE;
            ELSE
                RETURN LENGTH(apellido) <= 40 AND REGEXP_LIKE(apellido, '^[a-zA-Z ]+$');
            END IF;
        END fn_validar_apellido;

    FUNCTION fn_validar_correo(correo VARCHAR2) RETURN BOOLEAN IS
        BEGIN
            RETURN correo IS NOT NULL AND REGEXP_LIKE(correo, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');
        END fn_validar_correo;

    FUNCTION fn_validar_contrasena(password VARCHAR2) RETURN BOOLEAN IS
        BEGIN
            RETURN LENGTH(password) > 8 AND REGEXP_LIKE(password, '.*[A-Z]+.*[0-9]+.*');
        END fn_validar_contrasena;

    FUNCTION fn_validar_fecha_nacimiento(fecha DATE) RETURN BOOLEAN IS
        BEGIN
            RETURN fecha IS NOT NULL AND fecha BETWEEN (SYSDATE - 160*365) AND (SYSDATE - 14*365);
        END fn_validar_fecha_nacimiento;

    FUNCTION fn_validar_celular(celular VARCHAR2) RETURN BOOLEAN IS  
        BEGIN
            RETURN LENGTH(celular) = 10 AND REGEXP_LIKE(celular, '^[0-9]{10}$') AND SUBSTR(celular, 1, 1) = '3';
        END fn_validar_celular;

    FUNCTION fn_validar_telefono(telefono INTEGER) RETURN BOOLEAN IS
        BEGIN
            RETURN LENGTH(telefono) = 10 AND SUBSTR(telefono, 1, 2) = '60' AND REGEXP_LIKE(telefono, '^[0-9]+$');
        END fn_validar_telefono;

END pkg_utilidades;
/

prompt +-------------------------------------------------------------+
prompt |            Package  pkg_formularios   
prompt +-------------------------------------------------------------+

prompt --> Cabecera del paquete  pkg_formularios
CREATE OR REPLACE PACKAGE pkg_formularios AS
    -- Funciones y procedimientos
    FUNCTION fn_existe_nodo_principal RETURN BOOLEAN;
    FUNCTION fn_padre_es_modulo(p_id_padre INTEGER) RETURN BOOLEAN;
    FUNCTION fn_obtener_siguiente_orden(p_id_padre INTEGER) RETURN INTEGER;

    -- Procedimiento para almacenar datos de log antes de la actualización
    PROCEDURE pr_preparar_datos_log(p_accion VARCHAR2, p_accion_aud VARCHAR2);
    -- Procedimiento para registrar los logs después de la actualización
    PROCEDURE pr_registrar_log_update;
END pkg_formularios;
/

prompt --> Cuerpo del paquete  pkg_formularios

CREATE OR REPLACE PACKAGE BODY pkg_formularios AS
    v_accion VARCHAR2(1000);
    v_accion_aud VARCHAR2(1000);

    -- Verifica si existe un nodo principal
    FUNCTION fn_existe_nodo_principal RETURN BOOLEAN IS
        v_cantidad NUMBER(1);
    BEGIN
        SELECT COUNT(*)
        INTO v_cantidad
        FROM Formularios
        WHERE Nodo_Principal = 1;

        RETURN v_cantidad > 0;
    END fn_existe_nodo_principal;

    -- Verifica si el ID padre es un módulo
    FUNCTION fn_padre_es_modulo(p_id_padre INTEGER) RETURN BOOLEAN IS
        v_modulo NUMBER(1);
    BEGIN
        SELECT MODULO
        INTO v_modulo
        FROM Formularios
        WHERE ID_FORMULARIO = p_id_padre;

        RETURN v_modulo = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE; -- Si el ID padre no existe, retorna falso
    END fn_padre_es_modulo;

    -- Obtiene el siguiente valor de orden para un nodo hijo
    FUNCTION fn_obtener_siguiente_orden(p_id_padre INTEGER) RETURN INTEGER IS
        v_max_orden INTEGER;
    BEGIN
        SELECT COALESCE(MAX(ORDEN), 0)
        INTO v_max_orden
        FROM Formularios
        WHERE ID_PADRE = p_id_padre;

        RETURN v_max_orden + 2;
    END fn_obtener_siguiente_orden;

    -- Procedimiento para almacenar los datos de log antes de la actualización
    PROCEDURE pr_preparar_datos_log(p_accion VARCHAR2, p_accion_aud VARCHAR2) IS
    BEGIN
        v_accion := p_accion;
        v_accion_aud := p_accion_aud;
    END pr_preparar_datos_log;

    -- Procedimiento para registrar los logs después de la actualización
    PROCEDURE pr_registrar_log_update IS
    BEGIN
        -- Registrar log en la tabla
        pkg_manejo_logs.pr_insertar_log_tabla(
            p_evento  => 'UPDATE',
            p_momento => 'AFTER',
            p_accion  => v_accion_aud
        );

        -- Registrar log en el archivo CSV
        pkg_manejo_logs.pr_insertar_log_archivo(
            p_evento  => 'UPDATE',
            p_momento => 'AFTER',
            p_accion  => v_accion,
            p_tabla   => 'FORMULARIOS'
        );
    END pr_registrar_log_update;
END pkg_formularios;
/


prompt +-------------------------------------------------------------+
prompt |            Package  pkg_usuarios   
prompt +-------------------------------------------------------------+
prompt --> Cabecera del paquete pkg_usuarios
CREATE OR REPLACE PACKAGE pkg_usuarios AS
    -- Función para obtener todos los datos de usuarios con los nombres de las relaciones
    FUNCTION fn_obtener_usuarios RETURN SYS_REFCURSOR;
END pkg_usuarios;
/

prompt --> Cuerpo del paquete  pkg_usuarios
CREATE OR REPLACE PACKAGE BODY pkg_usuarios AS
    FUNCTION fn_obtener_usuarios RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT 
                u.DOCUMENTO_USUARIO,
                u.datos_usuario.nombre AS NOMBRE_USUARIO,
                u.PRIMER_APELLIDO_USUARIO,
                u.SEGUNDO_APELLIDO_USUARIO,
                u.PASSWORD_USUARIO,
                u.FECHA_NACIMIENTO_USUARIO,
                u.datos_usuario.telefono.fijo AS TELEFONO_FIJO,
                u.datos_usuario.telefono.movil AS CELULAR,
                u.datos_usuario.correo AS CORREO,
                td.tipo_documento.nombre AS TIPO_DOCUMENTO,
                eu.estado_usuario.nombre AS ESTADO_USUARIO,
                s.sexo.nombre AS SEXO,
                r.rol.nombre AS ROL
            FROM 
                USUARIOS u
            LEFT JOIN TIPOS_DOCUMENTOS td ON u.TIPO_DOCUMENTO = td.tipo_documento.id
            LEFT JOIN ESTADOS_USUARIOS eu ON u.ESTADO_USUARIO = eu.estado_usuario.id
            LEFT JOIN SEXOS s ON u.SEXO_USUARIO = s.sexo.id
            LEFT JOIN ROLES r ON u.ROL_USUARIO = r.rol.id;

        RETURN v_cursor;
    END fn_obtener_usuarios;
END pkg_usuarios;
/


------------------------------------------------>>>> PAQUETES SIN PROBRAR, PERO EN TEORIA FUNVIONAN


prompt +-------------------------------------------------------------+
prompt |            Package  paquete_pedidos  
prompt +-------------------------------------------------------------+

-- Paquete para manejar operaciones relacionadas con pedidos
CREATE OR REPLACE PACKAGE paquete_pedidos AS
  PROCEDURE imprimir_pedidos_prioritarios;
  PROCEDURE imprimir_pedidos_prioritarios_fecha_actual;
  PROCEDURE imprimir_pedidos_por_estado(p_estado_id IN NUMBER);
END paquete_pedidos;
/

CREATE OR REPLACE PACKAGE BODY paquete_pedidos AS

  PROCEDURE imprimir_pedidos_prioritarios AS
  BEGIN
      FOR pedido IN (
          SELECT P.ID_PEDIDOS, P.FECHA_CREACION, P.FECHA_ENTREGA, P.DESCUENTO, P.TOTAL,
                 PR.prioridad.nombre AS NOMBRE_PRIORIDADES
          FROM PEDIDOS P
          INNER JOIN PRIORIDADES PR ON P.PRIORIDAD = PR.prioridad.id
          ORDER BY PR.prioridad.id DESC
      ) LOOP
          DBMS_OUTPUT.PUT_LINE('ID Pedido: ' || pedido.ID_PEDIDOS ||
                               ', Fecha Creación: ' || pedido.FECHA_CREACION ||
                               ', Fecha Entrega: ' || pedido.FECHA_ENTREGA ||
                               ', Descuento: ' || pedido.DESCUENTO ||
                               ', Total: ' || pedido.TOTAL ||
                               ', Prioridad: ' || pedido.NOMBRE_PRIORIDADES);
      END LOOP;
  END imprimir_pedidos_prioritarios;


  PROCEDURE imprimir_pedidos_prioritarios_fecha_actual AS
  BEGIN
      FOR pedido IN (
          SELECT P.ID_PEDIDOS, P.FECHA_CREACION, P.FECHA_ENTREGA, P.DESCUENTO, P.TOTAL,
                 PR.prioridad.nombre AS NOMBRE_PRIORIDADES
          FROM PEDIDOS P
          INNER JOIN PRIORIDADES PR ON P.PRIORIDAD = PR.prioridad.id
          WHERE TRUNC(P.FECHA_CREACION) = TRUNC(SYSDATE)
          ORDER BY PR.prioridad.id DESC
      ) LOOP
          DBMS_OUTPUT.PUT_LINE('ID Pedido: ' || pedido.ID_PEDIDOS ||
                               ', Fecha Creación: ' || pedido.FECHA_CREACION ||
                               ', Fecha Entrega: ' || pedido.FECHA_ENTREGA ||
                               ', Descuento: ' || pedido.DESCUENTO ||
                               ', Total: ' || pedido.TOTAL ||
                               ', Prioridad: ' || pedido.NOMBRE_PRIORIDADES);
      END LOOP;
  END imprimir_pedidos_prioritarios_fecha_actual;


  PROCEDURE imprimir_pedidos_por_estado(p_estado_id IN NUMBER) AS
  BEGIN
      FOR pedido IN (
          SELECT P.ID_PEDIDOS, P.FECHA_CREACION, P.FECHA_ENTREGA, P.DESCUENTO, P.TOTAL,
                 PR.prioridad.nombre AS NOMBRE_PRIORIDADES,
                 S.seguimiento.nombre AS NOMBRE_SEGUIMIENTO
          FROM PEDIDOS P
          INNER JOIN PRIORIDADES PR ON P.PRIORIDAD = PR.prioridad.id
          INNER JOIN SEGUIMIENTOS S ON P.SEGUIMIENTO = S.seguimiento.id
          WHERE P.SEGUIMIENTO = p_estado_id
          ORDER BY P.FECHA_CREACION DESC
      ) LOOP
          DBMS_OUTPUT.PUT_LINE('ID Pedido: ' || pedido.ID_PEDIDOS ||
                               ', Fecha Creación: ' || pedido.FECHA_CREACION ||
                               ', Fecha Entrega: ' || pedido.FECHA_ENTREGA ||
                               ', Descuento: ' || pedido.DESCUENTO ||
                               ', Total: ' || pedido.TOTAL ||
                               ', Prioridad: ' || pedido.NOMBRE_PRIORIDADES ||
                               ', Estado: ' || pedido.NOMBRE_SEGUIMIENTO);
      END LOOP;
  END imprimir_pedidos_por_estado;

END paquete_pedidos;
/