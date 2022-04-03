-- Function: gpInsertUpdate_Movement_PersonalSendCash()

-- DROP FUNCTION gpInsertUpdate_Movement_PersonalSendCash();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalSendCash(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inPersonalId          Integer   , -- Сотрудник
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbUnitId_Forwarding Integer; -- Подразделение (Место отправки)
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalSendCash());
     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_PersonalSendCash());

     -- проверка
     IF inOperDate <> DATE_TRUNC ('day', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;


     -- !!!надо будет переделать на вх.параметр!!! определяем Подразделение (Место отправки)
     vbUnitId_Forwarding:= (SELECT MIN (View_Unit.Id) FROM Object_Unit_View AS View_Unit WHERE View_Unit.BranchId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Branch() AND Object.AccessKeyId = lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_PersonalSendCash()))
                                                                                           AND View_Unit.Id IN (SELECT lfObject_Unit_byProfitLossDirection.UnitId FROM lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection WHERE lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId = zc_Enum_ProfitLossDirection_40100())
                           );

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PersonalSendCash(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили связь с <Сотрудник>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);
     
     -- сохранили связь с <Подразделение (Место отправки)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UnitForwarding(), ioId, vbUnitId_Forwarding);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.01.13                                        * add vbUnitId_Forwarding
 07.12.13                                        * add lpGetAccessKey
 30.09.13                                        *
*/
-- PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UnitForwarding(), Movement.Id, 8396) from Movement where Movement.DescId = zc_Movement_PersonalSendCash();
-- тест
-- SELECT * FROM gpInsertUpdate_Movement_PersonalSendCash (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')
