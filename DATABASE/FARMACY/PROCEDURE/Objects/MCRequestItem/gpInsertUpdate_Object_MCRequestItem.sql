-- Function: gpInsertUpdate_Object_MCRequestItem(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MCRequestItem (Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MCRequestItem(
 INOUT ioId               Integer,       -- Ключ объекта <Настройка категории наценок>
    IN inMCRequestId      Integer, 
    IN inMinPrice         TFloat, 
    IN inMarginPercent    TFloat, 
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS INTEGER AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean; 
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_MarginCategory());
   vbUserId := inSession;

   IF COALESCE(inMCRequestId, 0) = 0 THEN
      RAISE EXCEPTION 'Необходимо определить "Запрос на изменение категории наценки"';
   END IF;

   -- определили <Признак новый или корректировка>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   IF COALESCE(ioId, 0) = 0 
   THEN
      -- сохранили <Объект>
      ioId := lpInsertUpdate_Object (0, zc_Object_MCRequestItem(), 0, '');
   END IF;

   -- сохранили связь с <Категорией наценки>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MCRequestItem_MCRequest(), ioId, inMCRequestId);

   -- сохранили свойство <Минимальная цена>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MCRequestItem_MinPrice(), ioId, inMinPrice);
   -- сохранили свойство <% наценки>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MCRequestItem_MarginPercent(), ioId, inMarginPercent);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_MCRequestItem (Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.02.17         *
 09.04.15                          *
*/

-- тест
-- BEGIN; SELECT * FROM gpInsertUpdate_Object_MCRequestItem(0, 2,'ау','2'); ROLLBACK