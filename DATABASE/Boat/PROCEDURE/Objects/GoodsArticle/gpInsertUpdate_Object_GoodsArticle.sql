-- Function: gpInsertUpdate_Object_GoodsArticle()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsArticle(Integer, TVarChar, Integer, TVarChar);
CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsArticle(
 INOUT ioId                     Integer   , -- ключ объекта >
    IN inName                   TVarChar  , --
    IN inGoodsId                Integer,
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsArticle(), 0, inName, NULL);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsArticle_Goods(), ioId, inGoodsId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.04.22         *
*/

-- тест
--