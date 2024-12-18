
prompt +-------------------------------------------------------------+
prompt |           Añadiendo Constraints a las Tablas           |
prompt +-------------------------------------------------------------+

---------------------------------------ESTADOS_USUARIOS----------------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla ESTADOS_USUARIOS  |
prompt +--------------------------------------------------------+

ALTER TABLE ESTADOS_USUARIOS
ADD CONSTRAINT pk_id_estado_usuarios PRIMARY KEY (estado_usuario.id);

ALTER TABLE ESTADOS_USUARIOS
ADD CONSTRAINT nn_nombre_estado_usuarios CHECK (estado_usuario.nombre IS NOT NULL);

------------------------------------------TIPOS_DOCUMENTOS-------------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla TIPOS_DOCUMENTOS  |
prompt +--------------------------------------------------------+

ALTER TABLE TIPOS_DOCUMENTOS
ADD CONSTRAINT pk_id_documento_tipos_documentos PRIMARY KEY (tipo_documento.id );

ALTER TABLE TIPOS_DOCUMENTOS
ADD CONSTRAINT nn_nom_documento_tipos_documentos CHECK ( tipo_documento.nombre IS NOT NULL);


------------------------------------------ROLES-------------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla ROLES  |
prompt +--------------------------------------------------------+

ALTER TABLE ROLES
ADD CONSTRAINT nn_rol_roles CHECK (rol.nombre IS NOT NULL);

ALTER TABLE ROLES
ADD CONSTRAINT pk_id_rol_roles PRIMARY KEY ( rol.id);

------------------------------------------SEXOS-------------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla SEXOS       |
prompt +--------------------------------------------------------+

ALTER TABLE SEXOS
ADD CONSTRAINT nn_nombre_sexo_sexos CHECK (sexo.nombre IS NOT NULL);

ALTER TABLE SEXOS
ADD CONSTRAINT pk_id_sexo_sexos PRIMARY KEY (sexo.id);


------------------------------------------DEPARTAMENTOS-------------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla DEPARTAMENTOS     |
prompt +--------------------------------------------------------+

ALTER TABLE DEPARTAMENTOS
ADD CONSTRAINT nn_nombre_departamento_departamentos CHECK (NOMBRE_DEPARTAMENTO IS NOT NULL);

ALTER TABLE DEPARTAMENTOS ADD CONSTRAINT uk_nombre_departamento_departamentos UNIQUE (NOMBRE_DEPARTAMENTO);

ALTER TABLE DEPARTAMENTOS
ADD CONSTRAINT pk_id_departamento_departamentos PRIMARY KEY (ID_DEPARTAMENTO);

------------------------------------------CIUDADES-------------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla CIUDADES  |
prompt +--------------------------------------------------------+

ALTER TABLE CIUDADES
ADD CONSTRAINT nn_nombre_ciudad_ciudades CHECK (NOMBRE_CIUDAD IS NOT NULL);

ALTER TABLE CIUDADES ADD CONSTRAINT uk_nombre_ciudad UNIQUE (NOMBRE_CIUDAD);

ALTER TABLE CIUDADES
ADD CONSTRAINT pk_id_departamento_id_ciudad_ciudades PRIMARY KEY (ID_DEPARTAMENTO, ID_CIUDAD);

ALTER TABLE CIUDADES
ADD CONSTRAINT fk_id_departamento_ciudades
FOREIGN KEY (ID_DEPARTAMENTO)
REFERENCES DEPARTAMENTOS(ID_DEPARTAMENTO);

-----------------------------------------------BARRIOS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla BARRIOS  |
prompt +--------------------------------------------------------+

ALTER TABLE BARRIOS
ADD CONSTRAINT nn_nombre_barrio_barrios CHECK (NOMBRE_BARRIO IS NOT NULL);

ALTER TABLE BARRIOS ADD CONSTRAINT uk_nombre_barrio UNIQUE (NOMBRE_BARRIO);

ALTER TABLE BARRIOS
ADD CONSTRAINT pk_id_departamento_id_ciudad_id_barrio_barrios PRIMARY KEY (ID_DEPARTAMENTO, ID_CIUDAD, ID_BARRIO);

ALTER TABLE BARRIOS
ADD CONSTRAINT fk_id_departamento_id_ciudad_barrios
FOREIGN KEY (ID_DEPARTAMENTO, ID_CIUDAD)
REFERENCES CIUDADES(ID_DEPARTAMENTO, ID_CIUDAD);

-----------------------------------------------DIRECCIONES--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla DIRECCIONES  |
prompt +--------------------------------------------------------+

