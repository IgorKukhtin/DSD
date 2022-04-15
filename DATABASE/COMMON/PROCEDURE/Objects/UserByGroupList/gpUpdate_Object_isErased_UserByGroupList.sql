-- Function: gpUpdate_Object_isErased_UserByGroupList (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_UserByGroupList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_UserByGroupList(
    IN inObjectId Integer,
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_UserByGroupList());

   -- изменили
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.04.22         *
*/
