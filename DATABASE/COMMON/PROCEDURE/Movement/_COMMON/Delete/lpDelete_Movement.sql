-- Function: lpDelete_Movement(integer, tvarchar)

-- DROP FUNCTION lpDelete_Movement(integer, tvarchar);

CREATE OR REPLACE FUNCTION lpDelete_Movement(
IN inId integer, 
IN Session tvarchar)
  RETURNS void AS
$BODY$BEGIN

  DELETE FROM MovementItemReport WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE MovementId = inId);
  DELETE FROM MovementItemContainer WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE MovementId = inId);
  DELETE FROM MovementItemString WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE MovementId = inId);
  DELETE FROM MovementItemDate WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE MovementId = inId);
  DELETE FROM MovementItemBoolean WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE MovementId = inId);
  DELETE FROM MovementItemFloat WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE MovementId = inId);
  DELETE FROM MovementItemLinkObject WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE MovementId = inId);
  DELETE FROM MovementItemProtocol WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE MovementId = inId);
  DELETE FROM MovementItem WHERE MovementId = inId;
  DELETE FROM MovementLinkMovement WHERE MovementId = inId;
  DELETE FROM MovementLinkMovement WHERE MovementChildId = inId;
  DELETE FROM MovementLinkObject WHERE MovementId = inId;
  DELETE FROM MovementBLOB WHERE MovementId = inId;
  DELETE FROM MovementString WHERE MovementId = inId;
  DELETE FROM MovementDate WHERE MovementId = inId;
  DELETE FROM MovementFloat WHERE MovementId = inId;
  DELETE FROM MovementProtocol WHERE MovementId = inId;
  DELETE FROM MovementBoolean WHERE MovementId = inId;
  DELETE FROM Movement WHERE Id = inId;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.05.14                                        * add MovementItemProtocol
*/
