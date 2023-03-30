-- Function: gpUpdateObject_GoodsGroup_UKTZED()

DROP FUNCTION IF EXISTS gpUpdateObject_GoodsGroup_UKTZED_new (Integer, TVarChar, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_GoodsGroup_UKTZED_new(
    IN inId                  Integer   , -- Ключ объекта <товар>
    IN inUKTZED              TVarChar  , -- код товара по УКТ ЗЕД
    IN inUKTZED_new          TVarChar  , -- код товара по УКТ ЗЕД   новый
    IN inDateUKTZED_new      TDateTime , -- дата действия для код товара по УКТЗЕД   новый 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectString_GoodsGroup_UKTZED());
     vbUserId:= lpGetUserBySession (inSession);


     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsGroup_UKTZED(), inId, inUKTZED);
     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsGroup_UKTZED_new(), inId, inUKTZED_new);
     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_GoodsGroup_UKTZED_new(), inId, inDateUKTZED_new);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.03.23         *
*/


-- тест
--