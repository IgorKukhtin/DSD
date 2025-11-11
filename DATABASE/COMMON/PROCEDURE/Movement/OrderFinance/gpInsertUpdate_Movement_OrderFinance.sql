-- Function: gpInsertUpdate_Movement_OrderFinance()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderFinance (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderFinance (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderFinance (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

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
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
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