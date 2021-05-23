-- Function: gpUpdate_Object_isErased_Juridical (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_Juridical (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_Juridical(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   vbUserId:= lpGetUserBySession (inSession);


   IF vbUserId = 2731040 -- Зянько В.Я.
      AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.isErased = TRUE)
   THEN
       -- НЕТ проверки прав пользователя на вызов процедуры
       vbUserId:= lpGetUserBySession (inSession);
   ELSE
       -- проверка прав пользователя на вызов процедуры
       vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_Juridical());
   END IF;

   -- изменили
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.04.20         *
*/