ALTER TABLE DIRECCIONES
ADD CONSTRAINT nn_descripcion_direccion_direcciones CHECK (DESCRIPCION_DIRECCION IS NOT NULL);

ALTER TABLE DIRECCIONES
ADD CONSTRAINT pk_id_direccion_direcciones PRIMARY KEY (ID_DIRECCION);

ALTER TABLE DIRECCIONES
ADD CONSTRAINT fk_departamento_ciudad_barrio_direcciones
FOREIGN KEY (DEPARTAMENTO, CIUDAD, BARRIO)
REFERENCES BARRIOS(ID_DEPARTAMENTO, ID_CIUDAD, ID_BARRIO);


-----------------------------------------------FORMULARIOS---------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |     Constraints para la Tabla FORMULARIOS         |
prompt +--------------------------------------------------------+

ALTER TABLE FORMULARIOS
ADD CONSTRAINT nn_nombre_formulario_formularios CHECK (NOMBRE_FORMULARIO IS NOT NULL);

ALTER TABLE FORMULARIOS
ADD CONSTRAINT nn_nodo_principal_formularios CHECK (NODO_PRINCIPAL IS NOT NULL);

ALTER TABLE FORMULARIOS
ADD CONSTRAINT nn_modulo_formularios CHECK (MODULO IS NOT NULL);

ALTER TABLE FORMULARIOS
ADD CONSTRAINT nn_orden_formularios CHECK (ORDEN IS NOT NULL);

ALTER TABLE FORMULARIOS
ADD CONSTRAINT nn_url_formularios CHECK (URL IS NOT NULL);

ALTER TABLE FORMULARIOS
ADD CONSTRAINT chk_boolean_nodo_principal CHECK (NODO_PRINCIPAL IN (0, 1));

ALTER TABLE FORMULARIOS
ADD CONSTRAINT chk_boolean_modulo CHECK (MODULO IN (0, 1));

CREATE UNIQUE INDEX idx_id_padre_orden ON FORMULARIOS (ID_PADRE, ORDEN);

ALTER TABLE FORMULARIOS
ADD CONSTRAINT pk_id_formulario_formularios PRIMARY KEY (ID_FORMULARIO);

ALTER TABLE FORMULARIOS
ADD CONSTRAINT fk_id_padre_formularios
FOREIGN KEY (ID_PADRE)
REFERENCES FORMULARIOS(ID_FORMULARIO);

-----------------------------------------------PERFILES--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla PERFILES  |
prompt +--------------------------------------------------------+

ALTER TABLE PERFILES
ADD CONSTRAINT nn_insertar_perfiles CHECK (INSERTAR IS NOT NULL);

ALTER TABLE PERFILES
ADD CONSTRAINT nn_actualizar_perfiles CHECK (ACTUALIZAR IS NOT NULL);

ALTER TABLE PERFILES
ADD CONSTRAINT nn_eliminar_perfiles CHECK (ELIMINAR IS NOT NULL);

ALTER TABLE PERFILES
ADD CONSTRAINT chk_boolean_insertar CHECK (INSERTAR IN (0, 1));

ALTER TABLE PERFILES
ADD CONSTRAINT chk_boolean_actualizar CHECK (ACTUALIZAR IN (0, 1));

ALTER TABLE PERFILES
ADD CONSTRAINT chk_boolean_eliminar CHECK (ELIMINAR IN (0, 1));

ALTER TABLE PERFILES
ADD CONSTRAINT pk_id_perfil_id_formulario_perfiles PRIMARY KEY (ID_PERFIL, ID_FORMULARIO);


ALTER TABLE PERFILES
ADD CONSTRAINT fk_id_perfil_perfiles
FOREIGN KEY (ID_PERFIL)
REFERENCES ROLES(rol.id);

ALTER TABLE PERFILES
ADD CONSTRAINT fk_id_formulario_perfiles
FOREIGN KEY (ID_FORMULARIO)
REFERENCES FORMULARIOS(ID_FORMULARIO);

-----------------------------------------------USUARIOS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla  USUARIOS |
prompt +--------------------------------------------------------+

ALTER TABLE USUARIOS
ADD CONSTRAINT nn_nombre_usuario_usuarios CHECK ( datos_usuario.nombre IS NOT NULL);

ALTER TABLE USUARIOS
ADD CONSTRAINT nn_primer_apellido_usuario_usuarios CHECK (PRIMER_APELLIDO_USUARIO IS NOT NULL);

ALTER TABLE USUARIOS
ADD CONSTRAINT nn_correo_usuario_usuarios CHECK (datos_usuario.correo IS NOT NULL);

