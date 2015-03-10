-- Function: gpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash (Integer, TVarChar, TdateTime, TdateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash (Integer, TVarChar, TdateTime, TdateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash (Integer, TVarChar, TdateTime, TdateTime, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Cash(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inServiceDate         TDateTime , -- Дата начисления
    IN inAmountIn            TFloat    , -- Сумма прихода
    IN inAmountOut           TFloat    , -- Сумма расхода
    IN inAmountSumm          TFloat    , -- Cумма грн, обмен
    IN inComment             TVarChar  , -- Комментарий
    IN inCashId              Integer   , -- Касса
    IN inMoneyPlaceId        Integer   , -- Объекты работы с деньгами
    IN inPositionId          Integer   , -- Должность
    IN inMemberId            Integer   , -- Физ лицо (через кого)
    IN inContractId          Integer   , -- Договора
    IN inInfoMoneyId         Integer   , -- Управленческие статьи
    IN inUnitId              Integer   , -- Подразделения

    IN inCurrencyId           Integer   , -- Валюта 
   OUT outCurrencyValue       TFloat    , -- Курс для перевода в валюту баланса
   OUT outParValue            TFloat    , -- Номинал для перевода в валюту баланса
    IN inCurrencyPartnerValue TFloat    , -- Курс для расчета суммы операции
    IN inParPartnerValue      TFloat    , -- Номинал для расчета суммы операции
    
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS record as--Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbAmountCurrency TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());


     -- 1. если  update
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_Cash())
     THEN
         -- проверка
         IF EXISTS (SELECT Id FROM Movement WHERE Id = ioId AND ParentId <> 0)
         THEN
             RAISE EXCEPTION 'Ошибка.Документ № <%> может корректироваться только через <Касса выплата зп>.', inInvNumber;
         END IF;

         -- 1. Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- расчет курса для баланса
     IF inCurrencyId <> zc_Enum_Currency_Basis()
     THEN SELECT Amount, ParValue, Amount, ParValue
                 INTO outCurrencyValue, outParValue
                    , inCurrencyPartnerValue, inParPartnerValue -- !!!меняется значение!!!
          FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDate, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= inCurrencyId,  inPaidKindId:= zc_Enum_PaidKind_FirstForm());
     END IF;

     -- !!!очень важный расчет!!!
     IF inAmountIn <> 0 THEN
        IF inCurrencyId <> zc_Enum_Currency_Basis()
        THEN vbAmountCurrency:= inAmountIn;
             vbAmount := CAST (inAmountIn * outCurrencyValue / outParValue AS NUMERIC (16, 2));
        ELSE vbAmount := inAmountIn;
        END IF;
     ELSE
        IF inCurrencyId <> zc_Enum_Currency_Basis()
        THEN vbAmountCurrency:= -1 * inAmountOut;
             vbAmount := CAST (-1 * inAmountOut * outCurrencyValue / outParValue AS NUMERIC (16, 2));
        ELSE vbAmount := -1 * inAmountOut;
        END IF;
     END IF;

     -- проверка
     IF COALESCE (vbAmount, 0) = 0 AND inCurrencyId <> 0
     THEN
        RAISE EXCEPTION 'Ошибка.Сумма пересчета из валюты <%> в валюту <%> не должна быть = 0.', lfGet_Object_ValueData (inCurrencyId), lfGet_Object_ValueData (zc_Enum_Currency_Basis());
     END IF;

     -- сохранили
     ioId := lpInsertUpdate_Movement_Cash (ioId          := ioId
                                         , inParentId    := NULL
                                         , inInvNumber   := inInvNumber
                                         , inOperDate    := inOperDate
                                         , inServiceDate := inServiceDate
                                         , inAmountIn    := inAmountIn
                                         , inAmountOut   := inAmountOut
                                         , inAmountSumm  := inAmountSumm
                                         , inAmountCurrency := vbAmountCurrency
                                         , inComment     := inComment
                                         , inCashId      := inCashId
                                         , inMoneyPlaceId:= inMoneyPlaceId
                                         , inPositionId  := inPositionId
                                         , inContractId  := inContractId
                                         , inInfoMoneyId := inInfoMoneyId
                                         , inMemberId    := inMemberId
                                         , inUnitId      := inUnitId
                                         , inCurrencyId           := inCurrencyId
                                         , inCurrencyValue        := outCurrencyValue
                                         , inParValue             := outParValue
                                         , inCurrencyPartnerValue := inCurrencyPartnerValue
                                         , inParPartnerValue      := inParPartnerValue
                                         , inUserId      := vbUserId
                                          );

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- это временно
     IF (inInfoMoneyId <> 0 AND inMoneyPlaceId <> 0 AND (inContractId <> 0 OR EXISTS (SELECT Id FROM Object WHERE Id = inMoneyPlaceId AND DescId IN (zc_Object_Founder(), zc_Object_Member(), zc_Object_Personal())))) OR vbUserId <> 5 -- Админ -- NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         -- 5.3. проводим Документ
         IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Cash())
         THEN
              PERFORM lpComplete_Movement_Cash (inMovementId := ioId
                                              , inUserId     := vbUserId);
         END IF;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 09.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 30.08.14                                        * это временно
 29.08.14                                        * all
 17.08.14                                        * add MovementDescId
 10.05.14                                        * add lpInsert_MovementItemProtocol
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 22.01.14                                        * add IsMaster
 14.01.14                                        *
 26.12.13                                        * add lpComplete_Movement_Cash
 26.12.13                                        * add lpGetAccessKey
 23.12.13                        *                
 19.11.13                        *                
 06.08.13                        *                
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Cash (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
