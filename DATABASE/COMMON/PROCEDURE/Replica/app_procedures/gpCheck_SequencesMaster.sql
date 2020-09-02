/* 
  _replica.gpCheck_SequencesMaster() - ‘ункци€ провер€ет, не превышает ли сохраненный StartId максимальный Id дл€ таблицы. 
                                       Ќужна дл€ определени€ того, что StartId нужно переформировать (во врем€ обновлени€ sequence кто-то успел вставить данные)
*/  
CREATE OR REPLACE FUNCTION _replica.gpCheck_SequencesMaster(inSchema TVarChar, inTable TVarChar, inColumn TVarChar)
RETURNS BOOLEAN AS
$BODY$
DECLARE vbStartId BIGINT;
DECLARE vbMaxId BIGINT;
BEGIN

  EXECUTE 'SELECT MAX('|| inColumn ||') FROM ' || inSchema || '.' || inTable INTO vbMaxId;
  vbStartId := (SELECT start_id FROM _replica.table_slave WHERE master_schema = inSchema AND master_table = inTable);
  
  IF COALESCE(vbMaxId, 0) >= COALESCE(vbStartId, 0) THEN
    RETURN FALSE;
  ELSE 
    RETURN TRUE;
  END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;   
