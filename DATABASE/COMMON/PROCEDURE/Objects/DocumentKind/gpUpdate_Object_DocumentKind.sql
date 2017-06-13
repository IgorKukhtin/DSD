-- Function: gpUpdate_Object_DocumentKind()

DROP FUNCTION IF EXISTS gpUpdate_Object_DocumentKind (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_DocumentKind(
    IN inId                  Integer  , -- Ключ объекта <Типы документов>
    IN inGoodsId             Integer  , -- код товара по УКТ ЗЕД
    IN inGoodsKindId         Integer  , -- признак импортированного товара
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_DocumentKind());
     
     -- сохранили связь с <Товаром>
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DocumentKind_Goods(), inId, inGoodsId);
     -- сохранили связь с <Видом товаров>
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DocumentKind_GoodsKind(), inId, inGoodsKindId);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 13.06.17         *
*/


-- тест
-- SELECT * FROM gpUpdate_Object_DocumentKind (ioId:= 275079, inGoodsId:= 0, inGoodsKindId:= 0, inSession:= '2')
