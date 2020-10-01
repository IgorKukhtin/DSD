-- Function: gpCheck_SequencesMaster()

DROP FUNCTION IF EXISTS _replica.gpCheck_SequencesMaster();
DROP FUNCTION IF EXISTS _replica.gpCheck_SequencesMaster(TVarChar, TVarChar, TVarChar);

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