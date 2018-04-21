-- Function: gpInsertUpdate_ObjectHistory_Price ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_Price (Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_Price (Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_Price(
 INOUT ioId           Integer,    -- ключ объекта <Элемент истории прайса>
    IN inPriceId      Integer,    -- Прайс
    IN inOperDate     TDateTime,  -- Дата действия прайса
    IN inPrice        TFloat,     -- Цена
    IN inMCSValue     TFloat,     -- НТЗ
    IN inMCSPeriod    TFloat,     -- Количество дней для анализа НТЗ(период)
    IN inMCSDay       TFloat,     -- Страховой запас дней НТЗ
    IN inSession      TVarChar    -- сессия пользователя
)
  RETURNS integer AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());
    vbUserId := inSession::Integer;

   -- проверка
   IF COALESCE (inPriceId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлен <прайс>.';
   END IF;


   -- Вставляем или меняем объект историю
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_Price(), inPriceId, inOperDate, vbUserId);
   -- Цена
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_Price_Value(), ioId, inPrice);
   -- НТЗ
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_Price_MCSValue(), ioId, inMCSValue);

   -- Количество дней для анализа НТЗ
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_Price_MCSPeriod(), ioId, inMCSPeriod);
   -- Страховой запас дней НТЗ
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_Price_MCSDay(), ioId, inMCSDay);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 24.02.16         *
 04.07.14         *

*/
