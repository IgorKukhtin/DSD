-- Function: lpCheckUnique_Object_ObjectCode(integer, integer,integer)

-- DROP FUNCTION lpCheckUnique_Object_ObjectCode(integer, integer,integer);

CREATE OR REPLACE FUNCTION lpCheckUnique_Object_ObjectCode(
inId integer, 
inDescId integer,
inObjectCode integer)
  RETURNS void AS   
$BODY$
DECLARE
  ObjectName TVarChar;  
BEGIN

  IF COALESCE( inObjectCode, 0) <> 0 THEN
    IF EXISTS (SELECT ObjectCode FROM Object WHERE DescId = inDescId AND ObjectCode = inObjectCode AND Id <> COALESCE( inId, 0) ) THEN
       SELECT ItemName INTO ObjectName FROM ObjectDesc WHERE Id = inDescId;
       RAISE EXCEPTION 'Значение "%" не уникально для справочника "%"', inObjectCode, ObjectName;
    END IF; 
  END IF; 

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpCheckUnique_Object_ObjectCode(integer, integer, integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.06.13          *
 16.06.13                                        * COALESCE( inObjectCode, 0) <> 0

*/

-- тест
-- SELECT * FROM lpCheckUnique_Object_ObjectCode( 0, zc_Object_Goods(), 1)
