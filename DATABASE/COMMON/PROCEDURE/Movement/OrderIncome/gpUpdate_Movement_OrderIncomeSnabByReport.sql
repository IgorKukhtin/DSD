-- Function: gpUpdate_Movement_OrderIncomeSnabByReport()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderIncomeSnabByReport(Integer, TDateTime, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderIncomeSnabByReport(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inOperDateStart       TDateTime , -- 
    IN inOperDateEnd         TDateTime , -- 
    IN inDayCount            TFloat    , -- дней прогноза
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsInsert Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderIncome());

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), inId, inOperDateStart);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), inId, inOperDateEnd);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DayCount(), inId, inDayCount);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

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