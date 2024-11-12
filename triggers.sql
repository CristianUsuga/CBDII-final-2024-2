
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
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. estado_laboratorio.id: ' || :NEW.estado_laboratorio.id || ' , 2.estado_laboratorio.nombre: ' || :NEW.estado_laboratorio.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. estado_laboratorio.id : ' || :OLD.estado_laboratorio.id || ' | 2.estado_laboratorio.nombre : ' || :OLD.estado_laboratorio.nombre || ' || New 1. estado_laboratorio.id: ' || :NEW.estado_laboratorio.id || ' | 2.estado_laboratorio.nombre : ' || :NEW.estado_laboratorio.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. estado_laboratorio.id : ' || :OLD.estado_laboratorio.id || ' , Old 2.estado_laboratorio.nombre : ' || :OLD.estado_laboratorio.nombre || ' , New  1. estado_laboratorio.id: ' || :NEW.estado_laboratorio.id || ' , New 2.estado_laboratorio.nombre: ' || :NEW.estado_laboratorio.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. estado_laboratorio.id : ' || :OLD.estado_laboratorio.id || ' | 2.estado_laboratorio.nombre : ' || :OLD.estado_laboratorio.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. estado_laboratorio.id : ' || :OLD.estado_laboratorio.id || ' , Old 2.estado_laboratorio.nombre : ' || :OLD.estado_laboratorio.nombre;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_estado_lab_before;
/

----------------------------------------------------------------------------------------> AFTER <------------------------------------------------

CREATE OR REPLACE  TRIGGER tg_estado_lab_after
AFTER INSERT OR UPDATE OR DELETE
ON ESTADOS_LABORATORIOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla  VARCHAR2(50) := 'ESTADOS_LABORATORIOS';
    
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. estado_laboratorio.id: ' || :NEW.estado_laboratorio.id || ' | 2.estado_laboratorio.nombre: ' || :NEW.estado_laboratorio.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. estado_laboratorio.id: ' || :NEW.estado_laboratorio.id || ' , 2.estado_laboratorio.nombre: ' || :NEW.estado_laboratorio.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. estado_laboratorio.id : ' || :OLD.estado_laboratorio.id || ' | 2.estado_laboratorio.nombre : ' || :OLD.estado_laboratorio.nombre || ' || New 1. estado_laboratorio.id: ' || :NEW.estado_laboratorio.id || ' | 2.estado_laboratorio.nombre : ' || :NEW.estado_laboratorio.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. estado_laboratorio.id : ' || :OLD.estado_laboratorio.id || ' , Old 2.estado_laboratorio.nombre : ' || :OLD.estado_laboratorio.nombre || ' , New  1. estado_laboratorio.id: ' || :NEW.estado_laboratorio.id || ' , New 2.estado_laboratorio.nombre: ' || :NEW.estado_laboratorio.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. estado_laboratorio.id : ' || :OLD.estado_laboratorio.id || ' | 2.estado_laboratorio.nombre : ' || :OLD.estado_laboratorio.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. estado_laboratorio.id : ' || :OLD.estado_laboratorio.id || ' , Old 2.estado_laboratorio.nombre : ' || :OLD.estado_laboratorio.nombre;
    END IF;
    
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_estado_lab_after;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla TIPOS_MOVIMIENTOS    
prompt +-------------------------------------------------------------+

---Before TIPOS_MOVIMIENTOS

DROP SEQUENCE seq_id_t_movimiento;
CREATE SEQUENCE seq_id_t_movimiento START WITH 9 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE  TRIGGER tg_TIPOS_MOVIMIENTOS_before
BEFORE INSERT OR UPDATE OR DELETE
ON TIPOS_MOVIMIENTOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'TIPOS_MOVIMIENTOS';

BEGIN
     -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT seq_id_t_movimiento.NEXTVAL INTO :NEW.tipo_movimiento.id FROM dual;
        v_accion := '1. tipo_movimiento.id: ' || :NEW.tipo_movimiento.id || ' | 2.tipo_movimiento.nombre: ' || :NEW.tipo_movimiento.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. tipo_movimiento.id: ' || :NEW.tipo_movimiento.id || ' , 2.tipo_movimiento.nombre: ' || :NEW.tipo_movimiento.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. tipo_movimiento.id : ' || :OLD.tipo_movimiento.id || ' | 2.tipo_movimiento.nombre : ' || :OLD.tipo_movimiento.nombre || ' || New 1. tipo_movimiento.id: ' || :NEW.tipo_movimiento.id || ' | 2.tipo_movimiento.nombre : ' || :NEW.tipo_movimiento.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_movimiento.id : ' || :OLD.tipo_movimiento.id || ' , Old 2.tipo_movimiento.nombre : ' || :OLD.tipo_movimiento.nombre || ' , New  1. tipo_movimiento.id: ' || :NEW.tipo_movimiento.id || ' , New 2.tipo_movimiento.nombre: ' || :NEW.tipo_movimiento.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. tipo_movimiento.id : ' || :OLD.tipo_movimiento.id || ' | 2.tipo_movimiento.nombre : ' || :OLD.tipo_movimiento.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_movimiento.id : ' || :OLD.tipo_movimiento.id || ' , Old 2.tipo_movimiento.nombre : ' || :OLD.tipo_movimiento.nombre;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_TIPOS_MOVIMIENTOS_before;
/

-------------------------------------------------------------After TIPOS_MOVIMIENTOS

CREATE OR REPLACE  TRIGGER tg_TIPOS_MOVIMIENTOS_after
AFTER INSERT OR UPDATE OR DELETE
ON TIPOS_MOVIMIENTOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'TIPOS_MOVIMIENTOS';
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. tipo_movimiento.id: ' || :NEW.tipo_movimiento.id || ' | 2.tipo_movimiento.nombre: ' || :NEW.tipo_movimiento.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. tipo_movimiento.id: ' || :NEW.tipo_movimiento.id || ' , 2.tipo_movimiento.nombre: ' || :NEW.tipo_movimiento.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. tipo_movimiento.id : ' || :OLD.tipo_movimiento.id || ' | 2.tipo_movimiento.nombre : ' || :OLD.tipo_movimiento.nombre || ' || New 1. tipo_movimiento.id: ' || :NEW.tipo_movimiento.id || ' | 2.tipo_movimiento.nombre : ' || :NEW.tipo_movimiento.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_movimiento.id : ' || :OLD.tipo_movimiento.id || ' , Old 2.tipo_movimiento.nombre : ' || :OLD.tipo_movimiento.nombre || ' , New  1. tipo_movimiento.id: ' || :NEW.tipo_movimiento.id || ' , New 2.tipo_movimiento.nombre: ' || :NEW.tipo_movimiento.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. tipo_movimiento.id : ' || :OLD.tipo_movimiento.id || ' | 2.tipo_movimiento.nombre : ' || :OLD.tipo_movimiento.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_movimiento.id : ' || :OLD.tipo_movimiento.id || ' , Old 2.tipo_movimiento.nombre : ' || :OLD.tipo_movimiento.nombre;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_TIPOS_MOVIMIENTOS_after;
/


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla SEGUIMIENTOS           
prompt +-------------------------------------------------------------+

--BEFORE SEGUIMIENTOS
DROP SEQUENCE seq_id_seguimiento;
CREATE SEQUENCE seq_id_seguimiento START WITH 10 INCREMENT BY 1 NOCACHE;


--BEFORE SEGUIMIENTOS

CREATE OR REPLACE  TRIGGER tg_SEGUIMIENTOS_before
BEFORE INSERT OR UPDATE OR DELETE
ON SEGUIMIENTOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'SEGUIMIENTOS';
    
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT seq_id_seguimiento.NEXTVAL INTO :NEW.seguimiento.id FROM dual;
        v_accion := '1. seguimiento.id: ' || :NEW.seguimiento.id || ' | 2.seguimiento.nombre: ' || :NEW.seguimiento.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. seguimiento.id: ' || :NEW.seguimiento.id || ' , 2.seguimiento.nombre: ' || :NEW.seguimiento.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. seguimiento.id : ' || :OLD.seguimiento.id || ' | 2.seguimiento.nombre : ' || :OLD.seguimiento.nombre || ' || New 1. seguimiento.id: ' || :NEW.seguimiento.id || ' | 2.seguimiento.nombre : ' || :NEW.seguimiento.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. seguimiento.id : ' || :OLD.seguimiento.id || ' , Old 2.seguimiento.nombre : ' || :OLD.seguimiento.nombre || ' , New  1. seguimiento.id: ' || :NEW.seguimiento.id || ' , New 2.seguimiento.nombre: ' || :NEW.seguimiento.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. seguimiento.id : ' || :OLD.seguimiento.id || ' | 2.seguimiento.nombre : ' || :OLD.seguimiento.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. seguimiento.id : ' || :OLD.seguimiento.id || ' , Old 2.seguimiento.nombre : ' || :OLD.seguimiento.nombre;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_SEGUIMIENTOS_before;
/

--After seguimientos

CREATE OR REPLACE  TRIGGER tg_SEGUIMIENTOS_after
AFTER INSERT OR UPDATE OR DELETE
ON SEGUIMIENTOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'SEGUIMIENTOS';
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. seguimiento.id: ' || :NEW.seguimiento.id || ' | 2.seguimiento.nombre: ' || :NEW.seguimiento.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. seguimiento.id: ' || :NEW.seguimiento.id || ' , 2.seguimiento.nombre: ' || :NEW.seguimiento.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. seguimiento.id : ' || :OLD.seguimiento.id || ' | 2.seguimiento.nombre : ' || :OLD.seguimiento.nombre || ' || New 1. seguimiento.id: ' || :NEW.seguimiento.id || ' | 2.seguimiento.nombre : ' || :NEW.seguimiento.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. seguimiento.id : ' || :OLD.seguimiento.id || ' , Old 2.seguimiento.nombre : ' || :OLD.seguimiento.nombre || ' , New  1. seguimiento.id: ' || :NEW.seguimiento.id || ' , New 2.seguimiento.nombre: ' || :NEW.seguimiento.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. seguimiento.id : ' || :OLD.seguimiento.id || ' | 2.seguimiento.nombre : ' || :OLD.seguimiento.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. seguimiento.id : ' || :OLD.seguimiento.id || ' , Old 2.seguimiento.nombre : ' || :OLD.seguimiento.nombre;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_SEGUIMIENTOS_after;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla PRIORIDADES           
prompt +-------------------------------------------------------------+

DROP SEQUENCE seq_id_prioridad;
CREATE SEQUENCE seq_id_prioridad START WITH 5 INCREMENT BY 1 NOCACHE;

--Before PRIORIDADES

CREATE OR REPLACE  TRIGGER tg_PRIORIDADES_before
BEFORE INSERT OR UPDATE OR DELETE
ON PRIORIDADES
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'PRIORIDADES';
    
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT seq_id_prioridad.NEXTVAL INTO :NEW.prioridad.id FROM dual;
        v_accion := '1. prioridad.id: ' || :NEW.prioridad.id || ' | 2.prioridad.nombre: ' || :NEW.prioridad.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. prioridad.id: ' || :NEW.prioridad.id || ' , 2.prioridad.nombre: ' || :NEW.prioridad.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. prioridad.id : ' || :OLD.prioridad.id || ' | 2.prioridad.nombre : ' || :OLD.prioridad.nombre || ' || New 1. prioridad.id: ' || :NEW.prioridad.id || ' | 2.prioridad.nombre : ' || :NEW.prioridad.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. prioridad.id : ' || :OLD.prioridad.id || ' , Old 2.prioridad.nombre : ' || :OLD.prioridad.nombre || ' , New  1. prioridad.id: ' || :NEW.prioridad.id || ' , New 2.prioridad.nombre: ' || :NEW.prioridad.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. prioridad.id : ' || :OLD.prioridad.id || ' | 2.prioridad.nombre : ' || :OLD.prioridad.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. prioridad.id : ' || :OLD.prioridad.id || ' , Old 2.prioridad.nombre : ' || :OLD.prioridad.nombre;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_PRIORIDADES_before;
/

--After PRIORIDADES


CREATE OR REPLACE  TRIGGER tg_PRIORIDADES_after
AFTER INSERT OR UPDATE OR DELETE
ON PRIORIDADES
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'PRIORIDADES';
    
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. prioridad.id: ' || :NEW.prioridad.id || ' | 2.prioridad.nombre: ' || :NEW.prioridad.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. prioridad.id: ' || :NEW.prioridad.id || ' , 2.prioridad.nombre: ' || :NEW.prioridad.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. prioridad.id : ' || :OLD.prioridad.id || ' | 2.prioridad.nombre : ' || :OLD.prioridad.nombre || ' || New 1. prioridad.id: ' || :NEW.prioridad.id || ' | 2.prioridad.nombre : ' || :NEW.prioridad.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. prioridad.id : ' || :OLD.prioridad.id || ' , Old 2.prioridad.nombre : ' || :OLD.prioridad.nombre || ' , New  1. prioridad.id: ' || :NEW.prioridad.id || ' , New 2.prioridad.nombre: ' || :NEW.prioridad.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. prioridad.id : ' || :OLD.prioridad.id || ' | 2.prioridad.nombre : ' || :OLD.prioridad.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. prioridad.id : ' || :OLD.prioridad.id || ' , Old 2.prioridad.nombre : ' || :OLD.prioridad.nombre;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_PRIORIDADES_after;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla TIPOS_DESCUENTOS    
prompt +-------------------------------------------------------------+

DROP SEQUENCE seq_TIPO_DESCUENTO;
CREATE SEQUENCE seq_TIPO_DESCUENTO START WITH 4 INCREMENT BY 1 NOCACHE;

--Before TIPOS_DESCUENTOS

CREATE OR REPLACE  TRIGGER tg_TIPO_DESCUENTO_before
BEFORE INSERT OR UPDATE OR DELETE
ON TIPOS_DESCUENTOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'TIPOS_DESCUENTOS';
    
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT seq_TIPO_DESCUENTO.NEXTVAL INTO :NEW.tipo_descuento.id FROM dual;
        v_accion := '1. tipo_descuento.id: ' || :NEW.tipo_descuento.id || ' | 2.tipo_descuento.nombre: ' || :NEW.tipo_descuento.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. tipo_descuento.id: ' || :NEW.tipo_descuento.id || ' , 2.tipo_descuento.nombre: ' || :NEW.tipo_descuento.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. tipo_descuento.id : ' || :OLD.tipo_descuento.id || ' | 2.tipo_descuento.nombre : ' || :OLD.tipo_descuento.nombre || ' || New 1. tipo_descuento.id: ' || :NEW.tipo_descuento.id || ' | 2.tipo_descuento.nombre : ' || :NEW.tipo_descuento.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_descuento.id : ' || :OLD.tipo_descuento.id || ' , Old 2.tipo_descuento.nombre : ' || :OLD.tipo_descuento.nombre || ' , New  1. tipo_descuento.id: ' || :NEW.tipo_descuento.id || ' , New 2.tipo_descuento.nombre: ' || :NEW.tipo_descuento.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. tipo_descuento.id : ' || :OLD.tipo_descuento.id || ' | 2.tipo_descuento.nombre : ' || :OLD.tipo_descuento.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_descuento.id : ' || :OLD.tipo_descuento.id || ' , Old 2.tipo_descuento.nombre : ' || :OLD.tipo_descuento.nombre;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END;
/

--After TIPOS_DESCUENTOS


CREATE OR REPLACE  TRIGGER tg_TIPO_DESCUENTO_after
AFTER INSERT OR UPDATE OR DELETE
ON TIPOS_DESCUENTOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'TIPOS_DESCUENTOS';
    BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN 
        v_evento := 'INSERT';
        v_accion := '1. tipo_descuento.id: ' || :NEW.tipo_descuento.id || ' | 2.tipo_descuento.nombre: ' || :NEW.tipo_descuento.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. tipo_descuento.id: ' || :NEW.tipo_descuento.id || ' , 2.tipo_descuento.nombre: ' || :NEW.tipo_descuento.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. tipo_descuento.id : ' || :OLD.tipo_descuento.id || ' | 2.tipo_descuento.nombre : ' || :OLD.tipo_descuento.nombre || ' || New 1. tipo_descuento.id: ' || :NEW.tipo_descuento.id || ' | 2.tipo_descuento.nombre : ' || :NEW.tipo_descuento.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_descuento.id : ' || :OLD.tipo_descuento.id || ' , Old 2.tipo_descuento.nombre : ' || :OLD.tipo_descuento.nombre || ' , New  1. tipo_descuento.id: ' || :NEW.tipo_descuento.id || ' , New 2.tipo_descuento.nombre: ' || :NEW.tipo_descuento.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. tipo_descuento.id : ' || :OLD.tipo_descuento.id || ' | 2.tipo_descuento.nombre : ' || :OLD.tipo_descuento.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_descuento.id : ' || :OLD.tipo_descuento.id || ' , Old 2.tipo_descuento.nombre : ' || :OLD.tipo_descuento.nombre;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_TIPO_DESCUENTO_after;
