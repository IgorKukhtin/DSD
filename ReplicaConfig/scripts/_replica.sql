CREATE SCHEMA _replica;


/* ************************************************************************** */
/*                              �������                                       */
/* ************************************************************************** */

/* 
  table_ddl - ������� ��������� DDL �������.
*/
--DROP TABLE IF EXISTS _replica.table_ddl;
CREATE TABLE IF NOT EXISTS _replica.table_ddl(
  id SERIAL       PRIMARY KEY,
  query           TEXT,
  last_modified   TIMESTAMP WITHOUT TIME ZONE DEFAULT 
                            timezone('utc'::text, now())::timestamp
  
);

/* ************************************************************************** */

/* 
  _replica.clients - ������� ��������� �������������� ��������. ������ ����������
                   ������ ��������������� � ���� ������� � ��������� ���������
                   ���� ����������� ������� �������� ������� replica_client_visit()
*/
--DROP TABLE IF EXISTS _replica.clients;
CREATE TABLE IF NOT EXISTS _replica.clients (
  ID                SERIAL PRIMARY KEY,
  PID               INTEGER,
  client_id         BIGINT UNIQUE,
  client_name       TEXT,
  application_name  TEXT,
  first_visit       TIMESTAMP WITHOUT TIME ZONE,
  last_visit        TIMESTAMP WITHOUT TIME ZONE,-- DEFAULT timezone('utc'::text, now())::timestamp
  last_id           INTEGER
  
);


/* ************************************************************************** */

/* 
  table_update_data - ������� ��������� �������������� ���������� ������,
                      ������� ������ ���� �������� �������.
*/

--DROP TABLE IF EXISTS _replica.table_update_data;
CREATE TABLE IF NOT EXISTS _replica.table_update_data (
  ID              SERIAL PRIMARY KEY,
  schema_name     TEXT,
  table_name      TEXT,
  pk_keys         TEXT,
  pk_values       TEXT,
  upd_cols        TEXT,
  operation       TEXT,
  transaction_id  BIGINT,
  user_name       TEXT,
  last_modified   TIMESTAMP WITHOUT TIME ZONE DEFAULT 
                            timezone('utc'::text, now())::timestamp
);

--CREATE INDEX idx_replica_update_table_name ON _replica.table_update_data (table_name);
CREATE INDEX idx_replica_update_last_modified ON _replica.table_update_data (last_modified);
--CREATE INDEX _replica.idx_replica_update_operation ON _replica.table_update_data (operation);

/* ************************************************************************** */
/* 
  table_slave - ������� ������ ���������� � ������ ��������, ��������� �� ������.
*/

--DROP TABLE IF EXISTS _replica.table_update_data;
CREATE TABLE IF NOT EXISTS _replica.table_slave (
  ID SERIAL         PRIMARY KEY,
  table_key         BIGINT,
  master_schema     TEXT,
  slave_schema      TEXT,
  master_table      TEXT,
  slave_table       TEXT,
  master_fields     TEXT,
  slave_fields      TEXT,
  downloaded        BOOLEAN,
  last_row_id       BIGINT, -- ID ����� ��� ROW_NUMBER. ��������� ��� ��������� �������.
  sql_select        TEXT,
  sql_update        TEXT,
  sql_insert        TEXT,
  last_modified     TIMESTAMP WITHOUT TIME ZONE
                            
);

CREATE UNIQUE INDEX idx_replica_table_slave_table_key ON _replica.table_slave (table_key);

/* ************************************************************************** */
/* 
  settings - ������� � ����������� ����������.
*/

DROP TABLE IF EXISTS _replica.settings;
CREATE TABLE IF NOT EXISTS _replica.settings (
  ID SERIAL       PRIMARY KEY,
  name            TEXT UNIQUE,
  value           TEXT,
  reserv          TEXT
);


/* ************************************************************************** */

/* 
  _replica.loger - ������� ��������� ������ ��������� ������ ��� ��������� ������
                   �� ������� table_update_data 
*/
DROP TABLE IF EXISTS _replica.logger;
CREATE TABLE IF NOT EXISTS _replica.logger (
  ID                SERIAL PRIMARY KEY,
  client_id         BIGINT,
  msg               TEXT,
  msg_type          TEXT,
  description       TEXT,
  last_modified     TIMESTAMP WITHOUT TIME ZONE
  
);

/* ************************************************************************** */
/*                              �������                                       */
/* ************************************************************************** */



