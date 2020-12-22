-- Function: lpUpdate_Object_isErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS lpUpdate_Object_isErased (Integer, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Object_isErased (Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_isErased(
    IN inObjectId    Integer,
    IN inIsErased    Boolean, 
    IN inUserId      Integer
)
RETURNS VOID
AS
$BODY$
   DECLARE vbIsErased Boolean;
BEGIN

   -- изменили
   UPDATE Object SET isErased = inIsErased WHERE Id = inObjectId  RETURNING DescId, isErased INTO vbDescId, vbIsErased;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= inObjectId, inUserId:= inUserId, inIsUpdate:= TRUE, inIsErased:= TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.09.14                                        * add синхронизируем удаление
 08.05.14                                        *
*/
