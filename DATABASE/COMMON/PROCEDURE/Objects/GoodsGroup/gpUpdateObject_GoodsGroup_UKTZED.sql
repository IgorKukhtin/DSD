-- Function: gpUpdateObject_GoodsGroup_UKTZED()

DROP FUNCTION IF EXISTS gpUpdateObject_GoodsGroup_UKTZED (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_GoodsGroup_UKTZED(
    IN inId                  Integer   , -- Ключ объекта <товар>
    IN inUKTZED              TVarChar  , -- код товара по УКТ ЗЕД
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

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 13.01.17         *
*/


-- тест
-- SELECT * FROM gpUpdateObject_Goods_UKTZED (ioId:= 275079, inUKTZED:= '456/45', inSession:= '2')
