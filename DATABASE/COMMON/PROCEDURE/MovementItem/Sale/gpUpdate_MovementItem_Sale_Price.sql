-- Function: gpUpdate_MovementItem_Sale_Price()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Sale_Price (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Sale_Price(
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;
   DECLARE vbPriceListId Integer;
   DECLARE vbMovementId_order Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Sale_Price());


     -- определяются параметры документа
     SELECT Movement.StatusId
          , Movement.InvNumber
          , Movement.OperDate
          , MovementLinkObject_PriceList.ObjectId AS PriceListId
          , MLM_Order.MovementChildId             AS MovementId_order

            INTO vbStatusId, vbInvNumber, vbOperDate, vbPriceListId, vbMovementId_order
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                       ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                      AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
          LEFT JOIN MovementLinkMovement AS MLM_Order
                                         ON MLM_Order.MovementId = Movement.Id
                                        AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
     WHERE Movement.Id = inMovementId;


     -- проверка - проведенные/удаленные документы Изменять нельзя
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
     -- Проверка - Прайс лист должен быть установлен
     IF COALESCE (vbPriceListId, 0) = 0 
     THEN
         RAISE EXCEPTION 'Ошибка.Значение <Прайс лист> должно быть установлено.';
     END IF;
   

     -- меняется параметр
     -- !!!замена!!!
     SELECT tmp.OperDate
            INTO vbOperDate
     FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                               , inPartnerId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                               , inMovementDescId := zc_Movement_Sale()
                                               , inOperDate_order := CASE WHEN vbMovementId_order <> 0
                                                                               THEN (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_order)
                                                                          ELSE NULL
                                                                     END
                                               , inOperDatePartner:= CASE WHEN vbMovementId_order <> 0 AND vbOperDate + INTERVAL '1 DAY' >=  (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_order)
                                                                               THEN NULL
                                                                          ELSE vbOperDate
                                                                     END
                                               , inDayPrior_PriceReturn:= 0 -- !!!параметр здесь не важен!!!
                                               , inIsPrior        := FALSE -- !!!параметр здесь не важен!!!
                                               , inOperDatePartner_order:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_order AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                ) AS tmp;


     -- сохранили
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), MovementItem.Id, COALESCE (lfObjectHistory_PriceListItem_kind.ValuePrice, lfObjectHistory_PriceListItem.ValuePrice, 0))
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                      ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                     AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
          -- вид товара
          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

          -- привязываем 2 раза по виду товара и с пустым видом
          LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate)
                 AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = MovementItem.ObjectId
                                                 AND lfObjectHistory_PriceListItem.GoodsKindId IS NULL
                                                 
          LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate)
                 AS lfObjectHistory_PriceListItem_kind 
                 ON lfObjectHistory_PriceListItem_kind.GoodsId = MovementItem.ObjectId
                AND COALESCE (lfObjectHistory_PriceListItem_kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
     WHERE MovementId = inMovementId
       -- !!! без акций !!!
       AND COALESCE (MIFloat_PromoMovement.ValueData, 0) = 0
     ;


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementId = inMovementId;

     -- сохранили связь с <PriceList>
     -- PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), inMovementId, vbPriceListId);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 02.12.19         *
 22.08.15         *

*/
