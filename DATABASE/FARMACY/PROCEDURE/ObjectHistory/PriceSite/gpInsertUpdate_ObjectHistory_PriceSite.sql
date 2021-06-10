-- Function: gpInsertUpdate_ObjectHistory_PriceSite ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceSite (Integer, Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceSite(
 INOUT ioId           Integer,    -- ключ объекта <Элемент истории прайса>
    IN inPriceSiteId  Integer,    -- Прайс
    IN inOperDate     TDateTime,  -- Дата действия прайса
    IN inPrice        TFloat,     -- Цена
    IN inSession      TVarChar    -- сессия пользователя
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());
    vbUserId := inSession::Integer;

   -- проверка
   IF COALESCE (inPriceSiteId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлен <прайс>.';
   END IF;


   -- Вставляем или меняем объект историю
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceSite(), inPriceSiteId, inOperDate, vbUserId);
   -- Цена
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceSite_Value(), ioId, inPrice);
        
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.06.21                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_ObjectHistory_PriceSite()

