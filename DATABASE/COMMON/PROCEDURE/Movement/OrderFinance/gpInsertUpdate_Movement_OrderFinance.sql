-- Function: gpInsertUpdate_Movement_OrderFinance()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderFinance (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderFinance (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderFinance(
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
    IN inComment             TVarChar   , -- Примечание
   OUT outStartDate          TDateTime,
   OUT outEndDate            TDateTime,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderFinance());

     IF COALESCE (ioId, 0) = 0 -- AND vbUserId NOT IN (5, 11973291) -- Галеміна О.А.
        -- Подтверждение СБ = ДА
        AND (EXISTS (SELECT FROM ObjectBoolean AS OB WHERE OB.ObjectId = inOrderFinanceId AND OB.DescId = zc_ObjectBoolean_OrderFinance_SB() AND OB.ValueData = TRUE)
          -- Заполнение № заявки 1С = НЕТ
          OR (EXISTS (SELECT FROM ObjectBoolean AS OB WHERE OB.ObjectId = inOrderFinanceId AND OB.DescId = zc_ObjectBoolean_OrderFinance_InvNumber() AND OB.ValueData = TRUE)
          -- Заполнение № счета = НЕТ
          AND EXISTS (SELECT FROM ObjectBoolean AS OB WHERE OB.ObjectId = inOrderFinanceId AND OB.DescId = zc_ObjectBoolean_OrderFinance_InvNumber_Invoice() AND OB.ValueData = TRUE)
             )
            )
     THEN
         inOperDate:= CURRENT_DATE;
         inWeekNumber:= CASE WHEN EXTRACT (YEAR FROM inOperDate + INTERVAL '10 DAY') > EXTRACT (YEAR FROM inOperDate) THEN 1 ELSE EXTRACT (WEEK FROM inOperDate) + 1 END;
     END IF;


     -- проверка
     IF COALESCE (inOrderFinanceId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Вид Планирования не выбран.';
     END IF;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_OrderFinance (ioId               := ioId
                                                 , inInvNumber        := inInvNumber
                                                 , inOperDate         := inOperDate
                                                 , inOrderFinanceId   := inOrderFinanceId
                                                 , inBankAccountId    := inBankAccountId
                                                 , inMemberId_1       := inMemberId_1
                                                 , inMemberId_2       := inMemberId_2
                                                 , inWeekNumber       := inWeekNumber
                                                 , inTotalSumm_1      := inTotalSumm_1
                                                 , inTotalSumm_2      := inTotalSumm_2
                                                 , inTotalSumm_3      := inTotalSumm_3
                                                 , inComment          := inComment
                                                 , inUserId           := vbUserId
                                                  );


     --
     outStartDate:= zfCalc_Week_StartDate (inOperDate, inWeekNumber :: TFloat);
     outEndDate  := zfCalc_Week_EndDate   (inOperDate, inWeekNumber :: TFloat);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.25         *
 30.07.19         *
*/

-- тест
--