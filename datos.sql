
prompt +-------------------------------------------------+
prompt |    Datos de la Tabla  ESTADOS_LABORATORIOS      |
prompt +-------------------------------------------------+


INSERT INTO "US_NATURAANTIOQUIA"."ESTADOS_LABORATORIOS" (ID_ESTADO_LAB, NOMBRE_EST_LAB) VALUES ('1', 'Activo');
INSERT INTO "US_NATURAANTIOQUIA"."ESTADOS_LABORATORIOS" (ID_ESTADO_LAB, NOMBRE_EST_LAB) VALUES ('2', 'Desactivado');


prompt +-------------------------------------------------+
prompt |    Datos de la Tabla  TIPOS_MOVIMIENTOS      |
prompt +-------------------------------------------------+
INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_MOVIMIENTOS" (ID_T_MOVIMIENTO, NOMBRE_T_MOVIMIENTO) VALUES ('1', 'Compras de productos nuevos.');
INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_MOVIMIENTOS" (ID_T_MOVIMIENTO, NOMBRE_T_MOVIMIENTO) VALUES ('2', 'Devoluciones de clientes.');
INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_MOVIMIENTOS" (ID_T_MOVIMIENTO, NOMBRE_T_MOVIMIENTO) VALUES ('3', 'Producción interna de productos.');
INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_MOVIMIENTOS" (ID_T_MOVIMIENTO, NOMBRE_T_MOVIMIENTO) VALUES ('4', 'Ventas físicas en tiendas.');
INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_MOVIMIENTOS" (ID_T_MOVIMIENTO, NOMBRE_T_MOVIMIENTO) VALUES ('5', 'Ventas en línea.');
INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_MOVIMIENTOS" (ID_T_MOVIMIENTO, NOMBRE_T_MOVIMIENTO) VALUES ('6', 'Pérdidas o daños de productos.');
INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_MOVIMIENTOS" (ID_T_MOVIMIENTO, NOMBRE_T_MOVIMIENTO) VALUES ('7', 'Caducidad de productos.');
INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_MOVIMIENTOS" (ID_T_MOVIMIENTO, NOMBRE_T_MOVIMIENTO) VALUES ('8', 'Cambios en los precios de los productos.');

prompt +-------------------------------------------------+
prompt |    Datos de la Tabla SEGUIMIENTOS       |
prompt +-------------------------------------------------+

INSERT INTO "US_NATURAANTIOQUIA"."SEGUIMIENTOS" (ID_SEGUIMIENTO, NOMBRE_SEGUIMIENTO) VALUES ('1', 'Recibido');
INSERT INTO "US_NATURAANTIOQUIA"."SEGUIMIENTOS" (ID_SEGUIMIENTO, NOMBRE_SEGUIMIENTO) VALUES ('2', 'En proceso');
INSERT INTO "US_NATURAANTIOQUIA"."SEGUIMIENTOS" (ID_SEGUIMIENTO, NOMBRE_SEGUIMIENTO) VALUES ('3', 'Aprobado');
INSERT INTO "US_NATURAANTIOQUIA"."SEGUIMIENTOS" (ID_SEGUIMIENTO, NOMBRE_SEGUIMIENTO) VALUES ('4', 'Enviado');
INSERT INTO "US_NATURAANTIOQUIA"."SEGUIMIENTOS" (ID_SEGUIMIENTO, NOMBRE_SEGUIMIENTO) VALUES ('5', 'Entregado');
INSERT INTO "US_NATURAANTIOQUIA"."SEGUIMIENTOS" (ID_SEGUIMIENTO, NOMBRE_SEGUIMIENTO) VALUES ('6', 'Cancelado');
INSERT INTO "US_NATURAANTIOQUIA"."SEGUIMIENTOS" (ID_SEGUIMIENTO, NOMBRE_SEGUIMIENTO) VALUES ('7', 'Rechazado');
INSERT INTO "US_NATURAANTIOQUIA"."SEGUIMIENTOS" (ID_SEGUIMIENTO, NOMBRE_SEGUIMIENTO) VALUES ('8', 'En devolución');
INSERT INTO "US_NATURAANTIOQUIA"."SEGUIMIENTOS" (ID_SEGUIMIENTO, NOMBRE_SEGUIMIENTO) VALUES ('9', 'Completado');

prompt +-------------------------------------------------+
prompt |    Datos de la Tabla PRIORIDADES       |
prompt +-------------------------------------------------+

