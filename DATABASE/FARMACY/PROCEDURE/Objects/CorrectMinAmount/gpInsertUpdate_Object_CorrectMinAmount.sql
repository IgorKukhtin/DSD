-- Function: gpInsertUpdate_Object_CorrectMinAmount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CorrectMinAmount (Integer, Integer, TDateTime, TFloat, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CorrectMinAmount(
 INOUT ioId                      Integer   ,   	-- ключ объекта <>
    IN inPayrollTypeId           Integer   ,    -- Тип расчета заработной платы
    IN inDateStart               TDateTime ,    -- Дата начала действия
    IN inAmount                  TFloat    ,    -- Сумма корректировки
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CorrectMinAmount());
   vbUserId := lpGetUserBySession (inSession); 
   inDateStart := DATE_TRUNC ('DAY', inDateStart);
   
   IF COALESCE(inPayrollTypeId, 0) = 0
   THEN
     RAISE EXCEPTION 'Не определен <Тип расчета заработной платы>';
   END IF;

   IF inDateStart IS NULL OR inDateStart < DATE_TRUNC ('MONTH', CURRENT_DATE)
   THEN
     RAISE EXCEPTION 'Не определен <Дата начала действия> или меньше текущего месяца';
   END IF;

   IF EXISTS(SELECT * FROM gpSelect_Object_CorrectMinAmount (inPayrollTypeId, TRUE, inSession) AS CMA 
             WHERE CMA.ID <> COALESCE(ioId, 0) AND CMA.DateStart = inDateStart)
   THEN
     RAISE EXCEPTION 'Дата начала действия должна быть уникальной.';
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CorrectMinAmount(), 0, '');

   -- сохранили связь с <Тип расчета заработной платы>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CorrectMinAmount_PayrollType(), ioId, inPayrollTypeId);

   -- сохранили свойство <Дата начала действия>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_CorrectMinAmount_Date(), ioId, inDateStart);

   -- сохранили свойство <Сумма корректировки>
   PERFORM lpInsertUpdate_ObjecTFloat(zc_ObjectFloat_CorrectMinAmount_Amount(), ioId, inAmount);

   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.06.21                                                       *
*/

-- тест
-- select * from gpInsertUpdate_Object_CorrectMinAmount(ioId := 0 , inPayrollTypeId := 11936842 , inDateStart := ('01.07.2021')::TDateTime , inAmount := 20 ,  inSession := '3');