/


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla TIPOS_VALORES    
prompt +-------------------------------------------------------------+
DROP SEQUENCE seq_TIPO_VALOR;
CREATE SEQUENCE seq_TIPO_VALOR START WITH 3 INCREMENT BY 1 NOCACHE;



--Before PRIORIDADES

CREATE OR REPLACE  TRIGGER tg_TIPOS_VALORES_before
BEFORE INSERT OR UPDATE OR DELETE
ON TIPOS_VALORES
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'TIPOS_VALORES';
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT seq_TIPO_VALOR.NEXTVAL INTO :NEW.tipo_valor.id FROM dual;
        v_accion := '1. tipo_valor.id: ' || :NEW.tipo_valor.id || ' | 2.tipo_valor.nombre: ' || :NEW.tipo_valor.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. tipo_valor.id: ' || :NEW.tipo_valor.id || ' , 2.tipo_valor.nombre: ' || :NEW.tipo_valor.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. tipo_valor.id : ' || :OLD.tipo_valor.id || ' | 2.tipo_valor.nombre : ' || :OLD.tipo_valor.nombre || ' || New 1. tipo_valor.id: ' || :NEW.tipo_valor.id || ' | 2.tipo_valor.nombre : ' || :NEW.tipo_valor.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_valor.id : ' || :OLD.tipo_valor.id || ' , Old 2.tipo_valor.nombre : ' || :OLD.tipo_valor.nombre || ' , New  1. tipo_valor.id: ' || :NEW.tipo_valor.id || ' , New 2.tipo_valor.nombre: ' || :NEW.tipo_valor.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. tipo_valor.id : ' || :OLD.tipo_valor.id || ' | 2.tipo_valor.nombre : ' || :OLD.tipo_valor.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_valor.id : ' || :OLD.tipo_valor.id || ' , Old 2.tipo_valor.nombre : ' || :OLD.tipo_valor.nombre;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_TIPOS_VALORES_before;
/


--After  TIPOS_VALORES

CREATE OR REPLACE  TRIGGER tg_TIPOS_VALORES_after
AFTER INSERT OR UPDATE OR DELETE
ON TIPOS_VALORES
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'TIPOS_VALORES';
    
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. tipo_valor.id: ' || :NEW.tipo_valor.id || ' | 2.tipo_valor.nombre: ' || :NEW.tipo_valor.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. tipo_valor.id: ' || :NEW.tipo_valor.id || ' , 2.tipo_valor.nombre: ' || :NEW.tipo_valor.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. tipo_valor.id : ' || :OLD.tipo_valor.id || ' | 2.tipo_valor.nombre : ' || :OLD.tipo_valor.nombre || ' || New 1. tipo_valor.id: ' || :NEW.tipo_valor.id || ' | 2.tipo_valor.nombre : ' || :NEW.tipo_valor.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_valor.id : ' || :OLD.tipo_valor.id || ' , Old 2.tipo_valor.nombre : ' || :OLD.tipo_valor.nombre || ' , New  1. tipo_valor.id: ' || :NEW.tipo_valor.id || ' , New 2.tipo_valor.nombre: ' || :NEW.tipo_valor.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. tipo_valor.id : ' || :OLD.tipo_valor.id || ' | 2.tipo_valor.nombre : ' || :OLD.tipo_valor.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_valor.id : ' || :OLD.tipo_valor.id || ' , Old 2.tipo_valor.nombre : ' || :OLD.tipo_valor.nombre;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_TIPOS_VALORES_after;
/


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  CATEGORIAS
prompt +-------------------------------------------------------------+
DROP SEQUENCE seq_categoria;
CREATE SEQUENCE seq_categoria START WITH 1 INCREMENT BY 1 NOCACHE;

--Before CATEGORIAS

CREATE OR REPLACE  TRIGGER tg_CATEGORIAS_before
BEFORE INSERT OR UPDATE OR DELETE
ON CATEGORIAS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'CATEGORIAS';
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT seq_categoria.NEXTVAL INTO :NEW.categoria.id FROM dual;
        v_accion := '1. categoria.id: ' || :NEW.categoria.id || ' | 2.categoria.nombre: ' || :NEW.categoria.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. categoria.id: ' || :NEW.categoria.id || ' , 2.categoria.nombre: ' || :NEW.categoria.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. categoria.id : ' || :OLD.categoria.id || ' | 2.categoria.nombre : ' || :OLD.categoria.nombre || ' || New 1. categoria.id: ' || :NEW.categoria.id || ' | 2.categoria.nombre : ' || :NEW.categoria.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. categoria.id : ' || :OLD.categoria.id || ' , Old 2.categoria.nombre : ' || :OLD.categoria.nombre || ' , New  1. categoria.id: ' || :NEW.categoria.id || ' , New 2.categoria.nombre: ' || :NEW.categoria.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. categoria.id : ' || :OLD.categoria.id || ' | 2.categoria.nombre : ' || :OLD.categoria.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. categoria.id : ' || :OLD.categoria.id || ' , Old 2.categoria.nombre : ' || :OLD.categoria.nombre;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_CATEGORIAS_before;
/

--After CATEGORIAS
CREATE OR REPLACE  TRIGGER tg_CATEGORIAS_after
AFTER INSERT OR UPDATE OR DELETE
ON CATEGORIAS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'CATEGORIAS';
BEGIN
        -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. categoria.id: ' || :NEW.categoria.id || ' | 2.categoria.nombre: ' || :NEW.categoria.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. categoria.id: ' || :NEW.categoria.id || ' , 2.categoria.nombre: ' || :NEW.categoria.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. categoria.id : ' || :OLD.categoria.id || ' | 2.categoria.nombre : ' || :OLD.categoria.nombre || ' || New 1. categoria.id: ' || :NEW.categoria.id || ' | 2.categoria.nombre : ' || :NEW.categoria.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. categoria.id : ' || :OLD.categoria.id || ' , Old 2.categoria.nombre : ' || :OLD.categoria.nombre || ' , New  1. categoria.id: ' || :NEW.categoria.id || ' , New 2.categoria.nombre: ' || :NEW.categoria.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. categoria.id : ' || :OLD.categoria.id || ' | 2.categoria.nombre : ' || :OLD.categoria.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. categoria.id : ' || :OLD.categoria.id || ' , Old 2.categoria.nombre : ' || :OLD.categoria.nombre;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_CATEGORIAS_after;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla TIPOS_TRANSPORTISTAS     
prompt +-------------------------------------------------------------+
DROP SEQUENCE seq_tipo_transportista;
CREATE SEQUENCE seq_tipo_transportista START WITH 3 INCREMENT BY 1 NOCACHE;

--Before TIPOS_TRANSPORTISTAS

CREATE OR REPLACE  TRIGGER tg_TIPOS_TRANSPORTISTAS_before
BEFORE INSERT OR UPDATE OR DELETE
ON TIPOS_TRANSPORTISTAS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'TIPOS_TRANSPORTISTAS';
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT seq_tipo_transportista.NEXTVAL INTO :NEW.tipo_transportista.id FROM dual;
        v_accion := '1. tipo_transportista.id: ' || :NEW.tipo_transportista.id || ' | 2.tipo_transportista.nombre: ' || :NEW.tipo_transportista.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. tipo_transportista.id: ' || :NEW.tipo_transportista.id || ' , 2.tipo_transportista.nombre: ' || :NEW.tipo_transportista.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. tipo_transportista.id : ' || :OLD.tipo_transportista.id || ' | 2.tipo_transportista.nombre : ' || :OLD.tipo_transportista.nombre || ' || New 1. tipo_transportista.id: ' || :NEW.tipo_transportista.id || ' | 2.tipo_transportista.nombre : ' || :NEW.tipo_transportista.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_transportista.id : ' || :OLD.tipo_transportista.id || ' , Old 2.tipo_transportista.nombre : ' || :OLD.tipo_transportista.nombre || ' , New  1. tipo_transportista.id: ' || :NEW.tipo_transportista.id || ' , New 2.tipo_transportista.nombre: ' || :NEW.tipo_transportista.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. tipo_transportista.id : ' || :OLD.tipo_transportista.id || ' | 2.tipo_transportista.nombre : ' || :OLD.tipo_transportista.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_transportista.id : ' || :OLD.tipo_transportista.id || ' , Old 2.tipo_transportista.nombre : ' || :OLD.tipo_transportista.nombre;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_TIPOS_TRANSPORTISTAS_before;
/

--After TIPOS_TRANSPORTISTAS
CREATE OR REPLACE  TRIGGER tg_TIPOS_TRANSPORTISTAS_after
AFTER INSERT OR UPDATE OR DELETE
ON TIPOS_TRANSPORTISTAS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'TIPOS_TRANSPORTISTAS';
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. tipo_transportista.id: ' || :NEW.tipo_transportista.id || ' | 2.tipo_transportista.nombre: ' || :NEW.tipo_transportista.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. tipo_transportista.id: ' || :NEW.tipo_transportista.id || ' , 2.tipo_transportista.nombre: ' || :NEW.tipo_transportista.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. tipo_transportista.id : ' || :OLD.tipo_transportista.id || ' | 2.tipo_transportista.nombre : ' || :OLD.tipo_transportista.nombre || ' || New 1. tipo_transportista.id: ' || :NEW.tipo_transportista.id || ' | 2.tipo_transportista.nombre : ' || :NEW.tipo_transportista.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_transportista.id : ' || :OLD.tipo_transportista.id || ' , Old 2.tipo_transportista.nombre : ' || :OLD.tipo_transportista.nombre || ' , New  1. tipo_transportista.id: ' || :NEW.tipo_transportista.id || ' , New 2.tipo_transportista.nombre: ' || :NEW.tipo_transportista.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. tipo_transportista.id : ' || :OLD.tipo_transportista.id || ' | 2.tipo_transportista.nombre : ' || :OLD.tipo_transportista.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_transportista.id : ' || :OLD.tipo_transportista.id || ' , Old 2.tipo_transportista.nombre : ' || :OLD.tipo_transportista.nombre;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_TIPOS_TRANSPORTISTAS_after;
/


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla SEXOS     
prompt +-------------------------------------------------------------+

DROP SEQUENCE seq_sexos;
CREATE SEQUENCE seq_sexos START WITH 3 INCREMENT BY 1 NOCACHE;

--Before SEXOS

CREATE OR REPLACE  TRIGGER tg_SEXOS_before
BEFORE INSERT OR UPDATE OR DELETE
ON SEXOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'SEXOS';
BEGIN
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT seq_sexos.NEXTVAL INTO :NEW.sexo.id FROM dual;
        v_accion := '1. sexo.id: ' || :NEW.sexo.id || ' | 2.sexo.nombre: ' || :NEW.sexo.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. sexo.id: ' || :NEW.sexo.id || ' , 2.sexo.nombre: ' || :NEW.sexo.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. sexo.id : ' || :OLD.sexo.id || ' | 2.sexo.nombre : ' || :OLD.sexo.nombre || ' || New 1. sexo.id: ' || :NEW.sexo.id || ' | 2.sexo.nombre : ' || :NEW.sexo.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. sexo.id : ' || :OLD.sexo.id || ' , Old 2.sexo.nombre : ' || :OLD.sexo.nombre || ' , New  1. sexo.id: ' || :NEW.sexo.id || ' , New 2.sexo.nombre: ' || :NEW.sexo.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. sexo.id : ' || :OLD.sexo.id || ' | 2.sexo.nombre : ' || :OLD.sexo.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. sexo.id : ' || :OLD.sexo.id || ' , Old 2.sexo.nombre : ' || :OLD.sexo.nombre;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_SEXOS_before;
/



--After SEXOS
CREATE OR REPLACE  TRIGGER tg_SEXOS_after
AFTER INSERT OR UPDATE OR DELETE
ON SEXOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'SEXOS';
    
BEGIN
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. sexo.id: ' || :NEW.sexo.id || ' | 2.sexo.nombre: ' || :NEW.sexo.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. sexo.id: ' || :NEW.sexo.id || ' , 2.sexo.nombre: ' || :NEW.sexo.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. sexo.id : ' || :OLD.sexo.id || ' | 2.sexo.nombre : ' || :OLD.sexo.nombre || ' || New 1. sexo.id: ' || :NEW.sexo.id || ' | 2.sexo.nombre : ' || :NEW.sexo.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. sexo.id : ' || :OLD.sexo.id || ' , Old 2.sexo.nombre : ' || :OLD.sexo.nombre || ' , New  1. sexo.id: ' || :NEW.sexo.id || ' , New 2.sexo.nombre: ' || :NEW.sexo.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. sexo.id : ' || :OLD.sexo.id || ' | 2.sexo.nombre : ' || :OLD.sexo.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. sexo.id : ' || :OLD.sexo.id || ' , Old 2.sexo.nombre : ' || :OLD.sexo.nombre;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_SEXOS_after;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla ESTADOS_USUARIOS           
prompt +-------------------------------------------------------------+

DROP SEQUENCE SEQ_ID_ESTADO_USUARIOS;

CREATE SEQUENCE SEQ_ID_ESTADO_USUARIOS START WITH 4 INCREMENT BY 1 NOCACHE NOCYCLE;

    

--Before ESTADOS_USUARIOS

CREATE OR REPLACE  TRIGGER tg_ESTADOS_USUARIOS_before
BEFORE INSERT OR UPDATE OR DELETE
ON ESTADOS_USUARIOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'ESTADOS_USUARIOS';
BEGIN
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT SEQ_ID_ESTADO_USUARIOS.NEXTVAL INTO :NEW.estado_usuario.id FROM dual;
        v_accion := '1. estado_usuario.id: ' || :NEW.estado_usuario.id || ' | 2.estado_usuario.nombre: ' || :NEW.estado_usuario.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. estado_usuario.id: ' || :NEW.estado_usuario.id || ' , 2.estado_usuario.nombre: ' || :NEW.estado_usuario.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. estado_usuario.id : ' || :OLD.estado_usuario.id || ' | 2.estado_usuario.nombre : ' || :OLD.estado_usuario.nombre || ' || New 1. estado_usuario.id: ' || :NEW.estado_usuario.id || ' | 2.estado_usuario.nombre : ' || :NEW.estado_usuario.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. estado_usuario.id : ' || :OLD.estado_usuario.id || ' , Old 2.estado_usuario.nombre : ' || :OLD.estado_usuario.nombre || ' , New  1. estado_usuario.id: ' || :NEW.estado_usuario.id || ' , New 2.estado_usuario.nombre: ' || :NEW.estado_usuario.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. estado_usuario.id : ' || :OLD.estado_usuario.id || ' | 2.estado_usuario.nombre : ' || :OLD.estado_usuario.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. estado_usuario.id : ' || :OLD.estado_usuario.id || ' , Old 2.estado_usuario.nombre : ' || :OLD.estado_usuario.nombre;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_ESTADOS_USUARIOS_before;
/

--After ESTADOS_USUARIOS
CREATE OR REPLACE  TRIGGER tg_ESTADOS_USUARIOS_after
AFTER INSERT OR UPDATE OR DELETE
ON ESTADOS_USUARIOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'ESTADOS_USUARIOS';
BEGIN
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. estado_usuario.id: ' || :NEW.estado_usuario.id || ' | 2.estado_usuario.nombre: ' || :NEW.estado_usuario.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. estado_usuario.id: ' || :NEW.estado_usuario.id || ' , 2.estado_usuario.nombre: ' || :NEW.estado_usuario.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. estado_usuario.id : ' || :OLD.estado_usuario.id || ' | 2.estado_usuario.nombre : ' || :OLD.estado_usuario.nombre || ' || New 1. estado_usuario.id: ' || :NEW.estado_usuario.id || ' | 2.estado_usuario.nombre : ' || :NEW.estado_usuario.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. estado_usuario.id : ' || :OLD.estado_usuario.id || ' , Old 2.estado_usuario.nombre : ' || :OLD.estado_usuario.nombre || ' , New  1. estado_usuario.id: ' || :NEW.estado_usuario.id || ' , New 2.estado_usuario.nombre: ' || :NEW.estado_usuario.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. estado_usuario.id : ' || :OLD.estado_usuario.id || ' | 2.estado_usuario.nombre : ' || :OLD.estado_usuario.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. estado_usuario.id : ' || :OLD.estado_usuario.id || ' , Old 2.estado_usuario.nombre : ' || :OLD.estado_usuario.nombre;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_ESTADOS_USUARIOS_after;
/


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla TIPOS_DOCUMENTOS           
prompt +-------------------------------------------------------------+

DROP SEQUENCE SEQ_TIPOS_DOCUMENTOS;

CREATE SEQUENCE SEQ_TIPOS_DOCUMENTOS START WITH 4 INCREMENT BY 1 NOCACHE NOCYCLE;


--Before TIPOS_DOCUMENTOS

