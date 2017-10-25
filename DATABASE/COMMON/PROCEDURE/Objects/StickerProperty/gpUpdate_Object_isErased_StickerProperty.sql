-- Function: gpUpdate_Object_isErased_Goods (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_StickerProperty (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_StickerProperty(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_StickerProperty());  --  zc_Enum_Process_Update_Object_isErased_StickerProperty

   -- изменили
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_isErased_StickerProperty (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
  24.10.17        *
*/
