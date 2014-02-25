-- Function: gpUpdateObjectIsErased (Integer, TVarChar)

-- DROP FUNCTION gpUpdateObjectIsErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObjectIsErased(
    IN inObjectId Integer, 
    IN Session    TVarChar
)
RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (Session);

   UPDATE Object SET isErased = NOT isErased WHERE Id = inObjectId;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= inObjectId, inUserId:= vbUserId, inIsUpdate:= TRUE, inIsErased:= TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdateObjectIsErased (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 25.02.14                                        *
*/