CREATE OR REPLACE  TRIGGER tg_TIPOS_DOCUMENTOS_before
BEFORE INSERT OR UPDATE OR DELETE
ON TIPOS_DOCUMENTOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'TIPOS_DOCUMENTOS';
BEGIN
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT SEQ_TIPOS_DOCUMENTOS.NEXTVAL INTO :NEW.tipo_documento.id FROM dual;
        v_accion := '1. tipo_documento.id: ' || :NEW.tipo_documento.id || ' | 2.tipo_documento.nombre: ' || :NEW.tipo_documento.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. tipo_documento.id: ' || :NEW.tipo_documento.id || ' , 2.tipo_documento.nombre: ' || :NEW.tipo_documento.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. tipo_documento.id : ' || :OLD.tipo_documento.id || ' | 2.tipo_documento.nombre : ' || :OLD.tipo_documento.nombre || ' || New 1. tipo_documento.id: ' || :NEW.tipo_documento.id || ' | 2.tipo_documento.nombre : ' || :NEW.tipo_documento.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_documento.id : ' || :OLD.tipo_documento.id || ' , Old 2.tipo_documento.nombre : ' || :OLD.tipo_documento.nombre || ' , New  1. tipo_documento.id: ' || :NEW.tipo_documento.id || ' , New 2.tipo_documento.nombre: ' || :NEW.tipo_documento.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. tipo_documento.id : ' || :OLD.tipo_documento.id || ' | 2.tipo_documento.nombre : ' || :OLD.tipo_documento.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_documento.id : ' || :OLD.tipo_documento.id || ' , Old 2.tipo_documento.nombre : ' || :OLD.tipo_documento.nombre;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_TIPOS_DOCUMENTOS_before;
/

--After TIPOS_DOCUMENTOS
CREATE OR REPLACE  TRIGGER tg_TIPOS_DOCUMENTOS_after
AFTER INSERT OR UPDATE OR DELETE
ON TIPOS_DOCUMENTOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'TIPOS_DOCUMENTOS';
BEGIN
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. tipo_documento.id: ' || :NEW.tipo_documento.id || ' | 2.tipo_documento.nombre: ' || :NEW.tipo_documento.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. tipo_documento.id: ' || :NEW.tipo_documento.id || ' , 2.tipo_documento.nombre: ' || :NEW.tipo_documento.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. tipo_documento.id : ' || :OLD.tipo_documento.id || ' | 2.tipo_documento.nombre : ' || :OLD.tipo_documento.nombre || ' || New 1. tipo_documento.id: ' || :NEW.tipo_documento.id || ' | 2.tipo_documento.nombre : ' || :NEW.tipo_documento.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_documento.id : ' || :OLD.tipo_documento.id || ' , Old 2.tipo_documento.nombre : ' || :OLD.tipo_documento.nombre || ' , New  1. tipo_documento.id: ' || :NEW.tipo_documento.id || ' , New 2.tipo_documento.nombre: ' || :NEW.tipo_documento.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. tipo_documento.id : ' || :OLD.tipo_documento.id || ' | 2.tipo_documento.nombre : ' || :OLD.tipo_documento.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. tipo_documento.id : ' || :OLD.tipo_documento.id || ' , Old 2.tipo_documento.nombre : ' || :OLD.tipo_documento.nombre;
    END IF;
        -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_TIPOS_DOCUMENTOS_after;
/


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla roles           
prompt +-------------------------------------------------------------+
DROP SEQUENCE seq_roles;
CREATE SEQUENCE seq_roles START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

--Before ROLES

CREATE OR REPLACE  TRIGGER tg_ROLES_before
BEFORE INSERT OR UPDATE OR DELETE
ON ROLES
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'ROLES';
BEGIN
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT seq_roles.NEXTVAL INTO :NEW.rol.id FROM dual;
        v_accion := '1. rol.id: ' || :NEW.rol.id || ' | 2.rol.nombre: ' || :NEW.rol.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. rol.id: ' || :NEW.rol.id || ' , 2.rol.nombre: ' || :NEW.rol.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. rol.id : ' || :OLD.rol.id || ' | 2.rol.nombre : ' || :OLD.rol.nombre || ' || New 1. rol.id: ' || :NEW.rol.id || ' | 2.rol.nombre : ' || :NEW.rol.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. rol.id : ' || :OLD.rol.id || ' , Old 2.rol.nombre : ' || :OLD.rol.nombre || ' , New  1. rol.id: ' || :NEW.rol.id || ' , New 2.rol.nombre: ' || :NEW.rol.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. rol.id : ' || :OLD.rol.id || ' | 2.rol.nombre : ' || :OLD.rol.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. rol.id : ' || :OLD.rol.id || ' , Old 2.rol.nombre : ' || :OLD.rol.nombre;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_ROLES_before;
/



--After ROLES
CREATE OR REPLACE  TRIGGER tg_ROLES_after
AFTER INSERT OR UPDATE OR DELETE
ON ROLES
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'ROLES';
BEGIN
    -- Determina el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. rol.id: ' || :NEW.rol.id || ' | 2.rol.nombre: ' || :NEW.rol.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. rol.id: ' || :NEW.rol.id || ' , 2.rol.nombre: ' || :NEW.rol.nombre;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. rol.id : ' || :OLD.rol.id || ' | 2.rol.nombre : ' || :OLD.rol.nombre || ' || New 1. rol.id: ' || :NEW.rol.id || ' | 2.rol.nombre : ' || :NEW.rol.nombre;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. rol.id : ' || :OLD.rol.id || ' , Old 2.rol.nombre : ' || :OLD.rol.nombre || ' , New  1. rol.id: ' || :NEW.rol.id || ' , New 2.rol.nombre: ' || :NEW.rol.nombre;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. rol.id : ' || :OLD.rol.id || ' | 2.rol.nombre : ' || :OLD.rol.nombre ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. rol.id : ' || :OLD.rol.id || ' , Old 2.rol.nombre : ' || :OLD.rol.nombre;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_ROLES_after;
/


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  DEPARTAMENTOS          
prompt +-------------------------------------------------------------+
DROP SEQUENCE seq_departamento;
CREATE SEQUENCE seq_departamento START WITH 1 INCREMENT BY 1  NOCACHE NOCYCLE;

--Before DEPARTAMENTOS

CREATE OR REPLACE  TRIGGER tg_NOMBRE_DEPARTAMENTOES_before
BEFORE INSERT OR UPDATE OR DELETE
ON DEPARTAMENTOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'DEPARTAMENTOS';
BEGIN
    -- Determina el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT seq_departamento.NEXTVAL INTO :new.id_departamento FROM dual;
        v_accion := '1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' | 2.NOMBRE_DEPARTAMENTO : ' || :NEW.NOMBRE_DEPARTAMENTO;
        --Preparar acción tabla log
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' || ' , New 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' , New 2.NOMBRE_DEPARTAMENTO: ' || :NEW.NOMBRE_DEPARTAMENTO ;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' || '1.ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' | 2.NOMBRE_DEPARTAMENTO: ' || :OLD.NOMBRE_DEPARTAMENTO|| ' ||New 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' | 2.NOMBRE_DEPARTAMENTO : ' || :NEW.NOMBRE_DEPARTAMENTO;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => '  || ' ,Old 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' , Old 2.NOMBRE_DEPARTAMENTO : ' || :OLD.NOMBRE_DEPARTAMENTO || ' , New 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' , New 2.NOMBRE_DEPARTAMENTO_NEW: ' || :NEW.NOMBRE_DEPARTAMENTO;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' || '1.ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' | 2.NOMBRE_DEPARTAMENTO: ' || :OLD.NOMBRE_DEPARTAMENTO ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => '  || ' ,Old 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' , Old 2.NOMBRE_DEPARTAMENTO : ' || :OLD.NOMBRE_DEPARTAMENTO;

    END IF;
    
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_NOMBRE_DEPARTAMENTOES_before;
/

--After DEPARTAMENTOS
CREATE OR REPLACE  TRIGGER tg_DEPARTAMENTOS_after
AFTER INSERT OR UPDATE OR DELETE
ON DEPARTAMENTOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'DEPARTAMENTOS';
BEGIN
    -- Determina el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' | 2.NOMBRE_DEPARTAMENTO : ' || :NEW.NOMBRE_DEPARTAMENTO;
        --Preparar acción tabla log
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' || ' , New 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' , New 2.NOMBRE_DEPARTAMENTO: ' || :NEW.NOMBRE_DEPARTAMENTO ;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' || '1.ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' | 2.NOMBRE_DEPARTAMENTO: ' || :OLD.NOMBRE_DEPARTAMENTO|| ' ||New 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' | 2.NOMBRE_DEPARTAMENTO : ' || :NEW.NOMBRE_DEPARTAMENTO;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => '  || ' ,Old 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' , Old 2.NOMBRE_DEPARTAMENTO : ' || :OLD.NOMBRE_DEPARTAMENTO || ' , New 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' , New 2.NOMBRE_DEPARTAMENTO_NEW: ' || :NEW.NOMBRE_DEPARTAMENTO;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' || '1.ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' | 2.NOMBRE_DEPARTAMENTO: ' || :OLD.NOMBRE_DEPARTAMENTO ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => '  || ' ,Old 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' , Old 2.NOMBRE_DEPARTAMENTO : ' || :OLD.NOMBRE_DEPARTAMENTO;

    END IF;
    
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_DEPARTAMENTOS_after;
/


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  CIUDADES          
prompt +-------------------------------------------------------------+

DROP SEQUENCE seq_ciudad;
CREATE SEQUENCE seq_ciudad START WITH 1 INCREMENT BY 1  NOCACHE NOCYCLE;


--Before CIUDADES

CREATE OR REPLACE  TRIGGER tg_NOMBRE_CIUDADES_before
BEFORE INSERT OR UPDATE OR DELETE
ON CIUDADES
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'CIUDADES';
BEGIN
    -- Determina el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT seq_ciudad.NEXTVAL INTO :new.id_ciudad FROM dual;
        v_accion := '1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' | 2.ID_CIUDAD: ' || :NEW.ID_CIUDAD || ' | 3.NOMBRE_CIUDAD: ' || :NEW.NOMBRE_CIUDAD;
        --Preparar acción tabla log
        v_accion_aud := 'TABLA: ' || v_tabla || ' => '  || ' , 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' , 2.ID_CIUDAD: ' || :NEW.ID_CIUDAD || ' ,  3.NOMBRE_CIUDAD: ' || :NEW.NOMBRE_CIUDAD;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'OLD 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' | 2.ID_CIUDAD : ' || :OLD.ID_CIUDAD || ' | 3.NOMBRE_CIUDAD: ' || :OLD.NOMBRE_CIUDAD || ' || New 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' | 2.ID_CIUDAD : ' || :NEW.ID_CIUDAD || ' | 3.NOMBRE_CIUDAD: ' || :NEW.NOMBRE_CIUDAD;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' || ', OLD 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' , OLD 2.ID_CIUDAD : '|| :OLD.ID_CIUDAD || ' , OLD 3.NOMBRE_CIUDAD: '  || :OLD.ID_CIUDAD || ' , NEW 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' , NEW 2.ID_CIUDAD_NEW: ' || :NEW.ID_CIUDAD || ' ,  NEW 3.NOMBRE_CIUDAD_NEW: ' || :NEW.NOMBRE_CIUDAD;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'OLD 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' | 2.ID_CIUDAD : ' || :OLD.ID_CIUDAD || ' | 3.NOMBRE_CIUDAD: ' || :OLD.NOMBRE_CIUDAD ;
       v_accion_aud := 'TABLA: ' || v_tabla || ' => '||' , OLD 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' , OLD 2.ID_CIUDAD : '|| :OLD.ID_CIUDAD || ' , OLD 3.NOMBRE_CIUDAD: '  || :OLD.ID_CIUDAD ;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END;
/


--After CIUDADES
CREATE OR REPLACE  TRIGGER tg_CIUDADES_after
AFTER INSERT OR UPDATE OR DELETE
ON CIUDADES
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'CIUDADES';

BEGIN
-- Determina el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' | 2.ID_CIUDAD: ' || :NEW.ID_CIUDAD || ' | 3.NOMBRE_CIUDAD: ' || :NEW.NOMBRE_CIUDAD;
        --Preparar acción tabla log
        v_accion_aud := 'TABLA: ' || v_tabla || ' => '  || ' , 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' , 2.ID_CIUDAD: ' || :NEW.ID_CIUDAD || ' ,  3.NOMBRE_CIUDAD: ' || :NEW.NOMBRE_CIUDAD;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'OLD 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' | 2.ID_CIUDAD : ' || :OLD.ID_CIUDAD || ' | 3.NOMBRE_CIUDAD: ' || :OLD.NOMBRE_CIUDAD || ' || New 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' | 2.ID_CIUDAD : ' || :NEW.ID_CIUDAD || ' | 3.NOMBRE_CIUDAD: ' || :NEW.NOMBRE_CIUDAD;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' || ', OLD 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' , OLD 2.ID_CIUDAD : '|| :OLD.ID_CIUDAD || ' , OLD 3.NOMBRE_CIUDAD: '  || :OLD.ID_CIUDAD || ' , NEW 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' , NEW 2.ID_CIUDAD_NEW: ' || :NEW.ID_CIUDAD || ' ,  NEW 3.NOMBRE_CIUDAD_NEW: ' || :NEW.NOMBRE_CIUDAD;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'OLD 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' | 2.ID_CIUDAD : ' || :OLD.ID_CIUDAD || ' | 3.NOMBRE_CIUDAD: ' || :OLD.NOMBRE_CIUDAD ;
       v_accion_aud := 'TABLA: ' || v_tabla || ' => '||' , OLD 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' , OLD 2.ID_CIUDAD : '|| :OLD.ID_CIUDAD || ' , OLD 3.NOMBRE_CIUDAD: '  || :OLD.ID_CIUDAD ;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_CIUDADES_after;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla   BARRIOS         
prompt +-------------------------------------------------------------+

DROP SEQUENCE seq_barrio;
CREATE SEQUENCE seq_barrio START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


--Before BARRIOS

CREATE OR REPLACE  TRIGGER tg_NOMBRE_BARRIOS_before
BEFORE INSERT OR UPDATE OR DELETE
ON BARRIOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'BARRIOS';

BEGIN
    -- Determina el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT seq_barrio.NEXTVAL INTO :new.id_barrio FROM dual;
        v_accion := '1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' | 2.ID_CIUDAD: ' || :NEW.ID_CIUDAD || ' | 3.ID_BARRIO: ' || :NEW.ID_BARRIO || ' | 4.NOMBRE_BARRIO: ' || :NEW.NOMBRE_BARRIO;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => '||' , NEW 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' , NEW 2.ID_CIUDAD: ' || :NEW.ID_CIUDAD || ' , NEW  3.ID_BARRIO: '  || :NEW.ID_BARRIO || ' , NEW 4.NOMBRE_BARRIO: ' || :NEW.NOMBRE_BARRIO;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'OLD 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' | 2.ID_CIUDAD : ' || :OLD.ID_CIUDAD || ' | 3.ID_BARRIO: ' || :OLD.ID_BARRIO || ' | 4.NOMBRE_BARRIO: ' || :OLD.NOMBRE_BARRIO || ' || NEW 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' | 2.ID_CIUDAD : ' || :NEW.ID_CIUDAD || ' | 3.ID_BARRIO: ' || :NEW.ID_BARRIO || ' | 4.NOMBRE_BARRIO: ' || :NEW.NOMBRE_BARRIO;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' , NEW 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' , NEW 2.ID_CIUDAD: ' || :NEW.ID_CIUDAD || ' , NEW  3.ID_BARRIO: '  || :NEW.ID_BARRIO || ' , NEW 4.NOMBRE_BARRIO: ' || :NEW.NOMBRE_BARRIO  || ',  4.NOMBRE_BARRIO_OLD: '  || :OLD.NOMBRE_BARRIO || ' , NEW 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' , NEW 2.ID_CIUDAD: ' || :NEW.ID_CIUDAD || ' , NEW 3.ID_BARRIO: ' || :NEW.ID_BARRIO || ' , NEW 4.NOMBRE_BARRIO: '  || :NEW.NOMBRE_BARRIO;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
         v_accion := ' OLD 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' | 2.ID_CIUDAD : ' || :OLD.ID_CIUDAD || ' | 3.ID_BARRIO: ' || :OLD.ID_BARRIO || ' | 4.NOMBRE_BARRIO: ' || :OLD.NOMBRE_BARRIO ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => '|| ' , OLD 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' , OLD 2.ID_CIUDAD : '|| :OLD.ID_CIUDAD || ' , OLD  3.ID_BARRIO: '  || :OLD.ID_BARRIO || ' , OLD 4.NOMBRE_BARRIO: '  || :OLD.NOMBRE_BARRIO ;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_NOMBRE_BARRIOS_before;
/