ALTER TABLE USUARIOS
ADD CONSTRAINT nn_password_usuario_usuarios CHECK (PASSWORD_USUARIO IS NOT NULL);

ALTER TABLE USUARIOS
ADD CONSTRAINT nn_fecha_nacimiento_usuario_usuarios CHECK (FECHA_NACIMIENTO_USUARIO IS NOT NULL);

ALTER TABLE USUARIOS
ADD CONSTRAINT nn_celular_usuario_usuarios CHECK (datos_usuario.telefono.movil IS NOT NULL);

ALTER TABLE USUARIOS
ADD CONSTRAINT nn_tipo_documento_usuario_usuarios CHECK (TIPO_DOCUMENTO IS NOT NULL);

ALTER TABLE USUARIOS
ADD CONSTRAINT nn_estado_usuario_usuarios CHECK (ESTADO_USUARIO IS NOT NULL);

ALTER TABLE USUARIOS
ADD CONSTRAINT nn_sexo_usuario_usuarios CHECK (SEXO_USUARIO IS NOT NULL);

ALTER TABLE USUARIOS
ADD CONSTRAINT nn_rol_usuario_usuarios CHECK (ROL_USUARIO IS NOT NULL);

ALTER TABLE USUARIOS
ADD CONSTRAINT pk_documento_usuario_usuarios PRIMARY KEY (DOCUMENTO_USUARIO);

ALTER TABLE USUARIOS
ADD CONSTRAINT uk_correo_usuario UNIQUE (datos_usuario.correo);


ALTER TABLE USUARIOS
ADD CONSTRAINT fk_sexo_usuario_usuarios
FOREIGN KEY (SEXO_USUARIO)
REFERENCES SEXOS(sexo.id);

ALTER TABLE USUARIOS
ADD CONSTRAINT fk_tipo_documento_usuario_usuarios
FOREIGN KEY (TIPO_DOCUMENTO)
REFERENCES TIPOS_DOCUMENTOS(tipo_documento.id);

ALTER TABLE USUARIOS
ADD CONSTRAINT fk_estado_usuario_usuarios
FOREIGN KEY (ESTADO_USUARIO)
REFERENCES ESTADOS_USUARIOS(estado_usuario.id);

ALTER TABLE USUARIOS
ADD CONSTRAINT fk_rol_usuario_usuarios
FOREIGN KEY (ROL_USUARIO)
REFERENCES ROLES(rol.id);

-----------------------------------------------SEGUIMIENTOS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |      Constraints para la Tabla SEGUIMIENTOS        |
prompt +--------------------------------------------------------+

ALTER TABLE SEGUIMIENTOS
ADD CONSTRAINT nn_nombre_seguimiento_seguimientos CHECK (seguimiento.nombre IS NOT NULL);

ALTER TABLE SEGUIMIENTOS
ADD CONSTRAINT pk_id_seguimiento_seguimientos PRIMARY KEY (seguimiento.id);

-----------------------------------------------PRIORIDADES--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |     Constraints para la Tabla PRIORIDADES      |
prompt +--------------------------------------------------------+

ALTER TABLE PRIORIDADES
ADD CONSTRAINT nn_nombre_prioridades_prioridades CHECK (prioridad.nombre IS NOT NULL);

ALTER TABLE PRIORIDADES
ADD CONSTRAINT pk_id_prioridad_prioridades PRIMARY KEY (prioridad.id);

-----------------------------------------------TIPOS_TRANSPORTISTAS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |    Constraints para la Tabla TIPOS_TRANSPORTISTAS      |
prompt +--------------------------------------------------------+

ALTER TABLE TIPOS_TRANSPORTISTAS
ADD CONSTRAINT nn_nombre_prioridades_tipo_transportista CHECK (tipo_transportista.nombre IS NOT NULL);

ALTER TABLE TIPOS_TRANSPORTISTAS
ADD CONSTRAINT pk_id_tipo_transportista PRIMARY KEY (tipo_transportista.id);

-----------------------------------------------ESTADOS_LABORATORIOS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla ESTADOS_LABORATORIOS    |
prompt +--------------------------------------------------------+

ALTER TABLE ESTADOS_LABORATORIOS
ADD CONSTRAINT nn_nombre_estado_laboratorio CHECK (estado_laboratorio.nombre IS NOT NULL);

ALTER TABLE ESTADOS_LABORATORIOS
ADD CONSTRAINT pk_id_estado_laboratorio PRIMARY KEY (estado_laboratorio.id);

-----------------------------------------------TIPOS_MOVIMIENTOS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |     Constraints para la Tabla TIPOS_MOVIMIENTOS    |
prompt +--------------------------------------------------------+

