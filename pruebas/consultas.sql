prompt +-------------------------------------------------------------+
prompt |            SELECTS DE OBJECTOS    
prompt +-------------------------------------------------------------+

--TIPOS_MOVIMIENTOS
SELECT 
    d.tipo_movimiento.id AS ID_T_MOVIMIENTO,
    d.tipo_movimiento.nombre AS NOMBRE_T_MOVIMIENTO
FROM 
    US_NATURAANTIOQUIA.TIPOS_MOVIMIENTOS d;


--SEGUIMIENTOS
SELECT 
    d.seguimiento.id AS ID_SEGUIMIENTO,
    d.seguimiento.nombre AS NOMBRE_SEGUIMIENTO
FROM 
    US_NATURAANTIOQUIA.SEGUIMIENTOS d;

SELECT 
    d.prioridad.id AS ID_PRIORIDAD,
    d.prioridad.nombre AS NOMBRE_PRIORIDADES
FROM 
    US_NATURAANTIOQUIA.PRIORIDADES d;


SELECT 
    d.tipo_descuento.id AS ID_TIPO_DESC,
    d.tipo_descuento.nombre AS NOMBRE_TIPO_DESC
FROM 
    US_NATURAANTIOQUIA.TIPOS_DESCUENTOS d;

SELECT 
    d.tipo_valor.id AS ID_TIPO_VALOR,
    d.tipo_valor.nombre AS NOMBRE_TIPO_VALOR
FROM 
    US_NATURAANTIOQUIA.TIPOS_VALORES d;

SELECT 
    d.tipo_transportista.id AS ID_TIPO_TRANSPORTISTA,
    d.tipo_transportista.nombre AS NOMBRE_TIPO_TRANSPORTISTA
FROM 
    US_NATURAANTIOQUIA.TIPOS_TRANSPORTISTAS d;

SELECT 
    d.sexo.id AS ID_SEXO,
    d.sexo.nombre AS NOMBRE_SEXO
FROM 
    US_NATURAANTIOQUIA.SEXOS d;


SELECT 
    d.estado_usuario.id AS ID_ESTADO_USUARIO,
    d.estado_usuario.nombre AS NOMBRE_ESTADO
FROM 
    US_NATURAANTIOQUIA.ESTADOS_USUARIOS d;


SELECT 
    d.tipo_documento.id AS ID_DOCUMENTO,
    d.tipo_documento.nombre AS NOMBRE_DOCUMENTO
FROM 
    US_NATURAANTIOQUIA.TIPOS_DOCUMENTOS d;

SELECT 
    d.estado_laboratorio.id AS ID_DOCUMENTO,
    d.estado_laboratorio.nombre AS NOMBRE_DOCUMENTO
FROM 
    US_NATURAANTIOQUIA.estados_laboratorios d;

prompt +-------------------------------------------------------------+
prompt |            UPDATES DE OBJECTOS    
prompt +-------------------------------------------------------------+

 UPDATE ESTADOS_LABORATORIOS el
    SET el.estado_laboratorio.nombre = 'Cmbio en 133'
    WHERE el.estado_laboratorio.id = 133;

UPDATE USUARIOS el set el.datos_usuario.nombre = 'Juan IV', el.datos_usuario.telefono.movil = 3008020158 WHERE DOCUMENTO_USUARIO = '123456717';

UPDATE laboratorios el set el.datos_laboratorios.nombre = 'Juan IV Labora' where id_laboratorio = 1;

INSERT INTO TRANSPORTISTAS(datos_transportistas,TIPO) VALUES (contacto('Test transportista',telefonos(6000000000, 3008020156),'test_transpor@1example.com'),3);

UPDATE TRANSPORTISTAS el set el.datos_transportistas.nombre = 'Labo IV Labid_transportista' where id_transportista =  2 ;


prompt +-------------------------------------------------------------+
prompt |            INSERTAR  OBJECTOS USUARIO    
prompt +-------------------------------------------------------------+

INSERT INTO USUARIOS 
    (
        DOCUMENTO_USUARIO,
        datos_usuario,
        PRIMER_APELLIDO_USUARIO,
        SEGUNDO_APELLIDO_USUARIO,
        PASSWORD_USUARIO,
        FECHA_NACIMIENTO_USUARIO,
        TIPO_DOCUMENTO,
        ESTADO_USUARIO,
        SEXO_USUARIO,
        ROL_USUARIO
    ) 
    VALUES 
    (
        123456789, -- DOCUMENTO_USUARIO
        contacto(
            'Juan Perez', -- nombre
            telefonos(1234567, 987654321), -- telefono (fijo, movil)
            'juan.perez@example.com' -- correo
        ),
        'Perez', -- PRIMER_APELLIDO_USUARIO
        'Garcia', -- SEGUNDO_APELLIDO_USUARIO
        'securepassword', -- PASSWORD_USUARIO
        TO_DATE('1985-07-25', 'YYYY-MM-DD'), -- FECHA_NACIMIENTO_USUARIO
        1, -- TIPO_DOCUMENTO
        1, -- ESTADO_USUARIO
        1, -- SEXO_USUARIO
        1  -- ROL_USUARIO
    );