--After BARRIOS
CREATE OR REPLACE  TRIGGER tg_BARRIOS_after
AFTER INSERT OR UPDATE OR DELETE
ON BARRIOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'BARRIOS';
BEGIN
        -- Determina el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' | 2.ID_CIUDAD: ' || :NEW.ID_CIUDAD || ' | 3.ID_BARRIO: ' || :NEW.ID_BARRIO || ' | 4.NOMBRE_BARRIO: ' || :NEW.NOMBRE_BARRIO;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => '||' , NEW 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' , NEW 2.ID_CIUDAD: ' || :NEW.ID_CIUDAD || ' , NEW  3.ID_BARRIO: '  || :NEW.ID_BARRIO || ' , NEW 4.NOMBRE_BARRIO: ' || :NEW.NOMBRE_BARRIO;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'OLD 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' | 2.ID_CIUDAD : ' || :OLD.ID_CIUDAD || ' | 3.ID_BARRIO: ' || :OLD.ID_BARRIO || ' | 4.NOMBRE_BARRIO: ' || :OLD.NOMBRE_BARRIO || ' || NEW 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' | 2.ID_CIUDAD : ' || :NEW.ID_CIUDAD || ' | 3.ID_BARRIO: ' || :NEW.ID_BARRIO || ' | 4.NOMBRE_BARRIO: ' || :NEW.NOMBRE_BARRIO;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' , NEW 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' , NEW 2.ID_CIUDAD: ' || :NEW.ID_CIUDAD || ' , NEW  3.ID_BARRIO: '  || :NEW.ID_BARRIO || ' , NEW 4.NOMBRE_BARRIO: ' || :NEW.NOMBRE_BARRIO  || ',  4.NOMBRE_BARRIO_OLD: '  || :OLD.NOMBRE_BARRIO || ' , NEW 1. ID_DEPARTAMENTO: ' || :NEW.ID_DEPARTAMENTO || ' , NEW 2.ID_CIUDAD: ' || :NEW.ID_CIUDAD || ' , NEW 3.ID_BARRIO: ' || :NEW.ID_BARRIO || ' , NEW 4.NOMBRE_BARRIO: '  || :NEW.NOMBRE_BARRIO;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
         v_accion := ' OLD 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' | 2.ID_CIUDAD : ' || :OLD.ID_CIUDAD || ' | 3.ID_BARRIO: ' || :OLD.ID_BARRIO || ' | 4.NOMBRE_BARRIO: ' || :OLD.NOMBRE_BARRIO ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => '|| ' , OLD 1. ID_DEPARTAMENTO : ' || :OLD.ID_DEPARTAMENTO || ' , OLD 2.ID_CIUDAD : '|| :OLD.ID_CIUDAD || ' , OLD  3.ID_BARRIO: '  || :OLD.ID_BARRIO || ' , OLD 4.NOMBRE_BARRIO: '  || :OLD.NOMBRE_BARRIO ;
    END IF;
    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END;
/


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla   DIRECCIONES         
prompt +-------------------------------------------------------------+

DROP SEQUENCE seq_direccion;
CREATE SEQUENCE seq_direccion START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

--Before BARRIOS

CREATE OR REPLACE  TRIGGER tg_DIRECCIONES_before
BEFORE INSERT OR UPDATE OR DELETE
ON DIRECCIONES
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'DIRECCIONES';

BEGIN
    -- Determina el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        SELECT seq_direccion.NEXTVAL INTO :new.id_direccion FROM dual;
        v_accion := '1. ID_DIRECCION: ' || :NEW.ID_DIRECCION || ' | 2.DESCRIPCION_DIRECCION: ' || :NEW.DESCRIPCION_DIRECCION || ' | 3.DEPARTAMENTO: ' || :NEW.DEPARTAMENTO || ' | 4.CIUDAD: ' || :NEW.CIUDAD || ' | 5.BARRIO: ' || :NEW.BARRIO;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => '|| ' , NEW 1. ID_DIRECCION: ' || :NEW.ID_DIRECCION || ' , NEW 2.DESCRIPCION_DIRECCION: ' || :NEW.DESCRIPCION_DIRECCION || ' , NEW 3.DEPARTAMENTO: ' || :NEW.DEPARTAMENTO || ' , NEW 4.CIUDAD: '  || :NEW.CIUDAD || ' , NEW 5.BARRIO: '  || :NEW.BARRIO;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'OLD 1. ID_DIRECCION : ' || :OLD.ID_DIRECCION || ' | OLD 2.DESCRIPCION_DIRECCION : ' || :OLD.DESCRIPCION_DIRECCION || ' | OLD 3.DEPARTAMENTO: ' || :OLD.DEPARTAMENTO || ' | OLD 4.CIUDAD: ' || :OLD.CIUDAD || ' | OLD 5.BARRIO: ' || :OLD.BARRIO || ' || NEW 1. ID_DIRECCION: ' || :NEW.ID_DIRECCION || ' |  2.DESCRIPCION_DIRECCION : ' || :NEW.DESCRIPCION_DIRECCION || ' |  3.DEPARTAMENTO: ' || :NEW.DEPARTAMENTO || ' |  4.CIUDAD: ' || :NEW.CIUDAD || ' |  5.BARRIO: ' || :NEW.BARRIO;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => '||' , OLD 1. ID_DIRECCION : ' || :OLD.ID_DIRECCION || ' , OLD 2.DESCRIPCION_DIRECCION : '|| :OLD.DESCRIPCION_DIRECCION || ' , OLD 3.DEPARTAMENTO: '  || :OLD.DEPARTAMENTO || ' ,  4.CIUDAD_OLD: '  || :OLD.CIUDAD|| ' ,  5.BARRIO_OLD: '  || :OLD.BARRIO|| ' , NEW 1. ID_DIRECCION: ' || :NEW.ID_DIRECCION || ' , NEW 2.DESCRIPCION_DIRECCION: ' || :NEW.DESCRIPCION_DIRECCION || ' , NEW 3.DEPARTAMENTO: ' || :NEW.DEPARTAMENTO || ' , NEW 4.CIUDAD: '  || :NEW.CIUDAD || ' , NEW 5.BARRIO: '  || :NEW.BARRIO;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'OLD 1. ID_DIRECCION : ' || :OLD.ID_DIRECCION || ' | OLD 2.DESCRIPCION_DIRECCION : ' || :OLD.DESCRIPCION_DIRECCION || ' | OLD 3.DEPARTAMENTO: ' || :OLD.DEPARTAMENTO || ' | OLD 4.CIUDAD: ' || :OLD.CIUDAD || ' | OLD 5.BARRIO: ' ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => '||' , OLD 1. ID_DIRECCION : ' || :OLD.ID_DIRECCION || ' , OLD 2.DESCRIPCION_DIRECCION : '|| :OLD.DESCRIPCION_DIRECCION || ' , OLD 3.DEPARTAMENTO: '  || :OLD.DEPARTAMENTO || ' ,  4.CIUDAD_OLD: '  || :OLD.CIUDAD|| ' ,  5.BARRIO_OLD: '  || :OLD.BARRIO;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_DIRECCIONES_before;
/


--After DIRECCIONES
CREATE OR REPLACE  TRIGGER tg_DIRECCIONES_after
AFTER INSERT OR UPDATE OR DELETE
ON DIRECCIONES
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'DIRECCIONES';
BEGIN
        IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. ID_DIRECCION: ' || :NEW.ID_DIRECCION || ' | 2.DESCRIPCION_DIRECCION: ' || :NEW.DESCRIPCION_DIRECCION || ' | 3.DEPARTAMENTO: ' || :NEW.DEPARTAMENTO || ' | 4.CIUDAD: ' || :NEW.CIUDAD || ' | 5.BARRIO: ' || :NEW.BARRIO;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => '|| ' , NEW 1. ID_DIRECCION: ' || :NEW.ID_DIRECCION || ' , NEW 2.DESCRIPCION_DIRECCION: ' || :NEW.DESCRIPCION_DIRECCION || ' , NEW 3.DEPARTAMENTO: ' || :NEW.DEPARTAMENTO || ' , NEW 4.CIUDAD: '  || :NEW.CIUDAD || ' , NEW 5.BARRIO: '  || :NEW.BARRIO;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'OLD 1. ID_DIRECCION : ' || :OLD.ID_DIRECCION || ' | OLD 2.DESCRIPCION_DIRECCION : ' || :OLD.DESCRIPCION_DIRECCION || ' | OLD 3.DEPARTAMENTO: ' || :OLD.DEPARTAMENTO || ' | OLD 4.CIUDAD: ' || :OLD.CIUDAD || ' | OLD 5.BARRIO: ' || :OLD.BARRIO || ' || NEW 1. ID_DIRECCION: ' || :NEW.ID_DIRECCION || ' |  2.DESCRIPCION_DIRECCION : ' || :NEW.DESCRIPCION_DIRECCION || ' |  3.DEPARTAMENTO: ' || :NEW.DEPARTAMENTO || ' |  4.CIUDAD: ' || :NEW.CIUDAD || ' |  5.BARRIO: ' || :NEW.BARRIO;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => '||' , OLD 1. ID_DIRECCION : ' || :OLD.ID_DIRECCION || ' , OLD 2.DESCRIPCION_DIRECCION : '|| :OLD.DESCRIPCION_DIRECCION || ' , OLD 3.DEPARTAMENTO: '  || :OLD.DEPARTAMENTO || ' ,  4.CIUDAD_OLD: '  || :OLD.CIUDAD|| ' ,  5.BARRIO_OLD: '  || :OLD.BARRIO|| ' , NEW 1. ID_DIRECCION: ' || :NEW.ID_DIRECCION || ' , NEW 2.DESCRIPCION_DIRECCION: ' || :NEW.DESCRIPCION_DIRECCION || ' , NEW 3.DEPARTAMENTO: ' || :NEW.DEPARTAMENTO || ' , NEW 4.CIUDAD: '  || :NEW.CIUDAD || ' , NEW 5.BARRIO: '  || :NEW.BARRIO;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'OLD 1. ID_DIRECCION : ' || :OLD.ID_DIRECCION || ' | OLD 2.DESCRIPCION_DIRECCION : ' || :OLD.DESCRIPCION_DIRECCION || ' | OLD 3.DEPARTAMENTO: ' || :OLD.DEPARTAMENTO || ' | OLD 4.CIUDAD: ' || :OLD.CIUDAD || ' | OLD 5.BARRIO: ' ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => '||' , OLD 1. ID_DIRECCION : ' || :OLD.ID_DIRECCION || ' , OLD 2.DESCRIPCION_DIRECCION : '|| :OLD.DESCRIPCION_DIRECCION || ' , OLD 3.DEPARTAMENTO: '  || :OLD.DEPARTAMENTO || ' ,  4.CIUDAD_OLD: '  || :OLD.CIUDAD|| ' ,  5.BARRIO_OLD: '  || :OLD.BARRIO;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END tg_DIRECCIONES_after;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla   USUARIOS_DIRECCIONES         
prompt +-------------------------------------------------------------+

--USUARIOS_DIRECCIONES BEFORE
CREATE OR REPLACE  TRIGGER tg_USUARIOS_DIRECCIONES_before
BEFORE INSERT OR UPDATE OR DELETE
ON USUARIOS_DIRECCIONES
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'USUARIOS_DIRECCIONES';
    
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. ID_USUARIO: ' || :NEW.ID_USUARIO || ' | 2.ID_DIRECCION: ' || :NEW.ID_DIRECCION;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. ID_USUARIO: ' || :NEW.ID_USUARIO || ' , 2.ID_DIRECCION: ' || :NEW.ID_DIRECCION;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. ID_USUARIO : ' || :OLD.ID_USUARIO || ' | 2.ID_DIRECCION : ' || :OLD.ID_DIRECCION || ' || New 1. ID_USUARIO: ' || :NEW.ID_USUARIO || ' | 2.ID_DIRECCION : ' || :NEW.ID_DIRECCION;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. ID_USUARIO : ' || :OLD.ID_USUARIO || ' , Old 2.ID_DIRECCION : ' || :OLD.ID_DIRECCION || ' , New  1. ID_USUARIO: ' || :NEW.ID_USUARIO || ' , New 2.ID_DIRECCION: ' || :NEW.ID_DIRECCION;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. ID_USUARIO : ' || :OLD.ID_USUARIO || ' | 2.ID_DIRECCION : ' || :OLD.ID_DIRECCION ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. ID_USUARIO : ' || :OLD.ID_USUARIO || ' , Old 2.ID_DIRECCION : ' || :OLD.ID_DIRECCION;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END;
/
------USUARIOS_DIRECCIONES AFTER
CREATE OR REPLACE  TRIGGER tg_USUARIOS_DIRECCIONES_AFTER
AFTER INSERT OR UPDATE OR DELETE
ON USUARIOS_DIRECCIONES
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'USUARIOS_DIRECCIONES';
    
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := '1. ID_USUARIO: ' || :NEW.ID_USUARIO || ' | 2.ID_DIRECCION: ' || :NEW.ID_DIRECCION;
        v_accion_aud := 'TABLA: ' || v_tabla|| ' => '  || ', 1. ID_USUARIO: ' || :NEW.ID_USUARIO || ' , 2.ID_DIRECCION: ' || :NEW.ID_DIRECCION;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'Old' ||' 1. ID_USUARIO : ' || :OLD.ID_USUARIO || ' | 2.ID_DIRECCION : ' || :OLD.ID_DIRECCION || ' || New 1. ID_USUARIO: ' || :NEW.ID_USUARIO || ' | 2.ID_DIRECCION : ' || :NEW.ID_DIRECCION;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. ID_USUARIO : ' || :OLD.ID_USUARIO || ' , Old 2.ID_DIRECCION : ' || :OLD.ID_DIRECCION || ' , New  1. ID_USUARIO: ' || :NEW.ID_USUARIO || ' , New 2.ID_DIRECCION: ' || :NEW.ID_DIRECCION;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion := 'Old' ||'1. ID_USUARIO : ' || :OLD.ID_USUARIO || ' | 2.ID_DIRECCION : ' || :OLD.ID_DIRECCION ;
        v_accion_aud := 'TABLA: ' || v_tabla || ' => ' ||' Old 1. ID_USUARIO : ' || :OLD.ID_USUARIO || ' , Old 2.ID_DIRECCION : ' || :OLD.ID_DIRECCION;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla USUARIOS           
prompt +-------------------------------------------------------------+

CREATE OR REPLACE TRIGGER tg_Val_Usuario_BEFORE
BEFORE INSERT OR UPDATE
ON USUARIOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'USUARIOS';
    ex_documento_invalido EXCEPTION;
    ex_nombre_usuario_nulo EXCEPTION;
    ex_primer_apellido_nulo EXCEPTION;
    ex_segundo_apellido_invalido EXCEPTION;
    ex_correo_invalido EXCEPTION;
    ex_contrasena_invalida EXCEPTION;
    ex_fecha_nacimiento_invalida EXCEPTION;
    ex_celular_invalido EXCEPTION;
    ex_telefono_invalido EXCEPTION;
