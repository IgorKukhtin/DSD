ALTER TABLE _replica.clients ALTER COLUMN PID SET DATA TYPE BigInt;
ALTER TABLE _replica.clients ALTER COLUMN last_id SET DATA TYPE BigInt;
ALTER TABLE _replica.clients ALTER COLUMN last_id_ddl SET DATA TYPE BigInt;

ALTER TABLE resourseitemprotocol ALTER COLUMN id_start SET DATA TYPE BigInt;
ALTER TABLE resourseitemprotocol ALTER COLUMN id_end SET DATA TYPE BigInt;

/*
-- drop TABLE _replica.table_update_data 
CREATE TABLE IF NOT EXISTS _replica.table_update_data (
  ID              BIGSERIAL PRIMARY KEY,
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

--DROP TABLE IF EXISTS _replica.table_ddl;
CREATE TABLE IF NOT EXISTS _replica.table_ddl(
  id BIGSERIAL       PRIMARY KEY,
  query           TEXT,
  last_modified   TIMESTAMP WITHOUT TIME ZONE DEFAULT 
                            timezone('utc'::text, now())::timestamp
  
);
*/