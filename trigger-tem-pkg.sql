prompt +----------------------------------+
prompt |      Creación del directorio      |
prompt +----------------------------------+

CREATE OR REPLACE DIRECTORY NaturantioquiaLogs AS 'C:/Oracle';
prompt  -->  Directorio NaturantioquiaLogs creado correctamente.

prompt |      Activación Mensajería       |
SET SERVEROUTPUT ON;

prompt +----------------------------------+
prompt |      Creación de Triggers       |
prompt |       en la Base de Datos        |
prompt |          naturantioquia          |
prompt +----------------------------------+

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla ESTADOS_LABORATORIOS    
prompt +-------------------------------------------------------------+

--> Before
DROP SEQUENCE seq_estado_lab;
CREATE SEQUENCE seq_estado_lab START WITH 3 INCREMENT BY 1 NOCACHE;


CREATE OR REPLACE NONEDITIONABLE TRIGGER tg_estado_lab_before
BEFORE INSERT OR UPDATE OR DELETE
ON ESTADOS_LABORATORIOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_usuario VARCHAR2(100) := SYS_CONTEXT('USERENV', 'SESSION_USER');
BEGIN
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT seq_estado_lab.NEXTVAL INTO :NEW.estado_laboratorio.id FROM dual;
        v_accion := '1. estado_laboratorio.id: ' || :NEW.estado_laboratorio.id || ' | 2.estado_laboratorio.nombre: ' || :NEW.estado_laboratorio.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old 1. estado_laboratorio.id : ' || :OLD.estado_laboratorio.id || ' | 2.estado_laboratorio.nombre : ' || :OLD.estado_laboratorio.nombre || ' || New 1. estado_laboratorio.id: ' || :NEW.estado_laboratorio.id || ' | 2.estado_laboratorio.nombre : ' || :NEW.estado_laboratorio.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old 1.estado_laboratorio.id : ' || :OLD.estado_laboratorio.id || ' | 2.estado_laboratorio.nombre : ' || :OLD.estado_laboratorio.nombre ;
    END IF;

    -- Llamar al procedimiento para registrar el log
    US_NATURAANTIOQUIA.manejo_logs.registrar_log(
        p_evento => v_evento,
        p_momento => v_momento,
        p_accion => v_accion,
        p_usuario => v_usuario,
        p_tabla => 'ESTADOS_LABORATORIOS'
    );
END;
/


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla   IMAGENES_PRODUCTOS         
prompt +-------------------------------------------------------------+


DROP SEQUENCE seq_imagen_product;
CREATE SEQUENCE seq_imagen_product START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- BEFORE IMAGENES_PRODUCTOS
CREATE OR REPLACE TRIGGER tg_IMAGENES_PRODUCTOS_before
BEFORE INSERT OR UPDATE OR DELETE
ON IMAGENES_PRODUCTOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50) := 'IMAGENES_PRODUCTOS';
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT seq_imagen_product.NEXTVAL INTO :NEW.ID_PRODUCTO FROM dual;
        v_accion := '1. ID_PRODUCTO: ' || :NEW.ID_PRODUCTO || ' | 2.ID_IMAGEN: ' || :NEW.ID_IMAGEN || '| 3. NOMBRE_IMAGEN: |' || :NEW.NOMBRE_IMAGEN || '| 4.UBICACION_IMAGEN: | ' || :NEW.UBICACION_IMAGEN;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' || ', 1. ID_PRODUCTO: ' || :NEW.ID_PRODUCTO || ' , 2.ID_IMAGEN: ' || :NEW.ID_IMAGEN || ' , 3. NOMBRE_IMAGEN: |' || :NEW.NOMBRE_IMAGEN || ' , 4.UBICACION_IMAGEN: | ' || :NEW.UBICACION_IMAGEN;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old 1. ID_PRODUCTO: ' || :OLD.ID_PRODUCTO || ' | 2.ID_IMAGEN: ' || :OLD.ID_IMAGEN || '| 3. NOMBRE_IMAGEN: |' || :OLD.NOMBRE_IMAGEN || '| 4.UBICACION_IMAGEN: | ' || :OLD.UBICACION_IMAGEN || ' || New 1. ID_PRODUCTO: ' || :NEW.ID_PRODUCTO || ' | 2.ID_IMAGEN: ' || :NEW.ID_IMAGEN || '| 3. NOMBRE_IMAGEN: |' || :NEW.NOMBRE_IMAGEN || '| 4.UBICACION_IMAGEN: | ' || :NEW.UBICACION_IMAGEN;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' || ' OLD 1. ID_PRODUCTO: ' || :OLD.ID_PRODUCTO || ' , OLD 2.ID_IMAGEN: ' || :OLD.ID_IMAGEN || ' , OLD 3. NOMBRE_IMAGEN: |' || :OLD.NOMBRE_IMAGEN || ' , OLD 4.UBICACION_IMAGEN: | ' || :OLD.UBICACION_IMAGEN || ' , New  1. ID_PRODUCTO: ' || :NEW.ID_PRODUCTO || ' , New 2.ID_IMAGEN: ' || :NEW.ID_IMAGEN || ' , New 3. NOMBRE_IMAGEN: |' || :NEW.NOMBRE_IMAGEN || ' , New 4.UBICACION_IMAGEN: | ' || :NEW.UBICACION_IMAGEN;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old 1. ID_PRODUCTO: ' || :OLD.ID_PRODUCTO || ' | 2.ID_IMAGEN: ' || :OLD.ID_IMAGEN || '| 3. NOMBRE_IMAGEN: |' || :OLD.NOMBRE_IMAGEN || '| 4.UBICACION_IMAGEN: | ' || :OLD.UBICACION_IMAGEN;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' || ' OLD 1. ID_PRODUCTO: ' || :OLD.ID_PRODUCTO || ' , OLD 2.ID_IMAGEN: ' || :OLD.ID_IMAGEN || ' , OLD 3. NOMBRE_IMAGEN: |' || :OLD.NOMBRE_IMAGEN || ' , OLD 4.UBICACION_IMAGEN: | ' || :OLD.UBICACION_IMAGEN;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  => v_accion_aud
    );

    -- Llamar al procedimiento para insertar el log en el archivo CSV
    pkg_manejo_logs.pr_insertar_log_archivo(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  => v_accion,
        p_tabla   => v_tabla
    );

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Comuníquese con el responsable del área.');
        DBMS_OUTPUT.PUT_LINE('Código de error: ' || SQLCODE || ' - Mensaje: ' || SQLERRM);