BEGIN
    -- Validación del documento
    IF NOT pkg_utilidades.fn_validar_documento(:NEW.DOCUMENTO_USUARIO) THEN
        RAISE ex_documento_invalido;
    END IF;

    -- Validación del nombre
    IF NOT pkg_utilidades.fn_validar_nombre(:NEW.DATOS_USUARIO.nombre) THEN
        RAISE ex_nombre_usuario_nulo;
    ELSE
        :NEW.DATOS_USUARIO.nombre := TRIM(UPPER(:NEW.DATOS_USUARIO.nombre));
    END IF;

    -- Validación del primer apellido
    IF NOT pkg_utilidades.fn_validar_apellido(:NEW.PRIMER_APELLIDO_USUARIO) THEN
        RAISE ex_primer_apellido_nulo;
    ELSE
        :NEW.PRIMER_APELLIDO_USUARIO := TRIM(UPPER(:NEW.PRIMER_APELLIDO_USUARIO));
    END IF;

    -- Validación del segundo apellido
    IF pkg_utilidades.fn_validar_apellido(:NEW.SEGUNDO_APELLIDO_USUARIO) THEN
        IF :NEW.SEGUNDO_APELLIDO_USUARIO IS NOT NULL THEN
        :NEW.SEGUNDO_APELLIDO_USUARIO := TRIM(UPPER(:NEW.SEGUNDO_APELLIDO_USUARIO));
        ELSE
        :NEW.SEGUNDO_APELLIDO_USUARIO := NULL;
        END IF;
    ELSE
        RAISE ex_segundo_apellido_invalido;
    END IF;

    -- Validación del correo
    IF NOT pkg_utilidades.fn_validar_correo(:NEW.DATOS_USUARIO.correo) THEN
        RAISE ex_correo_invalido;
    END IF;

    -- Validación de la contraseña
    IF NOT pkg_utilidades.fn_validar_contrasena(:NEW.PASSWORD_USUARIO) THEN
        RAISE ex_contrasena_invalida;
    END IF;

    -- Validación de la fecha de nacimiento
    IF :NEW.FECHA_NACIMIENTO_USUARIO IS NOT NULL AND
        NOT pkg_utilidades.fn_validar_fecha_nacimiento(:NEW.FECHA_NACIMIENTO_USUARIO) THEN
        RAISE ex_fecha_nacimiento_invalida;
    END IF;

    -- Validación del celular
    IF :NEW.DATOS_USUARIO.telefono.movil IS NOT NULL AND
        NOT pkg_utilidades.fn_validar_celular(:NEW.DATOS_USUARIO.telefono.movil) THEN
        RAISE ex_celular_invalido;
    END IF;

    -- Validación del teléfono fijo
    IF :NEW.DATOS_USUARIO.telefono.fijo IS NOT NULL AND
        NOT pkg_utilidades.fn_validar_telefono(:NEW.DATOS_USUARIO.telefono.fijo) THEN
        RAISE ex_telefono_invalido;
    END IF;

    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := ' || NEW' || ' | 1. DOCUMENTO_USUARIO: ' || :NEW.DOCUMENTO_USUARIO || ' | 2.DATOS_USUARIO.nombre: ' || :NEW.DATOS_USUARIO.nombre ||' | 3.PRIMER_APELLIDO_USUARIO: ' || :NEW.PRIMER_APELLIDO_USUARIO || ' | 4.SEGUNDO_APELLIDO_USUARIO: ' || :NEW.SEGUNDO_APELLIDO_USUARIO || ' | 5.DATOS_USUARIO.correo: ' || :NEW.DATOS_USUARIO.correo || ' | 6.DATOS_USUARIO.telefono.movil: ' || :NEW.DATOS_USUARIO.telefono.movil || ' | 7.DATOS_USUARIO.telefono.fijo: ' || :NEW.DATOS_USUARIO.telefono.fijo || 
        ' | 8.FECHA_NACIMIENTO_USUARIO: ' || :NEW.FECHA_NACIMIENTO_USUARIO || 
        ' | 9.PASSWORD_USUARIO: ' || :NEW.PASSWORD_USUARIO || 
        ' | 10.TIPO_DOCUMENTO: ' || :NEW.TIPO_DOCUMENTO || 
        ' | 11.ESTADO_USUARIO: ' || :NEW.ESTADO_USUARIO || 
        ' | 12.SEXO_USUARIO: ' || :NEW.SEXO_USUARIO || 
        ' | 13.ROL_USUARIO: ' || :NEW.ROL_USUARIO ;


        v_accion_aud := 
        'TABLA: ' || v_tabla || ' => '|| 
        ' , NEW 1. DOCUMENTO_USUARIO: ' || :NEW.DOCUMENTO_USUARIO || 
        ' , NEW 2.DATOS_USUARIO.nombre: ' || :NEW.DATOS_USUARIO.nombre || 
        ' , NEW 3.PRIMER_APELLIDO_USUARIO: ' || :NEW.PRIMER_APELLIDO_USUARIO || 
        ' , NEW 4.SEGUNDO_APELLIDO_USUARIO: '  || :NEW.SEGUNDO_APELLIDO_USUARIO || 
        ' , NEW 5.DATOS_USUARIO.correo: '  || :NEW.DATOS_USUARIO.correo ||
        ' , NEW 6.DATOS_USUARIO.telefono.movil: '  || :NEW.DATOS_USUARIO.telefono.movil ||
        ' , NEW 7.DATOS_USUARIO.telefono.fijo: '  || :NEW.DATOS_USUARIO.telefono.fijo ||
        ' , NEW 8.FECHA_NACIMIENTO_USUARIO: '  || :NEW.FECHA_NACIMIENTO_USUARIO ||
        ' , NEW 9.PASSWORD_USUARIO: '  || :NEW.PASSWORD_USUARIO ||
        ' , NEW 10.TIPO_DOCUMENTO: '  || :NEW.TIPO_DOCUMENTO ||
        ' , NEW 11.ESTADO_USUARIO: '  || :NEW.ESTADO_USUARIO ||
        ' , NEW 12.SEXO_USUARIO: '  || :NEW.SEXO_USUARIO ||
        ' , NEW 13.ROL_USUARIO: '  || :NEW.ROL_USUARIO ;

        
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion :=         '|| OLD ' ||
        ' | 1. DOCUMENTO_USUARIO: ' || :OLD.DOCUMENTO_USUARIO || 
        ' | 2.DATOS_USUARIO.nombre: ' || :OLD.DATOS_USUARIO.nombre ||
        ' | 3.PRIMER_APELLIDO_USUARIO: ' || :OLD.PRIMER_APELLIDO_USUARIO || 
        ' | 4.SEGUNDO_APELLIDO_USUARIO: ' || :OLD.SEGUNDO_APELLIDO_USUARIO || 
        ' | 5.DATOS_USUARIO.correo: ' || :OLD.DATOS_USUARIO.correo || 
        ' || NEW' ||
        '1. DOCUMENTO_USUARIO: ' || :NEW.DOCUMENTO_USUARIO || 
        ' | 2.DATOS_USUARIO.nombre: ' || :NEW.DATOS_USUARIO.nombre ||
        ' | 3.PRIMER_APELLIDO_USUARIO: ' || :NEW.PRIMER_APELLIDO_USUARIO || 
        ' | 4.SEGUNDO_APELLIDO_USUARIO: ' || :NEW.SEGUNDO_APELLIDO_USUARIO || 
        ' | 5.DATOS_USUARIO.correo: ' || :NEW.DATOS_USUARIO.correo;


       v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
                ' , OLD 1. DOCUMENTO_USUARIO: ' || :OLD.DOCUMENTO_USUARIO || 
                ' , OLD 2.DATOS_USUARIO.nombre: ' || :OLD.DATOS_USUARIO.nombre ||
                ' , OLD 3.PRIMER_APELLIDO_USUARIO: ' || :OLD.PRIMER_APELLIDO_USUARIO || 
                ' , OLD 4.SEGUNDO_APELLIDO_USUARIO: ' || :OLD.SEGUNDO_APELLIDO_USUARIO || 
                ' , OLD 5.DATOS_USUARIO.correo: ' || :OLD.DATOS_USUARIO.correo ||
                ' , NEW 1. DOCUMENTO_USUARIO: ' || :NEW.DOCUMENTO_USUARIO || 
                ' , NEW 2.DATOS_USUARIO.nombre: ' || :NEW.DATOS_USUARIO.nombre ||
                ' , NEW 3.PRIMER_APELLIDO_USUARIO: ' || :NEW.PRIMER_APELLIDO_USUARIO || 
                ' , NEW 4.SEGUNDO_APELLIDO_USUARIO: ' || :NEW.SEGUNDO_APELLIDO_USUARIO ;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
    );

    -- Llamar al procedimiento para insertar el log en el archivo CSV
    pkg_manejo_logs.pr_insertar_log_archivo(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  => v_accion,
        p_tabla   => v_tabla
    );

EXCEPTION
    WHEN ex_documento_invalido THEN
        RAISE_APPLICATION_ERROR(-20006, 'El número de documento no es válido en Colombia.');
    WHEN ex_nombre_usuario_nulo THEN
        RAISE_APPLICATION_ERROR(-20007, 'El nombre de usuario no puede estar en blanco.');
    WHEN ex_primer_apellido_nulo THEN
        RAISE_APPLICATION_ERROR(-20008, 'El primer apellido no puede estar en blanco.');
    WHEN ex_segundo_apellido_invalido THEN
        RAISE_APPLICATION_ERROR(-20009, 'El segundo apellido no es válido.');
    WHEN ex_correo_invalido THEN
        RAISE_APPLICATION_ERROR(-20010, 'El correo electrónico no es válido.');
    WHEN ex_contrasena_invalida THEN
        RAISE_APPLICATION_ERROR(-20011, 'La contraseña no cumple con los requisitos de seguridad. 8 caracteres, contener al menos una letra mayúscula y un número.');
    WHEN ex_fecha_nacimiento_invalida THEN
        RAISE_APPLICATION_ERROR(-20012, 'La fecha de nacimiento no cumple con los requisitos.(14 años)');
    WHEN ex_celular_invalido THEN
        RAISE_APPLICATION_ERROR(-20013, 'El número de celular no es válido. Inicia con 3 o no tienes 10 caracteres');
    WHEN ex_telefono_invalido THEN
        RAISE_APPLICATION_ERROR(-20014, 'El número de teléfono no válido. 60 + área + teléfono fijo.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Comuníquese con el responsable del área.');     
        DBMS_OUTPUT.PUT_LINE('Código de error: ' || SQLCODE || ' - Mensaje: ' || SQLERRM);
END;
/

--Before delete usuarios 

CREATE OR REPLACE TRIGGER tg_Val_Usuario_BEFORE_DEL
BEFORE DELETE
ON USUARIOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'USUARIOS';

BEGIN
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion :=
        '|| OLD ' ||
        ' | 1. DOCUMENTO_USUARIO: ' || :OLD.DOCUMENTO_USUARIO || 
        ' | 2.DATOS_USUARIO.nombre: ' || :OLD.DATOS_USUARIO.nombre ||
        ' | 3.PRIMER_APELLIDO_USUARIO: ' || :OLD.PRIMER_APELLIDO_USUARIO || 
        ' | 4.SEGUNDO_APELLIDO_USUARIO: ' || :OLD.SEGUNDO_APELLIDO_USUARIO || 
        ' | 5.DATOS_USUARIO.correo: ' || :OLD.DATOS_USUARIO.correo || 
        ' | 6.DATOS_USUARIO.telefono.movil: ' || :OLD.DATOS_USUARIO.telefono.movil || 
        ' | 7.DATOS_USUARIO.telefono.fijo: ' || :OLD.DATOS_USUARIO.telefono.fijo || 
        ' | 8.FECHA_NACIMIENTO_USUARIO: ' || :OLD.FECHA_NACIMIENTO_USUARIO || 
        ' | 9.PASSWORD_USUARIO: ' || :OLD.PASSWORD_USUARIO || 
        ' | 10.TIPO_DOCUMENTO: ' || :OLD.TIPO_DOCUMENTO || 
        ' | 11.ESTADO_USUARIO: ' || :OLD.ESTADO_USUARIO || 
        ' | 12.SEXO_USUARIO: ' || :OLD.SEXO_USUARIO || 
        ' | 13.ROL_USUARIO: ' || :OLD.ROL_USUARIO 
        ;
        v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
        ' , OLD 1. DOCUMENTO_USUARIO: ' || :OLD.DOCUMENTO_USUARIO || 
        ' , OLD 2.DATOS_USUARIO.nombre: ' || :OLD.DATOS_USUARIO.nombre ||
        ' , OLD 3.PRIMER_APELLIDO_USUARIO: ' || :OLD.PRIMER_APELLIDO_USUARIO || 
        ' , OLD 4.SEGUNDO_APELLIDO_USUARIO: ' || :OLD.SEGUNDO_APELLIDO_USUARIO || 
        ' , OLD 5.DATOS_USUARIO.correo: ' || :OLD.DATOS_USUARIO.correo || 
        ' , OLD 6.DATOS_USUARIO.telefono.movil: ' || :OLD.DATOS_USUARIO.telefono.movil || 
        ' , OLD 7.DATOS_USUARIO.telefono.fijo: ' || :OLD.DATOS_USUARIO.telefono.fijo || 
        ' , OLD 8.FECHA_NACIMIENTO_USUARIO: ' || :OLD.FECHA_NACIMIENTO_USUARIO || 
        ' , OLD 9.PASSWORD_USUARIO: ' || :OLD.PASSWORD_USUARIO || 
        ' , OLD 10.TIPO_DOCUMENTO: ' || :OLD.TIPO_DOCUMENTO || 
        ' , OLD 11.ESTADO_USUARIO: ' || :OLD.ESTADO_USUARIO || 
        ' , OLD 12.SEXO_USUARIO: ' || :OLD.SEXO_USUARIO || 
        ' , OLD 13.ROL_USUARIO: ' || :OLD.ROL_USUARIO 
        ;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END;
/

-- After USUARIOS

CREATE OR REPLACE TRIGGER tg_Val_Usuario_AFTER
AFTER INSERT OR UPDATE OR DELETE
ON USUARIOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'USUARIOS';

BEGIN

    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := ' || NEW' || ' | 1. DOCUMENTO_USUARIO: ' || :NEW.DOCUMENTO_USUARIO || ' | 2.DATOS_USUARIO.nombre: ' || :NEW.DATOS_USUARIO.nombre ||' | 3.PRIMER_APELLIDO_USUARIO: ' || :NEW.PRIMER_APELLIDO_USUARIO || ' | 4.SEGUNDO_APELLIDO_USUARIO: ' || :NEW.SEGUNDO_APELLIDO_USUARIO || ' | 5.DATOS_USUARIO.correo: ' || :NEW.DATOS_USUARIO.correo || ' | 6.DATOS_USUARIO.telefono.movil: ' || :NEW.DATOS_USUARIO.telefono.movil || ' | 7.DATOS_USUARIO.telefono.fijo: ' || :NEW.DATOS_USUARIO.telefono.fijo || 
        ' | 8.FECHA_NACIMIENTO_USUARIO: ' || :NEW.FECHA_NACIMIENTO_USUARIO || 
        ' | 9.PASSWORD_USUARIO: ' || :NEW.PASSWORD_USUARIO || 
        ' | 10.TIPO_DOCUMENTO: ' || :NEW.TIPO_DOCUMENTO || 
        ' | 11.ESTADO_USUARIO: ' || :NEW.ESTADO_USUARIO || 
        ' | 12.SEXO_USUARIO: ' || :NEW.SEXO_USUARIO || 
        ' | 13.ROL_USUARIO: ' || :NEW.ROL_USUARIO ;


        v_accion_aud := 
        'TABLA: ' || v_tabla || ' => '|| 
        ' , NEW 1. DOCUMENTO_USUARIO: ' || :NEW.DOCUMENTO_USUARIO || 
        ' , NEW 2.DATOS_USUARIO.nombre: ' || :NEW.DATOS_USUARIO.nombre || 
        ' , NEW 3.PRIMER_APELLIDO_USUARIO: ' || :NEW.PRIMER_APELLIDO_USUARIO || 
        ' , NEW 4.SEGUNDO_APELLIDO_USUARIO: '  || :NEW.SEGUNDO_APELLIDO_USUARIO || 
        ' , NEW 5.DATOS_USUARIO.correo: '  || :NEW.DATOS_USUARIO.correo ||
        ' , NEW 6.DATOS_USUARIO.telefono.movil: '  || :NEW.DATOS_USUARIO.telefono.movil ||
        ' , NEW 7.DATOS_USUARIO.telefono.fijo: '  || :NEW.DATOS_USUARIO.telefono.fijo ||
        ' , NEW 8.FECHA_NACIMIENTO_USUARIO: '  || :NEW.FECHA_NACIMIENTO_USUARIO ||
        ' , NEW 9.PASSWORD_USUARIO: '  || :NEW.PASSWORD_USUARIO ||
        ' , NEW 10.TIPO_DOCUMENTO: '  || :NEW.TIPO_DOCUMENTO ||
        ' , NEW 11.ESTADO_USUARIO: '  || :NEW.ESTADO_USUARIO ||
        ' , NEW 12.SEXO_USUARIO: '  || :NEW.SEXO_USUARIO ||
        ' , NEW 13.ROL_USUARIO: '  || :NEW.ROL_USUARIO ;

        
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion :=         '|| OLD ' ||
        ' | 1. DOCUMENTO_USUARIO: ' || :OLD.DOCUMENTO_USUARIO || 
        ' | 2.DATOS_USUARIO.nombre: ' || :OLD.DATOS_USUARIO.nombre ||
        ' | 3.PRIMER_APELLIDO_USUARIO: ' || :OLD.PRIMER_APELLIDO_USUARIO || 
        ' | 4.SEGUNDO_APELLIDO_USUARIO: ' || :OLD.SEGUNDO_APELLIDO_USUARIO || 
        ' | 5.DATOS_USUARIO.correo: ' || :OLD.DATOS_USUARIO.correo || 
        ' || NEW' ||
        '1. DOCUMENTO_USUARIO: ' || :NEW.DOCUMENTO_USUARIO || 
        ' | 2.DATOS_USUARIO.nombre: ' || :NEW.DATOS_USUARIO.nombre ||
        ' | 3.PRIMER_APELLIDO_USUARIO: ' || :NEW.PRIMER_APELLIDO_USUARIO || 
        ' | 4.SEGUNDO_APELLIDO_USUARIO: ' || :NEW.SEGUNDO_APELLIDO_USUARIO || 
        ' | 5.DATOS_USUARIO.correo: ' || :NEW.DATOS_USUARIO.correo;


       v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
                ' , OLD 1. DOCUMENTO_USUARIO: ' || :OLD.DOCUMENTO_USUARIO || 
                ' , OLD 2.DATOS_USUARIO.nombre: ' || :OLD.DATOS_USUARIO.nombre ||
                ' , OLD 3.PRIMER_APELLIDO_USUARIO: ' || :OLD.PRIMER_APELLIDO_USUARIO || 
                ' , OLD 4.SEGUNDO_APELLIDO_USUARIO: ' || :OLD.SEGUNDO_APELLIDO_USUARIO || 
                ' , OLD 5.DATOS_USUARIO.correo: ' || :OLD.DATOS_USUARIO.correo ||
                ' , NEW 1. DOCUMENTO_USUARIO: ' || :NEW.DOCUMENTO_USUARIO || 
                ' , NEW 2.DATOS_USUARIO.nombre: ' || :NEW.DATOS_USUARIO.nombre ||
                ' , NEW 3.PRIMER_APELLIDO_USUARIO: ' || :NEW.PRIMER_APELLIDO_USUARIO || 
                ' , NEW 4.SEGUNDO_APELLIDO_USUARIO: ' || :NEW.SEGUNDO_APELLIDO_USUARIO ;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion :=
        '|| OLD ' ||
        ' | 1. DOCUMENTO_USUARIO: ' || :OLD.DOCUMENTO_USUARIO || 
        ' | 2.DATOS_USUARIO.nombre: ' || :OLD.DATOS_USUARIO.nombre ||
        ' | 3.PRIMER_APELLIDO_USUARIO: ' || :OLD.PRIMER_APELLIDO_USUARIO || 
        ' | 4.SEGUNDO_APELLIDO_USUARIO: ' || :OLD.SEGUNDO_APELLIDO_USUARIO || 
        ' | 5.DATOS_USUARIO.correo: ' || :OLD.DATOS_USUARIO.correo || 
        ' | 6.DATOS_USUARIO.telefono.movil: ' || :OLD.DATOS_USUARIO.telefono.movil || 
        ' | 7.DATOS_USUARIO.telefono.fijo: ' || :OLD.DATOS_USUARIO.telefono.fijo || 
        ' | 8.FECHA_NACIMIENTO_USUARIO: ' || :OLD.FECHA_NACIMIENTO_USUARIO || 
        ' | 9.PASSWORD_USUARIO: ' || :OLD.PASSWORD_USUARIO || 
        ' | 10.TIPO_DOCUMENTO: ' || :OLD.TIPO_DOCUMENTO || 
        ' | 11.ESTADO_USUARIO: ' || :OLD.ESTADO_USUARIO || 
        ' | 12.SEXO_USUARIO: ' || :OLD.SEXO_USUARIO || 
        ' | 13.ROL_USUARIO: ' || :OLD.ROL_USUARIO 
        ;
        v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
        ' , OLD 1. DOCUMENTO_USUARIO: ' || :OLD.DOCUMENTO_USUARIO || 
        ' , OLD 2.DATOS_USUARIO.nombre: ' || :OLD.DATOS_USUARIO.nombre ||
        ' , OLD 3.PRIMER_APELLIDO_USUARIO: ' || :OLD.PRIMER_APELLIDO_USUARIO || 
        ' , OLD 4.SEGUNDO_APELLIDO_USUARIO: ' || :OLD.SEGUNDO_APELLIDO_USUARIO || 
        ' , OLD 5.DATOS_USUARIO.correo: ' || :OLD.DATOS_USUARIO.correo || 
        ' , OLD 6.DATOS_USUARIO.telefono.movil: ' || :OLD.DATOS_USUARIO.telefono.movil || 
        ' , OLD 7.DATOS_USUARIO.telefono.fijo: ' || :OLD.DATOS_USUARIO.telefono.fijo || 
        ' , OLD 8.FECHA_NACIMIENTO_USUARIO: ' || :OLD.FECHA_NACIMIENTO_USUARIO || 
        ' , OLD 9.PASSWORD_USUARIO: ' || :OLD.PASSWORD_USUARIO || 
        ' , OLD 10.TIPO_DOCUMENTO: ' || :OLD.TIPO_DOCUMENTO || 
        ' , OLD 11.ESTADO_USUARIO: ' || :OLD.ESTADO_USUARIO || 
        ' , OLD 12.SEXO_USUARIO: ' || :OLD.SEXO_USUARIO || 
        ' , OLD 13.ROL_USUARIO: ' || :OLD.ROL_USUARIO 
        ;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  LABORATORIOS
