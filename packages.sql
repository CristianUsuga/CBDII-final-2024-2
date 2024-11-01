prompt +-------------------------------------------------------------+
prompt |            Package encabezado pkg_logs  
prompt +-------------------------------------------------------------+

CREATE OR REPLACE PACKAGE US_NATURAANTIOQUIA.manejo_logs AS
    PROCEDURE registrar_log(
        p_evento VARCHAR2,
        p_momento VARCHAR2,
        p_accion VARCHAR2,
        p_usuario VARCHAR2,
        p_tabla VARCHAR2
    );
    PROCEDURE verificar_cabecera(
        p_directorio VARCHAR2,
        p_nombre_archivo VARCHAR2
    );
END manejo_logs;
/


prompt +-------------------------------------------------------------+
prompt |            Package body pkg_logs  
prompt +-------------------------------------------------------------+

CREATE OR REPLACE PACKAGE BODY US_NATURAANTIOQUIA.manejo_logs AS

    -- Procedimiento para verificar la cabecera del archivo
    PROCEDURE verificar_cabecera(p_directorio VARCHAR2, p_nombre_archivo VARCHAR2) IS
        v_archivo UTL_FILE.FILE_TYPE;
        v_cabecera VARCHAR2(100) := 'FECHA,USUARIO,TABLA,EVENTO,MOMENTO,ACCIÓN';
        v_primera_linea VARCHAR2(1000);
        v_todas_lineas CLOB := EMPTY_CLOB();
        v_line VARCHAR2(32767);
        v_existe_cabecera BOOLEAN := FALSE;
        MAL_EDITADO EXCEPTION;
    BEGIN
        BEGIN
            v_archivo := UTL_FILE.FOPEN(p_directorio, p_nombre_archivo, 'R');
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
                UTL_FILE.FCLOSE(v_archivo);
                v_archivo := UTL_FILE.FOPEN(p_directorio, p_nombre_archivo, 'R');
                LOOP
                    UTL_FILE.GET_LINE(v_archivo, v_line);
                    IF NOT REGEXP_LIKE(v_line, v_cabecera) THEN
                        v_todas_lineas := v_todas_lineas || v_line || CHR(10);
                    END IF;
                END LOOP;
                UTL_FILE.FCLOSE(v_archivo);
                
                v_archivo := UTL_FILE.FOPEN(p_directorio, p_nombre_archivo, 'w');
                UTL_FILE.PUT_LINE(v_archivo, v_cabecera);
                UTL_FILE.PUT_LINE(v_archivo, v_todas_lineas);
                UTL_FILE.FCLOSE(v_archivo);
        END;
    END verificar_cabecera;

    -- Procedimiento para registrar logs
    PROCEDURE registrar_log(
        p_evento VARCHAR2,
        p_momento VARCHAR2,
        p_accion VARCHAR2,
        p_usuario VARCHAR2,
        p_tabla VARCHAR2
    ) IS
        v_fecha TIMESTAMP := SYSTIMESTAMP;
        v_archivo UTL_FILE.FILE_TYPE;
        v_nombre_archivo VARCHAR2(100) := 'NaturantioquiaLogs.csv';
        v_directorio VARCHAR2(100) := 'NATURANTIOQUIALOGS';
        v_linea VARCHAR2(1000);
    BEGIN
        -- Registrar log en tabla
        INSERT INTO "US_NATURAANTIOQUIA"."LOGS" (FECHA_AUD, USUARIO_AUD, EVENTO_AUD, MOMENTO_AUD, ACCION_AUD) 
        VALUES (v_fecha, p_usuario, p_evento, p_momento, p_accion);

        -- Verificar cabecera
        verificar_cabecera(v_directorio, v_nombre_archivo);

        -- Escribir log en archivo
        v_archivo := UTL_FILE.FOPEN(v_directorio, v_nombre_archivo, 'A');
        v_linea := TO_CHAR(v_fecha, 'YYYY-MM-DD HH24:MI:SS') || ',' ||
                   p_usuario || ',' ||
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
            -- Manejo de errores en un archivo de error separado
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
                    DBMS_OUTPUT.PUT_LINE('Error al escribir en el archivo de error.');
            END;
    END registrar_log;

