-- Function: lpDelete_MovementItem(integer, tvarchar)

-- DROP FUNCTION lpDelete_MovementItem(integer, tvarchar);

CREATE OR REPLACE FUNCTION lpDelete_MovementItem(
IN inId integer, 
IN Session tvarchar)
  RETURNS void AS
$BODY$BEGIN

  DELETE FROM MovementItemDate WHERE MovementItemId IN (SELECT Id FROM  MovementItem WHERE ParentId = inId);
  DELETE FROM MovementItemFloat WHERE MovementItemId IN (SELECT Id FROM  MovementItem WHERE ParentId = inId);
  DELETE FROM MovementItemBoolean WHERE MovementItemId IN (SELECT Id FROM  MovementItem WHERE ParentId = inId);
  DELETE FROM MovementItemString WHERE MovementItemId IN (SELECT Id FROM  MovementItem WHERE ParentId = inId);
  DELETE FROM MovementItemLinkObject WHERE MovementItemId IN (SELECT Id FROM  MovementItem WHERE ParentId = inId);
  DELETE FROM MovementItemBLOB WHERE MovementItemId IN (SELECT Id FROM  MovementItem WHERE ParentId = inId);
  DELETE FROM MovementItem WHERE ParentId = inId;
  DELETE FROM MovementItemReport WHERE MovementItemId = inId;
  DELETE FROM MovementItemContainer WHERE MovementItemId = inId;
  DELETE FROM MovementItemLinkObject WHERE MovementItemId = inId;
  DELETE FROM MovementItemString WHERE MovementItemId = inId;
  DELETE FROM MovementItemDate WHERE MovementItemId = inId;
  DELETE FROM MovementItemFloat WHERE MovementItemId = inId;
  DELETE FROM MovementItemProtocol WHERE MovementItemId = inId;
  DELETE FROM MovementItemBoolean WHERE MovementItemId = inId;
  DELETE FROM MovementItemBLOB WHERE MovementItemId = inId;
  DELETE FROM MovementItem WHERE Id = inId;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.05.14                                        * add MovementItemProtocol
*/
