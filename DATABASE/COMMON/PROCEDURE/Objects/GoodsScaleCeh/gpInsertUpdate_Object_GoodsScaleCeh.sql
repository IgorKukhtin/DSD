-- Function: gpInsertUpdate_Object_GoodsScaleCeh()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsScaleCeh (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsScaleCeh(
 INOUT ioId              Integer   , -- ключ объекта <Составляющие рецептур>
    IN inFromId          Integer   , --
    IN inToId            Integer   , -- 
    IN inGoodsId         Integer   , -- ссылка на Товары
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsScaleCeh());

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsScaleCeh(), 0, '');


   -- сохранили связь с <от кого>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsScaleCeh_From(), ioId, inFromId);
   -- сохранили связь с <кому>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsScaleCeh_To(), ioId, inToId);
   -- сохранили связь с <Товаром>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsScaleCeh_Goods(), ioId, inGoodsId);

   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE 
      -- сохранили свойство <Дата корр.>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (корр.)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);
   END IF;
    
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.06.19         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsScaleCeh ()