CREATE OR REPLACE FUNCTION _replica.notice_ddl() RETURNS event_trigger AS $$
BEGIN
  INSERT INTO _replica.table_ddl(query) VALUES(current_query());
  PERFORM pg_notify('_replica_ddl_notify_', '');
  --raise info '%', session_user || ' ran - '||TG_TAG||' - '||TG_EVENT||' - '||CURRENT_QUERY();
END;
$$ LANGUAGE plpgsql;

-- �������� �������� ������� ���
--DROP EVENT TRIGGER IF EXISTS etg;
--CREATE EVENT TRIGGER etg ON DDL_COMMAND_END
--    EXECUTE PROCEDURE _replica.notice_ddl();
    
/* ************************************************************************** */
/* 
  _replica.notice_changed_data - ��������� ������� ���������� �� ��������� ������ 
                           �������, ������� ������ ���� �������� �������. 
                           ��������� ������ � ��������� ������� � ���������� 
                           �������� �� ����������.
*/

CREATE OR REPLACE FUNCTION _replica.notice_changed_data() RETURNS trigger AS $$
DECLARE
  current_row   RECORD; 
  ri            RECORD;  
  _names TEXT[];
  _vals  TEXT[];
  _cols  TEXT[];
  v1     TEXT;
  v2     TEXT;
BEGIN
  IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
    current_row := NEW;
  ELSE
    current_row := OLD;
  END IF;
  
  -- ��� ���������� ������� ����� �����, ������ ������� ����������.
  IF (TG_OP = 'UPDATE') THEN
  	FOR ri IN
      SELECT pre.key AS columname, pre.value AS prevalue, post.value AS postvalue
        FROM jsonb_each(to_jsonb(OLD)) AS pre, jsonb_each(to_jsonb(NEW)) AS post
        WHERE pre.key = post.key AND pre.value IS DISTINCT FROM post.value
    LOOP
      _cols  = array_append(_cols, ri.columname);	
    END LOOP;
    IF _cols IS NULL THEN
      RETURN current_row;    
    END IF;    
  END IF;
  
  CASE TG_NARGS
    WHEN 1 THEN  -- ��������� ����. �� ���������
      EXECUTE 'SELECT ($1).' || TG_ARGV[0]  INTO v1 USING current_row;
      INSERT INTO _replica.table_update_data(schema_name, table_name, pk_keys, pk_values, upd_cols, operation, transaction_id, user_name)  
             VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, TG_ARGV[0], v1, _cols, TG_OP, txid_current(), session_user);
      
    WHEN 2 THEN  -- ��������� ����, ���������. ������� �� ���� �����.
      EXECUTE 'SELECT ($1).' || TG_ARGV[0] || ', ($1).' || TG_ARGV[1]  INTO v1, v2 USING current_row;
      INSERT INTO _replica.table_update_data(schema_name, table_name, transaction_id, user_name, pk_keys, pk_values, upd_cols, operation)  
             VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, txid_current(), session_user,
                     Format('{%s, %s}', TG_ARGV[0], TG_ARGV[1]), --ARRAY[v1, v2]);
                     Format('{%s, %s}', v1, v2), _cols, TG_OP);
                                
    ELSE -- ��������� ����. ���������. ������� �� 3� � ����� �����.
      FOREACH v2 IN ARRAY TG_ARGV LOOP
        EXECUTE 'SELECT ($1).' || col  INTO v1 USING current_row;
        _vals  = array_append(_vals, v1);
        _names = array_append(_names, v2);
      END LOOP;
      INSERT INTO _replica.table_update_data(schema_name, table_name, pk_keys, pk_values, upd_cols, operation, transaction_id, user_name)  
             VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, _names, _vals, _cols, TG_OP, txid_current(), session_user);  
  END CASE;
  
  -- ����������� �������
  PERFORM pg_notify('_replica_table_notify_', '');--Format('[%s, %s]',TG_TABLE_SCHEMA, TG_TABLE_NAME));

  RETURN current_row;
END;
$$ LANGUAGE plpgsql;


/* ************************************************************************** */
/* 
  notice_changed_data_v2 - ��������� ������� ���������� �� ��������� ������ 
                           �������, ������� ������ ���� �������� �������. 
                           ��������� ������ � ��������� ������� � ���������� 
                           �������� �� ����������.
*/

