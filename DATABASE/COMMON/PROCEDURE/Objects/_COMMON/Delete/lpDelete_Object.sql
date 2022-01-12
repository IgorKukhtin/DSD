-- Function: lpDelete_Object(integer, tvarchar)

-- DROP FUNCTION lpDelete_Object(integer, tvarchar);

CREATE OR REPLACE FUNCTION lpDelete_Object(
IN inId integer, 
IN Session tvarchar)
  RETURNS void AS
$BODY$
  DECLARE vbDescId Integer;
BEGIN

/*

  RAISE EXCEPTION 'Серьезный скрипт !!!НЕ ДЛЯ РАБОЧЕЙ БАЗЫ!!!';

  -- Серьезный скрипт !!!НЕ ДЛЯ РАБОЧЕЙ БАЗЫ!!!
  DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryFloat.objecthistoryid IN 
        (SELECT ID FROM ObjectHistory WHERE ObjectId = inId);
  DELETE FROM ObjectHistoryString WHERE ObjectHistoryString.objecthistoryid IN 
        (SELECT ID FROM ObjectHistory WHERE ObjectId = inId);
  DELETE FROM ObjectHistoryLink WHERE ObjectHistoryLink.objecthistoryid IN 
        (SELECT ID FROM ObjectHistory WHERE ObjectId = inId);
  DELETE FROM ObjectHistory  WHERE ObjectId = inId;
  DELETE FROM DefaultValue  WHERE UserKeyId = inId;
  DELETE FROM MovementItemProtocol WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId);
--  DELETE FROM MovementItemReport WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId);
  DELETE FROM MovementItemContainer WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId);
  DELETE FROM MovementItemString WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId);
  DELETE FROM MovementItemFloat WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId);
  DELETE FROM MovementItemDate WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId);
  DELETE FROM MovementItemBoolean WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId);
  DELETE FROM MovementItemLinkObject WHERE ObjectId = inId;
  DELETE FROM MovementItemLinkObject WHERE MovementItemId in (SELECT Id FROM MovementItem WHERE ObjectId = inId);
  DELETE FROM MovementLinkObject WHERE ObjectId = inId;
  DELETE FROM MovementItem WHERE ObjectId = inId;
  DELETE FROM ContainerLinkObject WHERE ContainerId in (SELECT Id FROM Container WHERE ObjectId = inId);
  DELETE FROM Container WHERE ObjectId = inId;
  DELETE FROM ContainerLinkObject WHERE ObjectId = inId;
  -- truncate table movementitemcontainer

  DELETE FROM ContainerLinkObjectDesc WHERE ObjectDescId in (select id FROM ObjectDesc where id between 1 and 7);
  DELETE FROM ObjectLinkDesc WHERE ChildObjectDescId in (select id FROM ObjectDesc where id between 1 and 7);
  DELETE FROM ObjectLinkDesc WHERE DescId = vbObjectDescId;
  DELETE FROM ObjectStringDesc WHERE DescId = vbObjectDescId;
  DELETE FROM ObjectBLOBDesc WHERE DescId = vbObjectDescId;
  DELETE FROM ObjectFloatDesc WHERE DescId = vbObjectDescId;
  DELETE FROM ObjectBooleanDesc WHERE DescId = vbObjectDescId;
  DELETE FROM ObjectDateDesc WHERE DescId = vbObjectDescId;
  DELETE FROM ObjectDesc WHERE Id = vbObjectDescId;

*/
  DELETE FROM ObjectLink WHERE ObjectId = inId;
  -- DELETE FROM ObjectLink WHERE ChildObjectId = inId;
  DELETE FROM ObjectString WHERE ObjectId = inId;
  DELETE FROM ObjectBLOB WHERE ObjectId = inId;
  DELETE FROM ObjectFloat WHERE ObjectId = inId;
  DELETE FROM ObjectProtocol WHERE ObjectId = inId;
  DELETE FROM ObjectBoolean WHERE ObjectId = inId;
  DELETE FROM ObjectDate WHERE ObjectId = inId;
  DELETE FROM Object WHERE Id = inId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpDelete_Object(integer, tvarchar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.04.15                                        * Серьезный скрипт !!!НЕ ДЛЯ РАБОЧЕЙ БАЗЫ!!!
 01.01.14          *
*/
