prompt +-------------------------------------------------------------+
prompt |            Package encabezado pkg_logs  
prompt +-------------------------------------------------------------+

CREATE OR REPLACE PACKAGE pkg_logs AS
    -- Variables globales para indicar cuándo están activos los logs
    g_logs_activados BOOLEAN := TRUE;

    -- Getters y setters para las variables globales
    PROCEDURE set_logs_activados(p_activados BOOLEAN);
    FUNCTION get_logs_activados RETURN BOOLEAN;

    -- Procedimientos para registrar en la tabla de logs
    PROCEDURE log_to_table(
        p_fecha      TIMESTAMP,
        p_usuario    VARCHAR2,
        p_evento     VARCHAR2,
        p_momento    VARCHAR2,
        p_accion_aud VARCHAR2
    );

    -- Procedimientos para registrar en el archivo de logs
    PROCEDURE log_to_file(
        p_fecha      TIMESTAMP,
        p_usuario    VARCHAR2,
        p_tabla      VARCHAR2,
        p_evento     VARCHAR2,
        p_momento    VARCHAR2,
        p_accion     VARCHAR2
    );
END pkg_logs;
/

prompt +-------------------------------------------------------------+
prompt |            Package body pkg_logs  
prompt +-------------------------------------------------------------+

CREATE OR REPLACE PACKAGE BODY pkg_logs AS

    -- Setter para g_logs_activados
    PROCEDURE set_logs_activados(p_activados BOOLEAN) IS
    BEGIN
        g_logs_activados := p_activados;
    END set_logs_activados;

    -- Getter para g_logs_activados
    FUNCTION get_logs_activados RETURN BOOLEAN IS
    BEGIN
        RETURN g_logs_activados;
    END get_logs_activados;

    -- Procedimiento para registrar en la tabla de logs
    PROCEDURE log_to_table(
        p_fecha      TIMESTAMP,
        p_usuario    VARCHAR2,
        p_evento     VARCHAR2,
        p_momento    VARCHAR2,
        p_accion_aud VARCHAR2
    ) IS
    BEGIN
        IF g_logs_activados THEN
            INSERT INTO "US_NATURAANTIOQUIA"."LOGS" 
            (FECHA_AUD, USUARIO_AUD, EVENTO_AUD, MOMENTO_AUD, ACCION_AUD)
            VALUES (p_fecha, p_usuario, p_evento, p_momento, p_accion_aud);
        END IF;
    END log_to_table;

    -- Procedimiento para registrar en el archivo de logs
    PROCEDURE log_to_file(
        p_fecha      TIMESTAMP,
        p_usuario    VARCHAR2,
        p_tabla      VARCHAR2,
        p_evento     VARCHAR2,
        p_momento    VARCHAR2,
        p_accion     VARCHAR2
    ) IS
        v_archivo         UTL_FILE.FILE_TYPE; -- Archivo para los logs
        v_linea           VARCHAR2(1000); -- Línea de log a escribir
        v_nombre_archivo  VARCHAR2(100) := 'NaturantioquiaLogs.csv'; -- Nombre del archivo de logs
        v_directorio      VARCHAR2(100) := 'NATURANTIOQUIALOGS'; -- Directorio del archivo de logs
        v_cabecera        VARCHAR2(100) := 'FECHA,USUARIO,TABLA,EVENTO,MOMENTO,ACCIÓN'; -- Cabecera del archivo
        v_primera_linea   VARCHAR2(1000); -- Primera línea del archivo
        v_existe_cabecera BOOLEAN := FALSE; -- Bandera para verificar cabecera
        MAL_EDITADO       EXCEPTION; -- Excepción para cabecera mal editada
    BEGIN
        IF g_logs_activados THEN
            -- Verifica y escribe la cabecera si es necesario
            BEGIN
                v_archivo := UTL_FILE.FOPEN(v_directorio, v_nombre_archivo, 'R');
                UTL_FILE.GET_LINE(v_archivo, v_primera_linea);
                IF v_primera_linea <> v_cabecera THEN
                    RAISE MAL_EDITADO;
                ELSIF v_primera_linea = v_cabecera THEN
                    v_existe_cabecera := TRUE;
                END IF;
                UTL_FILE.FCLOSE(v_archivo);
            EXCEPTION
                WHEN UTL_FILE.INVALID_PATH OR UTL_FILE.INVALID_OPERATION OR NO_DATA_FOUND THEN
                    v_existe_cabecera := FALSE;
                WHEN MAL_EDITADO THEN
                    -- Si la cabecera está mal editada, lanza un error
                    RAISE_APPLICATION_ERROR(-20001, 'Cabecera mal editada');
            END;

            -- Abre el archivo en modo append (agregar al final del archivo)
            v_archivo := UTL_FILE.FOPEN(v_directorio, v_nombre_archivo, 'A');
            IF NOT v_existe_cabecera THEN
                -- Escribe la cabecera si no existe
                UTL_FILE.PUT_LINE(v_archivo, v_cabecera);
            END IF;

            -- Crea la línea de log y la escribe en el archivo
            v_linea := TO_CHAR(p_fecha, 'YYYY-MM-DD HH24:MI:SS') || ',' ||
                       p_usuario || ',' || p_tabla || ',' || p_evento || ',' ||
                       p_momento || ',' || p_accion;
            UTL_FILE.PUT_LINE(v_archivo, v_linea);
            UTL_FILE.FCLOSE(v_archivo);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            -- Cierra el archivo en caso de error
            IF UTL_FILE.IS_OPEN(v_archivo) THEN
                UTL_FILE.FCLOSE(v_archivo);
            END IF;
            -- Registra el error en un archivo de log separado
            DECLARE
                v_error_file UTL_FILE.FILE_TYPE;
                v_error_msg  VARCHAR2(1000);
            BEGIN
                v_error_file := UTL_FILE.FOPEN(v_directorio, 'error_log.txt', 'A');
                v_error_msg := TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' - Error: ' || SQLERRM;
                UTL_FILE.PUT_LINE(v_error_file, v_error_msg);
                UTL_FILE.FCLOSE(v_error_file);
            EXCEPTION
                WHEN OTHERS THEN
                   DBMS_OUTPUT.PUT_LINE('Contactar con el encargado.');
            END;
            RAISE;
    END log_to_file;

