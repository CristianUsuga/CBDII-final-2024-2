
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
