-- Function: lpInsertUpdate_Movement_OrderFinance()

--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderFinance (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderFinance (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderFinance(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inOrderFinanceId      Integer   , --
    IN inBankAccountId       Integer   , --
    IN inMemberId_1          Integer   , --
    IN inMemberId_2          Integer   , --
    IN inWeekNumber          TFloat    , --
    IN inTotalSumm_1         TFloat    , --
    IN inTotalSumm_2         TFloat    , --
    IN inTotalSumm_3         TFloat    , --
    IN inComment             TVarChar  , -- Примечание
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
           vbMemberId Integer;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- проверка
     IF COALESCE (inOrderFinanceId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Вид Планирования не выбран.';
     END IF;

     -- проверка
     IF COALESCE (ioId, 0) = 0 AND EXISTS (SELECT 1
                                           FROM Movement
                                                INNER JOIN MovementFloat AS MovementFloat_WeekNumber
                                                                         ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                                        AND MovementFloat_WeekNumber.DescId     = zc_MovementFloat_WeekNumber()
                                                                        AND MovementFloat_WeekNumber.ValueData  = inWeekNumber
                                                INNER JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                                              ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                                             AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                                                                             AND MovementLinkObject_OrderFinance.ObjectId   = inOrderFinanceId
                                           WHERE Movement.DescId = zc_Movement_OrderFinance()
                                             AND Movement.StatusId <> zc_Enum_Status_Erased()
                                             AND Movement.OperDate BETWEEN inOperDate - INTERVAL '14 DAY' AND inOperDate + INTERVAL '7 DAY'
                                          )
        AND inUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.Дублирование запрещено.%Уже существует документ планирования № <%> от <%>%для <%> недели + <%>'
                                        , CHR (13)
                                        , (SELECT Movement.InvNumber
                                           FROM Movement
                                                INNER JOIN MovementFloat AS MovementFloat_WeekNumber
                                                                         ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                                        AND MovementFloat_WeekNumber.DescId     = zc_MovementFloat_WeekNumber()
                                                                        AND MovementFloat_WeekNumber.ValueData  = inWeekNumber
                                                INNER JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                                              ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                                             AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                                                                             AND MovementLinkObject_OrderFinance.ObjectId   = inOrderFinanceId
                                           WHERE Movement.DescId = zc_Movement_OrderFinance()
                                             AND Movement.StatusId <> zc_Enum_Status_Erased()
                                             AND Movement.OperDate BETWEEN inOperDate - INTERVAL '14 DAY' AND inOperDate + INTERVAL '7 DAY'
                                           ORDER BY Movement.Id
                                           LIMIT 1
                                          )
                                        , (SELECT zfConvert_DateToString (Movement.OperDate)
                                           FROM Movement
                                                INNER JOIN MovementFloat AS MovementFloat_WeekNumber
                                                                         ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                                        AND MovementFloat_WeekNumber.DescId     = zc_MovementFloat_WeekNumber()
                                                                        AND MovementFloat_WeekNumber.ValueData  = inWeekNumber
                                                INNER JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                                              ON MovementLinkObject_OrderFinance.MovementId = Movement.Id
                                                                             AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                                                                             AND MovementLinkObject_OrderFinance.ObjectId   = inOrderFinanceId
                                           WHERE Movement.DescId = zc_Movement_OrderFinance()
                                             AND Movement.StatusId <> zc_Enum_Status_Erased()
                                             AND Movement.OperDate BETWEEN inOperDate - INTERVAL '14 DAY' AND inOperDate + INTERVAL '7 DAY'
                                           ORDER BY Movement.Id
                                           LIMIT 1
                                          )
                                        , CHR (13)
                                        , zfConvert_FloatToString (inWeekNumber)
                                        , lfGet_Object_ValueData_sh (inOrderFinanceId)
                                         ;
     END IF;


     -- определяем ключ доступа
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_OrderFinance());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderFinance(), inInvNumber, inOperDate, NULL, NULL);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_OrderFinance(), ioId, inOrderFinanceId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BankAccount(), ioId, inBankAccountId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member_1(), ioId, inMemberId_1);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member_2(), ioId, inMemberId_2);

     --сохранили
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_WeekNumber(), ioId, inWeekNumber);
     --сохранили
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm_1(), ioId, inTotalSumm_1);
     --сохранили
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm_2(), ioId, inTotalSumm_2);
     --сохранили
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm_3(), ioId, inTotalSumm_3);

     -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);


     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Дата создания>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (создание)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);

         vbMemberId:= (SELECT ObjectLink_User_Member.ChildObjectId AS MemberId
                       FROm ObjectLink AS ObjectLink_User_Member
                       WHERE ObjectLink_User_Member.ObjectId = inUserId
                         AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                      );
         --
         PERFORM -- сохранили свойство <Unit (Автор заявки)>
                 lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, lfSelect.UnitId)
                 -- сохранили свойство <Должность (Автор заявки)>
               , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Position(), ioId, lfSelect.PositionId)
         FROM lfSelect_Object_Member_findPersonal (inUserId ::TVarChar) AS lfSelect
         WHERE lfSelect.MemberId = vbMemberId;

     ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSummOrderFinance (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.25         *
 29.07.19         *
*/

-- тест
--