ALTER TABLE TIPOS_MOVIMIENTOS
ADD CONSTRAINT nn_nombre_t_movimiento_tipos_movimientos CHECK (tipo_movimiento.nombre IS NOT NULL);

ALTER TABLE TIPOS_MOVIMIENTOS
ADD CONSTRAINT pk_id_t_movimiento_tipos_movimientos PRIMARY KEY (tipo_movimiento.id);

-----------------------------------------------TIPOS_DESCUENTOS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla TIPOS_DESCUENTOS   |
prompt +--------------------------------------------------------+

ALTER TABLE TIPOS_DESCUENTOS
ADD CONSTRAINT nn_nombre_tipo_descuento_tipo_descuento CHECK (tipo_descuento.nombre IS NOT NULL);

ALTER TABLE TIPOS_DESCUENTOS
ADD CONSTRAINT pk_id_tipo_descuento_tipo_descuento PRIMARY KEY (tipo_descuento.id );

-----------------------------------------------TIPOS_VALORES--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |     Constraints para la Tabla TIPOS_VALORES      |
prompt +--------------------------------------------------------+

ALTER TABLE TIPOS_VALORES
ADD CONSTRAINT nn_nombre_tipo_valor_tipo_valor CHECK (tipo_valor.nombre IS NOT NULL);

ALTER TABLE TIPOS_VALORES
ADD CONSTRAINT pk_id_tipo_valor_tipo_valor PRIMARY KEY (tipo_valor.id);

-----------------------------------------------CATEGORIAS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla CATEGORIAS  |
prompt +--------------------------------------------------------+

ALTER TABLE CATEGORIAS
ADD CONSTRAINT nn_nombre_categoria_categorias CHECK (categoria.nombre IS NOT NULL);

ALTER TABLE CATEGORIAS
ADD CONSTRAINT pk_id_categoria_categorias PRIMARY KEY (categoria.id );


-----------------------------------------------LABORATORIOS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla LABORATORIOS  |
prompt +--------------------------------------------------------+

ALTER TABLE LABORATORIOS
ADD CONSTRAINT nn_nombre_laboratorios CHECK (datos_laboratorios.nombre IS NOT NULL);

ALTER TABLE LABORATORIOS
ADD CONSTRAINT nn_correo_laboratorios CHECK (datos_laboratorios.correo IS NOT NULL);

CREATE UNIQUE INDEX unq_correo_laboratorios ON LABORATORIOS (datos_laboratorios.correo);

ALTER TABLE LABORATORIOS
ADD CONSTRAINT nn_celular_laboratorios CHECK (datos_laboratorios.telefono.movil IS NOT NULL);

ALTER TABLE LABORATORIOS
ADD CONSTRAINT nn_estado_laboratorio_laboratorios CHECK (ESTADO_LABORATORIO IS NOT NULL);

ALTER TABLE LABORATORIOS
ADD CONSTRAINT pk_id_laboratorio_laboratorios PRIMARY KEY (ID_LABORATORIO);

ALTER TABLE LABORATORIOS
ADD CONSTRAINT fk_estado_laboratorio_laboratorios
FOREIGN KEY (ESTADO_LABORATORIO)
REFERENCES ESTADOS_LABORATORIOS(estado_laboratorio.id);

-----------------------------------------------TRANSPORTISTAS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |      Constraints para la Tabla TRANSPORTISTAS      |
prompt +--------------------------------------------------------+

ALTER TABLE TRANSPORTISTAS
ADD CONSTRAINT nn_nombre_transportistas CHECK (datos_transportistas.nombre IS NOT NULL);

ALTER TABLE TRANSPORTISTAS
ADD CONSTRAINT nn_celular_transportistas CHECK (datos_transportistas.telefono.movil IS NOT NULL);

ALTER TABLE TRANSPORTISTAS
ADD CONSTRAINT nn_correo_transportistas CHECK (datos_transportistas.correo IS NOT NULL);

CREATE UNIQUE INDEX unq_correo_transportistas ON TRANSPORTISTAS (datos_transportistas.correo);

ALTER TABLE TRANSPORTISTAS
ADD CONSTRAINT nn_tipo_transportistas CHECK (TIPO IS NOT NULL);

ALTER TABLE TRANSPORTISTAS
ADD CONSTRAINT pk_id_transportista_transportistas PRIMARY KEY (ID_TRANSPORTISTA);

ALTER TABLE TRANSPORTISTAS
ADD CONSTRAINT fk_tipo_transportistas
FOREIGN KEY (TIPO)
REFERENCES TIPOS_TRANSPORTISTAS(tipo_transportista.id );

