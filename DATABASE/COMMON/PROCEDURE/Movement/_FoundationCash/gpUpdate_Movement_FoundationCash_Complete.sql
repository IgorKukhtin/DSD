-- Function: gpUpdate_Movement_FoundationCash_Complete(Integer, tvarchar)

-- DROP FUNCTION gpUpdate_Movement_FoundationCash_Complete(Integer, tvarchar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_FoundationCash_Complete(IN ioId Integer, Session tvarchar)
  RETURNS boolean AS
$BODY$
BEGIN
  -- 
  -- 
  RETURN true;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpUpdate_Movement_FoundationCash_Complete(Integer, tvarchar)
  OWNER TO postgres;
