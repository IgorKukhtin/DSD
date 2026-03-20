-- Function: gpSelect_Movement_DiscountPrograms_effie

DROP FUNCTION IF EXISTS gpSelect_Movement_DiscountPrograms_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_DiscountPrograms_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (extId                      TVarChar   --Уникальный идентификатор промо акции
             , Name                       TVarChar   --Название промо акции
             , startDate                  TVarChar   --Дата старта промо акции
             , endDate                    TVarChar   --Дата окончания промо акции
             , description                TVarChar   --Описание акции
             , priority                   Integer    --Приоритет промоакции (используется для определения порядка применения скидок по промоакциям и программам скидок)
             , promoActionTypeId          Integer    --"Механика промоакции:
                                                     /* 1 - Купи N штук товаров из списка и получи скидку на эти товары 
                                                        2 - Купи N штук товаров из списка товаров и получи подарок
                                                        3 - Купи N уникальных товаров в количестве M каждого товара и получи подарок
                                                        4 - Купи P единицы измерения (литров\кг) товаров из списка товаров и получи подарок
                                                        5 - Купи товары из списка на сумму N+ и получи товар в подарок
                                                        6 - Купи N уникальных товаров в количестве M в каждой группе товаров (количество групп > 1) и получи подарок"
                                                     */
             , totalQnt                   TFloat     --"Количество для срабатывания акции (логика работы с полями описана для БА здесь Настройка промо-акций )"
             , needBuy                    TFloat     --"Количество уникальных товаров для срабатывания акции (для акций типа 1-4 и 6)
             , giftChoiseAbility          Boolean    --Возможность выбора подарка: false = нет / true = да
             , shortName                  TVarChar   --Короткое название (аббревиатура)
             , form                       TVarChar   --Форма заказа для срабатывания (Корректные значения 1, 2 или null)
             , changeNeedOrderToMinValue  Boolean    --Не применять цикличность расчета количества товаров
             , quantityLimitInTt          Boolean    --Лимит на количество срабатываний акции в каждой торговой точке, где доступна эта акция. (По умолчанию null, т.е. лимит отсутствует)
             , isDeleted                  Boolean    -- Признак активности 
) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- временная таблица PriceListItem
     CREATE TEMP TABLE _tmpPromo (MovementId      Integer,
                                  MovementItemId  Integer,
                                  GoodsId         Integer,
                                  GoodsKindId     Integer)  ON COMMIT DROP;
     
     INSERT INTO _tmpPromo (MovementId,
                            MovementItemId,
                            GoodsId,
                            GoodsKindId) 
     
     WITH 
     tmpGoodsByGoodsKind AS (SELECT DISTINCT
                                    ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId                   AS GoodsId
                                  , COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                             FROM Object AS Object_GoodsByGoodsKind
                                  JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                  ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId = Object_GoodsByGoodsKind.Id
                                                 AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                                 AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId > 0

                                  -- Ограничим - есть Вид товара
                                  INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                        ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                       AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                       AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId > 0
                                 --
                                  JOIN ObjectBoolean AS ObjectBoolean_GoodsByGoodsKind_Order
                                                     ON ObjectBoolean_GoodsByGoodsKind_Order.ObjectId  = Object_GoodsByGoodsKind.Id
                                                    AND ObjectBoolean_GoodsByGoodsKind_Order.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                                    AND (ObjectBoolean_GoodsByGoodsKind_Order.ValueData = TRUE -- условие что разрешен
                                                      OR (ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     = 9505524 -- 457 - Сосиски ФІЛЕЙКИ вар 1 ґ ТМ Наші Ковбаси
                                                      AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = 8344    -- Б/В 0,5кг
                                                        ))
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsByGoodsKind_NotMobile
                                                          ON ObjectBoolean_GoodsByGoodsKind_NotMobile.ObjectId  = Object_GoodsByGoodsKind.Id
                                                         AND ObjectBoolean_GoodsByGoodsKind_NotMobile.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_NotMobile()
                                                         AND ObjectBoolean_GoodsByGoodsKind_NotMobile.ValueData = TRUE -- условие что НЕ разрешен

                                  -- Ограничим - если НЕ удален
                                  JOIN Object AS Object_Goods ON Object_Goods.Id       = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                                                             AND Object_Goods.isErased = FALSE
                                  -- Ограничим - если НЕ удален
                                  JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id       = ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId
                                                                 AND Object_GoodsKind.isErased = FALSE
                                  -- Ограничим - ТОЛЬКО если ГП
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                       ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                                                      AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                  -- ограничили
                                  INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                  AND Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                                                                                     , zc_Enum_InfoMoneyDestination_21000() -- Общефирменные + Чапли
                                                                                                                     , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                                      )
                             WHERE Object_GoodsByGoodsKind.DescId = zc_Object_GoodsByGoodsKind()
                               AND Object_GoodsByGoodsKind.isErased = FALSE
                               AND ObjectBoolean_GoodsByGoodsKind_NotMobile.ObjectId IS NULL
                            )

   , tmpMovement AS (SELECT Movement_Promo.*
                          , MovementDate_StartSale.ValueData            AS StartSale
                          , MovementDate_EndSale.ValueData              AS EndSale
                     FROM Movement AS Movement_Promo
                          INNER JOIN MovementDate AS MovementDate_StartSale
                                                  ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                                 AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                          INNER JOIN MovementDate AS MovementDate_EndSale
                                                  ON MovementDate_EndSale.MovementId = Movement_Promo.Id
                                                 AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()

                     WHERE Movement_Promo.DescId = zc_Movement_Promo()
                       AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                       AND (MovementDate_StartSale.ValueData <= CURRENT_DATE
                            AND MovementDate_EndSale.ValueData >= CURRENT_DATE
                           )
                    ) 

   , tmpMI AS (SELECT MovementItem.* 
               FROM MovementItem
               WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                 AND MovementItem.DescId = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
               )
   , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                           FROM MovementItemLinkObject
                           WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                             AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                          )

    -- все данные по Акциям + виды товара
    SELECT tmpMI.MovementId  AS MovementId
         , tmpMI.Id          AS MovementItemId
         , tmpMI.ObjectId    AS GoodsId
         , COALESCE (MILinkObject_GoodsKind.ObjectId, tmpGoodsByGoodsKind.GoodsKindId) AS GoodsKindId
         , CURRENT_TIMESTAMP AS InsertDate
    FROM tmpMI
         LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                     ON MILinkObject_GoodsKind.MovementItemId = tmpMI.Id
                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
         LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = tmpMI.ObjectId
                                      AND COALESCE (MILinkObject_GoodsKind.ObjectId,0) = 0
    ;
    
     /* Код	Название	Название функции
1	Скидка в грн для цены с НДС	zc_Enum_PromoDiscountKind_Summ
2	Скидка в % для цены без НДС	zc_Enum_PromoDiscountKind_Tax                                  
       */
     
     --нужно записать в таблицу Object_Promo_effie  те элементы , которых нет - ключ MovementItemId, GoodsKindId 
     INSERT INTO Movement_DiscountPrograms_effie (MovementId, MovementItemId, GoodsId, GoodsKindId, InsertDate)
     SELECT DISTINCT
            _tmpPromo.MovementId
          , _tmpPromo.MovementItemId
          , _tmpPromo.GoodsId
          , _tmpPromo.GoodsKindId
          , CURRENT_TIMESTAMP AS InsertDate
      FROM _tmpPromo
           LEFT JOIN Object_Promo_effie ON Object_Promo_effie.MovementItemId = _tmpPromo.MovementItemId
                                       AND Object_Promo_effie.GoodsKindId = _tmpPromo.GoodsKindId
     WHERE Object_Promo_effie.Id IS NULL;


     -- Результат
     RETURN QUERY
     --
     SELECT Object_Promo_effie.Id                ::TVarChar AS extId
          , ''                                   ::TVarChar AS Name
          , MovementDate_StartPromo.ValueData    ::TVarChar AS startDate
          , MovementDate_EndPromo.ValueData      ::TVarChar AS endDate
          , Object_PromoDiscountKind.ValueData   ::TVarChar AS description
          , 0                                    ::Integer  AS priority
          , 0                                    ::Integer  AS promoActionTypeId
          , MIFloat_Value_m.ValueData            ::TFloat   AS totalQnt
          , MIFloat_Value_n.ValueData            ::TFloat   AS needBuy
          , FALSE                                ::Boolean  AS giftChoiseAbility
          , ''                                   ::TVarChar AS shortName
          , ''                                   ::TVarChar AS form
          , FALSE                                ::Boolean  AS changeNeedOrderToMinValue
          , NULL                                 ::Boolean  AS quantityLimitInTt
          , FALSE                                ::Boolean  AS isDeleted
     FROM Object_Promo_effie
          LEFT JOIN MovementDate AS MovementDate_StartPromo
                                 ON MovementDate_StartPromo.MovementId = Object_Promo_effie.MovementId
                                AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
          LEFT JOIN MovementDate AS MovementDate_EndPromo
                                 ON MovementDate_EndPromo.MovementId = Object_Promo_effie.MovementId
                                AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

          LEFT JOIN MovementItemLinkObject AS MILinkObject_PromoDiscountKind
                                           ON MILinkObject_PromoDiscountKind.MovementItemId = Object_Promo_effie.MovementItemId
                                          AND MILinkObject_PromoDiscountKind.DescId = zc_MILinkObject_PromoDiscountKind()
          LEFT JOIN Object AS Object_PromoDiscountKind ON Object_PromoDiscountKind.Id = COALESCE (MILinkObject_PromoDiscountKind.ObjectId, zc_Enum_PromoDiscountKind_Tax())
             
          LEFT JOIN MovementItemFloat AS MIFloat_Value_m
                                      ON MIFloat_Value_m.MovementItemId = Object_Promo_effie.MovementItemId
                                     AND MIFloat_Value_m.DescId = zc_MIFloat_Value_m()

          LEFT JOIN MovementItemFloat AS MIFloat_Value_n
                                      ON MIFloat_Value_n.MovementItemId = Object_Promo_effie.MovementItemId
                                     AND MIFloat_Value_n.DescId = zc_MIFloat_Value_n()
          
 --limit 200
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_DiscountPrograms_effie (zfCalc_UserAdmin()::TVarChar);
