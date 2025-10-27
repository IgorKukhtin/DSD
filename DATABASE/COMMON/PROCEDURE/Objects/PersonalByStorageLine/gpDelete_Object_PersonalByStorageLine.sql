-- Function: gpDelete_Object_PersonalByStorageLine( TVarChar)
--удалить все элементы справочника, только под правами админа

DROP FUNCTION IF EXISTS gpDelete_Object_PersonalByStorageLine ( TVarChar);


CREATE OR REPLACE FUNCTION gpDelete_Object_PersonalByStorageLine(
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);
   
   
    -- проверка
   IF vbUserId <> zfCalc_UserAdmin()
   THEN
       RAISE EXCEPTION 'Ошибка. Удаление ВСЕХ элементов справочника разрешено только Администратору.';
   END IF;

   PERFORM lpUpdate_Object_isErased (inObjectId:= Object.Id, inUserId:= vbUserId)
   FROM Object
   WHERE Object.DescId = zc_Object_PersonalByStorageLine()
     AND Object.IsErased = FALSE
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.10.25         * 
*/