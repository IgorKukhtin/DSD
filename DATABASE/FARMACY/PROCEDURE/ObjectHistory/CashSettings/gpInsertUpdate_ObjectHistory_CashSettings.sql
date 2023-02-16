-- Function: gpInsertUpdate_ObjectHistory_CashSettings ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_CashSettings (Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_CashSettings(
 INOUT ioId              Integer,    -- ключ объекта <Элемент истории Общие настройки касс>
    IN inCashSettingsId  Integer,    -- Общие настройки касс
    IN inStartDate       TDateTime,  -- Дата действия прайса
    IN inFixedPercent    TFloat,     -- Фиксированный процент выполнения плана	
    IN inPenMobApp       TFloat,     -- Сумма штрафа за 1% невыполнения плана по мобильному приложению
    IN inSession         TVarChar    -- сессия пользователя
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());
    vbUserId := inSession::Integer;

   -- проверка
   IF COALESCE (inCashSettingsId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлен элемент <Общие настройки касс>.';
   END IF;


   -- Вставляем или меняем объект историю
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_CashSettings(), inCashSettingsId, inStartDate, vbUserId);
   
   -- Фиксированный процент выполнения плана	
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_CashSettings_FixedPercent(), ioId, inFixedPercent);
   
   -- Сумма штрафа за 1% невыполнения плана по мобильному приложению
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_CashSettings_PenMobApp(), ioId, inPenMobApp);
        
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.02.23                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_ObjectHistory_CashSettings()