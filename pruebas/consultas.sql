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
