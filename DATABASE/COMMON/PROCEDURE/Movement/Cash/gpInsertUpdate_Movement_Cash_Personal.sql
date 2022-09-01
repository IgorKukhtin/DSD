-- Function: gpInsertUpdate_Movement_Cash_Personal()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash_Personal (Integer, TVarChar, tdatetime, Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash_Personal (Integer, TVarChar, tdatetime, Integer, Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Cash_Personal(
 INOUT ioMovementId          Integer   , -- 
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inParentId            Integer   , -- документ наче=исления зп
    IN inCashId              Integer   , -- Касса 
    IN inInfoMoneyId         Integer   , --
    IN inComment             TVarChar  , -- Комментерий
    IN inMemberId            Integer   , -- Физ лицо (через кого)
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash_Personal());

     -- проверка
     IF COALESCE (inParentId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Ведомость>.';
     END IF;

     -- сохранили <Документ>
     ioMovementId := (SELECT lpInsertUpdate_Movement_Cash (ioId          := ioMovementId
                                                         , inParentId    := inParentId
                                                         , inInvNumber   := inInvNumber
                                                         , inOperDate    := inOperDate
                                                         , inServiceDate := MovementDate_ServiceDate.ValueData
                                                         , inAmountIn    := CASE WHEN MovementItem.Amount > 0 THEN MovementItem.Amount ELSE 0 END
                                                         , inAmountOut   := CASE WHEN MovementItem.Amount < 0 THEN -1 * MovementItem.Amount ELSE 0 END
                                                         , inAmountSumm     := NULL
                                                         , inAmountCurrency := NULL
                                                         , inComment     := inComment
                                                         , inCarId       := NULL
                                                         , inCashId      := inCashId
                                                         , inMoneyPlaceId:= MovementLinkObject_PersonalServiceList.ObjectId
                                                         , inPositionId  := NULL
                                                         , inContractId  := NULL
                                                         , inInfoMoneyId := inInfoMoneyId --zc_Enum_InfoMoney_60101() -- Заработная плата
                                                                         /*(SELECT DISTINCT MovementItemLinkObject.ObjectId
                                                                             FROM MovementItem
                                                                                  INNER JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.Id
                                                                                                                   AND MovementItemLinkObject.DescId         = zc_MILinkObject_InfoMoney()
                                                                             WHERE MovementItem.MovementId         = inParentId
                                                                               AND MovementItem.isErased           = FALSE
                                                                               AND MovementItem.DescId             = zc_MI_Master()
                                                                               AND MovementItemLinkObject.ObjectId = zc_Enum_InfoMoney_60101() -- Заработная плата
                                                                            )*/
                                                         , inMemberId    := inMemberId
                                                         , inUnitId      := NULL
                                                         , inCurrencyId          := zc_Enum_Currency_Basis()
                                                         , inCurrencyValue       := NULL
                                                         , inParValue            := NULL
                                                         , inCurrencyPartnerId   := NULL
                                                         , inCurrencyPartnerValue:= NULL
                                                         , inParPartnerValue     := NULL
                                                         , inMovementId_Partion  := 0
                                                         , inUserId      := vbUserId
                                                          )
                      FROM (SELECT ioMovementId AS MovementId) AS tmp
                           LEFT JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId AND MovementItem.DescId = zc_MI_Master()
                           LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                                  ON MovementDate_ServiceDate.MovementId = inParentId
                                                 AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                        ON MovementLinkObject_PersonalServiceList.MovementId = inParentId
                                                       AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                     );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 01.09.22         * inInfoMoneyId
 21.05.17         *
 05.04.15                                        * all
 16.02.15                                        * all
 16.09.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Cash_Personal (ioMovementId:= 0, inInvNumber:= '', inOperDate:= '01.09.2014', inCashId := 14462, inPersonalId:= 8469, inAmount:= 99, inComment:= 'inComment', inInfoMoneyId:= 8994, inUnitId:= 8386, inPositionId:= 12428, inPaidKindId:= 4, inServiceDate:= '01.01.2013', inSession:= '2')
