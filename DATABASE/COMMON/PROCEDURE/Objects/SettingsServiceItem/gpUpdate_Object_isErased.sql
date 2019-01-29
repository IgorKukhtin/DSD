-- Function: gpUpdate_Object_isErased (Integer, TVarChar)

-- DROP FUNCTION gpUpdate_Object_isErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased(
    IN inObjectId Integer, 
    IN inSession    TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверки прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   -- изменили
   UPDATE Object SET isErased = TRUE WHERE Id = inObjectId;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= inObjectId, inUserId:= vbUserId, inIsUpdate:= TRUE, inIsErased:= TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 29.01.19         *
*/