prompt +-------------------------------------------------------------+
DROP SEQUENCE SEQ_ID_LABORATORIO;
CREATE SEQUENCE SEQ_ID_LABORATORIO START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_Laboratorios_before
BEFORE INSERT 
ON LABORATORIOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'LABORATORIOS';
    ex_correo_invalido EXCEPTION;
    ex_telefono_invalido EXCEPTION;
    ex_celular_invalido EXCEPTION;
BEGIN
    -- Generar el ID_LABORATORIO utilizando la secuencia
    SELECT SEQ_ID_LABORATORIO.NEXTVAL INTO :NEW.ID_LABORATORIO FROM dual;

    -- Validación del correo
    IF NOT pkg_utilidades.fn_validar_correo(:NEW.datos_laboratorios.correo) THEN
        RAISE ex_correo_invalido;
    END IF;

    -- Validación del teléfono fijo
    IF :NEW.datos_laboratorios.telefono.fijo IS NOT NULL AND 
       NOT pkg_utilidades.fn_validar_telefono(:NEW.datos_laboratorios.telefono.fijo) THEN
        RAISE ex_telefono_invalido;
    END IF;

    -- Validación del número móvil
    IF :NEW.datos_laboratorios.telefono.movil IS NOT NULL AND 
       NOT pkg_utilidades.fn_validar_celular(:NEW.datos_laboratorios.telefono.movil) THEN
        RAISE ex_celular_invalido;
    END IF;
    
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := ' || NEW' || ' | 1. ID_LABORATORIO: ' || :NEW.ID_LABORATORIO || 
        ' | 2.datos_laboratorios.nombre: ' || :NEW.datos_laboratorios.nombre ||       
        ' | 3.datos_laboratorios.telefono.fijo: ' || :NEW.datos_laboratorios.telefono.fijo|| 
        ' | 4.datos_laboratorios.correo: ' || :NEW.datos_laboratorios.correo || 
        ' | 5.datos_laboratorios.telefono.movil: ' || :NEW.datos_laboratorios.telefono.movil ||
        ' | 6.ESTADO_LABORATORIO: ' || :NEW.ESTADO_LABORATORIO ;  
        v_accion_aud := 
        'TABLA: ' || v_tabla || ' => '|| 
        ' , NEW 1. ID_LABORATORIO: ' || :NEW.ID_LABORATORIO || 
        ' , NEW 2.datos_laboratorios.nombre: ' || :NEW.datos_laboratorios.nombre || 
        ' , NEW 3.datos_laboratorios.telefono.fijo: ' || :NEW.datos_laboratorios.telefono.fijo||
        ' , NEW 4.datos_laboratorios.correo: ' || :NEW.datos_laboratorios.correo || 
        ' , NEW  5.datos_laboratorios.telefono.movil: ' || :NEW.datos_laboratorios.telefono.movil ||
        ' , NEW  6.ESTADO_LABORATORIO: ' || :NEW.ESTADO_LABORATORIO ;
    END IF;
        -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
    );

    -- Llamar al procedimiento para insertar el log en el archivo CSV
    pkg_manejo_logs.pr_insertar_log_archivo(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  => v_accion,
        p_tabla   => v_tabla
    );

EXCEPTION
    WHEN ex_correo_invalido THEN
        RAISE_APPLICATION_ERROR(-20015, 'El correo electrónico no es válido.');
    WHEN ex_telefono_invalido THEN
        RAISE_APPLICATION_ERROR(-20016, 'El número de teléfono no es válido. Debe empezar con 60 y tener 10 dígitos.');
    WHEN ex_celular_invalido THEN
        RAISE_APPLICATION_ERROR(-20017, 'El número de celular no es válido. Debe empezar con 3 y tener 10 dígitos.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Comuníquese con el responsable del área.');
        DBMS_OUTPUT.PUT_LINE('Código de error: ' || SQLCODE || ' - Mensaje: ' || SQLERRM);
END;
/


---> Actualizar laboratorios

CREATE OR REPLACE TRIGGER tg_Val_Laboratorios_BEFORE_UPDATE
BEFORE UPDATE
ON LABORATORIOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10) := 'UPDATE';
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(1000);
    v_accion_aud VARCHAR2(1000);
    v_tabla VARCHAR2(50) := 'LABORATORIOS';

    ex_correo_invalido EXCEPTION;
    ex_telefono_invalido EXCEPTION;
    ex_celular_invalido EXCEPTION;
BEGIN
    -- Validación del correo
    IF NOT pkg_utilidades.fn_validar_correo(:NEW.datos_laboratorios.correo) THEN
        RAISE ex_correo_invalido;
    END IF;

    -- Validación del teléfono fijo
    IF :NEW.datos_laboratorios.telefono.fijo IS NOT NULL AND 
       NOT pkg_utilidades.fn_validar_telefono(:NEW.datos_laboratorios.telefono.fijo) THEN
        RAISE ex_telefono_invalido;
    END IF;

    -- Validación del número móvil
    IF :NEW.datos_laboratorios.telefono.movil IS NOT NULL AND 
       NOT pkg_utilidades.fn_validar_celular(:NEW.datos_laboratorios.telefono.movil) THEN
        RAISE ex_celular_invalido;
    END IF;

    -- Crear mensaje de log solo con los campos que cambian
    v_accion := 'OLD | 1. ID_LABORATORIO: ' || :OLD.ID_LABORATORIO || 
                ' | 2.datos_laboratorios.nombre: ' || :OLD.datos_laboratorios.nombre ||       
                ' | 3.datos_laboratorios.telefono.fijo: ' || :OLD.datos_laboratorios.telefono.fijo|| 
                ' | 4.datos_laboratorios.correo: ' || :OLD.datos_laboratorios.correo || 
                ' | 5.datos_laboratorios.telefono.movil: ' || :OLD.datos_laboratorios.telefono.movil ||
                ' | 6.ESTADO_LABORATORIO: ' || :OLD.ESTADO_LABORATORIO || 
                ' || NEW | 1. ID_LABORATORIO: ' || :NEW.ID_LABORATORIO || 
                ' | 2.datos_laboratorios.nombre: ' || :NEW.datos_laboratorios.nombre ||       
                ' | 3.datos_laboratorios.telefono.fijo: ' || :NEW.datos_laboratorios.telefono.fijo|| 
                ' | 4.datos_laboratorios.correo: ' || :NEW.datos_laboratorios.correo || 
                ' | 5.datos_laboratorios.telefono.movil: ' || :NEW.datos_laboratorios.telefono.movil ||
                ' | 6.ESTADO_LABORATORIO: ' || :NEW.ESTADO_LABORATORIO;

    v_accion_aud := 'TABLA: ' || v_tabla || ' => ' || 
                    ' OLD | 1. ID_LABORATORIO: ' || :OLD.ID_LABORATORIO || 
                    ' , 2.datos_laboratorios.nombre: ' || :OLD.datos_laboratorios.nombre || 
                    ' , 3.datos_laboratorios.telefono.fijo: ' || :OLD.datos_laboratorios.telefono.fijo ||
                    ' , 4.datos_laboratorios.correo: ' || :OLD.datos_laboratorios.correo || 
                    ' , 5.datos_laboratorios.telefono.movil: ' || :OLD.datos_laboratorios.telefono.movil ||
                    ' , 6.ESTADO_LABORATORIO: ' || :OLD.ESTADO_LABORATORIO || 
                    ' NEW | 1. ID_LABORATORIO: ' || :NEW.ID_LABORATORIO || 
                    ' , 2.datos_laboratorios.nombre: ' || :NEW.datos_laboratorios.nombre || 
                    ' , 3.datos_laboratorios.telefono.fijo: ' || :NEW.datos_laboratorios.telefono.fijo ||
                    ' , 4.datos_laboratorios.correo: ' || :NEW.datos_laboratorios.correo || 
                    ' , 5.datos_laboratorios.telefono.movil: ' || :NEW.datos_laboratorios.telefono.movil ||
                    ' , 6.ESTADO_LABORATORIO: ' || :NEW.ESTADO_LABORATORIO;

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
    WHEN ex_correo_invalido THEN
        RAISE_APPLICATION_ERROR(-20015, 'El correo electrónico no es válido.');
    WHEN ex_telefono_invalido THEN
        RAISE_APPLICATION_ERROR(-20016, 'El número de teléfono no es válido. Debe empezar con 60 y tener 10 dígitos.');
    WHEN ex_celular_invalido THEN
        RAISE_APPLICATION_ERROR(-20017, 'El número de celular no es válido. Debe empezar con 3 y tener 10 dígitos.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Comuníquese con el responsable del área.');
        DBMS_OUTPUT.PUT_LINE('Código de error: ' || SQLCODE || ' - Mensaje: ' || SQLERRM);
END;
/

    

---> Eliminar laboratorios

CREATE OR REPLACE TRIGGER trg_Validacion_Eliminacion_Laboratorios_before
BEFORE DELETE
ON LABORATORIOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10) := 'DELETE';
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud VARCHAR2(500);
    v_tabla VARCHAR2(50) := 'LABORATORIOS';

    v_num_productos NUMBER;
    ex_laboratorio_presente EXCEPTION;
BEGIN
    -- Contar el número de productos del laboratorio actual en la tabla productos
    SELECT COUNT(*)
    INTO v_num_productos
    FROM PRODUCTOS
    WHERE ID_LABORATORIOS = :OLD.ID_LABORATORIO;

    -- Si hay productos del laboratorio en la tabla productos
    IF v_num_productos > 0 THEN
        RAISE ex_laboratorio_presente;
    END IF;

    -- Preparar los mensajes de log con los valores OLD
    v_accion := '|| OLD | 1. ID_LABORATORIO: ' || :OLD.ID_LABORATORIO || 
                ' | 2.datos_laboratorios.nombre: ' || :OLD.datos_laboratorios.nombre ||       
                ' | 3.datos_laboratorios.telefono.fijo: ' || :OLD.datos_laboratorios.telefono.fijo || 
                ' | 4.datos_laboratorios.correo: ' || :OLD.datos_laboratorios.correo || 
                ' | 5.datos_laboratorios.telefono.movil: ' || :OLD.datos_laboratorios.telefono.movil ||
                ' | 6.ESTADO_LABORATORIO: ' || :OLD.ESTADO_LABORATORIO;

    v_accion_aud := 'TABLA: ' || v_tabla || ' => ' || 
                    ' OLD | 1. ID_LABORATORIO: ' || :OLD.ID_LABORATORIO || 
                    ' , 2.datos_laboratorios.nombre: ' || :OLD.datos_laboratorios.nombre || 
                    ' , 3.datos_laboratorios.telefono.fijo: ' || :OLD.datos_laboratorios.telefono.fijo ||
                    ' , 4.datos_laboratorios.correo: ' || :OLD.datos_laboratorios.correo || 
                    ' , 5.datos_laboratorios.telefono.movil: ' || :OLD.datos_laboratorios.telefono.movil ||
                    ' , 6.ESTADO_LABORATORIO: ' || :OLD.ESTADO_LABORATORIO;

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
    WHEN ex_laboratorio_presente THEN
        RAISE_APPLICATION_ERROR(-20018, 'No se puede eliminar el laboratorio porque está presente en la tabla productos.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Comuníquese con el responsable del área.');
        DBMS_OUTPUT.PUT_LINE('Código de error: ' || SQLCODE || ' - Mensaje: ' || SQLERRM);
END;
/

