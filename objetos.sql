prompt +----------------------------------+
prompt |      Creación de Objetos         |
prompt |       en la Base de Datos        |
prompt |          Naturantioquia          |
prompt +----------------------------------+

prompt --> Borrado de Objetos 
DROP TYPE US_NATURAANTIOQUIA.telefonos;
DROP TYPE US_NATURAANTIOQUIA.contacto;
DROP TYPE US_NATURAANTIOQUIA.elemento;

prompt +-------------------------------------------------+
prompt |        Creación de objeto TELEFONOS        |
prompt +-------------------------------------------------+

CREATE OR REPLACE TYPE US_NATURAANTIOQUIA.telefonos AS OBJECT (
        fijo  INTEGER,
        movil INTEGER
);
/

prompt +-------------------------------------------------+
prompt |        Creación de objeto CONTACTO       |
prompt +-------------------------------------------------+
CREATE OR REPLACE TYPE US_NATURAANTIOQUIA.contacto AS OBJECT (
        nombre   VARCHAR2(150),
        telefono telefonos,
        correo   VARCHAR2(100)
);
/

prompt +-------------------------------------------------+
prompt |        Creación de objeto ELEMENTO       |
prompt +-------------------------------------------------+
CREATE OR REPLACE TYPE US_NATURAANTIOQUIA.elemento AS OBJECT (
        id     INTEGER,
        nombre VARCHAR2(50)
);
/