-----------------------------------------------PRODUCTOS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |      Constraints para la Tabla PRODUCTOS       |
prompt +--------------------------------------------------------+

ALTER TABLE PRODUCTOS
ADD CONSTRAINT nn_nombre_producto_productos CHECK (NOMBRE_PRODUCTO IS NOT NULL);

ALTER TABLE PRODUCTOS
ADD CONSTRAINT nn_descripcion_producto_productos CHECK (DESCRIPCION_PRODUCTO IS NOT NULL);

ALTER TABLE PRODUCTOS
ADD CONSTRAINT nn_precio_producto_productos CHECK (PRECIO IS NOT NULL);

ALTER TABLE PRODUCTOS
ADD CONSTRAINT nn_stock_minimo_producto_productos CHECK (STOCK_MINIMO IS NOT NULL);

ALTER TABLE PRODUCTOS
ADD CONSTRAINT nn_stock_maximo_producto_productos CHECK (STOCK_MAXIMO IS NOT NULL);

ALTER TABLE PRODUCTOS
ADD CONSTRAINT nn_cantidad_actual_producto_productos CHECK (CANTIDAD_ACTUAL IS NOT NULL);

ALTER TABLE PRODUCTOS
ADD CONSTRAINT nn_fecha_creacion_producto_productos CHECK (FECHA_CREACION IS NOT NULL);

ALTER TABLE PRODUCTOS
ADD CONSTRAINT nn_fecha_actualizacion_producto_productos CHECK (FECHA_ACTUALIZACION IS NOT NULL);

ALTER TABLE PRODUCTOS
ADD CONSTRAINT nn_id_laboratorios_producto_productos CHECK (ID_LABORATORIOS IS NOT NULL);

ALTER TABLE PRODUCTOS
ADD CONSTRAINT pk_id_producto_productos PRIMARY KEY (ID_PRODUCTO);

ALTER TABLE PRODUCTOS
ADD CONSTRAINT fk_id_laboratorios_producto_productos
FOREIGN KEY (ID_LABORATORIOS)
REFERENCES LABORATORIOS(ID_LABORATORIO);

-----------------------------------------------LOTES_PRODUCTOS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |      Constraints para la Tabla LOTES_PRODUCTOS     |
prompt +--------------------------------------------------------+

ALTER TABLE LOTES_PRODUCTOS
ADD CONSTRAINT nn_cantidad_lotes_productos CHECK (CANTIDAD IS NOT NULL);

ALTER TABLE LOTES_PRODUCTOS
ADD CONSTRAINT nn_fecha_vencimiento_lotes_productos CHECK (FECHA_VENCIMIENTO IS NOT NULL);

ALTER TABLE LOTES_PRODUCTOS
ADD CONSTRAINT nn_id_producto_lotes_productos CHECK (ID_PRODUCTO IS NOT NULL);

ALTER TABLE LOTES_PRODUCTOS
ADD CONSTRAINT pk_id_lote_lotes_productos PRIMARY KEY (ID_LOTE);

ALTER TABLE LOTES_PRODUCTOS
ADD CONSTRAINT fk_id_producto_lotes_productos
FOREIGN KEY (ID_PRODUCTO)
REFERENCES PRODUCTOS(ID_PRODUCTO);


------------------------------------------------MOVIMIENTOS_INVENTARIO--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla MOVIMIENTOS_INVENTARIO      |
prompt +--------------------------------------------------------+

ALTER TABLE MOVIMIENTOS_INVENTARIO
ADD CONSTRAINT nn_id_producto_movimientos_inventario CHECK (ID_PRODUCTO IS NOT NULL);

ALTER TABLE MOVIMIENTOS_INVENTARIO
ADD CONSTRAINT nn_id_lote_movimientos_inventario CHECK (ID_LOTE IS NOT NULL);

ALTER TABLE MOVIMIENTOS_INVENTARIO
ADD CONSTRAINT nn_cantidad_movimientos_inventario CHECK (CANTIDAD IS NOT NULL);

ALTER TABLE MOVIMIENTOS_INVENTARIO
ADD CONSTRAINT nn_fecha_movimiento_movimientos_inventario CHECK (FECHA_MOVIMIENTO IS NOT NULL);

ALTER TABLE MOVIMIENTOS_INVENTARIO
ADD CONSTRAINT nn_tipo_movimiento_movimientos_inventario CHECK (TIPO_MOVIMIENTO IS NOT NULL);

ALTER TABLE MOVIMIENTOS_INVENTARIO
ADD CONSTRAINT pk_id_movimiento_movimientos_inventario PRIMARY KEY (ID_MOVIMIENTO);

