-- Function: _replica.notice_changed_data()

-- DROP FUNCTION _replica.notice_changed_data();

CREATE OR REPLACE FUNCTION _replica.notice_changed_data()
  RETURNS trigger AS
$BODY$
DECLARE
  current_row   RECORD;
  ri            RECORD;
  _names TEXT[];
  _vals  TEXT[];
  _cols  TEXT[];
  v1     TEXT;
  v2     TEXT;
BEGIN
  IF (TG_OP ILIKE 'INSERT') OR (TG_OP ILIKE 'UPDATE') THEN
    current_row := NEW;
  ELSE
    current_row := OLD;
  END IF;

  -- При обновлении получим имена полей, данные которых имзенились.
  IF (TG_OP ILIKE 'UPDATE') THEN
  	FOR ri IN

      -- !!! PG 9.5 or latter !!!
      --SELECT pre.key AS columname, pre.value AS prevalue, post.value AS postvalue
      --  FROM jsonb_each(to_jsonb(OLD)) AS pre, jsonb_each(to_jsonb(NEW)) AS post
      --  WHERE pre.key = post.key AND pre.value IS DISTINCT FROM post.value

      -- !!! PG 9.4 !!!
      SELECT pre.key AS columname, pre.value AS prevalue, post.value AS postvalue
        FROM json_each(to_json(OLD)) AS pre, json_each(to_json(NEW)) AS post
        WHERE pre.key = post.key AND pre.value :: TVarChar IS DISTINCT FROM post.value :: TVarChar

    LOOP
      _cols  = array_append(_cols, ri.columname);
    END LOOP;
    IF _cols IS NULL THEN
      RETURN current_row;
    END IF;
  END IF;

  -- Первичный ключ. Не составной
  IF TG_NARGS = 1 AND _replica.zc_isReplica_two() = TRUE
  THEN
      EXECUTE 'SELECT ($1).' || TG_ARGV[0]  INTO v1 USING current_row;
      INSERT INTO _replica.table_update_data_two (schema_name, table_name, pk_keys, pk_values, upd_cols, operation, transaction_id, user_name)
             VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, TG_ARGV[0], v1, _cols, TG_OP, txid_current(), session_user);

  -- Первичный ключ. Не составной
  ELSEIF TG_NARGS = 1
  THEN
      EXECUTE 'SELECT ($1).' || TG_ARGV[0]  INTO v1 USING current_row;
      INSERT INTO _replica.table_update_data (schema_name, table_name, pk_keys, pk_values, upd_cols, operation, transaction_id, user_name)
             VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, TG_ARGV[0], v1, _cols, TG_OP, txid_current(), session_user);

  -- Первичный ключ, составной. Состоит из двух полей.
  ELSEIF TG_NARGS = 2 AND _replica.zc_isReplica_two() = TRUE
  THEN
      EXECUTE 'SELECT ($1).' || TG_ARGV[0] || ', ($1).' || TG_ARGV[1]  INTO v1, v2 USING current_row;
      INSERT INTO _replica.table_update_data_two (schema_name, table_name, transaction_id, user_name, pk_keys, pk_values, upd_cols, operation)
             VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, txid_current(), session_user,
                     Format('{%s, %s}', TG_ARGV[0], TG_ARGV[1]), --ARRAY[v1, v2]);
                     Format('{%s, %s}', v1, v2), _cols, TG_OP);

  -- Первичный ключ, составной. Состоит из двух полей.
  ELSEIF TG_NARGS = 2
  THEN
      EXECUTE 'SELECT ($1).' || TG_ARGV[0] || ', ($1).' || TG_ARGV[1]  INTO v1, v2 USING current_row;
      INSERT INTO _replica.table_update_data (schema_name, table_name, transaction_id, user_name, pk_keys, pk_values, upd_cols, operation)
             VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, txid_current(), session_user,
                     Format('{%s, %s}', TG_ARGV[0], TG_ARGV[1]), --ARRAY[v1, v2]);
                     Format('{%s, %s}', v1, v2), _cols, TG_OP);

  -- Первичный ключ. Составной. Состоит из 3х и болей полей.
  ELSE
      FOREACH v2 IN ARRAY TG_ARGV LOOP
        EXECUTE 'SELECT ($1).' || col  INTO v1 USING current_row;
        _vals  = array_append(_vals, v1);
        _names = array_append(_names, v2);
      END LOOP;
      
      IF _replica.zc_isReplica_two() = TRUE
      THEN
          INSERT INTO _replica.table_update_data_two (schema_name, table_name, pk_keys, pk_values, upd_cols, operation, transaction_id, user_name)
                 VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, _names, _vals, _cols, TG_OP, txid_current(), session_user);
      ELSE
          INSERT INTO _replica.table_update_data (schema_name, table_name, pk_keys, pk_values, upd_cols, operation, transaction_id, user_name)
                 VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, _names, _vals, _cols, TG_OP, txid_current(), session_user);
      END IF;

  END IF;

  -- уведомление клиенту
  -- PERFORM pg_notify('_replica_table_notify_', '');--Format('[%s, %s]',TG_TABLE_SCHEMA, TG_TABLE_NAME));

  RETURN current_row;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