INSERT INTO "US_NATURAANTIOQUIA"."PRIORIDADES" (ID_PRIORIDAD, NOMBRE_PRIORIDADES) VALUES ('1', 'Prioritario');
INSERT INTO "US_NATURAANTIOQUIA"."PRIORIDADES" (ID_PRIORIDAD, NOMBRE_PRIORIDADES) VALUES ('2', 'Esencial');
INSERT INTO "US_NATURAANTIOQUIA"."PRIORIDADES" (ID_PRIORIDAD, NOMBRE_PRIORIDADES) VALUES ('3', 'Estándar');
INSERT INTO "US_NATURAANTIOQUIA"."PRIORIDADES" (ID_PRIORIDAD, NOMBRE_PRIORIDADES) VALUES ('4', 'Bajo');


prompt +-------------------------------------------------+
prompt |    Datos de la Tabla TIPOS_DESCUENTOS       |
prompt +-------------------------------------------------+

INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_DESCUENTOS" (ID_TIPO_DESC, NOMBRE_TIPO_DESC) VALUES ('1', 'Temporalidad');
INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_DESCUENTOS" (ID_TIPO_DESC, NOMBRE_TIPO_DESC) VALUES ('2', 'Promocionales');
INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_DESCUENTOS" (ID_TIPO_DESC, NOMBRE_TIPO_DESC) VALUES ('3', 'Volumen');


prompt +-------------------------------------------------+
prompt |    Datos de la Tabla TIPOS_VALORES       |
prompt +-------------------------------------------------+
INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_VALORES" (ID_TIPO_VALOR, NOMBRE_TIPO_VALOR) VALUES ('1', 'Porcentaje');
INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_VALORES" (ID_TIPO_VALOR, NOMBRE_TIPO_VALOR) VALUES ('2', 'Cantidad');

prompt +-------------------------------------------------+
prompt |    Datos de la Tabla TIPOS_TRANSPORTISTAS       |
prompt +-------------------------------------------------+
INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_TRANSPORTISTAS" (ID_TIPO_TRANSPORTISTA, NOMBRE_PRIORIDADES) VALUES ('1', 'Individual');
INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_TRANSPORTISTAS" (ID_TIPO_TRANSPORTISTA, NOMBRE_PRIORIDADES) VALUES ('2', 'Corporativo');

prompt +-------------------------------------------------+
prompt |        Datos de la Tabla SEXOS       |
prompt +-------------------------------------------------+
INSERT INTO "US_NATURAANTIOQUIA"."SEXOS" (ID_SEXO, NOMBRE_SEXO) VALUES ('1', 'Masculino');
INSERT INTO "US_NATURAANTIOQUIA"."SEXOS" (ID_SEXO, NOMBRE_SEXO) VALUES ('2', 'Femenino');


prompt +-------------------------------------------------+
prompt |        Datos de la Tabla ESTADOS_USUARIOS       |
prompt +-------------------------------------------------+
INSERT INTO "US_NATURAANTIOQUIA"."ESTADOS_USUARIOS" (ID_ESTADO_USUARIOS, NOMBRE_ESTADO) VALUES ('1', 'Activo');
INSERT INTO "US_NATURAANTIOQUIA"."ESTADOS_USUARIOS" (ID_ESTADO_USUARIOS, NOMBRE_ESTADO) VALUES ('2', 'Inactivo');
INSERT INTO "US_NATURAANTIOQUIA"."ESTADOS_USUARIOS" (ID_ESTADO_USUARIOS, NOMBRE_ESTADO) VALUES ('3', 'Bloqueado');


prompt +-------------------------------------------------+
prompt |        Datos de la Tabla TIPOS_DOCUMENTOS       |
prompt +-------------------------------------------------+

INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_DOCUMENTOS" (ID_DOCUMENTO, NOMBRE_DOCUMENTO) VALUES ('1', 'Tarjeta de Identidad');
INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_DOCUMENTOS" (ID_DOCUMENTO, NOMBRE_DOCUMENTO) VALUES ('2', 'Cédula de Ciudadanía');
INSERT INTO "US_NATURAANTIOQUIA"."TIPOS_DOCUMENTOS" (ID_DOCUMENTO, NOMBRE_DOCUMENTO) VALUES ('3', 'Cédula de Extranjería');



--PRUEBA

--INSERT INTO "US_NATURAANTIOQUIA"."LOGS" (FECHA_AUD, USUARIO_AUD, EVENTO_AUD, MOMENTO_AUD, ACCION_AUD) VALUES (TO_DATE('2024-10-10 18:56:13', 'YYYY-MM-DD HH24:MI:SS'), 'SYSTEM', 'UPDATE', 'AFTER', 'TABLANDDFLSKDJLSKDSD')