END manejo_logs;
/



prompt +-------------------------------------------------------------+
prompt |            Package  paquete_validaciones  
prompt +-------------------------------------------------------------+
CREATE OR REPLACE PACKAGE paquete_validaciones AS
    FUNCTION validar_numero_documento(p_documento IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION validar_nombre_usuario(p_nombre_usuario IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION validar_primer_apellido(p_primer_apellido IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION validar_segundo_apellido(p_segundo_apellido IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION validar_correo_electronico(p_correo IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION validar_contrasena(p_contrasena IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION validar_fecha_nacimiento(p_fecha_nacimiento IN DATE) RETURN BOOLEAN;
    FUNCTION validar_celular(p_celular IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION validar_telefono(p_telefono IN VARCHAR2) RETURN BOOLEAN;
END paquete_validaciones;
/

CREATE OR REPLACE PACKAGE BODY paquete_validaciones AS
  FUNCTION validar_numero_documento(p_documento IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF LENGTH(p_documento) < 7 OR LENGTH(p_documento) > 10 OR NOT REGEXP_LIKE(p_documento, '^[0-9]+$') THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END validar_numero_documento;
  
  FUNCTION validar_nombre_usuario(p_nombre_usuario IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF p_nombre_usuario IS NULL THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END validar_nombre_usuario;
  
  FUNCTION validar_primer_apellido(p_primer_apellido IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF p_primer_apellido IS NULL THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END validar_primer_apellido;
  
  FUNCTION validar_segundo_apellido(p_segundo_apellido IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF p_segundo_apellido IS NOT NULL THEN
      IF LENGTH(p_segundo_apellido) > 40 OR NOT REGEXP_LIKE(p_segundo_apellido, '^[a-zA-Z ]+$') THEN
        RETURN FALSE;
      END IF;
    END IF;
    RETURN TRUE;
  END validar_segundo_apellido;
  
  FUNCTION validar_correo_electronico(p_correo IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF p_correo IS NULL OR NOT REGEXP_LIKE(p_correo, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END validar_correo_electronico;
  
  FUNCTION validar_contrasena(p_contrasena IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF LENGTH(p_contrasena) <= 8 OR NOT REGEXP_LIKE(p_contrasena, '.*[A-Z]+.*[0-9]+.*') THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END validar_contrasena;
  
  FUNCTION validar_fecha_nacimiento(p_fecha_nacimiento IN DATE) RETURN BOOLEAN IS
  BEGIN
    IF p_fecha_nacimiento IS NOT NULL THEN
      IF (p_fecha_nacimiento < (SYSDATE - 160*365) OR p_fecha_nacimiento > (SYSDATE - 14*365)) THEN
        RETURN FALSE;
      END IF;
    END IF;
    RETURN TRUE;
  END validar_fecha_nacimiento;
  
  FUNCTION validar_celular(p_celular IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF p_celular IS NOT NULL THEN
      IF LENGTH(p_celular) <> 10 OR SUBSTR(p_celular, 1, 1) <> '3' OR NOT REGEXP_LIKE(p_celular, '^[0-9]+$') THEN
        RETURN FALSE;
      END IF;
    END IF;
    RETURN TRUE;
  END validar_celular;
  
  FUNCTION validar_telefono(p_telefono IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF p_telefono IS NOT NULL THEN
      IF LENGTH(p_telefono) > 0 THEN
        IF LENGTH(p_telefono) <> 10 OR SUBSTR(p_telefono, 1, 2) <> '60' OR NOT REGEXP_LIKE(p_telefono, '^[0-9]+$') THEN
          RETURN FALSE;
        END IF;
      END IF;
    END IF;
    RETURN TRUE;
  END validar_telefono;
END paquete_validaciones;
/



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

