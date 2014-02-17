-- Function: lpInsertUpdate_Movement_ProfitLossService()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ProfitLossService(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Налоговая>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_ProfitLossService());

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ProfitLossService(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.02.14                                                         *

*/

-- тест
--SELECT * FROM lpInsertUpdate_Movement_ProfitLossService (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013',inUserId:= 2)

