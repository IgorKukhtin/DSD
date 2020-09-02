/* ************************************************************************** */
/* 
num_nulls -  вспомогательная функция для проверки нулевых значений.
             Возвращает количество NULL значений в массиве аргументов
*/
CREATE OR REPLACE FUNCTION _replica.num_nulls(VARIADIC TEXT[])  RETURNS INTEGER
AS $$
DECLARE 
  F TEXT;
  R INTEGER;
BEGIN
  R = 0;
  FOREACH F IN ARRAY  $1 LOOP
    IF F IS NULL THEN
      R := R + 1;
    END IF;
  END LOOP;
  RETURN R;
END;
$$ LANGUAGE plpgsql;

/* ************************************************************************** */


/* 
notice_changed_data_container -  триггерная функция для таблицы container
*/


CREATE OR REPLACE FUNCTION _replica.notice_changed_data_container() RETURNS trigger AS $$
DECLARE
  current_row   RECORD; 
  ri            RECORD;  
  _cols  TEXT[];
BEGIN
  IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
    current_row := NEW;
  ELSE
    current_row := OLD;
  END IF;
  
  -- При обновлении получим имена полей, данные которых имзенились.
  IF (TG_OP = 'UPDATE') THEN
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
  
  INSERT INTO _replica.table_update_data(schema_name, table_name, pk_keys, pk_values, upd_cols, operation, transaction_id, user_name)  
       VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, 'Id', current_row.Id, _cols, TG_OP, txid_current(), session_user);  

  
  -- уведомление клиенту
  PERFORM pg_notify('_replica_table_notify_', '');--Format('[%s, %s]',TG_TABLE_SCHEMA, TG_TABLE_NAME));

  RETURN current_row;
END;
$$ LANGUAGE plpgsql;


/* ************************************************************************** */


/* 
notice_changed_data_movementitemcontainer -  триггерная функция для таблицы movementitemcontainer
                    
*/

CREATE OR REPLACE FUNCTION _replica.notice_changed_data_movementitemcontainer() RETURNS trigger AS $$
DECLARE
  current_row   RECORD; 
  ri            RECORD;  
  _cols  TEXT[];
