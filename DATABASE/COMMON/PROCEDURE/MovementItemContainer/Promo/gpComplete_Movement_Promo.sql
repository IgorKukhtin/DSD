-- Function: gpComplete_Movement_Promo()

DROP FUNCTION IF EXISTS gpComplete_Movement_Promo  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Promo(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbStartSale TDateTime;
   DECLARE vbEndSale   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Promo());


     -- нашли
     vbStartSale:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_StartSale());
     vbEndSale  := (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_EndSale());


     -- проверка - если нет ВСЕХ подписей, проводить нельзя
     PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= inMovementId
                                        , inIsComplete:= TRUE
                                        , inIsUpdate  := FALSE
                                        , inUserId    := vbUserId
                                         );

    -- Проверили - Компенсация,грн 
    IF EXISTS (SELECT 1
                   FROM (SELECT 1 AS x) AS xx
                        LEFT JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                              AND MovementItem.DescId     = zc_MI_Master()
                                              AND MovementItem.isErased   = FALSE
                        LEFT JOIN MovementItemFloat AS MIFloat_SummOutMarket
                                                    ON MIFloat_SummOutMarket.MovementItemId = MovementItem.Id
                                                   AND MIFloat_SummOutMarket.DescId         = zc_MIFloat_SummOutMarket()
                        LEFT JOIN MovementItemFloat AS MIFloat_SummInMarket
                                                    ON MIFloat_SummInMarket.MovementItemId = MovementItem.Id
                                                   AND MIFloat_SummInMarket.DescId         = zc_MIFloat_SummInMarket()
                   WHERE COALESCE (MIFloat_SummOutMarket.ValueData, 0) = 0
                     AND COALESCE (MIFloat_SummInMarket.ValueData, 0)  = 0
                  )
       -- если Затраты
       AND EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Cost() AND MB.ValueData = TRUE)
    THEN
        RAISE EXCEPTION 'Ошибка.Для Акции с признаком <Затраты> необходимо заполнить ячейку <Компенсация,грн>.';
    END IF;


    -- Проверили - Ви товара
    IF EXISTS (SELECT 1
               FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                    INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                          ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                         AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                        , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                        , zc_Enum_InfoMoney_30102() -- Тушенка
                                                                                         )
                                         AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
                 AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0
              )
    THEN
        RAISE EXCEPTION 'Ошибка.Необходимо заполнить колонку вид товара.';
    END IF;


    -- Проверили inPriceTender
    IF EXISTS (SELECT 1
                FROM MovementItem
                     INNER JOIN MovementItemFloat AS MIFloat_PriceTender
                                                  ON MIFloat_PriceTender.MovementItemId = MovementItem.Id
                                                 AND MIFloat_PriceTender.DescId = zc_MIFloat_PriceTender()
                                                 AND MIFloat_PriceTender.valueData <> 0
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
               )
       AND EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Promo() AND MB.ValueData = TRUE)
    THEN
        RAISE EXCEPTION 'Ошибка. Значение <Цена Тендер> не может быть введено для документа с признаком <Акция>.';
    END IF;

     -- Проверка
     IF EXISTS (SELECT 1
                FROM MovementItem
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                GROUP BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId)
                HAVING MIN (MovementItem.Amount) <> MAX (MovementItem.Amount)
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Для товара <%> <%> введен разный Процент скидки : <%> и <%>.'
                       , lfGet_Object_ValueData(
                         (SELECT MovementItem.ObjectId
                          FROM MovementItem
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                          GROUP BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId)
                          HAVING MIN (MovementItem.Amount) <> MAX (MovementItem.Amount)
                          ORDER BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId)
                          LIMIT 1
                         ))
                       , lfGet_Object_ValueData(
                         (SELECT COALESCE (MILinkObject_GoodsKind.ObjectId)
                          FROM MovementItem
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                          GROUP BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId)
                          HAVING MIN (MovementItem.Amount) <> MAX (MovementItem.Amount)
                          ORDER BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId)
                          LIMIT 1
                         ))
                       , zfConvert_FloatToString(
                         (SELECT MIN (MovementItem.Amount)
                          FROM MovementItem
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                          GROUP BY MovementItem.ObjectId
                          HAVING MIN (MovementItem.Amount) <> MAX (MovementItem.Amount)
                          ORDER BY MovementItem.ObjectId
                          LIMIT 1
                         ))
                       , zfConvert_FloatToString(
                         (SELECT MAX (MovementItem.Amount)
                          FROM MovementItem
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                          GROUP BY MovementItem.ObjectId
                          HAVING MIN (MovementItem.Amount) <> MAX (MovementItem.Amount)
                          ORDER BY MovementItem.ObjectId
                          LIMIT 1
                         ))
               ;
     END IF;

     -- сохранение "новых" контрагентов + по продажам за аналогичный период
     PERFORM lpUpdate_Movement_Promo_Auto (inMovementId := inMovementId
                                         , inUserId     := vbUserId
                                          );

     -- проверка - не должно быть в этом периоде таких же Акций
    CREATE TEMP TABLE _tmpPromo_find ON COMMIT DROP AS
      (WITH tmpPromoPartner AS (SELECT COALESCE (MovementItem.ObjectId, 0)          AS PartnerId
                                     , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId
                                FROM Movement
                                     INNER JOIN MovementItem
                                             ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                                      ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                WHERE Movement.ParentId = inMovementId
                               )
            , tmpPromoGoods AS (SELECT DISTINCT MovementItem.ObjectId AS GoodsId
                                FROM MovementItem
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased   = FALSE
                               )
       -- Результат
       SELECT Movement.Id AS MovementId, Movement.InvNumber, Movement.OperDate
            , MovementDate_StartSale.ValueData AS StartSale, MovementDate_EndSale.ValueData AS EndSale
            , MI_PromoGoods.ObjectId   AS GoodsId
            , MI_PromoPartner.ObjectId AS PartnerId
       FROM Movement
            INNER JOIN MovementDate AS MovementDate_StartSale
                                    ON MovementDate_StartSale.MovementId = Movement.Id
                                   AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
            INNER JOIN MovementDate AS MovementDate_EndSale
                                    ON MovementDate_EndSale.MovementId = Movement.Id
                                   AND MovementDate_EndSale.DescId     = zc_MovementDate_EndSale()
            INNER JOIN Movement AS Movement_PromoPartner ON Movement_PromoPartner.ParentId = Movement.Id
                                                        AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
            INNER JOIN MovementItem AS MI_PromoGoods
                                    ON MI_PromoGoods.MovementId = Movement.Id
                                   AND MI_PromoGoods.DescId     = zc_MI_Master()
                                   AND MI_PromoGoods.isErased   = FALSE
            -- Товары
            INNER JOIN tmpPromoGoods ON tmpPromoGoods.GoodsId = MI_PromoGoods.ObjectId

            INNER JOIN MovementItem AS MI_PromoPartner
                                    ON MI_PromoPartner.MovementId = Movement_PromoPartner.Id
                                   AND MI_PromoPartner.DescId     = zc_MI_Master()
                                   AND MI_PromoPartner.isErased   = FALSE
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MI_PromoPartner.Id
                                            AND MILinkObject_Contract.DescId         = zc_MILinkObject_Contract()
            -- Контрагенты
            INNER JOIN tmpPromoPartner ON tmpPromoPartner.PartnerId  = MI_PromoPartner.ObjectId
                                      AND (tmpPromoPartner.ContractId = COALESCE (MILinkObject_Contract.ObjectId, 0)
                                        OR tmpPromoPartner.ContractId = 0
                                        OR COALESCE (MILinkObject_Contract.ObjectId, 0) = 0
                                          )

       WHERE Movement.DescId   = zc_Movement_Promo()
         AND Movement.StatusId = zc_Enum_Status_Complete()
       AND (vbStartSale BETWEEN MovementDate_StartSale.ValueData AND MovementDate_EndSale.ValueData
         OR vbEndSale   BETWEEN MovementDate_StartSale.ValueData AND MovementDate_EndSale.ValueData
           )
      );

     -- проверка - не должно быть в этом периоде таких же Акций
     IF EXISTS (SELECT 1 FROM _tmpPromo_find WHERE _tmpPromo_find.MovementId <> inMovementId)
     THEN
         RAISE EXCEPTION 'Ошибка.Невозможно дублирование Акций.%Найдена Акция № <%> от <%>%период проведения с <%> по <%>%для <%> % %.'
                        , CHR (13)
                        , (SELECT _tmpPromo_find.InvNumber FROM _tmpPromo_find WHERE _tmpPromo_find.MovementId <> inMovementId ORDER BY _tmpPromo_find.MovementId LIMIT 1)
                        , (SELECT zfConvert_DateToString (_tmpPromo_find.OperDate) FROM _tmpPromo_find WHERE _tmpPromo_find.MovementId <> inMovementId ORDER BY _tmpPromo_find.MovementId LIMIT 1)
                        , CHR (13)
                        , (SELECT zfConvert_DateToString (_tmpPromo_find.StartSale) FROM _tmpPromo_find WHERE _tmpPromo_find.MovementId <> inMovementId ORDER BY _tmpPromo_find.MovementId LIMIT 1)
                        , (SELECT zfConvert_DateToString (_tmpPromo_find.EndSale)   FROM _tmpPromo_find WHERE _tmpPromo_find.MovementId <> inMovementId ORDER BY _tmpPromo_find.MovementId LIMIT 1)
                        , CHR (13)
                        , (SELECT lfGet_Object_ValueData (_tmpPromo_find.GoodsId) FROM _tmpPromo_find WHERE _tmpPromo_find.MovementId <> inMovementId ORDER BY _tmpPromo_find.MovementId LIMIT 1)
                        , CHR (13)
                        , (SELECT lfGet_Object_ValueData_sh (_tmpPromo_find.PartnerId) FROM _tmpPromo_find WHERE _tmpPromo_find.MovementId <> inMovementId ORDER BY _tmpPromo_find.MovementId LIMIT 1)
                         ;
     END IF;


     -- проводим Документ + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Promo()
                                , inUserId     := vbUserId
                                 );

     if vbUserId = 5 AND 1=1 then RAISE EXCEPTION 'Нет Прав - что б ничего не делать'; end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 29.11.15                                        * add lpUpdate_Movement_Promo_Auto
 13.10.15                                                         *
 */