
CLEAR SCREEN;

prompt +----------------------------------+
prompt |   Script de Creación de Esquema |
prompt |    en la Base de Datos           |
prompt |          naturantioquia          |
prompt +----------------------------------+

connect system/sqlOracleDB2

show con_name

ALTER SESSION SET CONTAINER=CDB$ROOT;
ALTER DATABASE OPEN;

DROP TABLESPACE ts_naturaantioquia INCLUDING CONTENTS and DATAFILES;

CREATE TABLESPACE ts_naturaantioquia LOGGING
DATAFILE 'C:\Oracle\PPI-2024-2\datos\DF_naturaantioquia.dbf' size 100M;

alter session set "_ORACLE_SCRIPT"=true; 


drop user us_naturaantioquia cascade;

CREATE user us_naturaantioquia profile default 
identified by 123
default tablespace ts_naturaantioquia 
temporary tablespace temp 
account unlock;     


grant connect, resource,dba to us_naturaantioquia; 
prompt Privilegios asignados correctamente al nuevo usuario.

connect us_naturaantioquia/123
prompt Conectado como usuario us_naturaantioquia.

show user
