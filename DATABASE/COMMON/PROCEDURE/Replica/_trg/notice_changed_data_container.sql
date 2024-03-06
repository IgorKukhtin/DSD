-- Function: _replica.notice_changed_data_container()

-- DROP FUNCTION _replica.notice_changed_data_container();

CREATE OR REPLACE FUNCTION _replica.notice_changed_data_container()
  RETURNS trigger AS
$BODY$
DECLARE
  current_row   RECORD;
  ri            RECORD;
  _cols  TEXT[];
BEGIN
  IF (TG_OP ILIKE 'INSERT') OR (TG_OP ILIKE 'UPDATE') THEN
    current_row := NEW;
  ELSE
    current_row := OLD;
  END IF;

  -- ѕри обновлении получим имена полей, данные которых имзенились.
  IF (TG_OP ILIKE 'UPDATE') THEN
    IF (NEW.id <> OLD.id) OR (_replica.num_nulls(NEW.id::TEXT, OLD.id::TEXT) = 1)  THEN
      _cols  := array_append(_cols, 'Id');
    END IF;
    IF (NEW.DescId <> OLD.DescId) OR (_replica.num_nulls(NEW.DescId::TEXT, OLD.DescId::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'DescId');
    END IF;
    IF (NEW.ObjectId <> OLD.ObjectId) OR (_replica.num_nulls(NEW.ObjectId::TEXT, OLD.ObjectId::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'ObjectId');
    END IF;
    IF (NEW.Amount <> OLD.Amount) OR (_replica.num_nulls(NEW.Amount::TEXT, OLD.Amount::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'Amount');
    END IF;
    IF (NEW.ParentId <> OLD.ParentId) OR (_replica.num_nulls(NEW.ParentId::TEXT, OLD.ParentId::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'ParentId');
    END IF;
    IF (NEW.KeyValue <> OLD.KeyValue) OR (_replica.num_nulls(NEW.KeyValue::TEXT, OLD.KeyValue::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'KeyValue');
    END IF;
    IF (NEW.MasterKeyValue <> OLD.MasterKeyValue) OR (_replica.num_nulls(NEW.MasterKeyValue::TEXT, OLD.MasterKeyValue::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'MasterKeyValue');
    END IF;
    IF (NEW.ChildKeyValue <> OLD.ChildKeyValue) OR (_replica.num_nulls(NEW.ChildKeyValue::TEXT, OLD.ChildKeyValue::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'ChildKeyValue');
    END IF;
    IF (NEW.WhereObjectId <> OLD.WhereObjectId) OR (_replica.num_nulls(NEW.WhereObjectId::TEXT, OLD.WhereObjectId::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'WhereObjectId');
    END IF;
    IF _cols IS NULL THEN
      RETURN current_row;
    END IF;
  END IF;


  IF _replica.zc_isReplica_two() = TRUE
  THEN
      INSERT INTO _replica.table_update_data_two (schema_name, table_name, pk_keys, pk_values, upd_cols, operation, transaction_id, user_name, amount)
           VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, 'Id', current_row.Id, _cols, TG_OP, txid_current(), session_user, current_row.amount);
  ELSE
      INSERT INTO _replica.table_update_data (schema_name, table_name, pk_keys, pk_values, upd_cols, operation, transaction_id, user_name, amount)
           VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, 'Id', current_row.Id, _cols, TG_OP, txid_current(), session_user, current_row.amount);
  END IF;

  -- уведомление клиенту
  -- PERFORM pg_notify('_replica_table_notify_', '');--Format('[%s, %s]',TG_TABLE_SCHEMA, TG_TABLE_NAME));

  RETURN current_row;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE;
