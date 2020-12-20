-- Function: lpCheckUnique_ObjectString_ValueData(integer, tvarchar)

-- DROP FUNCTION lpCheckUnique_ObjectString_ValueData(integer, tvarchar);

-- Процедура проверяет уникальность поля ValueData у объекта

CREATE OR REPLACE FUNCTION lpCheckUnique_ObjectString_ValueData(
        inId        integer, 
        inDescId    integer,
        inValueData tvarchar,
        inUserId    integer)
  RETURNS void AS
$BODY$
DECLARE
  ObjectName TVarChar;
  FieldName TVarChar;  
BEGIN
  IF EXISTS (SELECT ValueData FROM ObjectString WHERE DescId = inDescId AND ValueData = inValueData AND ObjectId <> inId) THEN
     SELECT ObjectDesc.ItemName, ObjectStringDesc.ItemName INTO ObjectName, FieldName
     FROM ObjectDesc 
     JOIN ObjectStringDesc 
       ON ObjectStringDesc.DescId = ObjectDesc.Id
        WHERE ObjectStringDesc.Id = inDescId;

     --RAISE EXCEPTION 'Значение "%" не уникально для поля "%" справочника "%"', inValueData, FieldName, ObjectName;
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Значение "<%>" не уникально для поля "<%>" справочника "<%>"' :: TVarChar
                                             , inProcedureName := 'lpCheckUnique_ObjectString_ValueData'    :: TVarChar
                                             , inUserId        := inUserId
                                             , inParam1        := inValueData :: TVarChar
                                             , inParam2        := FieldName   :: TVarChar
                                             , inParam3        := ObjectName  :: TVarChar
                                             );
  END IF; 
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpCheckUnique_ObjectString_ValueData(integer, integer, tvarchar)
  OWNER TO postgres;