--AFTER LABORATORIOS
CREATE OR REPLACE TRIGGER trg_Laboratorios_after
AFTER INSERT OR UPDATE OR DELETE 
ON LABORATORIOS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'LABORATORIOS';
BEGIN
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion := ' || NEW' || ' | 1. ID_LABORATORIO: ' || :NEW.ID_LABORATORIO || 
        ' | 2.datos_laboratorios.nombre: ' || :NEW.datos_laboratorios.nombre ||       
        ' | 3.datos_laboratorios.telefono.fijo: ' || :NEW.datos_laboratorios.telefono.fijo|| 
        ' | 4.datos_laboratorios.correo: ' || :NEW.datos_laboratorios.correo || 
        ' | 5.datos_laboratorios.telefono.movil: ' || :NEW.datos_laboratorios.telefono.movil ||
        ' | 6.ESTADO_LABORATORIO: ' || :NEW.ESTADO_LABORATORIO ;  
        v_accion_aud := 
        'TABLA: ' || v_tabla || ' => '|| 
        ' , NEW 1. ID_LABORATORIO: ' || :NEW.ID_LABORATORIO || 
        ' , NEW 2.datos_laboratorios.nombre: ' || :NEW.datos_laboratorios.nombre || 
        ' , NEW 3.datos_laboratorios.telefono.fijo: ' || :NEW.datos_laboratorios.telefono.fijo||
        ' , NEW 4.datos_laboratorios.correo: ' || :NEW.datos_laboratorios.correo || 
        ' , NEW  5.datos_laboratorios.telefono.movil: ' || :NEW.datos_laboratorios.telefono.movil ||
        ' , NEW  6.ESTADO_LABORATORIO: ' || :NEW.ESTADO_LABORATORIO ;
        
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion := 'OLD | 1. ID_LABORATORIO: ' || :OLD.ID_LABORATORIO || 
                ' | 2.datos_laboratorios.nombre: ' || :OLD.datos_laboratorios.nombre ||       
                ' | 3.datos_laboratorios.telefono.fijo: ' || :OLD.datos_laboratorios.telefono.fijo|| 
                ' | 4.datos_laboratorios.correo: ' || :OLD.datos_laboratorios.correo || 
                ' | 5.datos_laboratorios.telefono.movil: ' || :OLD.datos_laboratorios.telefono.movil ||
                ' | 6.ESTADO_LABORATORIO: ' || :OLD.ESTADO_LABORATORIO || 
                ' || NEW | 1. ID_LABORATORIO: ' || :NEW.ID_LABORATORIO || 
                ' | 2.datos_laboratorios.nombre: ' || :NEW.datos_laboratorios.nombre ||       
                ' | 3.datos_laboratorios.telefono.fijo: ' || :NEW.datos_laboratorios.telefono.fijo|| 
                ' | 4.datos_laboratorios.correo: ' || :NEW.datos_laboratorios.correo || 
                ' | 5.datos_laboratorios.telefono.movil: ' || :NEW.datos_laboratorios.telefono.movil ||
                ' | 6.ESTADO_LABORATORIO: ' || :NEW.ESTADO_LABORATORIO;

    v_accion_aud := 'TABLA: ' || v_tabla || ' => ' || 
                    ' OLD | 1. ID_LABORATORIO: ' || :OLD.ID_LABORATORIO || 
                    ' , 2.datos_laboratorios.nombre: ' || :OLD.datos_laboratorios.nombre || 
                    ' , 3.datos_laboratorios.telefono.fijo: ' || :OLD.datos_laboratorios.telefono.fijo ||
                    ' , 4.datos_laboratorios.correo: ' || :OLD.datos_laboratorios.correo || 
                    ' , 5.datos_laboratorios.telefono.movil: ' || :OLD.datos_laboratorios.telefono.movil ||
                    ' , 6.ESTADO_LABORATORIO: ' || :OLD.ESTADO_LABORATORIO || 
                    ' NEW | 1. ID_LABORATORIO: ' || :NEW.ID_LABORATORIO || 
                    ' , 2.datos_laboratorios.nombre: ' || :NEW.datos_laboratorios.nombre || 
                    ' , 3.datos_laboratorios.telefono.fijo: ' || :NEW.datos_laboratorios.telefono.fijo ||
                    ' , 4.datos_laboratorios.correo: ' || :NEW.datos_laboratorios.correo || 
                    ' , 5.datos_laboratorios.telefono.movil: ' || :NEW.datos_laboratorios.telefono.movil ||
                    ' , 6.ESTADO_LABORATORIO: ' || :NEW.ESTADO_LABORATORIO;

    ELSIF DELETING THEN
        v_evento := 'DELETE';
         v_accion := '|| OLD | 1. ID_LABORATORIO: ' || :OLD.ID_LABORATORIO || 
                ' | 2.datos_laboratorios.nombre: ' || :OLD.datos_laboratorios.nombre ||       
                ' | 3.datos_laboratorios.telefono.fijo: ' || :OLD.datos_laboratorios.telefono.fijo || 
                ' | 4.datos_laboratorios.correo: ' || :OLD.datos_laboratorios.correo || 
                ' | 5.datos_laboratorios.telefono.movil: ' || :OLD.datos_laboratorios.telefono.movil ||
                ' | 6.ESTADO_LABORATORIO: ' || :OLD.ESTADO_LABORATORIO;

    v_accion_aud := 'TABLA: ' || v_tabla || ' => ' || 
                    ' OLD | 1. ID_LABORATORIO: ' || :OLD.ID_LABORATORIO || 
                    ' , 2.datos_laboratorios.nombre: ' || :OLD.datos_laboratorios.nombre || 
                    ' , 3.datos_laboratorios.telefono.fijo: ' || :OLD.datos_laboratorios.telefono.fijo ||
                    ' , 4.datos_laboratorios.correo: ' || :OLD.datos_laboratorios.correo || 
                    ' , 5.datos_laboratorios.telefono.movil: ' || :OLD.datos_laboratorios.telefono.movil ||
                    ' , 6.ESTADO_LABORATORIO: ' || :OLD.ESTADO_LABORATORIO;

    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END;
/


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  TRANSPORTISTAS
prompt +-------------------------------------------------------------+

DROP SEQUENCE seq_ID_TRANSPORTISTA;
CREATE SEQUENCE seq_ID_TRANSPORTISTA
START WITH 1
INCREMENT BY 1;


CREATE OR REPLACE TRIGGER tg_Val_Transportistas_BEFORE
BEFORE INSERT OR UPDATE ON TRANSPORTISTAS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50) := 'TRANSPORTISTAS';

    ex_correo_invalido EXCEPTION;
    ex_celular_invalido EXCEPTION;
    ex_telefono_invalido EXCEPTION;
BEGIN
    -- Generar ID_TRANSPORTISTA solo en inserciones
    IF INSERTING THEN
        SELECT seq_ID_TRANSPORTISTA.NEXTVAL INTO :NEW.ID_TRANSPORTISTA FROM dual;
        v_evento := 'INSERT';
        v_accion :=
        ' || NEW' ||
                ' | 1. ID_TRANSPORTISTA: ' || :NEW.ID_TRANSPORTISTA ||                                 
                ' | 2.datos_transportistas.nombre: ' || :NEW.datos_transportistas.nombre ||                    
                ' | 3.datos_transportistas.correo: ' || :NEW.datos_transportistas.correo ||                    
                ' | 4.datos_transportistas.telefono.movil: ' || :NEW.datos_transportistas.telefono.movil ||    
                ' | 5.datos_transportistas.telefono.fijo: ' || :NEW.datos_transportistas.telefono.fijo ||      
                ' | 6.TIPO: ' || :NEW.TIPO;                                    



        v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
                ' , NEW 1. ID_TRANSPORTISTA: ' || :NEW.ID_TRANSPORTISTA ||   
                ' , NEW 2.datos_transportistas.nombre: ' || :NEW.datos_transportistas.nombre ||
                ' , NEW 3.datos_transportistas.correo: ' || :NEW.datos_transportistas.correo ||
                ' , NEW 4.datos_transportistas.telefono.movil: ' || :NEW.datos_transportistas.telefono.movil || 
                ' , NEW 5.datos_transportistas.telefono.fijo: ' || :NEW.datos_transportistas.telefono.fijo ||
                ' , NEW  6.TIPO: ' || :NEW.TIPO;
    ELSE
        v_evento := 'UPDATE';
        v_accion :=
        ' || OLD' ||
        ' | 1. ID_TRANSPORTISTA: ' || :OLD.ID_TRANSPORTISTA ||                                 
        ' | 2.datos_transportistas.nombre: ' || :OLD.datos_transportistas.nombre ||                    
        ' | 3.datos_transportistas.correo: ' || :OLD.datos_transportistas.correo ||                    
        ' | 4.datos_transportistas.telefono.movil: ' || :OLD.datos_transportistas.telefono.movil ||    
        ' | NEW 1. ID_TRANSPORTISTA: ' || :NEW.ID_TRANSPORTISTA ||                                 
        ' | 2.datos_transportistas.nombre: ' || :NEW.datos_transportistas.nombre ||                    
        ' | 3.datos_transportistas.correo: ' || :NEW.datos_transportistas.correo ||                    
        ' | 4.datos_transportistas.telefono.movil: ' || :NEW.datos_transportistas.telefono.movil  ;

        v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
                ' , OLD 1. ID_TRANSPORTISTA: ' || :OLD.ID_TRANSPORTISTA ||   
                ' , OLD 2.datos_transportistas.nombre: ' || :OLD.datos_transportistas.nombre ||
                ' , OLD 3.datos_transportistas.correo: ' || :OLD.datos_transportistas.correo ||
                ' , OLD 4.datos_transportistas.telefono.movil: ' || :OLD.datos_transportistas.telefono.movil ||
                ' , OLD 5.datos_transportistas.telefono.fijo: ' || :OLD.datos_transportistas.telefono.fijo ||
                ' , OLD  6.TIPO: ' || :OLD.TIPO ||
                ' , NEW 1. ID_TRANSPORTISTA: ' || :NEW.ID_TRANSPORTISTA ||   
                ' , NEW 2.datos_transportistas.nombre: ' || :NEW.datos_transportistas.nombre ||
                ' , NEW 3.datos_transportistas.correo: ' || :NEW.datos_transportistas.correo ||
                ' , NEW 4.datos_transportistas.telefono.movil: ' || :NEW.datos_transportistas.telefono.movil ||
                ' , NEW 5.datos_transportistas.telefono.fijo: ' || :NEW.datos_transportistas.telefono.fijo ||
                ' , NEW  6.TIPO: ' || :NEW.TIPO;

    END IF;

    -- Validación del correo
    IF NOT pkg_utilidades.fn_validar_correo(:NEW.datos_transportistas.correo) THEN
        RAISE ex_correo_invalido;
    END IF;

    -- Validación del número móvil
    IF :NEW.datos_transportistas.telefono.movil IS NOT NULL AND 
       NOT pkg_utilidades.fn_validar_celular(:NEW.datos_transportistas.telefono.movil) THEN
        RAISE ex_celular_invalido;
    END IF;

    -- Validación del teléfono fijo
    IF :NEW.datos_transportistas.telefono.fijo IS NOT NULL AND 
       NOT pkg_utilidades.fn_validar_telefono(:NEW.datos_transportistas.telefono.fijo) THEN
        RAISE ex_telefono_invalido;
    END IF;


    -- Registrar log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  => v_accion_aud
    );

    -- Registrar log en el archivo CSV
    pkg_manejo_logs.pr_insertar_log_archivo(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  => v_accion,
        p_tabla   => v_tabla
    );

EXCEPTION
    WHEN ex_correo_invalido THEN
        RAISE_APPLICATION_ERROR(-20020, 'El correo electrónico no es válido.');
    WHEN ex_celular_invalido THEN
        RAISE_APPLICATION_ERROR(-20021, 'El número de celular no es válido.');
    WHEN ex_telefono_invalido THEN
        RAISE_APPLICATION_ERROR(-20022, 'El número de teléfono no válido.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Comuníquese con el responsable del área.');
        DBMS_OUTPUT.PUT_LINE('Código de error: ' || SQLCODE || ' - Mensaje: ' || SQLERRM);
END;
/


--> DELETE BEFORE

CREATE OR REPLACE TRIGGER tg_Transportistas_DEL_BEFORE
BEFORE DELETE ON TRANSPORTISTAS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50) := 'TRANSPORTISTAS';

    ex_correo_invalido EXCEPTION;
    ex_celular_invalido EXCEPTION;
    ex_telefono_invalido EXCEPTION;
BEGIN
    IF DELETING THEN
        v_evento := 'DELETE';
        v_accion :=
        ' || OLD' ||
        ' | 1. ID_TRANSPORTISTA: ' || :OLD.ID_TRANSPORTISTA ||                                 
        ' | 2.datos_transportistas.nombre: ' || :OLD.datos_transportistas.nombre ||                    
        ' | 3.datos_transportistas.correo: ' || :OLD.datos_transportistas.correo ||                    
        ' | 4.datos_transportistas.telefono.movil: ' || :OLD.datos_transportistas.telefono.movil ||    
        ' | 5.datos_transportistas.telefono.fijo: ' || :OLD.datos_transportistas.telefono.fijo ||      
        ' | 6.TIPO: ' || :OLD.TIPO ;        

        v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
        ' , OLD 1. ID_TRANSPORTISTA: ' || :OLD.ID_TRANSPORTISTA ||   
        ' , OLD 2.datos_transportistas.nombre: ' || :OLD.datos_transportistas.nombre ||
        ' , OLD 3.datos_transportistas.correo: ' || :OLD.datos_transportistas.correo ||
        ' , OLD 4.datos_transportistas.telefono.movil: ' || :OLD.datos_transportistas.telefono.movil ||
        ' , OLD 5.datos_transportistas.telefono.fijo: ' || :OLD.datos_transportistas.telefono.fijo ||
        ' , OLD  6.TIPO: ' || :OLD.TIPO  ;
    END IF;
        -- Registrar log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  => v_accion_aud
    );

    -- Registrar log en el archivo CSV
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
END tg_Transportistas_DEL_BEFORE;

---> TRANPORTISTA AFTER
CREATE OR REPLACE TRIGGER tg_Transportistas_AFTER
AFTER INSERT OR UPDATE OR DELETE ON TRANSPORTISTAS
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50) := 'TRANSPORTISTAS';
BEGIN
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion :=
        ' || NEW' ||
                ' | 1. ID_TRANSPORTISTA: ' || :NEW.ID_TRANSPORTISTA ||                                 
                ' | 2.datos_transportistas.nombre: ' || :NEW.datos_transportistas.nombre ||                    
                ' | 3.datos_transportistas.correo: ' || :NEW.datos_transportistas.correo ||                    
                ' | 4.datos_transportistas.telefono.movil: ' || :NEW.datos_transportistas.telefono.movil ||    
                ' | 5.datos_transportistas.telefono.fijo: ' || :NEW.datos_transportistas.telefono.fijo ||      
                ' | 6.TIPO: ' || :NEW.TIPO;                                    



        v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
                ' , NEW 1. ID_TRANSPORTISTA: ' || :NEW.ID_TRANSPORTISTA ||   
                ' , NEW 2.datos_transportistas.nombre: ' || :NEW.datos_transportistas.nombre ||
                ' , NEW 3.datos_transportistas.correo: ' || :NEW.datos_transportistas.correo ||
                ' , NEW 4.datos_transportistas.telefono.movil: ' || :NEW.datos_transportistas.telefono.movil || 
                ' , NEW 5.datos_transportistas.telefono.fijo: ' || :NEW.datos_transportistas.telefono.fijo ||
                ' , NEW  6.TIPO: ' || :NEW.TIPO;

    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion :=
        ' || OLD' ||
        ' | 1. ID_TRANSPORTISTA: ' || :OLD.ID_TRANSPORTISTA ||                                 
        ' | 2.datos_transportistas.nombre: ' || :OLD.datos_transportistas.nombre ||                    
        ' | 3.datos_transportistas.correo: ' || :OLD.datos_transportistas.correo ||                    
        ' | 4.datos_transportistas.telefono.movil: ' || :OLD.datos_transportistas.telefono.movil ||    
        ' | NEW 1. ID_TRANSPORTISTA: ' || :NEW.ID_TRANSPORTISTA ||                                 
        ' | 2.datos_transportistas.nombre: ' || :NEW.datos_transportistas.nombre ||                    
        ' | 3.datos_transportistas.correo: ' || :NEW.datos_transportistas.correo ||                    
        ' | 4.datos_transportistas.telefono.movil: ' || :NEW.datos_transportistas.telefono.movil  ;

        v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
                ' , OLD 1. ID_TRANSPORTISTA: ' || :OLD.ID_TRANSPORTISTA ||   
                ' , OLD 2.datos_transportistas.nombre: ' || :OLD.datos_transportistas.nombre ||
                ' , OLD 3.datos_transportistas.correo: ' || :OLD.datos_transportistas.correo ||
                ' , OLD 4.datos_transportistas.telefono.movil: ' || :OLD.datos_transportistas.telefono.movil ||
                ' , OLD 5.datos_transportistas.telefono.fijo: ' || :OLD.datos_transportistas.telefono.fijo ||
                ' , OLD  6.TIPO: ' || :OLD.TIPO ||
                ' , NEW 1. ID_TRANSPORTISTA: ' || :NEW.ID_TRANSPORTISTA ||   
                ' , NEW 2.datos_transportistas.nombre: ' || :NEW.datos_transportistas.nombre ||
                ' , NEW 3.datos_transportistas.correo: ' || :NEW.datos_transportistas.correo ||
                ' , NEW 4.datos_transportistas.telefono.movil: ' || :NEW.datos_transportistas.telefono.movil ||
                ' , NEW 5.datos_transportistas.telefono.fijo: ' || :NEW.datos_transportistas.telefono.fijo ||
                ' , NEW  6.TIPO: ' || :NEW.TIPO;

    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion :=
        ' || OLD' ||
        ' | 1. ID_TRANSPORTISTA: ' || :OLD.ID_TRANSPORTISTA ||                                 
        ' | 2.datos_transportistas.nombre: ' || :OLD.datos_transportistas.nombre ||                    
        ' | 3.datos_transportistas.correo: ' || :OLD.datos_transportistas.correo ||                    
        ' | 4.datos_transportistas.telefono.movil: ' || :OLD.datos_transportistas.telefono.movil ||    
        ' | 5.datos_transportistas.telefono.fijo: ' || :OLD.datos_transportistas.telefono.fijo ||      
        ' | 6.TIPO: ' || :OLD.TIPO ;        

        v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
        ' , OLD 1. ID_TRANSPORTISTA: ' || :OLD.ID_TRANSPORTISTA ||   
        ' , OLD 2.datos_transportistas.nombre: ' || :OLD.datos_transportistas.nombre ||
        ' , OLD 3.datos_transportistas.correo: ' || :OLD.datos_transportistas.correo ||
        ' , OLD 4.datos_transportistas.telefono.movil: ' || :OLD.datos_transportistas.telefono.movil ||
        ' , OLD 5.datos_transportistas.telefono.fijo: ' || :OLD.datos_transportistas.telefono.fijo ||
        ' , OLD  6.TIPO: ' || :OLD.TIPO  ;
    END IF;

            -- Registrar log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  => v_accion_aud
    );

    -- Registrar log en el archivo CSV
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

