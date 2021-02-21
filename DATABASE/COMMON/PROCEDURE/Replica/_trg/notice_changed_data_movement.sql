-- Function: _replica.notice_changed_data_movement()

-- DROP FUNCTION _replica.notice_changed_data_movement();

CREATE OR REPLACE FUNCTION _replica.notice_changed_data_movement()
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
    IF NEW.id <> OLD.id THEN
      _cols  := array_append(_cols, 'Id');
    END IF;
    IF NEW.DescId <> OLD.DescId THEN
      _cols  := array_append(_cols, 'DescId');
    END IF;
    IF NEW.InvNumber <> OLD.InvNumber THEN
      _cols  := array_append(_cols, 'InvNumber');
    END IF;
    IF NEW.OperDate <> OLD.OperDate THEN
      _cols  := array_append(_cols, 'OperDate');
    END IF;
    IF NEW.StatusId <> OLD.StatusId THEN
      _cols  := array_append(_cols, 'StatusId');
    END IF;
    IF NEW.ParentId <> OLD.ParentId THEN
      _cols  := array_append(_cols, 'ParentId');
    END IF;
    IF NEW.AccesskeyId <> OLD.AccesskeyId THEN
      _cols  := array_append(_cols, 'AccesskeyId');
    END IF;
    IF _cols IS NULL THEN
      RETURN current_row;
    END IF;
  END IF;


  IF _replica.zc_isReplica_two() = TRUE
  THEN
      INSERT INTO _replica.table_update_data_two (schema_name, table_name, pk_keys, pk_values, upd_cols, operation, ParentId, transaction_id, user_name)
           VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, 'Id', current_row.Id, _cols, TG_OP, current_row.ParentId, txid_current(), session_user);
  ELSE
      INSERT INTO _replica.table_update_data (schema_name, table_name, pk_keys, pk_values, upd_cols, operation, ParentId, transaction_id, user_name)
           VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, 'Id', current_row.Id, _cols, TG_OP, current_row.ParentId, txid_current(), session_user);
  END IF;

  -- уведомление клиенту
  -- PERFORM pg_notify('_replica_table_notify_', '');

  RETURN current_row;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