INSERT INTO laboratorios(datos_laboratorios,estado_laboratorio) VALUES (contacto('Natu vip',telefonos(6000000000, 3008020156),'1laboratorio2@1example.com'),158);

INSERT INTO TRANSPORTISTAS(datos_transportistas,TIPO) VALUES (contacto('Test transportista',telefonos(6000000000, 3008020156),'test_transpor@1example.com'),3);




---------Pruebas
DECLARE
    v_usuarios SYS_REFCURSOR;
    v_documento_usuario INTEGER;
    v_nombre_usuario VARCHAR2(150);
    v_primer_apellido VARCHAR2(50);
    v_segundo_apellido VARCHAR2(50);
    v_password VARCHAR2(100);
    v_fecha_nacimiento DATE;
    v_telefono_fijo INTEGER;
    v_celular INTEGER;
    v_correo VARCHAR2(100);
    v_tipo_documento VARCHAR2(50);
    v_estado_usuario VARCHAR2(50);
    v_sexo VARCHAR2(50);
    v_rol VARCHAR2(50);
BEGIN
    -- Llamada a la función del paquete para obtener los datos
    v_usuarios := pkg_usuarios.fn_obtener_usuarios;

    -- Bucle para leer los datos
    LOOP
        FETCH v_usuarios INTO v_documento_usuario, v_nombre_usuario, v_primer_apellido, v_segundo_apellido,
                            v_password, v_fecha_nacimiento, v_telefono_fijo, v_celular, v_correo,
                            v_tipo_documento, v_estado_usuario, v_sexo, v_rol;
        EXIT WHEN v_usuarios%NOTFOUND;

        -- Aquí puedes procesar cada fila, por ejemplo, mostrarla
        DBMS_OUTPUT.PUT_LINE('Usuario: ' || v_nombre_usuario || ' ' || v_primer_apellido || ' ' || v_segundo_apellido ||
                             ', Documento: ' || v_documento_usuario ||
                             ', Rol: ' || v_rol || ', Estado: ' || v_estado_usuario ||
                             ', Sexo: ' || v_sexo || ', Tipo de Documento: ' || v_tipo_documento);
    END LOOP;

    -- Cerrar el cursor
    CLOSE v_usuarios;
END;
/

set SERVEROUTPUT on;

SELECT td.tipo_documento.id, td.tipo_documento.nombre FROM tipos_documentos td;

select rl.rol.id,rl.rol.nombre  from roles rl;


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
            LEFT JOIN ROLES r ON u.ROL_USUARIO = r.rol.id where u.DOCUMENTO_USUARIO = 12345678;



UPDATE USUARIOS u set 
    
    u.datos_usuario.nombre = 'Juan IV', 
    u.PRIMER_APELLIDO_USUARIO =,
    u.SEGUNDO_APELLIDO_USUARIO =,
    u.PASSWORD_USUARIO =,
    u.FECHA_NACIMIENTO_USUARIO =,
    u.datos_usuario.telefono.fijo = ,
    u.datos_usuario.telefono.movil = 3008020158,
    u.datos_usuario.correo =,
    u.TIPO_DOCUMENTO =,
    u.ESTADO_USUARIO =,
    u.SEXO_USUARIO =,
    u.ROL_USUARIO =

WHERE DOCUMENTO_USUARIO = '12345678';

INSERT INTO roles (rol) values (elemento(1,'Cliente'));
INSERT INTO roles (rol) values (elemento(2,'Administrador '));
INSERT INTO roles (rol) values (elemento(3,'Delegado '));
INSERT INTO roles (rol) values (elemento(4,'Inventarios '));
INSERT INTO roles (rol) values (elemento(5,'Vendedor '));

UPDATE roles rl SET rl.rol.nombre = 'Administrador ' WHERE rl.rol.id = 2;

select rl.rol.id,rl.rol.nombre  from roles rl;

select  rl..id,rl.rol.nombre  from esta rl;

SELECT  eu.estado_usuario.id, eu.estado_usuario.nombre FROM ESTADOS_USUARIOS eu;

COMMIT;

SELECT 
    u.DOCUMENTO_USUARIO,
    u.datos_usuario.nombre AS nombre_usuario,
    u.PRIMER_APELLIDO_USUARIO,
    u.SEGUNDO_APELLIDO_USUARIO,
    r.rol.nombre AS nombre_rol
FROM 
    USUARIOS u
JOIN 
    ROLES r ON u.ROL_USUARIO = r.rol.id
WHERE 
    u.DOCUMENTO_USUARIO = 2292738139;  -- Reemplaza ":documento_usuario" por el ID del usuario que deseas consultar


SELECT COUNT(*) AS TOTAL FROM USUARIOS;



BEGIN
    pkg_usuarios.pr_actualizar_documento_usuario(
        p_documento_usuario_actual => 123456789, -- Documento actual
        p_documento_usuario_nuevo => 99999999   -- Nuevo documento
    );
END;
/
