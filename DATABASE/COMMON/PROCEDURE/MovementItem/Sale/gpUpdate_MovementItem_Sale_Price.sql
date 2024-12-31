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

   DECLARE vbStatusId         Integer;
   DECLARE vbInvNumber        TVarChar;
   DECLARE vbOperDate         TDateTime;
   DECLARE vbPriceListId      Integer;
   DECLARE vbMovementId_order Integer;
   DECLARE vbUnitId_From      Integer;
   DECLARE vbPartnerId_To     Integer;
   DECLARE vbContractId       Integer;
   DECLARE vbPriceWithVAT     Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Sale_Price());


     -- определяются параметры документа
     SELECT Movement.StatusId
          , Movement.InvNumber
          , Movement.OperDate
          , MovementLinkObject_PriceList.ObjectId AS PriceListId
          , MLM_Order.MovementChildId             AS MovementId_order
          , MovementLinkObject_From.ObjectId                        AS UnitId_From
          , MovementLinkObject_To.ObjectId                          AS PartnerId_To
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)      AS ContractId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT

            INTO vbStatusId, vbInvNumber, vbOperDate, vbPriceListId, vbMovementId_order
               , vbUnitId_From, vbPartnerId_To, vbContractId, vbPriceWithVAT
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

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
         IF vbStatusId = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
         END IF;
         --
         -- Распроводим Документ
         UPDATE Movement SET StatusId = zc_Enum_Status_UnComplete() WHERE Id = inMovementId;
         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
         
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
                                               , inOperDatePartner:= -- т.к. есть факт. дата
                                                                     (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                                   /*CASE WHEN vbMovementId_order <> 0 AND vbOperDate + INTERVAL '1 DAY' >=  (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_order)
                                                                               THEN NULL
                                                                          ELSE vbOperDate
                                                                     END*/
                                               , inDayPrior_PriceReturn:= 0 -- !!!параметр здесь не важен!!!
                                               , inIsPrior        := FALSE -- !!!параметр здесь не важен!!!
                                               , inOperDatePartner_order:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_order AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                ) AS tmp;


     -- сохранили - акции

     -- таблица - Promo-recalc
     CREATE TEMP TABLE _tmpItem_Promo_recalc (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, OperPrice TFloat, MovementId_promo Integer, OperPrice_promo TFloat, CountForPrice_promo TFloat, isChangePercent_promo Boolean) ON COMMIT DROP;
         -- текущие элементы
         INSERT INTO _tmpItem_Promo_recalc (MovementItemId, GoodsId, GoodsKindId, OperPrice, MovementId_promo, OperPrice_promo, CountForPrice_promo, isChangePercent_promo)
            SELECT MovementItem.Id                               AS MovementItemId
                 , MovementItem.ObjectId                         AS GoodsId
                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                 , COALESCE (MIFloat_Price.ValueData, 0)         AS OperPrice
                 , 0 AS MovementId_promo
                 , 0 AS OperPrice_promo
                 , 0 AS CountForPrice_promo
                 , TRUE AS isChangePercent_promo
            FROM MovementItem
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                            AND MIFloat_Price.DescId         = zc_MIFloat_Price()
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId     = zc_MI_Master()
              AND MovementItem.isErased   = FALSE
           ;

         -- !!!нашли Акции!!!
         UPDATE _tmpItem_Promo_recalc SET MovementId_promo = lpGet.MovementId
                                        , OperPrice_promo = CASE WHEN /*lpGet.TaxPromo <> 0*/ 1=1 AND vbPriceWithVAT = TRUE THEN lpGet.PriceWithVAT_orig
                                                                 WHEN /*lpGet.TaxPromo <> 0*/ 1=1 THEN lpGet.PriceWithOutVAT_orig
                                                                 ELSE 0
                                                            END
                                        , CountForPrice_promo = lpGet.CountForPrice
                                        , isChangePercent_promo = lpGet.isChangePercent
         FROM _tmpItem_Promo_recalc AS _tmpItem_Promo_recalc_find
              JOIN lpGet_Movement_Promo_Data (inOperDate   := CASE WHEN vbMovementId_Order <> 0
                                                                    AND TRUE = (SELECT ObjectBoolean_OperDateOrder.ValueData
                                                                                FROM ObjectLink AS ObjectLink_Juridical
                                                                                     INNER JOIN ObjectLink AS ObjectLink_Retail
                                                                                                           ON ObjectLink_Retail.ObjectId = ObjectLink_Juridical.ChildObjectId
                                                                                                          AND ObjectLink_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                                                     INNER JOIN ObjectBoolean AS ObjectBoolean_OperDateOrder
                                                                                                              ON ObjectBoolean_OperDateOrder.ObjectId = ObjectLink_Retail.ChildObjectId
                                                                                                             AND ObjectBoolean_OperDateOrder.DescId = zc_ObjectBoolean_Retail_OperDateOrder()
                                                                                WHERE ObjectLink_Juridical.ObjectId = vbPartnerId_To
                                                                                  AND ObjectLink_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                                               )
                                                                        THEN (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_Order)
                                                                   ELSE (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                              END
                                            , inPartnerId  := vbPartnerId_To
                                            , inContractId := vbContractId
                                            , inUnitId     := vbUnitId_From
                                            , inGoodsId    := _tmpItem_Promo_recalc_find.GoodsId
                                            , inGoodsKindId:= _tmpItem_Promo_recalc_find.GoodsKindId
                                             ) AS lpGet
              ON lpGet.MovementId > 0
         WHERE _tmpItem_Promo_recalc.MovementItemId = _tmpItem_Promo_recalc_find.MovementItemId
        ;

         -- Сохранили протокол
         PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, vbUserId, FALSE)
         FROM (WITH tmpMI AS (SELECT _tmpItem_Promo_recalc.MovementItemId
                                   , _tmpItem_Promo_recalc.GoodsId
                                   , _tmpItem_Promo_recalc.GoodsKindId
                                   , _tmpItem_Promo_recalc.OperPrice   AS OperPrice_old
                                   , CASE WHEN _tmpItem_Promo_recalc.isChangePercent_promo = TRUE THEN COALESCE (MF_ChangePercent.ValueData, 0) ELSE 0 END AS ChangePercent
                                   , _tmpItem_Promo_recalc.MovementId_promo
                                   , _tmpItem_Promo_recalc.OperPrice_promo
                                   , _tmpItem_Promo_recalc.CountForPrice_promo
                              FROM _tmpItem_Promo_recalc
                                   LEFT JOIN MovementFloat AS MF_ChangePercent
                                                           ON MF_ChangePercent.MovementId = inMovementId
                                                          AND MF_ChangePercent.DescId     = zc_MovementFloat_ChangePercent()
                             )
                    , tmpPrice AS (SELECT tmpGoods.GoodsId
                                        , COALESCE (ObjectLink_PriceListItem_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                        , COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) AS OperPrice
                                   FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmpGoods
                                         INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                               ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmpGoods.GoodsId
                                                              AND ObjectLink_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                                         INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                               ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                              AND ObjectLink_PriceListItem_PriceList.ChildObjectId = vbPriceListId
                                                              AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                         LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                              ON ObjectLink_PriceListItem_GoodsKind.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                             AND ObjectLink_PriceListItem_GoodsKind.DescId        = zc_ObjectLink_PriceListItem_GoodsKind()
                                         INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                                  ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                                 AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                                 AND vbOperDate >= ObjectHistory_PriceListItem.StartDate AND vbOperDate < ObjectHistory_PriceListItem.EndDate
                                         LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                                      ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                                     AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                   WHERE ObjectHistoryFloat_PriceListItem_Value.ValueData >= 0
                                  )
                  , tmpAll AS (SELECT tmpMI.MovementItemId
                                    , tmpMI.MovementId_promo
                                    , CASE WHEN tmpMI.MovementId_promo > 0 THEN tmpMI.OperPrice_promo
                                           ELSE COALESCE (tmpPrice_1.OperPrice, tmpPrice_2.OperPrice, tmpPrice_3.OperPrice, 0)
                                      END AS OperPrice
                                    , CASE WHEN tmpMI.MovementId_promo > 0 AND tmpMI.CountForPrice_promo > 0 THEN tmpMI.CountForPrice_promo
                                           ELSE 1
                                      END AS CountForPrice
                                    , tmpMI.ChangePercent
                               FROM tmpMI
                                    LEFT JOIN tmpPrice AS tmpPrice_1 ON tmpPrice_1.GoodsId     = tmpMI.GoodsId
                                                                    AND tmpPrice_1.GoodsKindId = tmpMI.GoodsKindId
                                    LEFT JOIN tmpPrice AS tmpPrice_2 ON tmpPrice_2.GoodsId     = tmpMI.GoodsId
                                                                    AND tmpPrice_2.GoodsKindId = 0
                                    LEFT JOIN tmpPrice AS tmpPrice_3 ON tmpPrice_3.GoodsId     = tmpMI.GoodsId
                                                                    AND tmpPrice_3.GoodsKindId = zc_GoodsKind_Basis()
                               WHERE COALESCE (tmpPrice_1.OperPrice, tmpPrice_2.OperPrice, tmpPrice_3.OperPrice, 0) >= 0
                                 AND (tmpMI.OperPrice_old <> CASE WHEN tmpMI.MovementId_promo > 0 THEN tmpMI.OperPrice_promo
                                                                  ELSE COALESCE (tmpPrice_1.OperPrice, tmpPrice_2.OperPrice, tmpPrice_3.OperPrice, 0)
                                                             END
                                   OR tmpMI.MovementId_promo > 0
                                     )
                              )
               -- Сохранили Цены
               SELECT CASE WHEN tmpAll.OperPrice >= 0 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), tmpAll.MovementItemId, tmpAll.OperPrice) END
                      -- сохранили свойство <MovementId-Акция>
                    , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), tmpAll.MovementItemId, COALESCE (tmpAll.MovementId_promo, 0))
                       -- сохранили свойство <(-)% Скидки (+)% Наценки>
                    , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), tmpAll.MovementItemId, tmpAll.ChangePercent)
                      -- сохранили свойство <Цена за количество>
                    , lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), tmpAll.MovementItemId, tmpAll.CountForPrice)
                      --
                    , tmpAll.MovementItemId
               FROM tmpAll
              ) AS tmp;


     -- сохранили
     /*PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), MovementItem.Id, COALESCE (lfObjectHistory_PriceListItem_kind.ValuePrice, lfObjectHistory_PriceListItem.ValuePrice, 0))
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
     ;*/

if vbUserId = 5 AND 1=0
then
    RAISE EXCEPTION 'Ошибка.<%>   %', vbOperDate
--    , (select COALESCE (lfObjectHistory_PriceListItem_kind.ValuePrice, lfObjectHistory_PriceListItem.ValuePrice, 0)
    , (select MIFloat_PromoMovement.ValueData
    
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
     WHERE MovementItem.MovementId = inMovementId
       -- !!! без акций !!!
       -- AND COALESCE (MIFloat_PromoMovement.ValueData, 0) = 0
       and MovementItem.Id = 311558848  
       )

;
end if;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementId = inMovementId;

     -- сохранили связь с <PriceList>
     -- PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), inMovementId, vbPriceListId);

     -- проверка
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
         -- создаются временные таблицы - для формирование данных для проводок
         PERFORM lpComplete_Movement_Sale_CreateTemp();
         -- Проводим Документ
         PERFORM lpComplete_Movement_Sale (inMovementId     := inMovementId
                                         , inUserId         := -1 * vbUserId
                                         , inIsLastComplete := TRUE
                                         , inIsRecalcPrice  := FALSE
                                          );
     ELSE
         -- пересчитали Итоговые суммы по накладной
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 02.12.19         *
 22.08.15         *

*/
