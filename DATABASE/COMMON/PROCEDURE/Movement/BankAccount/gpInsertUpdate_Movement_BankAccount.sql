-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount(Integer, TVarChar, TDateTime, TFloat, Integer,
                      Integer, Integer, Integer, Integer, Integer, TVarChar);
                                                                  	
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount(Integer, TVarChar, TDateTime, TFloat, Integer,
                      Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount(Integer, TVarChar, TDateTime, TFloat, TFloat, Integer,
                      TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankAccount(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inAmountIn            TFloat    , -- Сумма прихода
    IN inAmountOut           TFloat    , -- Сумма расхода

    IN inBankAccountId       Integer   , -- Расчетный счет 	
    IN inComment             TVarChar  , -- Комментарий 
    IN inMoneyPlaceId        Integer   , -- Юр лицо, счет, касса  	
    IN inContractId          Integer   , -- Договора
    IN inInfoMoneyId         Integer   , -- Статьи назначения 
    IN inUnitId              Integer   , -- Подразделение
    IN inCurrencyId          Integer   , -- Валюта 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());

     -- проверка
     IF (COALESCE(inAmountIn, 0) = 0) AND (COALESCE(inAmountOut, 0) = 0) THEN
        RAISE EXCEPTION 'Введите сумму прихода или расхода';
     END IF;

     -- проверка
     IF (COALESCE(inAmountIn, 0) <> 0) AND (COALESCE(inAmountOut, 0) <> 0) THEN
        RAISE EXCEPTION 'Должна быть введена только одна сумма - или прихода или расхода.';
     END IF;

     -- расчет
     IF inAmountIn <> 0 THEN
        vbAmount := inAmountIn;
     ELSE
        vbAmount := -1 * inAmountOut;
     END IF;


     PERFORM lpInsertUpdate_Movement_BankAccount (ioId, inInvNumber, inOperDate, vbAmount, 
             inBankAccountId, inComment, inMoneyPlaceId, inContractId, inInfoMoneyId, inUnitId, inCurrencyId, (SELECT ParentId FROM Movement WHERE Id = ioId), vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 13.03.14                                        * add vbUserId
 13.03.14                                        * err inParentId NOT NULL
 06.12.13                          *
 09.08.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_BankAccount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