END tg_Transportistas_AFTER; 

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  PERFILES
prompt +-------------------------------------------------------------+

--PERFILES BEFORE
CREATE OR REPLACE  TRIGGER tg_PERFILES_before
BEFORE INSERT OR UPDATE OR DELETE
ON PERFILES
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'PERFILES';
    
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion :=
        ' || NEW' ||
        ' | 1. ID_PERFIL: ' || :NEW.ID_PERFIL ||                                 
        ' | 2.ID_FORMULARIO: ' || :NEW.ID_FORMULARIO ||                    
        ' | 3.INSERTAR: ' || :NEW.INSERTAR ||                    
        ' | 4.ACTUALIZAR: ' || :NEW.ACTUALIZAR ||    
        ' | 5.ELIMINAR: ' || :NEW.ELIMINAR ;
        v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
                ' , NEW 1. ID_PERFIL: ' || :NEW.ID_PERFIL ||  
                ' , NEW 2. ID_FORMULARIO: ' || :NEW.ID_FORMULARIO ||   
                ' , NEW 3.INSERTAR: ' || :NEW.INSERTAR ||  
                ' , NEW 4.ACTUALIZAR: ' || :NEW.ACTUALIZAR ||
                ' , NEW 5.ELIMINAR: ' || :NEW.ELIMINAR ;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion :=
        ' || OLD' ||
        ' | 1. ID_PERFIL: ' || :OLD.ID_PERFIL ||                                 
        ' | 2.ID_FORMULARIO: ' || :OLD.ID_FORMULARIO ||                    
        ' | 3.INSERTAR: ' || :OLD.INSERTAR ||                    
        ' | 4.ACTUALIZAR: ' || :OLD.ACTUALIZAR ||    
        ' | 5.ELIMINAR: ' || :OLD.ELIMINAR ||
        ' || NEW' ||
        ' | 1. ID_PERFIL: ' || :NEW.ID_PERFIL ||                                 
        ' | 2.ID_FORMULARIO: ' || :NEW.ID_FORMULARIO ||                    
        ' | 3.INSERTAR: ' || :NEW.INSERTAR ||                    
        ' | 4.ACTUALIZAR: ' || :NEW.ACTUALIZAR ||    
        ' | 5.ELIMINAR: ' || :NEW.ELIMINAR ;

        v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
                ' , OLD 1. ID_PERFIL: ' || :OLD.ID_PERFIL ||  
                ' , OLD 2. ID_FORMULARIO: ' || :OLD.ID_FORMULARIO ||   
                ' , OLD 3.INSERTAR: ' || :OLD.INSERTAR ||  
                ' , OLD 4.ACTUALIZAR: ' || :OLD.ACTUALIZAR ||
                ' , OLD 5.ELIMINAR: ' || :OLD.ELIMINAR ||
                ' , NEW 1. ID_PERFIL: ' || :NEW.ID_PERFIL ||  
                ' , NEW 2. ID_FORMULARIO: ' || :NEW.ID_FORMULARIO ||   
                ' , NEW 3.INSERTAR: ' || :NEW.INSERTAR ||  
                ' , NEW 4.ACTUALIZAR: ' || :NEW.ACTUALIZAR ||
                ' , NEW 5.ELIMINAR: ' || :NEW.ELIMINAR ;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion :=
        ' || OLD' ||
        ' | 1. ID_PERFIL: ' || :OLD.ID_PERFIL ||                                 
        ' | 2.ID_FORMULARIO: ' || :OLD.ID_FORMULARIO ||                    
        ' | 3.INSERTAR: ' || :OLD.INSERTAR ||                    
        ' | 4.ACTUALIZAR: ' || :OLD.ACTUALIZAR ||    
        ' | 5.ELIMINAR: ' || :OLD.ELIMINAR ;
        v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
                ' , OLD 1. ID_PERFIL: ' || :OLD.ID_PERFIL ||  
                ' , OLD 2. ID_FORMULARIO: ' || :OLD.ID_FORMULARIO ||   
                ' , OLD 3.INSERTAR: ' || :OLD.INSERTAR ||  
                ' , OLD 4.ACTUALIZAR: ' || :OLD.ACTUALIZAR ||
                ' , OLD 5.ELIMINAR: ' || :OLD.ELIMINAR ;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END;
/

---> PERFILES AFTER

CREATE OR REPLACE  TRIGGER tg_PERFILES_AFTER
AFTER INSERT OR UPDATE OR DELETE
ON PERFILES
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10);
    v_momento VARCHAR2(10) := 'AFTER';
    v_accion VARCHAR2(500);
    v_accion_aud logs.ACCION_AUD%type;
    v_tabla VARCHAR2(50):= 'PERFILES';
    
BEGIN
    -- Determinar el tipo de evento
    IF INSERTING THEN
        v_evento := 'INSERT';
        v_accion :=
        ' || NEW' ||
        ' | 1. ID_PERFIL: ' || :NEW.ID_PERFIL ||                                 
        ' | 2.ID_FORMULARIO: ' || :NEW.ID_FORMULARIO ||                    
        ' | 3.INSERTAR: ' || :NEW.INSERTAR ||                    
        ' | 4.ACTUALIZAR: ' || :NEW.ACTUALIZAR ||    
        ' | 5.ELIMINAR: ' || :NEW.ELIMINAR ;
        v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
                ' , NEW 1. ID_PERFIL: ' || :NEW.ID_PERFIL ||  
                ' , NEW 2. ID_FORMULARIO: ' || :NEW.ID_FORMULARIO ||   
                ' , NEW 3.INSERTAR: ' || :NEW.INSERTAR ||  
                ' , NEW 4.ACTUALIZAR: ' || :NEW.ACTUALIZAR ||
                ' , NEW 5.ELIMINAR: ' || :NEW.ELIMINAR ;
    ELSIF UPDATING THEN
        v_evento := 'UPDATE';
        v_accion :=
        ' || OLD' ||
        ' | 1. ID_PERFIL: ' || :OLD.ID_PERFIL ||                                 
        ' | 2.ID_FORMULARIO: ' || :OLD.ID_FORMULARIO ||                    
        ' | 3.INSERTAR: ' || :OLD.INSERTAR ||                    
        ' | 4.ACTUALIZAR: ' || :OLD.ACTUALIZAR ||    
        ' | 5.ELIMINAR: ' || :OLD.ELIMINAR ||
        ' || NEW' ||
        ' | 1. ID_PERFIL: ' || :NEW.ID_PERFIL ||                                 
        ' | 2.ID_FORMULARIO: ' || :NEW.ID_FORMULARIO ||                    
        ' | 3.INSERTAR: ' || :NEW.INSERTAR ||                    
        ' | 4.ACTUALIZAR: ' || :NEW.ACTUALIZAR ||    
        ' | 5.ELIMINAR: ' || :NEW.ELIMINAR ;

        v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
                ' , OLD 1. ID_PERFIL: ' || :OLD.ID_PERFIL ||  
                ' , OLD 2. ID_FORMULARIO: ' || :OLD.ID_FORMULARIO ||   
                ' , OLD 3.INSERTAR: ' || :OLD.INSERTAR ||  
                ' , OLD 4.ACTUALIZAR: ' || :OLD.ACTUALIZAR ||
                ' , OLD 5.ELIMINAR: ' || :OLD.ELIMINAR ||
                ' , NEW 1. ID_PERFIL: ' || :NEW.ID_PERFIL ||  
                ' , NEW 2. ID_FORMULARIO: ' || :NEW.ID_FORMULARIO ||   
                ' , NEW 3.INSERTAR: ' || :NEW.INSERTAR ||  
                ' , NEW 4.ACTUALIZAR: ' || :NEW.ACTUALIZAR ||
                ' , NEW 5.ELIMINAR: ' || :NEW.ELIMINAR ;
    ELSIF DELETING THEN
        v_evento := 'DELETE';
        v_accion :=
        ' || OLD' ||
        ' | 1. ID_PERFIL: ' || :OLD.ID_PERFIL ||                                 
        ' | 2.ID_FORMULARIO: ' || :OLD.ID_FORMULARIO ||                    
        ' | 3.INSERTAR: ' || :OLD.INSERTAR ||                    
        ' | 4.ACTUALIZAR: ' || :OLD.ACTUALIZAR ||    
        ' | 5.ELIMINAR: ' || :OLD.ELIMINAR ;
        v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
                ' , OLD 1. ID_PERFIL: ' || :OLD.ID_PERFIL ||  
                ' , OLD 2. ID_FORMULARIO: ' || :OLD.ID_FORMULARIO ||   
                ' , OLD 3.INSERTAR: ' || :OLD.INSERTAR ||  
                ' , OLD 4.ACTUALIZAR: ' || :OLD.ACTUALIZAR ||
                ' , OLD 5.ELIMINAR: ' || :OLD.ELIMINAR ;
    END IF;

    -- Llamar al procedimiento para insertar el log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  =>  v_accion_aud
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
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla   FORMULARIOS         
prompt +-------------------------------------------------------------+

DROP SEQUENCE seq_id_formulario;
CREATE SEQUENCE seq_id_formulario START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER tg_Val_Formularios_insert_before
BEFORE INSERT
ON Formularios
FOR EACH ROW
DECLARE
    v_evento VARCHAR2(10) := 'INSERT';
    v_momento VARCHAR2(10) := 'BEFORE';
    v_accion VARCHAR2(500);
    v_accion_aud VARCHAR2(500);
    v_tabla VARCHAR2(50) := 'FORMULARIOS';

    -- Excepciones
    ex_nodo_principal_duplicado EXCEPTION;
    ex_nodo_principal_sin_padre EXCEPTION;
    ex_padre_no_es_modulo EXCEPTION;
BEGIN
    SELECT seq_id_formulario.NEXTVAL INTO :new.ID_FORMULARIO FROM dual;

    -- Asegurar que el nodo principal sea también un módulo
    IF :new.NODO_PRINCIPAL = 1 THEN
        :new.MODULO := 1;
    END IF;

    -- Validar nodo principal único
    IF pkg_formularios.fn_existe_nodo_principal AND :new.NODO_PRINCIPAL = 1 THEN
        RAISE ex_nodo_principal_duplicado;
    END IF;

    -- Validar ID padre para nodo principal
    IF :new.NODO_PRINCIPAL = 1 THEN
        IF :new.ID_PADRE IS NOT NULL THEN
            RAISE ex_nodo_principal_sin_padre;
        END IF;
    ELSE
        -- Validar ID padre no nulo
        IF :new.ID_PADRE IS NULL THEN
            RAISE ex_nodo_principal_sin_padre;
        ELSE
            -- Validar que el padre sea un módulo
            IF NOT pkg_formularios.fn_padre_es_modulo(:new.ID_PADRE) THEN
                RAISE ex_padre_no_es_modulo;
            END IF;
        END IF;
    END IF;

    -- Validación de orden: si no se ingresa, asignar el siguiente número de orden
    IF :new.ORDEN IS NULL THEN
        :new.ORDEN := pkg_formularios.fn_obtener_siguiente_orden(:new.ID_PADRE);
    END IF;

    -- Crear mensajes de log
    v_accion := '|| NEW | 1. ID_FORMULARIO: ' || :NEW.ID_FORMULARIO || 
                ' | 2. NOMBRE_FORMULARIO: ' || :NEW.NOMBRE_FORMULARIO ||       
                ' | 3. NODO_PRINCIPAL: ' || :NEW.NODO_PRINCIPAL || 
                ' | 4. MODULO: ' || :NEW.MODULO || 
                ' | 5. ID_PADRE: ' || :NEW.ID_PADRE || 
                ' | 6. ORDEN: ' || :NEW.ORDEN || 
                ' | 7. URL: ' || :NEW.URL;

    v_accion_aud :=
        'TABLA: ' ||v_tabla ||' => '||
        ' , NEW 1.  ID_FORMULARIO: ' || :NEW.ID_FORMULARIO || 
        ' , NEW 2.NOMBRE_FORMULARIO: ' || :NEW.NOMBRE_FORMULARIO || 
        ' , NEW 3.NODO_PRINCIPAL: ' || :NEW.NODO_PRINCIPAL || 
        ' , NEW 4. MODULO: ' || :NEW.MODULO || 
        ' , NEW 5.ID_PADRE: ' || :NEW.ID_PADRE || 
        ' , NEW 6. ORDEN: ' || :NEW.ORDEN || 
        ' , NEW 7. URL: ' || :NEW.URL;

    -- Registrar log en la tabla
    pkg_manejo_logs.pr_insertar_log_tabla(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  => v_accion_aud
    );

    -- Registrar log en el archivo CSV
    pkg_manejo_logs.pr_insertar_log_archivo(
        p_evento  => v_evento,
        p_momento => v_momento,
        p_accion  => v_accion,
        p_tabla   => v_tabla
    );

EXCEPTION
    WHEN ex_nodo_principal_duplicado THEN
        :NEW.NODO_PRINCIPAL := 0;
        DBMS_OUTPUT.PUT_LINE('Ya existe un nodo principal en la tabla Formularios.');
    WHEN ex_nodo_principal_sin_padre THEN
        :NEW.ID_PADRE := NULL;  
        DBMS_OUTPUT.PUT_LINE('El nodo principal no puede tener un padre si no es el nodo principal.');
    WHEN ex_padre_no_es_modulo THEN
        RAISE_APPLICATION_ERROR(-20003, 'El ID padre debe ser un módulo (Modulo = 1)');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Comuníquese con el responsable del área.');
        DBMS_OUTPUT.PUT_LINE('Código de error: ' || SQLCODE || ' - Mensaje: ' || SQLERRM);
END;
/


CREATE OR REPLACE TRIGGER tg_Val_Formularios_before_update
BEFORE UPDATE
ON Formularios
FOR EACH ROW
BEGIN
    -- Crear el mensaje de log con valores OLD y NEW
    pkg_formularios.pr_preparar_datos_log(
        p_accion => '|| OLD | 1. ID_FORMULARIO: ' || :OLD.ID_FORMULARIO || 
                    ' | 2. NOMBRE_FORMULARIO: ' || :OLD.NOMBRE_FORMULARIO ||       
                    ' | 3. NODO_PRINCIPAL: ' || :OLD.NODO_PRINCIPAL || 
                    ' | 4. MODULO: ' || :OLD.MODULO || 
                    ' | 5. ID_PADRE: ' || :OLD.ID_PADRE || 
                    ' | 6. ORDEN: ' || :OLD.ORDEN || 
                    ' | 7. URL: ' || :OLD.URL || 
                    ' || NEW | 1. ID_FORMULARIO: ' || :NEW.ID_FORMULARIO || 
                    ' | 2. NOMBRE_FORMULARIO: ' || :NEW.NOMBRE_FORMULARIO ||       
                    ' | 3. NODO_PRINCIPAL: ' || :NEW.NODO_PRINCIPAL || 
                    ' | 4. MODULO: ' || :NEW.MODULO || 
                    ' | 5. ID_PADRE: ' || :NEW.ID_PADRE || 
                    ' | 6. ORDEN: ' || :NEW.ORDEN || 
                    ' | 7. URL: ' || :NEW.URL,
                    
        p_accion_aud => 'TABLA: FORMULARIOS => ' || 
                    ' , OLD 1. ID_FORMULARIO: ' || :OLD.ID_FORMULARIO || 
                    ' , OLD 2. NOMBRE_FORMULARIO: ' || :OLD.NOMBRE_FORMULARIO ||       
                    ' , OLD 3. NODO_PRINCIPAL: ' || :OLD.NODO_PRINCIPAL || 
                    ' , OLD 4. MODULO: ' || :OLD.MODULO || 
                    ' , OLD 5. ID_PADRE: ' || :OLD.ID_PADRE || 
                    ' , OLD 6. ORDEN: ' || :OLD.ORDEN || 
                    ' , OLD 7. URL: ' || :OLD.URL || 
                    ' , NEW 1. ID_FORMULARIO: ' || :NEW.ID_FORMULARIO || 
                    ' , NEW 2. NOMBRE_FORMULARIO: ' || :NEW.NOMBRE_FORMULARIO ||       
                    ' , NEW 3. NODO_PRINCIPAL: ' || :NEW.NODO_PRINCIPAL || 
                    ' , NEW 4. MODULO: ' || :NEW.MODULO || 
                    ' , NEW 5. ID_PADRE: ' || :NEW.ID_PADRE || 
                    ' , NEW 6. ORDEN: ' || :NEW.ORDEN || 
                    ' , NEW 7. URL: ' || :NEW.URL
    );
END;
/

CREATE OR REPLACE TRIGGER tg_Val_Formularios_after_update
AFTER UPDATE
ON Formularios
BEGIN
    -- Registrar los logs usando los datos preparados en el paquete
    pkg_formularios.pr_registrar_log_update;
    
END;
/
