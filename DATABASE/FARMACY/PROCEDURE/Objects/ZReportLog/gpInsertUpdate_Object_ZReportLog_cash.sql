-- Function: gpInsertUpdate_Object_ZReportLog_cash()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ZReportLog_cash (Integer, TVarChar, TDateTime, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ZReportLog_cash(
    IN inZReport                   Integer,   -- Номер Z отчета
    IN inFiscalNumber              TVarChar,  -- Фискальный номер
    IN inDate                      TDateTime, -- Дата Z отчета
    IN inSummaCash                 TFloat,    -- Оборот наличный
    IN inSummaCard	               TFloat,    -- Оборот карта
    IN inUserId                    Integer,   -- Сотрудник
    IN inSession                   TVarChar   -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ZReportLog());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;
    
   IF COALESCE (vbUnitId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не определено подразделение.';
   END IF;
    
      
   -- пытаемся найти код
   IF EXISTS(SELECT ZReportLog.Id FROM Object AS ZReportLog
             WHERE ZReportLog.DescId = zc_Object_ZReportLog()
               AND ZReportLog.ObjectCode = inZReport
               AND ZReportLog.ValueData = TRIM(inFiscalNumber))
   THEN
     SELECT ZReportLog.Id 
     INTO vbId
     FROM Object AS ZReportLog
     WHERE ZReportLog.DescId = zc_Object_ZReportLog()
       AND ZReportLog.ObjectCode = inZReport
       AND ZReportLog.ValueData = TRIM(inFiscalNumber);    
   ELSE
     vbId := 0;
   END IF;

   -- сохранили <Объект>
   vbId := lpInsertUpdate_Object (vbId, zc_Object_ZReportLog(), inZReport, TRIM(inFiscalNumber));

   -- Дата Z отчета
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_ZReportLog_Date(), vbId, inDate);

   -- Оборот наличный
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ZReportLog_SummaCash(), vbId, inSummaCash);

   -- Оборот карта
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ZReportLog_SummaCard(), vbId, inSummaCard);
 
   -- Ссылка на подразделение
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ZReportLog_Unit(), vbId, vbUnitId);
   
   -- Ссылка на сотрудника
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ZReportLog_User(), vbId, inUserId);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.07.21                                                       *
*/

-- тест
-- 

select * from gpInsertUpdate_Object_ZReportLog_cash(inZReport := 32390569 , inFiscalNumber := '3000007988' , inDate := ('30.07.2021 13:31:15')::TDateTime , 
              inSummaCash := 49343 , inSummaCard := 20567 , inUserId := 3 ,  inSession := '3');