-- Function: gpUpdate_Object_isErased_SignInternal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_SignInternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_SignInternal(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_SignInternal());

   -- изменили
   PERFORM lp_Delete_Object (inObjectId, inSession) ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_isErased_SignInternal (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.08.16         *
*/
