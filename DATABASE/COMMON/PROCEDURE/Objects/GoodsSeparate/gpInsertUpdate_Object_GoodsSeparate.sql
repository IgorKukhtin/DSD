-- Function: gpInsertUpdate_Object_GoodsSeparate()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSeparate (Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSeparate (Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsSeparate(
 INOUT ioId              Integer   , -- ключ объекта <Составляющие рецептур>
    IN inGoodsMasterId   Integer   , --
    IN inGoodsId         Integer   , -- ссылка на Товары
    IN inGoodsKindId     Integer   , -- ссылка на Виды товаров
    IN inIsCalculated    Boolean   , -- Входит в осн. сырье (100 кг.)
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsSeparate());

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsSeparate(), 0, '');


   -- сохранили связь с <Товаром>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsSeparate_Goods(), ioId, inGoodsId);
   -- сохранили связь с <Видом товаров>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsSeparate_GoodsKind(), ioId, inGoodsKindId);

   -- сохранили связь с <гл Товаром>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsSeparate_GoodsMaster(), ioId, inGoodsMasterId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsSeparate_Calculated(), ioId, inIsCalculated);


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
 09.11.18         *
 07.10.18         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsSeparate ()
