-- Function: gpInsertUpdate_Movement_Cash_Personal()


DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_Cash_Personal (integer, tvarchar, tdatetime, Integer, Integer, tfloat, TVarChar, integer, integer, integer, TDateTime, tvarchar);

DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_PersonalCash (integer, tvarchar, tdatetime, Integer, TVarChar, TDateTime, tvarchar);
   
DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_Cash_Personal (integer, tvarchar, tdatetime, Integer, TVarChar, TDateTime, tvarchar);

DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_Cash_Personal (integer, tvarchar, tdatetime, Integer, TVarChar, TDateTime, Integer, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Cash_Personal(
 INOUT ioMovementId          Integer   , -- 
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inParentId            Integer   , -- документ наче=исления зп
    IN inCashId              Integer   , -- Касса
    IN inComment             TVarChar  , -- Комментерий
    IN inServiceDate         TDateTime , -- Дата начисления
    IN inMemberId            Integer   , -- Физ лицо (через кого)
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMIMasterId Integer;
   
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash_Personal());

     -- проверка
     IF COALESCE (inParentId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не выбрана <Ведомость начислений>.';
     END IF;

     -- расчет - 1-ое число месяца
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- сохранили <Документ>
     ioMovementId := (SELECT lpInsertUpdate_Movement_Cash (ioId          := ioMovementId
                                                         , inParentId    := inParentId
                                                         , inInvNumber   := inInvNumber
                                                         , inOperDate    := inOperDate
                                                         , inServiceDate := inServiceDate
                                                         , inAmountIn    := CASE WHEN MovementItem.Amount > 0 THEN MovementItem.Amount ELSE 0 END
                                                         , inAmountOut   := CASE WHEN MovementItem.Amount < 0 THEN -1 * MovementItem.Amount ELSE 0 END
                                                         , inComment     := inComment
                                                         , inCashId      := inCashId
                                                         , inMoneyPlaceId:= (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inParentId AND DescId = zc_MovementLinkObject_PersonalServiceList())
                                                         , inPositionId  := 0::Integer
                                                         , inContractId  := 0::Integer
                                                         , inInfoMoneyId := (SELECT MovementItemLinkObject.ObjectId FROM MovementItem INNER JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.Id AND MovementItemLinkObject.DescId = zc_MILinkObject_InfoMoney() WHERE MovementItem.MovementId = inParentId AND MovementItem.isErased = FALSE AND MovementItem.DescId = zc_MI_Master() GROUP BY MovementItemLinkObject.ObjectId)
                                                         , inMemberId    := inMemberId
                                                         , inUnitId      := 0::Integer
                                                         , inUserId      := vbUserId
                                                          )
                      FROM (SELECT ioMovementId AS MovementId) AS tmp
                           LEFT JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId AND MovementItem.DescId = zc_MI_Master()
                     );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.02.15                                        * all
 16.09.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Cash_Personal (ioMovementId:= 0, inInvNumber:= '', inOperDate:= '01.09.2014', inCashId := 14462, inPersonalId:= 8469, inAmount:= 99, inComment:= 'inComment', inInfoMoneyId:= 8994, inUnitId:= 8386, inPositionId:= 12428, inPaidKindId:= 4, inServiceDate:= '01.01.2013', inSession:= '2')
