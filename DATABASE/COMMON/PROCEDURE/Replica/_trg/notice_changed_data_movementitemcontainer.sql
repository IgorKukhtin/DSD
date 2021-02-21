-- Function: _replica.notice_changed_data_movementitemcontainer()

-- DROP FUNCTION _replica.notice_changed_data_movementitemcontainer();

CREATE OR REPLACE FUNCTION _replica.notice_changed_data_movementitemcontainer()
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
    IF NEW.MovementId <> OLD.MovementId THEN
      _cols  := array_append(_cols, 'MovementId');
    END IF;
    IF NEW.ContainerId <> OLD.ContainerId THEN
      _cols  := array_append(_cols, 'ContainerId');
    END IF;
    IF NEW.Amount <> OLD.Amount THEN
      _cols  := array_append(_cols, 'Amount');
    END IF;
    IF NEW.OperDate <> OLD.OperDate THEN
      _cols  := array_append(_cols, 'OperDate');
    END IF;
    IF NEW.MovementItemId <> OLD.MovementItemId THEN
      _cols  := array_append(_cols, 'MovementItemId');
    END IF;
    IF NEW.ParentId <> OLD.ParentId THEN
      _cols  := array_append(_cols, 'ParentId');
    END IF;
    IF NEW.isActive <> OLD.isActive THEN
      _cols  := array_append(_cols, 'isActive');
    END IF;
    IF NEW.MovementDescId <> OLD.MovementDescId THEN
      _cols  := array_append(_cols, 'MovementDescId');
    END IF;
    IF NEW.AnalyzerId <> OLD.AnalyzerId THEN
      _cols  := array_append(_cols, 'AnalyzerId');
    END IF;
    IF NEW.AccountId <> OLD.AccountId THEN
      _cols  := array_append(_cols, 'AccountId');
    END IF;
    IF NEW.ObjectId_analyzer <> OLD.ObjectId_analyzer THEN
      _cols  := array_append(_cols, 'ObjectId_analyzer');
    END IF;
    IF NEW.WhereObjectId_analyzer <> OLD.WhereObjectId_analyzer THEN
      _cols  := array_append(_cols, 'WhereObjectId_analyzer');
    END IF;
    IF NEW.ContainerId_analyzer <> OLD.ContainerId_analyzer THEN
      _cols  := array_append(_cols, 'ContainerId_analyzer');
    END IF;
    IF NEW.ObjectIntId_analyzer <> OLD.ObjectIntId_analyzer THEN
      _cols  := array_append(_cols, 'ObjectIntId_analyzer');
    END IF;
    IF NEW.ObjectExtId_analyzer <> OLD.ObjectExtId_analyzer THEN
      _cols  := array_append(_cols, 'ObjectExtId_analyzer');
    END IF;
    IF NEW.ContainerIntId_analyzer <> OLD.ContainerIntId_analyzer THEN
      _cols  := array_append(_cols, 'ContainerIntId_analyzer');
    END IF;
    IF NEW.AccountId_analyzer <> OLD.AccountId_analyzer THEN
      _cols  := array_append(_cols, 'AccountId_analyzer');
    END IF;
    IF _cols IS NULL THEN
      RETURN current_row;
    END IF;
  END IF;


  IF _replica.zc_isReplica_two() = TRUE
  THEN
      INSERT INTO _replica.table_update_data_two (schema_name, table_name, pk_keys, pk_values, upd_cols, operation, MovementId, ParentId, transaction_id, user_name)
           VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, 'Id', current_row.Id, _cols, TG_OP, current_row.MovementId, current_row.ParentId, txid_current(), session_user);
  ELSE
      INSERT INTO _replica.table_update_data (schema_name, table_name, pk_keys, pk_values, upd_cols, operation, MovementId, ParentId, transaction_id, user_name)
           VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, 'Id', current_row.Id, _cols, TG_OP, current_row.MovementId, current_row.ParentId, txid_current(), session_user);
  END IF;

  -- уведомление клиенту
  -- PERFORM pg_notify('_replica_table_notify_', '');--Format('[%s, %s]',TG_TABLE_SCHEMA, TG_TABLE_NAME));

  RETURN current_row;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
