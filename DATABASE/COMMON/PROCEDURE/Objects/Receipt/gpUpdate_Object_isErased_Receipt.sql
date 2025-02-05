-- Function: gpUpdate_Object_isErased_Receipt (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_Receipt (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_Receipt(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Receipt());

   -- изменили
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);
   -- !!!!!! PERFORM lp_Delete_Object (inObjectId, inSession) ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_isErased_Receipt (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.11.15         *
*/
