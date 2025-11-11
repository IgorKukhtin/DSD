-- Function: gpInsertUpdate_Movement_OrderFinance()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderFinance (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderFinance (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderFinance (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderFinance(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inOrderFinanceId      Integer   , --
    IN inBankAccountId       Integer   , -- 
    IN inMemberId_1          Integer   , --
    IN inMemberId_2          Integer   , --
    IN inWeekNumber          TFloat    , --
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


     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_OrderFinance (ioId               := ioId
                                                 , inInvNumber        := inInvNumber
                                                 , inOperDate         := inOperDate
                                                 , inOrderFinanceId   := inOrderFinanceId
                                                 , inBankAccountId    := inBankAccountId
                                                 , inMemberId_1       := inMemberId_1
                                                 , inMemberId_2       := inMemberId_2
                                                 , inWeekNumber       := inWeekNumber
                                                 , inComment          := inComment
                                                 , inUserId           := vbUserId
                                                  );
     
     WITH
     --берем от от даты документа + 300 дней, 
     tmpDataWeek AS (SELECT GENERATE_SERIES (inOperDate :: TDateTime , inOperDate + INTERVAL '300 DAY', '1 week' :: INTERVAL) AS OperDate)
     
     SELECT DATE_TRUNC ('WEEK', tmp.OperDate)                     :: TDateTime AS Monday
          , (DATE_TRUNC ('WEEK', tmp.OperDate)+ INTERVAL '6 DAY') :: TDateTime AS Sunday
          --, (EXTRACT (Week FROM tmp.OperDate) )                   :: Integer   AS WeekNumber 
   INTO outStartDate, outEndDate
     FROM tmpDataWeek AS tmp
     WHERE EXTRACT (Week FROM tmp.OperDate) = inWeekNumber
     AND inOperDate BETWEEN tmp.OperDate - INTERVAL '14 DAY' AND tmp.OperDate + INTERVAL '30 DAY'
     ;

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