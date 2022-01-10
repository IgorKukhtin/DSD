-- Function: lpCheckUnique_Object_ValueData(integer, tvarchar)

-- DROP FUNCTION lpCheckUnique_Object_ValueData(integer, tvarchar);

CREATE OR REPLACE FUNCTION lpCheckUnique_Object_ValueData(
   inId        integer, 
   inDescId    integer,
   inValueData tvarchar,
   inUserId    integer
   )
  RETURNS void AS
$BODY$
   DECLARE ObjectName TVarChar;  

BEGIN
  IF EXISTS (SELECT ValueData FROM Object WHERE DescId = inDescId AND ValueData = inValueData AND Id <> COALESCE(inId, 0) ) THEN
     SELECT ItemName INTO ObjectName FROM ObjectDesc WHERE Id = inDescId;

     --RAISE EXCEPTION 'Значение "%" не уникально для справочника "%"', inValueData, ObjectName;
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Значение "<%>" не уникально для справочника "<%>"' :: TVarChar
                                             , inProcedureName := 'lpCheckUnique_Object_ValueData'    :: TVarChar
                                             , inUserId        := inUserId
                                             , inParam1        := inValueData :: TVarChar
                                             , inParam2        := ObjectName  :: TVarChar
                                             );
  END IF; 
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpCheckUnique_Object_ValueData(integer, integer, tvarchar)
  OWNER TO postgres;
