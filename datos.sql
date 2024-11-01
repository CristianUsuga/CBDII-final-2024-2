
prompt +-------------------------------------------------+
prompt |    Datos de la Tabla  ESTADOS_LABORATORIOS      |
prompt +-------------------------------------------------+


INSERT INTO "US_NATURAANTIOQUIA"."ESTADOS_LABORATORIOS"
VALUES (elemento(1, 'Activo'));

INSERT INTO US_NATURAANTIOQUIA.ESTADOS_LABORATORIOS 
VALUES (elemento(2, 'Desactivado'));


prompt +-------------------------------------------------+
prompt |    Datos de la Tabla  TIPOS_MOVIMIENTOS      |
prompt +-------------------------------------------------+
INSERT INTO US_NATURAANTIOQUIA.TIPOS_MOVIMIENTOS 
VALUES (elemento(1, 'Compras de productos nuevos.'));

INSERT INTO US_NATURAANTIOQUIA.TIPOS_MOVIMIENTOS 
VALUES (elemento(2, 'Devoluciones de clientes.'));

INSERT INTO US_NATURAANTIOQUIA.TIPOS_MOVIMIENTOS 
VALUES (elemento(3, 'Producción interna de productos.'));

INSERT INTO US_NATURAANTIOQUIA.TIPOS_MOVIMIENTOS 
VALUES (elemento(4, 'Ventas físicas en tiendas.'));

INSERT INTO US_NATURAANTIOQUIA.TIPOS_MOVIMIENTOS 
VALUES (elemento(5, 'Ventas en línea.'));

INSERT INTO US_NATURAANTIOQUIA.TIPOS_MOVIMIENTOS 
VALUES (elemento(6, 'Pérdidas o daños de productos.'));

INSERT INTO US_NATURAANTIOQUIA.TIPOS_MOVIMIENTOS 
VALUES (elemento(7, 'Caducidad de productos.'));

INSERT INTO US_NATURAANTIOQUIA.TIPOS_MOVIMIENTOS 
VALUES (elemento(8, 'Cambios en los precios de los productos.'));


prompt +-------------------------------------------------+
prompt |    Datos de la Tabla SEGUIMIENTOS       |
prompt +-------------------------------------------------+

INSERT INTO US_NATURAANTIOQUIA.SEGUIMIENTOS 
VALUES (elemento(1, 'Recibido'));

INSERT INTO US_NATURAANTIOQUIA.SEGUIMIENTOS 
VALUES (elemento(2, 'En proceso'));

INSERT INTO US_NATURAANTIOQUIA.SEGUIMIENTOS 
VALUES (elemento(3, 'Aprobado'));

INSERT INTO US_NATURAANTIOQUIA.SEGUIMIENTOS 
VALUES (elemento(4, 'Enviado'));

INSERT INTO US_NATURAANTIOQUIA.SEGUIMIENTOS 
VALUES (elemento(5, 'Entregado'));

INSERT INTO US_NATURAANTIOQUIA.SEGUIMIENTOS 
VALUES (elemento(6, 'Cancelado'));

INSERT INTO US_NATURAANTIOQUIA.SEGUIMIENTOS 
VALUES (elemento(7, 'Rechazado'));

INSERT INTO US_NATURAANTIOQUIA.SEGUIMIENTOS 
VALUES (elemento(8, 'En devolución'));

INSERT INTO US_NATURAANTIOQUIA.SEGUIMIENTOS 
VALUES (elemento(9, 'Completado'));

prompt +-------------------------------------------------+
prompt |    Datos de la Tabla PRIORIDADES       |
prompt +-------------------------------------------------+

INSERT INTO US_NATURAANTIOQUIA.PRIORIDADES 
VALUES (elemento(1, 'Prioritario'));

INSERT INTO US_NATURAANTIOQUIA.PRIORIDADES 
VALUES (elemento(2, 'Esencial'));

INSERT INTO US_NATURAANTIOQUIA.PRIORIDADES 
VALUES (elemento(3, 'Estándar'));

INSERT INTO US_NATURAANTIOQUIA.PRIORIDADES 
VALUES (elemento(4, 'Bajo'));

prompt +-------------------------------------------------+
prompt |    Datos de la Tabla TIPOS_DESCUENTOS       |
prompt +-------------------------------------------------+

INSERT INTO US_NATURAANTIOQUIA.TIPOS_DESCUENTOS 
VALUES (elemento(1, 'Temporalidad'));

INSERT INTO US_NATURAANTIOQUIA.TIPOS_DESCUENTOS 
VALUES (elemento(2, 'Promocionales'));

INSERT INTO US_NATURAANTIOQUIA.TIPOS_DESCUENTOS 
VALUES (elemento(3, 'Volumen'));

prompt +-------------------------------------------------+
prompt |    Datos de la Tabla TIPOS_VALORES       |
prompt +-------------------------------------------------+
INSERT INTO US_NATURAANTIOQUIA.TIPOS_VALORES 
VALUES (elemento(1, 'Porcentaje'));

INSERT INTO US_NATURAANTIOQUIA.TIPOS_VALORES 
VALUES (elemento(2, 'Cantidad'));

prompt +-------------------------------------------------+
prompt |    Datos de la Tabla TIPOS_TRANSPORTISTAS       |
prompt +-------------------------------------------------+
INSERT INTO US_NATURAANTIOQUIA.TIPOS_TRANSPORTISTAS 
VALUES (elemento(1, 'Individual'));

INSERT INTO US_NATURAANTIOQUIA.TIPOS_TRANSPORTISTAS 
VALUES (elemento(2, 'Corporativo'));

prompt +-------------------------------------------------+
prompt |        Datos de la Tabla SEXOS       |
prompt +-------------------------------------------------+
INSERT INTO US_NATURAANTIOQUIA.SEXOS 
VALUES (elemento(1, 'Masculino'));

INSERT INTO US_NATURAANTIOQUIA.SEXOS 
VALUES (elemento(2, 'Femenino'));

prompt +-------------------------------------------------+
prompt |        Datos de la Tabla ESTADOS_USUARIOS       |
prompt +-------------------------------------------------+
INSERT INTO US_NATURAANTIOQUIA.ESTADOS_USUARIOS 
VALUES (elemento(1, 'Activo'));

INSERT INTO US_NATURAANTIOQUIA.ESTADOS_USUARIOS 
VALUES (elemento(2, 'Inactivo'));

INSERT INTO US_NATURAANTIOQUIA.ESTADOS_USUARIOS 
VALUES (elemento(3, 'Bloqueado'));


prompt +-------------------------------------------------+
prompt |        Datos de la Tabla TIPOS_DOCUMENTOS       |
prompt +-------------------------------------------------+

INSERT INTO US_NATURAANTIOQUIA.TIPOS_DOCUMENTOS 
VALUES (elemento(1, 'Tarjeta de Identidad'));

INSERT INTO US_NATURAANTIOQUIA.TIPOS_DOCUMENTOS 
VALUES (elemento(2, 'Cédula de Ciudadanía'));

INSERT INTO US_NATURAANTIOQUIA.TIPOS_DOCUMENTOS 
VALUES (elemento(3, 'Cédula de Extranjería'));


--PRUEBA

--INSERT INTO "US_NATURAANTIOQUIA"."LOGS" (FECHA_AUD, USUARIO_AUD, EVENTO_AUD, MOMENTO_AUD, ACCION_AUD) VALUES (TO_DATE('2024-10-10 18:56:13', 'YYYY-MM-DD HH24:MI:SS'), 'SYSTEM', 'UPDATE', 'AFTER', 'TABLANDDFLSKDJLSKDSD')
