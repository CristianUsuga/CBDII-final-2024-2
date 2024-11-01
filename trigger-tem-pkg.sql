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


