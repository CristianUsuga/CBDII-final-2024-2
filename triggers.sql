
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

CREATE OR REPLACE TRIGGER tg_estado_lab_before
BEFORE INSERT OR UPDATE OR DELETE
ON ESTADOS_LABORATORIOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla  VARCHAR2(50) := 'ESTADOS_LABORATORIOS';
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT seq_estado_lab.NEXTVAL INTO :NEW.estado_laboratorio.id FROM dual;
        v_accion := '1. estado_laboratorio.id: ' || :NEW.estado_laboratorio.id || ' | 2.estado_laboratorio.nombre: ' || :NEW.estado_laboratorio.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ', 1. estado_laboratorio.id: ' || :NEW.estado_laboratorio.id || || ' , 2.estado_laboratorio.nombre: ' || :NEW.estado_laboratorio.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old 1. estado_laboratorio.id : ' || :OLD.estado_laboratorio.id || ' | 2.estado_laboratorio.nombre : ' || :OLD.estado_laboratorio.nombre || ' || New 1. estado_laboratorio.id: ' || :NEW.estado_laboratorio.id || ' | 2.estado_laboratorio.nombre : ' || :NEW.estado_laboratorio.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. estado_laboratorio.id : ' || :OLD.estado_laboratorio.id || ' , 2.estado_laboratorio.nombre : ' || :OLD.estado_laboratorio.nombre || 
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old 1.estado_laboratorio.id : ' || :OLD.estado_laboratorio.id || ' | 2.estado_laboratorio.nombre : ' || :OLD.estado_laboratorio.nombre ;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  => v_accion
    );

    -- Llamar al procedimiento para insertar el log en el archivo CSV
    pkg_manejo_logs.pr_insertar_log_archivo(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  => v_accion,
        p_tabla   => v_tabla
    );

END tg_estado_lab_before;
/
