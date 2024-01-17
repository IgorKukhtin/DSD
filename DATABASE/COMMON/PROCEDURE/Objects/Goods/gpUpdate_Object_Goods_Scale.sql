-- Function: gpUpdateObject_Goods_Scale()


DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_Scale (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_Scale(
    IN inId                Integer   , -- Ключ объекта <товар>
    IN inName_Scale        TVarChar  , -- 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Goods_Scale());
     --vbUserId:= lpGetUserBySession (inSession);


     -- проверка прав пользователя на вызов процедуры
     IF 1=1 AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_Goods_Scale())
     THEN
         RAISE EXCEPTION 'Ошибка.Нет Прав на изменение <Название для приложения Scale>.';
     END IF;

     IF COALESCE (inId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент справочника не выбран.';
         --RETURN;
     END IF;

     -- сохранили свойство <Название для Scale>
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Scale(), inId, inName_Scale);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.01.24         *
*/


-- тест
--