ALTER TABLE MOVIMIENTOS_INVENTARIO
ADD CONSTRAINT fk_id_producto_movimientos_inventario
FOREIGN KEY (ID_PRODUCTO)
REFERENCES PRODUCTOS(ID_PRODUCTO);

ALTER TABLE MOVIMIENTOS_INVENTARIO
ADD CONSTRAINT fk_id_lote_movimientos_inventario
FOREIGN KEY (ID_LOTE)
REFERENCES LOTES_PRODUCTOS(ID_LOTE);

ALTER TABLE MOVIMIENTOS_INVENTARIO
ADD CONSTRAINT fk_tipo_movimiento_movimientos_inventario
FOREIGN KEY (TIPO_MOVIMIENTO)
REFERENCES TIPOS_MOVIMIENTOS(tipo_movimiento.id);

------------------------------------------------IMAGENES_PRODUCTOS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla IMAGENES_PRODUCTOS  |
prompt +--------------------------------------------------------+

ALTER TABLE IMAGENES_PRODUCTOS
ADD CONSTRAINT nn_nombre_imagen_imagenes_productos CHECK (NOMBRE_IMAGEN IS NOT NULL);

ALTER TABLE IMAGENES_PRODUCTOS
ADD CONSTRAINT nn_ubicacion_imagen_imagenes_productos CHECK (UBICACION_IMAGEN IS NOT NULL);

ALTER TABLE IMAGENES_PRODUCTOS
ADD CONSTRAINT pk_id_producto_id_imagen_imagenes_productos PRIMARY KEY (ID_PRODUCTO, ID_IMAGEN);

ALTER TABLE IMAGENES_PRODUCTOS
ADD CONSTRAINT fk_id_producto_imagenes_productos
FOREIGN KEY (ID_PRODUCTO)
REFERENCES PRODUCTOS(ID_PRODUCTO);


------------------------------------------------USUARIOS_DIRECCIONES--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla USUARIOS_DIRECCIONES  |
prompt +--------------------------------------------------------+

ALTER TABLE USUARIOS_DIRECCIONES
ADD CONSTRAINT pk_id_usuario_id_direccion_usuarios_direcciones PRIMARY KEY (ID_USUARIO, ID_DIRECCION);

ALTER TABLE USUARIOS_DIRECCIONES
ADD CONSTRAINT fk_id_usuario_usuarios_direcciones
FOREIGN KEY (ID_USUARIO)
REFERENCES USUARIOS(DOCUMENTO_USUARIO);

ALTER TABLE USUARIOS_DIRECCIONES
ADD CONSTRAINT fk_id_direccion_usuarios_direcciones
FOREIGN KEY (ID_DIRECCION)
REFERENCES DIRECCIONES(ID_DIRECCION);

------------------------------------------------PEDIDOS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |        Constraints para la Tabla PEDIDOS     |
prompt +--------------------------------------------------------+

ALTER TABLE PEDIDOS
ADD CONSTRAINT nn_fecha_entrega_pedidos CHECK (FECHA_ENTREGA IS NOT NULL);


ALTER TABLE PEDIDOS
ADD CONSTRAINT nn_descuento_pedidos CHECK (DESCUENTO IS NOT NULL);


ALTER TABLE PEDIDOS
ADD CONSTRAINT nn_prioridad_pedidos CHECK (PRIORIDAD IS NOT NULL);

ALTER TABLE PEDIDOS
ADD CONSTRAINT nn_seguimiento_pedidos CHECK (SEGUIMIENTO IS NOT NULL);


ALTER TABLE PEDIDOS
ADD CONSTRAINT nn_id_usuario_pedidos CHECK (ID_USUARIO IS NOT NULL);

ALTER TABLE PEDIDOS
ADD CONSTRAINT nn_id_direccion_pedidos CHECK (ID_DIRECCION IS NOT NULL);

ALTER TABLE PEDIDOS
ADD CONSTRAINT pk_id_pedidos_pedidos PRIMARY KEY (ID_PEDIDOS);

ALTER TABLE PEDIDOS
ADD CONSTRAINT fk_prioridad_pedidos
FOREIGN KEY (PRIORIDAD)
REFERENCES PRIORIDADES(prioridad.id );

ALTER TABLE PEDIDOS
ADD CONSTRAINT fk_seguimiento_pedidos
FOREIGN KEY (SEGUIMIENTO)
REFERENCES SEGUIMIENTOS( seguimiento.id);

