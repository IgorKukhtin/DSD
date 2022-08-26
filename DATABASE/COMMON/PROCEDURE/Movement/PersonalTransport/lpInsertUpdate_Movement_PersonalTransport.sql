-- Function: lpInsertUpdate_Movement_PersonalTransport()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PersonalTransport (Integer, TVarChar, TDateTime, TDateTime, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PersonalTransport(
 INOUT ioId                     Integer   , -- Ключ объекта <Документ>
    IN inInvNumber              TVarChar  , -- Номер документа
    IN inOperDate               TDateTime , -- Дата документа
    IN inServiceDate            TDateTime , -- Месяц начислений
    IN inPersonalServiceListId  Integer   , -- Ведомости начисления
    IN inComment                TVarChar  , -- Примечание
    IN inUserId                 Integer    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean; 
   DECLARE vbMovementId_check Integer;
BEGIN

     -- проверка
     IF inOperDate <> DATE_TRUNC ('Day', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- проверка
     IF COALESCE (inPersonalServiceListId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Ведомость начисления>.';
     END IF;


     -- расчет - 1-ое число месяца
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- Проверка - других быть не должно
     vbMovementId_check:= (SELECT MovementDate.MovementId
                           FROM MovementDate
                                INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = MovementDate.MovementId
                                                             AND MovementLinkObject.DescId = zc_MovementLinkObject_PersonalServiceList()
                                                             AND MovementLinkObject.ObjectId = inPersonalServiceListId
                                INNER JOIN Movement ON Movement.Id = MovementDate.MovementId
                                                   AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                   AND Movement.Id <> COALESCE (ioId, 0)
                           WHERE MovementDate.ValueData = inServiceDate
                             AND MovementDate.DescId = zc_MIDate_ServiceDate()
                           LIMIT 1
                          );
     IF vbMovementId_check <> 0 AND 1=0 -- AND inUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.Найдена другая <Ведомость начисления проезда> № <%> от <%> для <%> за <%>.Дублирование запрещено.', (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_check)
                                                                                                                                    , DATE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_check))
                                                                                                                                    , lfGet_Object_ValueData ((SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = vbMovementId_check AND MovementLinkObject.DescId = zc_MovementLinkObject_PersonalServiceList()))
                                                                                                                                    , zfCalc_MonthYearName ((SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = vbMovementId_check AND MovementDate.DescId = zc_MIDate_ServiceDate()));
     END IF;


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PersonalTransport(), inInvNumber, inOperDate, Null);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalServiceList(), ioId, inPersonalServiceListId);

     -- сохранили свойство <Месяц начислений>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), ioId, inServiceDate);

     -- сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.08.22         *
*/

-- тест
--