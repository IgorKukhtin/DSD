-- Function: lpDelete_Object(integer, tvarchar)

-- DROP FUNCTION lpDelete_Object(integer, tvarchar);

CREATE OR REPLACE FUNCTION lpDelete_ObjectForTest(
IN inId integer, 
IN Session tvarchar)
  RETURNS void AS
$BODY$
BEGIN
  RAISE EXCEPTION 'Ошибка.<%>', 'lpDelete_ObjectForTest';
  -- Серьезный скрипт !!!НЕ ДЛЯ РАБОЧЕЙ БАЗЫ!!!
  /*DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryFloat.objecthistoryid IN 
        (SELECT ID FROM ObjectHistory WHERE ObjectId = inId);
  DELETE FROM ObjectHistoryString WHERE ObjectHistoryString.objecthistoryid IN 
        (SELECT ID FROM ObjectHistory WHERE ObjectId = inId);
  DELETE FROM ObjectHistoryLink WHERE ObjectHistoryLink.objecthistoryid IN 
        (SELECT ID FROM ObjectHistory WHERE ObjectId = inId);
  DELETE FROM ObjectHistory  WHERE ObjectId = inId;
  DELETE FROM DefaultValue  WHERE UserKeyId = inId;
 -- DELETE FROM MovementItemProtocol WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId);
  --DELETE FROM MovementItemReport WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId); 
  
  --DELETE FROM MovementItemContainer WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId);                      
  --DELETE FROM MovementItem WHERE Id = inId  --in (SELECT Id FROM MovementItem WHERE ObjectId = inId); ---!
  --DELETE FROM MovementItem WHERE ObjectId = inId;  
  PERFORM lpDelete_MovementItem (MovementItem.Id, Session) FROM MovementItem WHERE ObjectId = inId;
  DELETE FROM MovementItemContainer WHERE ObjectId_analyzer = inId;
  DELETE FROM MovementItemContainer WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId);
  DELETE FROM ContainerLinkObject WHERE ObjectId = inId;
  DELETE FROM ContainerLinkObject WHERE containerId IN (SELECT Id FROM Container WHERE ParentId IN (SELECT Id FROM Container WHERE ObjectId = inId));
  DELETE FROM ContainerLinkObject WHERE containerId IN (SELECT Id FROM Container WHERE ObjectId = inId);
  DELETE FROM Container WHERE Id IN (SELECT Id FROM Container WHERE ParentId IN (SELECT Id FROM Container WHERE ObjectId = inId));
  DELETE FROM Container WHERE ObjectId = inId;
  
  DELETE FROM MovementItemString WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId);
  DELETE FROM MovementItemFloat WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId);
  DELETE FROM MovementItemFloat WHERE ValueData in (SELECT Id FROM MovementItem WHERE ObjectId = inId);
  DELETE FROM MovementItemDate WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId);
  DELETE FROM MovementItemBoolean WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId);
  DELETE FROM MovementItemLinkObject WHERE ObjectId = inId;
  DELETE FROM MovementItemLinkObject WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId);
  DELETE FROM MovementLinkObject WHERE ObjectId = inId;  
 --DELETE FROM MovementItem WHERE ParentId in (SELECT Id FROM MovementItem WHERE ObjectId = inId); ---!
  DELETE FROM MovementItem WHERE ObjectId = inId;
  DELETE FROM Container WHERE ObjectId = inId;
  DELETE FROM ContainerLinkObject WHERE ObjectId = inId;
  DELETE FROM ObjectLink WHERE ObjectId = inId;
  DELETE FROM ObjectLink WHERE ChildObjectId = inId;
  DELETE FROM ObjectString WHERE ObjectId = inId;
  DELETE FROM ObjectBLOB WHERE ObjectId = inId;
  DELETE FROM ObjectFloat WHERE ObjectId = inId;
  DELETE FROM ObjectProtocol WHERE ObjectId = inId;
  DELETE FROM ObjectBoolean WHERE ObjectId = inId;
  DELETE FROM ObjectDate WHERE ObjectId = inId;
  DELETE FROM Object WHERE Id = inId;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpDelete_ObjectForTest(integer, tvarchar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.04.15                                        * Серьезный скрипт !!!НЕ ДЛЯ РАБОЧЕЙ БАЗЫ!!!
 01.01.14          *
*/
