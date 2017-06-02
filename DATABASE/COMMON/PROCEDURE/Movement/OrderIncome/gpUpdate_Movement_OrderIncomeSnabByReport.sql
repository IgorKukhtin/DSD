-- Function: gpUpdate_Movement_OrderIncomeSnabByReport()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderIncomeSnabByReport (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderIncomeSnabByReport(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inOperDateStart       TDateTime , -- 
    IN inOperDateEnd         TDateTime , -- 
   OUT outDayCount           Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderIncome());


     -- сохранили свойство <нач. дата для период ПРОГНОЗА = 4 недели>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), inId, inOperDateStart);
     -- сохранили свойство <конечн. дата для период ПРОГНОЗА = 4 недели>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), inId, inOperDateEnd);

     -- сохранили свойство <на сколько дней считаем План. Заказ на месяц>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DayCount(), inId, 30);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

     -- Вернули - период ПРОГНОЗА = 4 недели
     outDayCount:= DATE_PART ('DAY', inOperDateEnd - inOperDateStart) + 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.04.17         *
*/

-- тест
-- 