BEGIN
  IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
    current_row := NEW;
  ELSE
    current_row := OLD;
  END IF;
  
  -- При обновлении получим имена полей, данные которых имзенились.
  IF (TG_OP = 'UPDATE') THEN
    IF (NEW.id <> OLD.id) OR (_replica.num_nulls(NEW.id::TEXT, OLD.id::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'Id');	    
    END IF;
    IF (NEW.DescId <> OLD.DescId) OR (_replica.num_nulls(NEW.DescId::TEXT, OLD.DescId::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'DescId');	    
    END IF;
    IF (NEW.MovementId <> OLD.MovementId) OR (_replica.num_nulls(NEW.MovementId::TEXT, OLD.MovementId::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'MovementId');	    
    END IF;
    IF (NEW.ContainerId <> OLD.ContainerId) OR (_replica.num_nulls(NEW.ContainerId::TEXT, OLD.ContainerId::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'ContainerId');	    
    END IF;
    IF (NEW.Amount <> OLD.Amount) OR (_replica.num_nulls(NEW.Amount::TEXT, OLD.Amount::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'Amount');	    
    END IF;
    IF (NEW.OperDate <> OLD.OperDate) OR (_replica.num_nulls(NEW.OperDate::TEXT, OLD.OperDate::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'OperDate');	    
    END IF;
    IF (NEW.MovementItemId <> OLD.MovementItemId) OR (_replica.num_nulls(NEW.MovementItemId::TEXT, OLD.MovementItemId::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'MovementItemId');	    
    END IF;
    IF (NEW.ParentId <> OLD.ParentId) OR (_replica.num_nulls(NEW.ParentId::TEXT, OLD.ParentId::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'ParentId');	    
    END IF;
    IF (NEW.isActive <> OLD.isActive) OR (_replica.num_nulls(NEW.isActive::TEXT, OLD.isActive::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'isActive');	    
    END IF;    
    IF (NEW.MovementDescId <> OLD.MovementDescId) OR (_replica.num_nulls(NEW.MovementDescId::TEXT, OLD.MovementDescId::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'MovementDescId');	    
    END IF; 
    IF (NEW.AnalyzerId <> OLD.AnalyzerId) OR (_replica.num_nulls(NEW.AnalyzerId::TEXT, OLD.AnalyzerId::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'AnalyzerId');	    
    END IF; 
    IF (NEW.AccountId <> OLD.AccountId) OR (_replica.num_nulls(NEW.AccountId::TEXT, OLD.AccountId::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'AccountId');	    
    END IF; 
    IF (NEW.ObjectId_analyzer <> OLD.ObjectId_analyzer) OR (_replica.num_nulls(NEW.ObjectId_analyzer::TEXT, OLD.ObjectId_analyzer::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'ObjectId_analyzer');	    
    END IF;  
    IF (NEW.WhereObjectId_analyzer <> OLD.WhereObjectId_analyzer) OR (_replica.num_nulls(NEW.WhereObjectId_analyzer::TEXT, OLD.WhereObjectId_analyzer::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'WhereObjectId_analyzer');	    
    END IF;
    IF (NEW.ContainerId_analyzer <> OLD.ContainerId_analyzer) OR (_replica.num_nulls(NEW.ContainerId_analyzer::TEXT, OLD.ContainerId_analyzer::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'ContainerId_analyzer');	    
    END IF;
    IF (NEW.ObjectIntId_analyzer <> OLD.ObjectIntId_analyzer) OR (_replica.num_nulls(NEW.ObjectIntId_analyzer::TEXT, OLD.ObjectIntId_analyzer::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'ObjectIntId_analyzer');	    
    END IF;
    IF (NEW.ObjectExtId_analyzer <> OLD.ObjectExtId_analyzer) OR (_replica.num_nulls(NEW.ObjectExtId_analyzer::TEXT, OLD.ObjectExtId_analyzer::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'ObjectExtId_analyzer');	    
    END IF;
    IF (NEW.ContainerIntId_analyzer <> OLD.ContainerIntId_analyzer) OR (_replica.num_nulls(NEW.ContainerIntId_analyzer::TEXT, OLD.ContainerIntId_analyzer::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'ContainerIntId_analyzer');	    
    END IF;
    IF (NEW.AccountId_analyzer <> OLD.AccountId_analyzer) OR (_replica.num_nulls(NEW.AccountId_analyzer::TEXT, OLD.AccountId_analyzer::TEXT) = 1) THEN
      _cols  := array_append(_cols, 'AccountId_analyzer');	    
    END IF;    
    IF _cols IS NULL THEN
      RETURN current_row;    
    END IF;
  END IF;
  
  INSERT INTO _replica.table_update_data(schema_name, table_name, pk_keys, pk_values, upd_cols, operation, transaction_id, user_name)  
       VALUES (TG_TABLE_SCHEMA, TG_TABLE_NAME, 'Id', current_row.Id, _cols, TG_OP, txid_current(), session_user);  

  
  -- уведомление клиенту
  PERFORM pg_notify('_replica_table_notify_', '');--Format('[%s, %s]',TG_TABLE_SCHEMA, TG_TABLE_NAME));

  RETURN current_row;
END;
$$ LANGUAGE plpgsql;

/*
Создание этих тригеров находится в приложении.
DROP TRIGGER IF EXISTS trigger_notify_changes_container ON public.container;
CREATE TRIGGER trigger_notify_changes_container
    BEFORE INSERT OR DELETE OR UPDATE 
    ON public.container
    FOR EACH ROW
    EXECUTE PROCEDURE _replica.notice_changed_data_container();

DROP TRIGGER IF EXISTS trigger_notify_changes_movementitemcontainer ON public.movementitemcontainer;    
CREATE TRIGGER trigger_notify_changes_movementitemcontainer
    BEFORE INSERT OR DELETE OR UPDATE 
    ON public.movementitemcontainer
    FOR EACH ROW
    EXECUTE PROCEDURE _replica.notice_changed_data_movementitemcontainer();    
*/