ALTER TABLE PEDIDOS
ADD CONSTRAINT fk_usuario_direccion_pedidos
FOREIGN KEY (ID_USUARIO, ID_DIRECCION)
REFERENCES USUARIOS_DIRECCIONES(ID_USUARIO, ID_DIRECCION);


------------------------------------------------CATEGORIAS_PRODUCTOS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla CATEGORIAS_PRODUCTOS  |
prompt +--------------------------------------------------------+

ALTER TABLE CATEGORIAS_PRODUCTOS
ADD CONSTRAINT pk_id_categoria_id_producto_categorias_productos PRIMARY KEY (ID_CATEGORIA, ID_PRODUCTO);

ALTER TABLE CATEGORIAS_PRODUCTOS
ADD CONSTRAINT fk_id_categoria_categorias_productos
FOREIGN KEY (ID_CATEGORIA)
REFERENCES CATEGORIAS(categoria.id);

ALTER TABLE CATEGORIAS_PRODUCTOS
ADD CONSTRAINT fk_id_producto_categorias_productos
FOREIGN KEY (ID_PRODUCTO)
REFERENCES PRODUCTOS(ID_PRODUCTO);

------------------------------------------------DETALLE_PEDIDOS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla DETALLE_PEDIDOS  |
prompt +--------------------------------------------------------+

ALTER TABLE DETALLE_PEDIDOS
ADD CONSTRAINT nn_cantidad_detalle_pedidos CHECK (CANTIDAD IS NOT NULL);

ALTER TABLE DETALLE_PEDIDOS
ADD CONSTRAINT nn_descuento_detalle_pedidos CHECK (DESCUENTO IS NOT NULL);

ALTER TABLE DETALLE_PEDIDOS
ADD CONSTRAINT nn_precio_unitario_detalle_pedidos CHECK (PRECIO_UNITARIO IS NOT NULL);

ALTER TABLE DETALLE_PEDIDOS
ADD CONSTRAINT nn_cantidad_entregada_detalle_pedidos CHECK (CANTIDAD_ENTREGADA IS NOT NULL);

ALTER TABLE DETALLE_PEDIDOS
ADD CONSTRAINT nn_descuento_aplicado_detalle_pedidos CHECK (DESCUENTO_APLICADO IS NOT NULL);

ALTER TABLE DETALLE_PEDIDOS
ADD CONSTRAINT pk_id_producto_id_pedido_detalle_pedidos PRIMARY KEY (ID_PRODUCTO, ID_PEDIDOS);

ALTER TABLE DETALLE_PEDIDOS
ADD CONSTRAINT fk_id_pedido_detalle_pedidos
FOREIGN KEY (ID_PEDIDOS)
REFERENCES PEDIDOS(ID_PEDIDOS);

ALTER TABLE DETALLE_PEDIDOS
ADD CONSTRAINT fk_id_producto_detalle_pedidos
FOREIGN KEY (ID_PRODUCTO)
REFERENCES PRODUCTOS(ID_PRODUCTO);

------------------------------------------------SECCIONES_ENVIOS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla SECCIONES_ENVIOS    |
prompt +--------------------------------------------------------+

ALTER TABLE SECCIONES_ENVIOS
ADD CONSTRAINT nn_des_seccion_secciones_envios CHECK (DES_SECCION IS NOT NULL);

ALTER TABLE SECCIONES_ENVIOS
ADD CONSTRAINT nn_cantidad_entregada_secciones_envios CHECK (CANTIDAD_ENTREGADA IS NOT NULL);

ALTER TABLE SECCIONES_ENVIOS
ADD CONSTRAINT nn_fecha_asignacion_secciones_envios CHECK (FECHA_ASIGNACION IS NOT NULL);

ALTER TABLE SECCIONES_ENVIOS
ADD CONSTRAINT nn_id_transportista_secciones_envios CHECK (ID_TRANSPORTISTA IS NOT NULL);

ALTER TABLE SECCIONES_ENVIOS
ADD CONSTRAINT nn_id_producto_secciones_envios CHECK (ID_PRODUCTO IS NOT NULL);

ALTER TABLE SECCIONES_ENVIOS
ADD CONSTRAINT nn_id_pedido_secciones_envios CHECK (ID_PEDIDO IS NOT NULL);

ALTER TABLE SECCIONES_ENVIOS
ADD CONSTRAINT pk_id_seccion_secciones_envios PRIMARY KEY (ID_SECCION);

ALTER TABLE SECCIONES_ENVIOS
ADD CONSTRAINT fk_id_transportista_secciones_envios
FOREIGN KEY (ID_TRANSPORTISTA)
REFERENCES TRANSPORTISTAS(ID_TRANSPORTISTA);

