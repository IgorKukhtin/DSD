-- Function: gpUpdate_MovementItem_Price_Currency()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Price_Currency (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Price_Currency(
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbCurrencyDocumentId Integer;
   DECLARE vbCurrencyPartnerId Integer;
   DECLARE vbCurrencyPartnerValue TFloat;
   DECLARE vbParPartnerValue TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Price_Currency());


     -- определяются параметры документа
     SELECT Movement.StatusId
          , Movement.InvNumber
          , MovementLinkObject_CurrencyDocument.ObjectId   AS CurrencyDocumentId
          , MovementLinkObject_CurrencyPartner.ObjectId    AS CurrencyPartnerId
          , MovementFloat_CurrencyPartnerValue.ValueData   AS CurrencyPartnerValue
          , MovementFloat_ParPartnerValue.ValueData        AS ParPartnerValue
            INTO vbStatusId, vbInvNumber, vbCurrencyDocumentId, vbCurrencyPartnerId, vbCurrencyPartnerValue, vbParPartnerValue
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                       ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                      AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                       ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                      AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
          LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                  ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                 AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
          LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                  ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                 AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()
     WHERE Movement.Id = inMovementId;


     -- проверка - проведенные/удаленные документы Изменять нельзя
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
     -- Проверка - Валюта должна быть установлена
     IF COALESCE (vbCurrencyDocumentId, 0) = 0 OR COALESCE (vbCurrencyPartnerId, 0) = 0 
     THEN
         RAISE EXCEPTION 'Ошибка.Значение <Валюта> должно быть установлено.';
     END IF;
     -- Проверка - Валюта должна отличаться
     IF vbCurrencyDocumentId = vbCurrencyPartnerId
     THEN
         RAISE EXCEPTION 'Ошибка.Значения <Валюта (цена)> и <Валюта (покупатель)> должны отличаться.';
     END IF;

     -- Проверка - курс должен быть установлен
     IF COALESCE (vbCurrencyPartnerValue, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Значение <Курс> должно быть установлено.';
     END IF;
     -- Проверка - Номинал должен быть установлен
     IF COALESCE (vbParPartnerValue, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Значение <Номинал> должно быть установлено.';
     END IF;


     -- сохранили
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), MovementItem.Id, CAST (MIFloat_Price.ValueData / vbCurrencyPartnerValue * vbParPartnerValue AS NUMERIC (16, 3)))
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
     WHERE MovementId = inMovementId;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementId = inMovementId;

     -- сохранили связь с <Валюта (документа)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), inMovementId, vbCurrencyPartnerId);
     -- сохранили свойство <Курс для перевода из вал. док. в валюту контрагента>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), inMovementId, 0);
     -- сохранили свойство <Номинал для перевода из вал. док. в валюту контрагента>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), inMovementId, 0);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 02.12.14                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_MovementItem_Price_Currency (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
