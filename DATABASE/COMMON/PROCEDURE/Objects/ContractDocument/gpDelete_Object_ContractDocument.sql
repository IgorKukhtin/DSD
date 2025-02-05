-- Function: gpDelete_Object_ContractDocument(integer, tvarchar)

DROP FUNCTION IF EXISTS gpDelete_Object_ContractDocument(integer, tvarchar);

CREATE OR REPLACE FUNCTION gpDelete_Object_ContractDocument(
     IN inId integer, 
     IN inSession tvarchar)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- НЕТ проверки прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   -- т.к. в lp Delete_Object заблокировал
   -- DELETE FROM ObjectLink WHERE ChildObjectId = inId;
   -- т.к. в lp Delete_Object заблокировал

   -- DELETE FROM ObjectBLOB WHERE ObjectId = inId;
   -- PERFORM lp Delete_Object(inId, inSession);
   
   -- изменили
   PERFORM lpUpdate_Object_isErased (inObjectId:= inId, inUserId:= vbUserId);
  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.02.14                        *
*/