ALTER TABLE SECCIONES_ENVIOS
ADD CONSTRAINT fk_id_producto_id_pedido_secciones_envios
FOREIGN KEY (ID_PRODUCTO, ID_PEDIDO)
REFERENCES DETALLE_PEDIDOS(ID_PRODUCTO, ID_PEDIDOS);

------------------------------------------------DESCUENTOS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |      Constraints para la Tabla DESCUENTOS      |
prompt +--------------------------------------------------------+

ALTER TABLE DESCUENTOS
ADD CONSTRAINT nn_nombre_descuento_descuentos CHECK (NOMBRE_DESCUENTO IS NOT NULL);

ALTER TABLE DESCUENTOS
ADD CONSTRAINT nn_descripcion_descuentos CHECK (DESCRIPCION IS NOT NULL);

ALTER TABLE DESCUENTOS
ADD CONSTRAINT nn_fecha_inicio_descuentos CHECK (FECHA_INICIO IS NOT NULL);

ALTER TABLE DESCUENTOS
ADD CONSTRAINT nn_valor_descuento_descuentos CHECK (VALOR_DESCUENTO IS NOT NULL);

ALTER TABLE DESCUENTOS
ADD CONSTRAINT nn_activo_descuentos CHECK (ACTIVO IS NOT NULL);

ALTER TABLE DESCUENTOS
ADD CONSTRAINT nn_tipo_descuento_descuentos CHECK (TIPO_DESCUENTO IS NOT NULL);

ALTER TABLE DESCUENTOS
ADD CONSTRAINT nn_tipo_valor_descuentos CHECK (TIPO_VALOR IS NOT NULL);

ALTER TABLE DESCUENTOS
ADD CONSTRAINT nn_id_categoria_descuentos CHECK (ID_CATEGORIA IS NOT NULL);

ALTER TABLE DESCUENTOS
ADD CONSTRAINT chk_boolean_activo CHECK (ACTIVO IN (0, 1));


ALTER TABLE DESCUENTOS
ADD CONSTRAINT pk_id_descuento_descuentos PRIMARY KEY (ID_DESCUENTO);

ALTER TABLE DESCUENTOS
ADD CONSTRAINT fk_tipo_descuento_descuentos
FOREIGN KEY (TIPO_DESCUENTO)
REFERENCES TIPOS_DESCUENTOS(tipo_descuento.id);

ALTER TABLE DESCUENTOS
ADD CONSTRAINT fk_tipo_valor_descuentos
FOREIGN KEY (TIPO_VALOR)
REFERENCES TIPOS_VALORES(tipo_valor.id );

ALTER TABLE DESCUENTOS
ADD CONSTRAINT fk_id_categoria_descuentos
FOREIGN KEY (ID_CATEGORIA)
REFERENCES CATEGORIAS(categoria.id );

------------------------------------------------DESCUENTOS_PRODUCTOS--------------------------------------------------------

prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla DESCUENTOS_PRODUCTOS     |
prompt +--------------------------------------------------------+

ALTER TABLE DESCUENTOS_PRODUCTOS
ADD CONSTRAINT pk_id_descuento_id_producto_descuentos_productos PRIMARY KEY (ID_DESCUENTO, ID_PRODUCTO);

ALTER TABLE DESCUENTOS_PRODUCTOS
ADD CONSTRAINT fk_id_descuento_descuentos_productos
FOREIGN KEY (ID_DESCUENTO)
REFERENCES DESCUENTOS(ID_DESCUENTO);

ALTER TABLE DESCUENTOS_PRODUCTOS
ADD CONSTRAINT fk_id_producto_descuentos_productos
FOREIGN KEY (ID_PRODUCTO)
REFERENCES PRODUCTOS(ID_PRODUCTO);


--
prompt +--------------------------------------------------------+
prompt |  Constraints para la Tabla LOGS     |
prompt +--------------------------------------------------------+

ALTER TABLE LOGS
ADD CONSTRAINT nn_FECHA_AUD CHECK (FECHA_AUD IS NOT NULL);
ALTER TABLE LOGS
ADD CONSTRAINT nn_EVENTO_AUD CHECK (EVENTO_AUD IN('INSERT','UPDATE','DELETE'));
ALTER TABLE LOGS
ADD CONSTRAINT nn_MOMENTO_AUD CHECK (MOMENTO_AUD IS NOT NULL);
ALTER TABLE LOGS
ADD CONSTRAINT nn_ACCION_AUD CHECK (ACCION_AUD IS NOT NULL);
ALTER TABLE LOGS
ADD CONSTRAINT nn_USUARIO_AUD CHECK (USUARIO_AUD IS NOT NULL);
