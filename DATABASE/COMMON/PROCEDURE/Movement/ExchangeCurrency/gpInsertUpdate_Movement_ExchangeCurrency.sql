-- Function: gpInsertUpdate_Movement_ExchangeCurrency()

-- DROP FUNCTION gpInsertUpdate_Movement_ExchangeCurrency();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ExchangeCurrency(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    
    IN inAmountFrom          TFloat    , -- Сумма ушедшая из первого хранилища денег
    IN inAmountTo            TFloat    , -- Сумма пришедшая во второе хранилище денег
    
    IN inFromId              Integer   , -- Касса, Расчетный счет
    IN inToId                Integer   , -- Касса, Расчетный счет
    IN inInfoMoneyId         Integer   , -- Статьи назначения 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ExchangeCurrency());
     vbUserId:= lpGetUserBySession (inSession);

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ExchangeCurrency(), inInvNumber, inOperDate, NULL);

     -- сохранили свойство <Сумма ушедшая>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountFrom(), ioId, inAmountFrom);

     -- сохранили свойство <Сумма пришедшая>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountTo(), ioId, inAmountTo);

     -- сохранили связь с <Сотрудники>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Юридическое лицо>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     
     -- сохранили связь с <Статьи назначения>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), ioId, inInfoMoneyId);
     
     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.13         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ExchangeCurrency (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')
