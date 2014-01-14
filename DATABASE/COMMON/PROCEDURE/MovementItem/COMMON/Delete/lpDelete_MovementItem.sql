-- Function: lpDelete_MovementItem(integer, tvarchar)

-- DROP FUNCTION lpDelete_MovementItem(integer, tvarchar);

CREATE OR REPLACE FUNCTION lpDelete_MovementItem(
IN inId integer, 
IN Session tvarchar)
  RETURNS void AS
$BODY$BEGIN

  DELETE FROM MovementItemLinkObject WHERE MovementItemId = inId;
  DELETE FROM MovementItemString WHERE MovementItemId = inId;
  DELETE FROM MovementItemDate WHERE MovementItemId = inId;
  DELETE FROM MovementItemFloat WHERE MovementItemId = inId;
--  DELETE FROM MovementItemProtocol WHERE MovementItemId = inId;
  DELETE FROM MovementItemBoolean WHERE MovementItemId = inId;
  DELETE FROM MovementItem WHERE Id = inId;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpDelete_MovementItem(integer, tvarchar)
  OWNER TO postgres;