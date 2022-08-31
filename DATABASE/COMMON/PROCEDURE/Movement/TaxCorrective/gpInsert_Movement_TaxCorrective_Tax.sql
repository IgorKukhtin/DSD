-- Function: gpInsert_Movement_TaxCorrective_Tax()

DROP FUNCTION IF EXISTS gpInsert_Movement_TaxCorrective_Tax (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_TaxCorrective_Tax(
    IN inMovementId_from     Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
   OUT outMessageText        Text      ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Text
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbMovementId_to Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Insert_Movement_TaxCorrective_Tax());


     -- Проверка
     IF NOT EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId_from AND Movement.DescId = zc_Movement_Tax())
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав перенести документы.';
     END IF;



     -- сохранили <Документ>
     vbMovementId_to := (SELECT lpInsertUpdate_Movement_TaxCorrective (ioId                  := 0
                                                                     , inInvNumber           := NEXTVAL ('movement_taxcorrective_seq') :: TVarChar
                                                                     , inInvNumberPartner    := lpInsertFind_Object_InvNumberTax (zc_Movement_TaxCorrective()
                                                                                                                                , inOperDate
                                                                                                                                -- , DATE_TRUNC ('MONTH', tmp.OperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                                                                                                                                , tmp.InvNumberBranch
                                                                                                                                 ) :: TVarChar
                                                                     , inInvNumberBranch     := tmp.InvNumberBranch
                                                                     , inOperDate            := inOperDate
                                                                     --, inOperDate            := DATE_TRUNC ('MONTH', tmp.OperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                                                                     , inChecked             := FALSE
                                                                     , inDocument            := FALSE
                                                                     , inPriceWithVAT        := tmp.PriceWithVAT
                                                                     , inVATPercent          := tmp.VATPercent
                                                                     , inFromId              := tmp.ToId
                                                                     , inToId                := tmp.FromId
                                                                     , inPartnerId           := tmp.PartnerId
                                                                     , inContractId          := tmp.ContractId
                                                                     , inDocumentTaxKindId   := CASE WHEN tmp.TaxKindId = zc_Enum_DocumentTaxKind_Tax()
                                                                                                          THEN zc_Enum_DocumentTaxKind_Corrective()

                                                                                                     WHEN tmp.TaxKindId = zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                                                          THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR()

                                                                                                     WHEN tmp.TaxKindId = zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                                                          THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR()

                                                                                                     WHEN tmp.TaxKindId = zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                                                          THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR()

                                                                                                     WHEN tmp.TaxKindId = zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                                                          THEN zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()
                                                                                                END
                                                                     , inUserId              := vbUserId
                                                                      ) AS MovementId
                         FROM gpGet_Movement_Tax (inMovementId:= inMovementId_from
                                                , inMask      := FALSE
                                                , inOperDate  := NULL
                                                , inSession   := inSession
                                                 ) AS tmp);

     -- сохранили связь с <Налоговая накладная>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), vbMovementId_to, inMovementId_from);

     -- сохранили свойство для документа <Корректировка>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isCopy(), vbMovementId_to, TRUE);


     -- сохранили <элементы документа>
     PERFORM lpInsertUpdate_MovementItem_TaxCorrective (ioId                 := 0
                                                      , inMovementId         := vbMovementId_to
                                                      , inGoodsId            := MovementItem.ObjectId
                                                      , inAmount             := MovementItem.Amount
                                                      , inPrice              := COALESCE (MIFloat_Price.ValueData, 0)
                                                      , inPriceTax_calc      := COALESCE (MIFloat_PriceTax_calc.ValueData, 0)
                                                      , ioCountForPrice      := COALESCE (MIFloat_CountForPrice.ValueData, 0)
                                                      , inGoodsKindId        := MILinkObject_GoodsKind.ObjectId
                                                      , inUserId             := vbUserId
                                                       ) AS tmp
     FROM MovementItem 
          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
          LEFT JOIN MovementItemFloat AS MIFloat_PriceTax_calc
                                      ON MIFloat_PriceTax_calc.MovementItemId = MovementItem.Id
                                     AND MIFloat_PriceTax_calc.DescId         = zc_MIFloat_PriceTax_calc()
          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                      ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                     AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
     WHERE MovementItem.MovementId = inMovementId_from
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE
       AND MovementItem.Amount     <> 0
     ;


     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_Complete_TaxCorrective()) AND 1=0
     THEN
         -- Проводим Документ
         outMessageText:= lpComplete_Movement_TaxCorrective (inMovementId := vbMovementId_to
                                                           , inUserId     := vbUserId);
     END IF;


     -- сохранили свойство для документа <Налоговая>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isCopy(), inMovementId_from, TRUE);
     -- сохранили протокол для документа <Налоговая>
     PERFORM lpInsert_MovementProtocol (inMovementId_from, vbUserId, FALSE);


IF vbUserId = 5
THEN
    RAISE EXCEPTION 'Ошибка.test = ok';
END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.08.15                                        *
*/


-- тест
-- SELECT * FROM gpInsert_Movement_TaxCorrective_Tax (inMovementId:= 275079, inDesc:= 'False', inSession:= '2')