END pkg_logs;
/

prompt +-------------------------------------------------------------+
prompt |            Package encabezado pkg_validaciones  
prompt +-------------------------------------------------------------+
CREATE OR REPLACE PACKAGE pkg_validaciones AS
    PROCEDURE validar_correo(p_correo IN VARCHAR2);
    PROCEDURE validar_telefono(p_telefono IN VARCHAR2);
    PROCEDURE validar_celular(p_celular IN VARCHAR2);

    -- Excepciones personalizadas
    ex_correo_invalido EXCEPTION;
    ex_telefono_invalido EXCEPTION;
    ex_celular_invalido EXCEPTION;
END pkg_validaciones;
/

CREATE OR REPLACE PACKAGE BODY pkg_validaciones AS

    -- Validar correo
    PROCEDURE validar_correo(p_correo IN VARCHAR2) IS
    BEGIN
        -- Depuración: Imprimir el valor del correo recibido
        DBMS_OUTPUT.PUT_LINE('Validando correo: ' || p_correo);
        
        IF p_correo IS NULL OR 
           NOT REGEXP_LIKE(p_correo, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
            -- Depuración: Imprimir mensaje si el correo es inválido
            DBMS_OUTPUT.PUT_LINE('Correo inválido: ' || p_correo);
            RAISE ex_correo_invalido;
        ELSE
            -- Depuración: Imprimir mensaje si el correo es válido
            DBMS_OUTPUT.PUT_LINE('Correo válido: ' || p_correo);
        END IF;
    EXCEPTION
        WHEN ex_correo_invalido THEN
            RAISE_APPLICATION_ERROR(-20015, 'El correo electrónico no es válido.');
    END validar_correo;



    -- Validar teléfono
    PROCEDURE validar_telefono(p_telefono IN VARCHAR2) IS
    BEGIN
        IF p_telefono IS NOT NULL THEN
            IF LENGTH(p_telefono) > 0 THEN
                IF LENGTH(p_telefono) <> 10 OR 
                   SUBSTR(p_telefono, 1, 2) <> '60' OR 
                   NOT REGEXP_LIKE(p_telefono, '^[0-9]+$') THEN
                    RAISE ex_telefono_invalido;
                END IF;
            END IF;
        END IF;
    EXCEPTION
        WHEN ex_telefono_invalido THEN
            RAISE_APPLICATION_ERROR(-20016, 'El número de teléfono no es válido.');
    END validar_telefono;

    -- Validar celular
    PROCEDURE validar_celular(p_celular IN VARCHAR2) IS
    BEGIN
        IF p_celular IS NOT NULL THEN
            IF LENGTH(p_celular) <> 10 OR 
               SUBSTR(p_celular, 1, 1) <> '3' OR 
               NOT REGEXP_LIKE(p_celular, '^[0-9]+$') THEN
                RAISE ex_celular_invalido;
            END IF;
        END IF;
    EXCEPTION
        WHEN ex_celular_invalido THEN
            RAISE_APPLICATION_ERROR(-20017, 'El número de celular no es válido.');
    END validar_celular;

END pkg_validaciones;
/


