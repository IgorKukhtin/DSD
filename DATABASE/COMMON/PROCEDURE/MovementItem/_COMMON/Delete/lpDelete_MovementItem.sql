-- Function: lpDelete_MovementItem(integer, tvarchar)

-- DROP FUNCTION lpDelete_MovementItem(integer, tvarchar);

CREATE OR REPLACE FUNCTION lpDelete_MovementItem(
IN inId integer, 
IN Session tvarchar)
  RETURNS void AS
$BODY$BEGIN

  DELETE FROM MovementItemReport WHERE MovementItemId = inId;
  DELETE FROM MovementItemContainer WHERE MovementItemId = inId;
  DELETE FROM MovementItemLinkObject WHERE MovementItemId = inId;
  DELETE FROM MovementItemString WHERE MovementItemId = inId;
  DELETE FROM MovementItemDate WHERE MovementItemId = inId;
  DELETE FROM MovementItemFloat WHERE MovementItemId = inId;
  DELETE FROM MovementItemProtocol WHERE MovementItemId = inId;
  DELETE FROM MovementItemBoolean WHERE MovementItemId = inId;
  DELETE FROM MovementItem WHERE Id = inId;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.05.14                                        * add MovementItemProtocol
*/