END tg_IMAGENES_PRODUCTOS_before;
/

------IMAGENES_PRODUCTOS AFTER
CREATE OR REPLACE  TRIGGER tg_IMAGENES_PRODUCTOS_AFTER
AFTER INSERT OR UPDATE OR DELETE
ON IMAGENES_PRODUCTOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'IMAGENES_PRODUCTOS';
    
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. ID_PRODUCTO: ' || :NEW.ID_PRODUCTO || ' | 2.ID_IMAGEN: ' || :NEW.ID_IMAGEN || '| 3. NOMBRE_IMAGEN: |' || :NEW.NOMBRE_IMAGEN || '| 4.UBICACION_IMAGEN: | ' || :NEW.UBICACION_IMAGEN;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' || ', 1. ID_PRODUCTO: ' || :NEW.ID_PRODUCTO || ' , 2.ID_IMAGEN: ' || :NEW.ID_IMAGEN || ' , 3. NOMBRE_IMAGEN: |' || :NEW.NOMBRE_IMAGEN || ' , 4.UBICACION_IMAGEN: | ' || :NEW.UBICACION_IMAGEN;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old 1. ID_PRODUCTO: ' || :OLD.ID_PRODUCTO || ' | 2.ID_IMAGEN: ' || :OLD.ID_IMAGEN || '| 3. NOMBRE_IMAGEN: |' || :OLD.NOMBRE_IMAGEN || '| 4.UBICACION_IMAGEN: | ' || :OLD.UBICACION_IMAGEN || ' || New 1. ID_PRODUCTO: ' || :NEW.ID_PRODUCTO || ' | 2.ID_IMAGEN: ' || :NEW.ID_IMAGEN || '| 3. NOMBRE_IMAGEN: |' || :NEW.NOMBRE_IMAGEN || '| 4.UBICACION_IMAGEN: | ' || :NEW.UBICACION_IMAGEN;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' || ' OLD 1. ID_PRODUCTO: ' || :OLD.ID_PRODUCTO || ' , OLD 2.ID_IMAGEN: ' || :OLD.ID_IMAGEN || ' , OLD 3. NOMBRE_IMAGEN: |' || :OLD.NOMBRE_IMAGEN || ' , OLD 4.UBICACION_IMAGEN: | ' || :OLD.UBICACION_IMAGEN || ' , New  1. ID_PRODUCTO: ' || :NEW.ID_PRODUCTO || ' , New 2.ID_IMAGEN: ' || :NEW.ID_IMAGEN || ' , New 3. NOMBRE_IMAGEN: |' || :NEW.NOMBRE_IMAGEN || ' , New 4.UBICACION_IMAGEN: | ' || :NEW.UBICACION_IMAGEN;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old 1. ID_PRODUCTO: ' || :OLD.ID_PRODUCTO || ' | 2.ID_IMAGEN: ' || :OLD.ID_IMAGEN || '| 3. NOMBRE_IMAGEN: |' || :OLD.NOMBRE_IMAGEN || '| 4.UBICACION_IMAGEN: | ' || :OLD.UBICACION_IMAGEN;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' || ' OLD 1. ID_PRODUCTO: ' || :OLD.ID_PRODUCTO || ' , OLD 2.ID_IMAGEN: ' || :OLD.ID_IMAGEN || ' , OLD 3. NOMBRE_IMAGEN: |' || :OLD.NOMBRE_IMAGEN || ' , OLD 4.UBICACION_IMAGEN: | ' || :OLD.UBICACION_IMAGEN;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  => v_accion_aud
    );

    -- Llamar al procedimiento para insertar el log en el archivo CSV
    pkg_manejo_logs.pr_insertar_log_archivo(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  => v_accion,
        p_tabla   => v_tabla
    );

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Comuníquese con el responsable del área.');
        DBMS_OUTPUT.PUT_LINE('Código de error: ' || SQLCODE || ' - Mensaje: ' || SQLERRM);
END tg_IMAGENES_PRODUCTOS_AFTER;
/

