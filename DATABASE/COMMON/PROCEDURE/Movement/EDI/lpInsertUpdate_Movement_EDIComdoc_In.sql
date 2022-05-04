-- Function: lpInsertUpdate_Movement_EDIComdoc_In()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_EDIComdoc_In (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_EDIComdoc_In(
    IN inMovementId      Integer   , --
    IN inUserId          Integer   , -- пользователь
   OUT outMessageText    Text      ,
    IN inSession         TVarChar    -- сессия пользователя
)                              
RETURNS Text
AS
$BODY$
   DECLARE vbMovementId_ReturnIn      Integer;
   DECLARE vbMovementId_TaxCorrective Integer;
   DECLARE vbMovementId_Tax           Integer;

   DECLARE vbInvNumberPartner_Tax     TVarChar;
   DECLARE vbOperDate_Tax             TDateTime;
   DECLARE vbJuridicalId_Tax          Integer;
   DECLARE vbBranchId                 Integer;
BEGIN

     -- Определяются филиал
     vbBranchId:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);

     -- Определяются параметры
     SELECT Movement_ReturnIn.Id, Movement_TaxCorrective.Id
          , TRIM (MovementString_InvNumberTax.ValueData), MovementDate_OperDateTax.ValueData, MovementLinkObject_Juridical.ObjectId
            INTO vbMovementId_ReturnIn, vbMovementId_TaxCorrective
               , vbInvNumberPartner_Tax, vbOperDate_Tax, vbJuridicalId_Tax
     FROM Movement
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_MasterEDI
                                         ON MovementLinkMovement_MasterEDI.MovementChildId = Movement.Id
                                        AND MovementLinkMovement_MasterEDI.DescId = zc_MovementLinkMovement_MasterEDI()
          LEFT JOIN Movement AS Movement_ReturnIn ON Movement_ReturnIn.Id = MovementLinkMovement_MasterEDI.MovementId
                                                 AND Movement_ReturnIn.StatusId <> zc_Enum_Status_Erased()
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_ChildEDI
                                         ON MovementLinkMovement_ChildEDI.MovementChildId = Movement.Id
                                        AND MovementLinkMovement_ChildEDI.DescId = zc_MovementLinkMovement_ChildEDI()
          LEFT JOIN Movement AS Movement_TaxCorrective ON Movement_TaxCorrective.Id = MovementLinkMovement_ChildEDI.MovementId
                                                      AND Movement_TaxCorrective.StatusId <> zc_Enum_Status_Erased()
          LEFT JOIN MovementString AS MovementString_InvNumberTax
                                   ON MovementString_InvNumberTax.MovementId =  Movement.Id
                                  AND MovementString_InvNumberTax.DescId = zc_MovementString_InvNumberTax()
          LEFT JOIN MovementDate AS MovementDate_OperDateTax
                                 ON MovementDate_OperDateTax.MovementId =  Movement.Id
                                AND MovementDate_OperDateTax.DescId = zc_MovementDate_OperDateTax()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                       ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
     WHERE Movement.Id = inMovementId;

     -- Проверка
     IF COALESCE (vbInvNumberPartner_Tax, '') = ''
     THEN
         RAISE EXCEPTION 'Ошибка.Номер документа <Налоговая накладная> не установлен.';
     END IF;
     -- Проверка
     IF COALESCE (vbJuridicalId_Tax, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Параметр <Юридическое лицо> не установлен.';
     END IF;


     -- Поиск документа <Налоговая накладная>
     vbMovementId_Tax:= (SELECT Movement.Id
                         FROM MovementString AS MovementString_InvNumberPartner
                              INNER JOIN Movement ON Movement.Id = MovementString_InvNumberPartner.MovementId
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                                 AND Movement.DescId = zc_Movement_Tax()
                                                 AND Movement.OperDate BETWEEN (vbOperDate_Tax - (INTERVAL '7 DAY')) AND (vbOperDate_Tax + (INTERVAL '7 DAY'))
                               INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                            AND MovementLinkObject_To.ObjectId = vbJuridicalId_Tax
                         WHERE MovementString_InvNumberPartner.ValueData = vbInvNumberPartner_Tax
                           AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner());

     -- Проверка
     IF COALESCE (vbMovementId_Tax, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ <Налоговая накладная> № <%> от <%> не найден.', vbInvNumberPartner_Tax, DATE (vbOperDate_Tax);
     END IF;


     -- обновили <Классификатор товаров> !!!по док-ту vbMovementId_Tax!!! + сохранили элементы !!!на самом деле только обновили GoodsId and GoodsKindId!!!
     PERFORM lpUpdate_MI_EDI_Params (inMovementId  := inMovementId
                                   , inContractId  := (SELECT MLO_Contract.ObjectId FROM MovementLinkObject AS MLO_Contract WHERE MLO_Contract.MovementId = vbMovementId_Tax AND MLO_Contract.DescId = zc_MovementLinkObject_Contract())
                                   , inJuridicalId := vbJuridicalId_Tax
                                   , inUserId      := inUserId
                                    );

     -- сохранили <Возврат от покупателя>
     SELECT lpInsertUpdate_Movement_ReturnIn
                                       (ioId                := vbMovementId_ReturnIn
                                      , inInvNumber         := CASE WHEN vbMovementId_ReturnIn <> 0 THEN (SELECT InvNumber FROM Movement WHERE Id = vbMovementId_ReturnIn) ELSE CAST (NEXTVAL ('movement_returnin_seq') AS TVarChar) END :: TVarChar
                                      , inInvNumberPartner  := MovementString_InvNumberPartner.ValueData
                                      , inInvNumberMark     := (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_ReturnIn AND DescId = zc_MovementString_InvNumberMark()) :: TVarChar
                                      , inParentId          := NULL
                                      , inOperDate          := MovementDate_OperDatePartner.ValueData
                                      , inOperDatePartner   := MovementDate_OperDatePartner.ValueData
                                      , inChecked           := (SELECT ValueData FROM MovementBoolean WHERE MovementId = vbMovementId_ReturnIn AND DescId = zc_MovementBoolean_Checked()) :: Boolean
                                      , inIsPartner         := (SELECT ValueData FROM MovementBoolean WHERE MovementId = vbMovementId_ReturnIn AND DescId = zc_MovementBoolean_isPartner()) :: Boolean
                                      , inPriceWithVAT      := MovementBoolean_PriceWithVAT.ValueData
                                      , inVATPercent        := MovementFloat_VATPercent.ValueData
                                      , inChangePercent     := (SELECT ValueData FROM MovementFloat WHERE MovementId = vbMovementId_ReturnIn AND DescId = zc_MovementFloat_ChangePercent())
                                      , inFromId            := (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = vbMovementId_Tax AND DescId = zc_MovementLinkObject_Partner())
                                      , inToId              := CASE WHEN vbBranchId <> 0
                                                                        THEN 309599 -- !!!Склад возвратов ф.Запорожье!!!
                                                                    ELSE 8461 -- !!!Склад Возвратов!!!
                                                               END
                                      , inPaidKindId        := zc_Enum_PaidKind_FirstForm() 
                                      , inContractId        := (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = vbMovementId_Tax AND DescId = zc_MovementLinkObject_Contract())
                                      , inCurrencyDocumentId:= 14461 -- грн
                                      , inCurrencyPartnerId := NULL
                                      , inCurrencyValue     := NULL
                                      , inParValue          := NULL
                                      , inCurrencyPartnerValue:= NULL
                                      , inParPartnerValue     := NULL
                                      , inMovementId_OrderReturnTare:= NULL
                                      , inComment           = ''
                                      , inUserId            := inUserId
                                       ) INTO vbMovementId_ReturnIn
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                   ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                  AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
     WHERE Movement.Id = inMovementId;

     -- сохранили строчную часть <Возврат от покупателя>
     PERFORM lpInsertUpdate_MovementItem_ReturnIn (ioId                 := tmpMI.MovementItemId
                                                 , inMovementId         := vbMovementId_ReturnIn
                                                 , inGoodsId            := tmpMI.GoodsId
                                                 , inAmount             := tmpMI.Amount
                                                 , inAmountPartner      := tmpMI.AmountPartner
                                                 , ioPrice              := tmpMI.Price
                                                 , ioCountForPrice      := 1
                                                 , inHeadCount          := 0
                                                 , inMovementId_Partion := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = tmpMI.MovementItemId AND DescId = zc_MIFloat_MovementId()), 0) :: Integer
                                                 , inPartionGoods       := ''
                                                 , inGoodsKindId        := tmpMI.GoodsKindId
                                                 , inAssetId            := NULL
                                                 , ioMovementId_Promo   := NULL
                                                 , ioChangePercent      := 0
                                                 , inIsCheckPrice       := FALSE
                                                 , inUserId             := inUserId
                                                  )
     FROM (SELECT MAX (tmpMI.MovementItemId) AS MovementItemId
                , tmpMI.GoodsId
                , tmpMI.GoodsKindId
                , SUM (tmpMI.Amount)         AS Amount
                , SUM (tmpMI.AmountPartner)  AS AmountPartner
                , tmpMI.Price
           FROM (SELECT 0                                                   AS MovementItemId
                      , MovementItem.ObjectId                               AS GoodsId
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                      , CASE WHEN vbBranchId <> 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END AS Amount
                      , COALESCE (MIFloat_AmountPartner.ValueData, 0)       AS AmountPartner
                      , COALESCE (MIFloat_Price.ValueData, 0)               AS Price
                 FROM MovementItem
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                  ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                      LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId =  zc_MI_Master()
                   AND MovementItem.isErased = FALSE
                UNION ALL
                 SELECT MovementItem.Id                                     AS MovementItemId
                      , MovementItem.ObjectId                               AS GoodsId
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                      , CASE WHEN vbBranchId <> 0 THEN 0 ELSE MovementItem.Amount END AS Amount
                      , 0                                                   AS AmountPartner
                      , COALESCE (MIFloat_Price.ValueData, 0)               AS Price
                 FROM MovementItem
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                        LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                    ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                   AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
                 WHERE MovementItem.MovementId = vbMovementId_ReturnIn
                   AND MovementItem.DescId =  zc_MI_Master()
                   AND MovementItem.isErased = FALSE
                ) AS tmpMI
           GROUP BY tmpMI.GoodsId
                  , tmpMI.GoodsKindId
                  , tmpMI.Price
          ) AS tmpMI
    ;

     -- сохранили <Корректировка к налоговой накладной>
     SELECT tmp.outMovementId_Corrective,  tmp.outMessageText
            INTO vbMovementId_TaxCorrective, outMessageText
     FROM gpInsertUpdate_Movement_TaxCorrective_From_Kind (inMovementId            := vbMovementId_ReturnIn
                                                         , inDocumentTaxKindId     := zc_Enum_DocumentTaxKind_Corrective()
                                                         , inDocumentTaxKindId_inf := NULL
                                                         , inIsTaxLink             := FALSE
                                                         , inSession               := inSession
                                                          ) AS tmp;
     -- сформировали связь Корректировки с Налоговой
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), vbMovementId_TaxCorrective, vbMovementId_Tax);

     -- сформировали связь <Возврат от покупателя> с EDI
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_MasterEDI(), vbMovementId_ReturnIn, inMovementId);

     -- сформировали связь <Корректировка к налоговой накладной> с EDI
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_ChildEDI(), vbMovementId_TaxCorrective, inMovementId);

     -- ФИНИШ - Проводим <Возврат от покупателя>
     PERFORM gpComplete_Movement_ReturnIn (inMovementId     := vbMovementId_ReturnIn
                                         , inIsLastComplete := TRUE
                                         , inSession        := inSession);
     -- сохранили протокол
     PERFORM lpInsert_Movement_EDIEvents (inMovementId, 'Завершен перенос данных из ComDoc в документ (' || (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_ReturnIn()) || ').', inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.09.14                                        *
 31.07.14                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_EDIComdoc_In (inMovementId:= 0, inUserId:= 2)
