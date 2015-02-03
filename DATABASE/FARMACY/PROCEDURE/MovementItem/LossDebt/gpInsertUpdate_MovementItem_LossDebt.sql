-- Function: gpInsertUpdate_MovementItem_LossDebt ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LossDebt (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_LossDebt(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inJuridicalId         Integer   , -- Юр.лицо
 INOUT ioAmountDebet         TFloat    , -- Сумма
 INOUT ioAmountKredit        TFloat    , -- Сумма
 INOUT ioSummDebet           TFloat    , -- Сумма остатка (долг)
 INOUT ioSummKredit          TFloat    , -- Сумма остатка (долг)
 INOUT ioIsCalculated        Boolean   , -- Сумма рассчитывается по остатку (да/нет)
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbSumm TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_LossDebt());

     -- проверка
     IF (COALESCE (ioAmountDebet, 0) <> 0) AND (COALESCE (ioAmountKredit, 0) <> 0) THEN
        RAISE EXCEPTION 'Ошибка.Должна быть введена только одна сумма: <Дебет> или <Кредит>.';
     END IF;

     -- проверка
     IF (COALESCE (ioSummDebet, 0) <> 0) AND (COALESCE (ioSummKredit, 0) <> 0) THEN
        RAISE EXCEPTION 'Ошибка.Должна быть введена только одна сумма: <Дебет долг на дату> или <Кредит долг на дату>.';
     END IF;

     -- расчет
     IF ioAmountDebet <> 0 THEN
        vbAmount := ioAmountDebet;
     ELSE
        vbAmount := -1 * ioAmountKredit;
     END IF;
     -- расчет
     IF ioSummDebet <> 0 THEN
        vbSumm := ioSummDebet;
     ELSE
        vbSumm := -1 * ioSummKredit;
     END IF;

     -- расчет
     ioIsCalculated:= (vbSumm <> 0 OR vbAmount = 0);
     -- 
     IF vbSumm <> 0 THEN ioAmountDebet := 0; ioAmountKredit := 0; END IF;

     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem_LossDebt (ioId                 := ioId
                                                 , inMovementId         := inMovementId
                                                 , inJuridicalId        := inJuridicalId
                                                 , inAmount             := vbAmount
                                                 , inSumm               := vbSumm
                                                 , inIsCalculated       := ioIsCalculated
                                                 , inUserId             := vbUserId
                                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 30.01.15                         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_LossDebt (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')

/*
SELECT MovementItem.ObjectId, MILinkObject_PaidKind.ObjectId, MILinkObject_InfoMoney.ObjectId, MILinkObject_Contract.ObjectId
                FROM MovementItem
                     JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                     JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                      ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                     JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                 ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                WHERE MovementItem.MovementId = 12055 
                  AND MovementItem.DescId = zc_MI_Master()

group by MovementItem.ObjectId, MILinkObject_PaidKind.ObjectId, MILinkObject_InfoMoney.ObjectId, MILinkObject_Contract.ObjectId
having count (*) >1
*/