CREATE OR REPLACE FUNCTION _replica.notice_changed_data_v2()
RETURNS trigger AS $$
DECLARE
  current_row   RECORD;  
  _names TEXT[];
  _vals  TEXT[];
  v1     TEXT;
  v2     TEXT;
BEGIN
  IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
    current_row := NEW;
  ELSE
    current_row := OLD;
  END IF;
  
  CASE TG_NARGS
    
    WHEN 1 THEN
      EXECUTE 'SELECT ($1).' || TG_ARGV[0]  INTO v1 USING current_row;
      INSERT INTO _replica.table_update_data(schema_name, table_name, pk_keys, pk_values)  VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, TG_ARGV[0], v1);
      
    WHEN 2 THEN
      EXECUTE 'SELECT ($1).' || TG_ARGV[0] || ', ($1).' || TG_ARGV[1]  INTO v1, v2 USING current_row;
      INSERT INTO _replica.table_update_data(schema_name, table_name, pk_keys, pk_values)  VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, 
                                Format('{%s, %s}', TG_ARGV[0], TG_ARGV[1]), --ARRAY[v1, v2]);
                                Format('{%s, %s}', v1, v2));
                                
    ELSE
      FOREACH v2 IN ARRAY TG_ARGV LOOP
        EXECUTE 'SELECT ($1).' || col  INTO v1 USING current_row;
        _vals  = array_append(_vals, v1);
        _names = array_append(_names, v2);
      END LOOP;
      INSERT INTO _replica.table_update_data(schema_name, table_name, pk_keys, pk_values)  VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, _names, _vals);  
  END CASE;
  PERFORM pg_notify('_replica_table_notify_');--, Format('[%s, %s, %s]',TG_TABLE_SCHEMA, TG_TABLE_NAME, TG_OP));

  RETURN current_row;
END;
$$ LANGUAGE plpgsql;


/* ************************************************************************** */


/* 
  replica_client_visit - ������� ������������ ������ ������� ��� ��������� �����
                          ���������� ����������� ������.
                        ���������� ������, ���� ������� ����������������.
                        ����� ����.
                        ������ �� ������ ������������ ������� ��� ������������� 
                        �����������.
*/
CREATE OR REPLACE FUNCTION _replica.client_visit(in_id BIGINT, in_name TEXT, in_last_id INTEGER) RETURNS BOOLEAN AS
$$
DECLARE
  cur_pid INTEGER;
  cli_pid INTEGER;
  ret BOOLEAN;
  lm TIMESTAMP WITHOUT TIME ZONE;
  li INTEGER;
BEGIN
  ret := TRUE;
  cur_pid := pg_backend_pid();
  SELECT pid, last_id INTO cli_pid, li FROM _replica.clients WHERE client_id = in_id;
  IF NOT FOUND THEN
    lm := timezone('utc'::text, now())::timestamp;
  	INSERT INTO _replica.clients (client_id, client_name, application_name, pid, first_visit, last_visit, last_id) 
    	VALUES (in_id, in_name, current_setting('application_name'), cur_pid, lm, lm, -1);
  ELSIF (cli_pid <> cur_pid) AND EXISTS(SELECT FROM pg_stat_activity WHERE pid = cli_pid) THEN
  	ret = FALSE;
  ELSE
    IF li < in_last_id THEN 
      li := in_last_id;
    END IF;
  	UPDATE _replica.clients SET 
        pid = cur_pid, 
        application_name = current_setting('application_name'),
        last_visit = timezone('utc'::text, now())::timestamp,
        last_id = li    
    WHERE client_id = in_id;
  END IF;
  PERFORM _replica.garbage(); 
  RETURN ret;
END;
$$ LANGUAGE plpgsql;


/* ************************************************************************** */
/* 
  _replica.garbage() - ������� ������� ������ �� ������� replica_update.
                            �������� ��������, ��� ��� ������ ���� �������� 
                            ������������������� ���������. ����� ������� �����
                            ���������� ������ � ����.
*/
CREATE OR REPLACE FUNCTION _replica.garbage() RETURNS void AS
$$
BEGIN
  DELETE FROM _replica.clients WHERE last_visit < CURRENT_DATE - INTERVAL '30 DAY';
  DELETE FROM _replica.table_update_data WHERE id < 
    (SELECT min(last_id) FROM _replica.clients);
  -- VACUUM OR TRUNCATE 
END;
$$ LANGUAGE plpgsql;


