SELECT 
    d.tipo_movimiento.id AS ID_T_MOVIMIENTO,
    d.tipo_movimiento.nombre AS NOMBRE_T_MOVIMIENTO
FROM 
    US_NATURAANTIOQUIA.TIPOS_MOVIMIENTOS d;



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

