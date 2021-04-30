-- Function: gpInsertUpdate_ObjectHistory_PriceChange ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceChange (Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceChange (Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceChange (Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceChange (Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceChange(
 INOUT ioId                 Integer,    -- ключ объекта <Элемент истории прайса>
    IN inPriceChangeId      Integer,    -- Прайс
    IN inOperDate           TDateTime,  -- Дата действия прайса
    IN inPriceChange        TFloat,     -- Цена
    IN inFixValue           TFloat,     -- 
    IN inFixPercent         TFloat,     --
    IN inFixDiscount        TFloat,     --
    IN inPercentMarkup      TFloat,     -- 
    IN inMultiplicity       TFloat,     -- кратность
    IN inFixEndDate         TDateTime,  -- Дата окончания действия скидки
    IN inSession            TVarChar    -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());
    vbUserId := inSession::Integer;

   -- проверка
   IF COALESCE (inPriceChangeId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлен <прайс>.';
   END IF;


   -- Вставляем или меняем объект историю
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceChange(), inPriceChangeId, inOperDate, vbUserId);
   -- Цена
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceChange_Value(), ioId, inPriceChange);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceChange_FixValue(), ioId, inFixValue);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceChange_FixPercent(), ioId, inFixPercent);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceChange_FixDiscount(), ioId, inFixDiscount);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceChange_PercentMarkup(), ioId, inPercentMarkup);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceChange_Multiplicity(), ioId, inMultiplicity);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryDate (zc_ObjectHistoryDate_PriceChange_FixEndDate(), ioId, inFixEndDate);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 04.12.19                                                      * FixDiscount
 08.02.19         * inFixPercent
 17.08.18         *
*/