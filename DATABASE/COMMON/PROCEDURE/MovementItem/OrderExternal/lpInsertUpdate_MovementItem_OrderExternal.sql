-- Function: lpInsertUpdate_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderExternal (Integer, Integer, Integer, TFloat, TFloat, Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderExternal(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountSecond        TFloat    , -- Количество дозаказ
    IN inGoodsKindId         Integer   , -- Виды товаров
 INOUT ioPrice               TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
   OUT outMovementId_Promo   Integer   ,
   OUT outPricePromo         TFloat    ,
    IN inUserId              Integer     -- пользователь
)
RETURNS RECORD AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbPriceWithVAT Boolean;
   DECLARE vbChangePercent TFloat;
   DECLARE vbIsChangePercent_Promo Boolean;
   DECLARE vbTaxPromo TFloat;
   DECLARE vbCountForPricePromo TFloat;
   DECLARE vbPartnerId Integer;

   DECLARE vbPriceListId Integer;
   DECLARE vbOperDate_pl TDateTime;
BEGIN
     -- !!!временно - пока есть ошибка на моб устройстве с ценами!!!
     IF COALESCE (ioPrice, 0) = 0 AND EXISTS (SELECT 1 FROM MovementString AS MS WHERE MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_GUID())
     THEN
         -- !!!замена!!!
         SELECT tmp.PriceListId, tmp.OperDate
                INTO vbPriceListId, vbOperDate_pl
         FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                   , inPartnerId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                                   , inMovementDescId := zc_Movement_Sale()
                                                   , inOperDate_order := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
                                                   , inOperDatePartner:=  NULL
                                                   , inDayPrior_PriceReturn:= NULL
                                                   , inIsPrior        := FALSE -- !!!отказались от старых цен!!!
                                                   , inOperDatePartner_order:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                    ) AS tmp;
         -- !!!замена!!!
         ioPrice:= COALESCE ((SELECT tmp.ValuePrice FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := vbOperDate_pl
                                                                                          , inPriceListId:= vbPriceListId
                                                                                          , inGoodsId    := inGoodsId
                                                                                          , inGoodsKindId:= inGoodsKindId
                                                                                          , inSession    := inUserId :: TVarChar
                                                                                           ) AS tmp)
                            ,(SELECT tmp.ValuePrice FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := vbOperDate_pl
                                                                                          , inPriceListId:= vbPriceListId
                                                                                          , inGoodsId    := inGoodsId
                                                                                          , inGoodsKindId:= NULL
                                                                                          , inSession    := inUserId :: TVarChar
                                                                                           ) AS tmp)
                            , 0);
                                                                                                                                                                                                                             
     END IF;


     -- Контрагент
     vbPartnerId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From());
     -- Цены с НДС
     vbPriceWithVAT:= (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT());
     -- параметры акции
     SELECT tmp.MovementId, CASE WHEN tmp.TaxPromo <> 0 AND vbPriceWithVAT = TRUE THEN tmp.PriceWithVAT_orig
                                 WHEN tmp.TaxPromo <> 0 THEN tmp.PriceWithOutVAT_orig
                                 ELSE 0
                            END
          , tmp.CountForPrice
          , tmp.TaxPromo
          , tmp.isChangePercent
            INTO outMovementId_Promo, outPricePromo, vbCountForPricePromo, vbTaxPromo, vbIsChangePercent_Promo
     FROM lpGet_Movement_Promo_Data (inOperDate   := CASE WHEN TRUE = (SELECT ObjectBoolean_OperDateOrder.ValueData
                                                                       FROM ObjectLink AS ObjectLink_Juridical
                                                                            INNER JOIN ObjectLink AS ObjectLink_Retail
                                                                                                  ON ObjectLink_Retail.ObjectId = ObjectLink_Juridical.ChildObjectId
                                                                                                 AND ObjectLink_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                                            INNER JOIN ObjectBoolean AS ObjectBoolean_OperDateOrder
                                                                                                     ON ObjectBoolean_OperDateOrder.ObjectId = ObjectLink_Retail.ChildObjectId
                                                                                                    AND ObjectBoolean_OperDateOrder.DescId = zc_ObjectBoolean_Retail_OperDateOrder()
                                                                       WHERE ObjectLink_Juridical.ObjectId = vbPartnerId
                                                                         AND ObjectLink_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                                      )
                                                                THEN (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
                                                          ELSE (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                             + (COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbPartnerId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_DocumentDayCount()), 0) :: TVarChar || ' DAY') :: INTERVAL
                                                          -- + (COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbPartnerId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_PrepareDayCount()),  0) :: TVarChar || ' DAY') :: INTERVAL
                                                     END
                                   , inPartnerId  := vbPartnerId
                                   , inContractId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                   , inUnitId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                   , inGoodsId    := inGoodsId
                                   , inGoodsKindId:= inGoodsKindId) AS tmp;


     -- (-)% Скидки (+)% Наценки
     vbChangePercent:= CASE WHEN COALESCE (vbIsChangePercent_Promo, TRUE) = TRUE THEN COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_ChangePercent()), 0) ELSE 0 END;

     -- !!!замена для акции!!
     IF outMovementId_Promo > 0
     THEN
        IF NOT EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = outMovementId_Promo AND MB.DescId = zc_MovementBoolean_Promo() AND MB.ValueData = TRUE)
        THEN
              -- меняется значение - для Тенедер
             ioPrice:= outPricePromo;

        ELSEIF COALESCE (ioId, 0) = 0 AND vbTaxPromo <> 0
        THEN
            -- меняется значение
            ioPrice:= outPricePromo;
            ioCountForPrice:= vbCountForPricePromo;

        ELSE IF ioId <> 0 AND ioPrice <> outPricePromo AND vbTaxPromo <> 0
             THEN
                 IF EXISTS (SELECT 1 FROM MovementString AS MS WHERE MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_GUID())
                 THEN
                     -- меняется значение
                     ioPrice:= outPricePromo;
                 ELSE
                     RAISE EXCEPTION 'Ошибка.Для товара = <%> <%> необходимо ввести акционную цену = <%>.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData_sh (inGoodsKindId), zfConvert_FloatToString (outPricePromo);
                 END IF;
             END IF;
        END IF;
     -- ELSE !!!обратно из прайса пока не реализовал!!!!
     END IF;


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- сохранили свойство <MovementId-Акция>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), ioId, COALESCE (outMovementId_Promo, 0));

     -- сохранили свойство <(-)% Скидки (+)% Наценки>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, vbChangePercent);

     -- сохранили свойство <Количество дозаказ>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), ioId, inAmountSecond);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, ioPrice);

     -- сохранили свойство <Цена за количество>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, ioCountForPrice);

     -- расчитали сумму по элементу, для грида
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST ((COALESCE (inAmount,0) + COALESCE (inAmountSecond,0)) * ioPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST ((COALESCE (inAmount,0) + COALESCE (inAmountSecond,0)) * ioPrice AS NUMERIC (16, 2))
                      END;

     IF inGoodsId <> 0
     THEN
         -- создали объект <Связи Товары и Виды товаров>
         PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);
     END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.12.19         *
 19.10.14                                        * set lp
 25.08.14                                        * add сохранили протокол
 18.08.14                                                        *
 06.06.14                                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_OrderExternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')

