-- Function: lpDelete_Object(integer, tvarchar)

DROP FUNCTION IF EXISTS gpDelete_Object_ContractDocument(integer, tvarchar);

CREATE OR REPLACE FUNCTION gpDelete_Object_ContractDocument(
     IN inId integer, 
     IN inSession tvarchar)
RETURNS void AS
$BODY$
BEGIN

  -- т.к. в lpDelete_Object заблокировал
  -- DELETE FROM ObjectLink WHERE ChildObjectId = inId;
  -- т.к. в lpDelete_Object заблокировал
  DELETE FROM ObjectBLOB WHERE ObjectId = inId;

  PERFORM lpDelete_Object(inId, inSession);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_Object_ContractDocument(integer, tvarchar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.02.14                        *
*/