/*
-- !!!!!!!!!!!! - 0 - !!!!!!!!! 
select lpInsertUpdate_MovementFloat_TotalSumm  (tmp.Id)
from (
select distinct Movement.*
from Movement
     inner join MovementFloat AS MF on MF.MovementId = Movement.Id AND MF.DescId = zc_MovementFloat_ChangePercent() and MF.ValueData <> 0
     inner join MovementItem on MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
          and MovementItem.isErased = FALSE

                                 left JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                             ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                            AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

where Movement.DescId = zc_Movement_OrderExternal() 
-- and Movement.Id = 4111493 
  and Movement.OperDate between '01.07.2016' and '01.10.2016'
  and coalesce (MIFloat_ChangePercent.ValueData, 0)  = 0
) as tmp



-- !!!!!!!!!!!! - 1 - !!!!!!!!! 
select Movement.*
, MIFloat_ChangePercent.*
, MF.ValueData
      -- , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), MovementItem.Id, MF.ValueData)
from Movement
     inner join MovementFloat AS MF on MF.MovementId = Movement.Id AND MF.DescId = zc_MovementFloat_ChangePercent() and MF.ValueData <> 0
     inner join MovementItem on MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
          -- and MovementItem.isErased = FALSE

                                 left JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                             ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                            AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

where Movement.DescId = zc_Movement_OrderExternal() 
-- and Movement.Id = 4111493 
  and Movement.OperDate between '01.07.2016' and '01.10.2016'
and coalesce (MIFloat_ChangePercent.ValueData, 0) <> coalesce (MF.ValueData, 0)


-- !!!!!!!!!!!! - 2 - !!!!!!!!! 
select Movement.*
--     , MovementItem.ObjectId AS GoodsId
--       , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), MovementItem.Id, 0)
, MIFloat_ChangePercent.*
, MIFloat_ChangePercent2.ValueDaTA
-- , Movement_sale.*
, MI_sale.*
from Movement
     inner join MovementFloat AS MF on MF.MovementId = Movement.Id AND MF.DescId = zc_MovementFloat_ChangePercent() and MF.ValueData <> 0

     inner join MovementLinkMovement AS MLM on  MLM.DescId = zc_MovementLinkMovement_Order()
                                                           and MLM.MovementChildId = Movement.Id
     INNER join Movement as Movement_sale on Movement_sale.Id = MLM.MovementId
                                         and Movement_sale.dESCId = zc_Movement_Sale()

     inner join MovementItem on MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            -- and MovementItem.isErased = FALSE


                                 inner JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                              ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                             AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                                             AND MIFloat_PromoMovement.ValueData > 0

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                                 inner JOIN MovementItemFloat AS MIFloat_ChangePercent2
                                                             ON MIFloat_ChangePercent2.MovementItemId = MovementItem.Id
                                                            AND MIFloat_ChangePercent2.DescId = zc_MIFloat_ChangePercent()
                                                            AND MIFloat_ChangePercent2.ValueDaTA <> 0

     inner join MovementItem as MI_sale on MI_sale.MovementId = MLM.MovementId AND MI_sale.DescId = zc_MI_Master() AND MI_sale.isErased = FALSE AND MI_sale.ObjectId = MovementItem.ObjectId

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_sale
                                                                  ON MILinkObject_GoodsKind_sale.MovementItemId = MI_sale.Id
                                                                 AND MILinkObject_GoodsKind_sale.DescId = zc_MILinkObject_GoodsKind()

                                 left JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                             ON MIFloat_ChangePercent.MovementItemId = MI_sale.Id
                                                            AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

where Movement.DescId = zc_Movement_OrderExternal()
-- and Movement.Id = 4111493 
  and Movement.OperDate between '01.09.2016' and '01.12.2016'
  and COALESCE (MIFloat_ChangePercent.ValueData, 0) = 0
  and coalesce (MILinkObject_GoodsKind_sale.ObjectId , 0) = coalesce (MILinkObject_GoodsKind.ObjectId , 0)
*/
