-- Function: gpSelect_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderExternal (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderExternal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inPriceListId Integer      , -- ключ Прайс листа
    IN inOperDate    TDateTime    , -- Дата документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, LineNum Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , AmountRemains TFloat, Amount TFloat, AmountEDI TFloat, AmountSecond TFloat
             , GoodsKindId Integer, GoodsKindName  TVarChar, MeasureName TVarChar
             , Price TFloat, PriceEDI TFloat, CountForPrice TFloat, AmountSumm TFloat, AmountSumm_Partner TFloat, ChangePercent TFloat
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , ArticleGLN TVarChar
             , MovementPromo TVarChar, PricePromo Numeric (16,8)
             , isErased Boolean
             , isPriceEDIDiff Boolean
             , StartBegin TDateTime, EndBegin TDateTime, diffBegin_sec TFloat
             , AmountWeight_child_one  TFloat
             , AmountWeightSecond_child_sec  TFloat                                                   
             , AmountWeight_child TFloat
             , AmountWeightDiff_child TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbIsOrderDnepr Boolean;

   DECLARE vbPartnerId Integer;
   DECLARE vbContractId Integer;
   DECLARE vbChangePercent TFloat;
   DECLARE vbPriceWithVAT Boolean;
   DECLARE vbOperDate_promo TDateTime;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- меняется параметр
     -- !!!замена!!!
     SELECT tmp.PriceListId, tmp.OperDate
            INTO inPriceListId, inOperDate
     FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                               , inPartnerId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                               , inMovementDescId := zc_Movement_Sale() -- !!!не ошибка!!!
                                               , inOperDate_order := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
                                               , inOperDatePartner:= NULL
                                               , inDayPrior_PriceReturn:= 0 -- !!!параметр здесь не важен!!!
                                               , inIsPrior        := FALSE -- !!!параметр здесь не важен!!!
                                               , inOperDatePartner_order:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                ) AS tmp;


     -- Контрагент
     vbPartnerId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From());
     -- Договор
     vbContractId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract());
     -- (-)% Скидки (+)% Наценки
     vbChangePercent:= (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_ChangePercent());
     -- Цены с НДС
     vbPriceWithVAT:= (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT());
     -- Дата для поиска акций - или <Дата покупателя в продаже> или <Дата заявки>
     vbOperDate_promo:= CASE WHEN TRUE = (SELECT ObjectBoolean_OperDateOrder.ValueData
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
                        END;

     -- определяется
     vbGoodsPropertyId:= zfCalc_GoodsPropertyId ((SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_Contract())
                                               , (SELECT ObjectLink_Partner_Juridical.ChildObjectId FROM MovementLinkObject LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject.ObjectId AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical() WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_From())
                                               , (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_From())
                                                );

     -- определяется
     vbUnitId:= (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject INNER JOIN Object ON Object.Id = MovementLinkObject.ObjectId AND Object.DescId = zc_Object_Unit() WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_From());
     IF COALESCE (vbUnitId, 0) = 0
     THEN
         vbUnitId:= (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_To());
     END IF;

     -- определяется
     vbIsOrderDnepr:= EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (402720)) -- Заявки-Днепр
                  AND EXISTS (SELECT Object.Id FROM Object WHERE Object.Id = vbUnitId AND Object.ObjectCode >= 30000);



     -- Результат
     IF inShowAll THEN

     -- Результат такой
     RETURN QUERY
      WITH -- Акции по товарам на дату
           tmpPromo AS (SELECT tmp.*
                        FROM lpSelect_Movement_Promo_Data (inOperDate   := vbOperDate_promo
                                                         , inPartnerId  := vbPartnerId
                                                         , inContractId := vbContractId
                                                         , inUnitId     := vbUnitId
                                                          ) AS tmp
                       )
            -- Цены из прайса
          , tmpPriceList AS (SELECT lfSelect.GoodsId     AS GoodsId
                                  , lfSelect.GoodsKindId AS GoodsKindId
                                  , lfSelect.ValuePrice  AS Price_PriceList
                             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId, inOperDate:= inOperDate) AS lfSelect 
                            )
           -- Ограничение - какие товары показать
         , tmpInfoMoney AS (SELECT View_InfoMoney.InfoMoneyGroupId
                                 , View_InfoMoney.InfoMoneyDestinationId
                                 , View_InfoMoney.InfoMoneyId
                            FROM (SELECT View_InfoMoney.InfoMoneyGroupId
                                       , View_InfoMoney.InfoMoneyDestinationId
                                       , View_InfoMoney.InfoMoneyId
                                  FROM MovementLinkObject AS MLO_Contract
                                       INNER JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                             ON ObjectLink_Contract_InfoMoney.ObjectId = MLO_Contract.ObjectId
                                                            AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                                       INNER JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId
                                  WHERE MLO_Contract.MovementId = inMovementId
                                    AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()
                                 ) AS tmpContract
                                 INNER JOIN Object_InfoMoney_View AS View_InfoMoney ON (View_InfoMoney.InfoMoneyDestinationId  IN (zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье + Основное сырье
                                                                                                                                 , zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
                                                                                                                                  )
                                                                                        AND tmpContract.InfoMoneyId = zc_Enum_InfoMoney_30201() -- Доходы + Мясное сырье + Мясное сырье
                                                                                       )
                                                                                    OR ((View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21100() -- Общефирменные + Дворкин
                                                                                         OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_30103() -- Доходы + Продукция + Хлеб
                                                                                        )
                                                                                        AND tmpContract.InfoMoneyId = zc_Enum_InfoMoney_30103() -- Доходы + Продукция + Хлеб
                                                                                       )
                                                                                    OR (View_InfoMoney.InfoMoneyDestinationId  IN (zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                                                                                                 , zc_Enum_InfoMoneyDestination_21000() -- Общефирменные + Чапли
                                                                                                                                 , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                                                 , zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                                                                                                                 , zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
                                                                                                                                  )
                                                                                        AND View_InfoMoney.InfoMoneyId <> zc_Enum_InfoMoney_30103() -- Доходы + Продукция + Хлеб
                                                                                        AND tmpContract.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                                                                                       )
                                                                                    OR (View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700() -- Общефирменные + Товары
                                                                                        AND tmpContract.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30500() -- Доходы + Прочие доходы
                                                                                       )

                           )
            -- Ограничение для ГП - какие товары показать
          , tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                         , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                    FROM ObjectBoolean AS ObjectBoolean_Order
                                         LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                                    WHERE ObjectBoolean_Order.ValueData = TRUE
                                      AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                      -- AND vbIsOrderDnepr = TRUE
                                   )
            -- Существующие MovementItem
          , tmpMI_G AS (SELECT MovementItem.Id
                             , MovementItem.ObjectId   AS GoodsId
                             , MovementItem.Amount     AS Amount
                             , MovementItem.isErased
                        FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                             INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = tmpIsErased.isErased
                        )
          , tmpMI_LO AS (SELECT MovementItemLinkObject.*
                         FROM MovementItemLinkObject
                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                           AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                         )

          , tmpMI_Float AS (SELECT MovementItemFloat.*
                            FROM MovementItemFloat
                            WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                              AND MovementItemFloat.DescId IN (zc_MIFloat_Price()
                                                             , zc_MIFloat_PriceEDI()
                                                             , zc_MIFloat_CountForPrice()
                                                             , zc_MIFloat_AmountSecond()
                                                             , zc_MIFloat_Summ()
                                                             , zc_MIFloat_PromoMovementId()
                                                             , zc_MIFloat_ChangePercent()
                                                             )
                           )

          , tmpMI_Date AS (SELECT MovementItemDate.*
                           FROM MovementItemDate
                           WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                             AND MovementItemDate.DescId IN (zc_MIDate_StartBegin()
                                                           , zc_MIDate_EndBegin()
                                                            )
                           )

          , tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                 , MovementItem.GoodsId                          AS GoodsId
                                 , MovementItem.Amount                           AS Amount
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                                 , COALESCE (MIFloat_PriceEDI.ValueData, 0)      AS PriceEDI
                                 , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                                 , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent
                                 , MIFloat_AmountSecond.ValueData                AS AmountSecond
                                 , MIFloat_Summ.ValueData                        AS Summ
                                 , MIFloat_PromoMovement.ValueData               AS MovementId_Promo
                                 , MIDate_StartBegin.ValueData                   AS StartBegin
                                 , MIDate_EndBegin.ValueData                     AS EndBegin
                                 , EXTRACT (EPOCH FROM (COALESCE (MIDate_EndBegin.ValueData, zc_DateStart()) - COALESCE (MIDate_StartBegin.ValueData, zc_DateStart())) :: INTERVAL) :: TFloat AS diffBegin_sec
                                 , MovementItem.isErased
                            FROM tmpMI_G AS MovementItem
                                 LEFT JOIN tmpMI_LO AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 LEFT JOIN tmpMI_Float AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 LEFT JOIN tmpMI_Float AS MIFloat_PriceEDI
                                                       ON MIFloat_PriceEDI.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PriceEDI.DescId = zc_MIFloat_PriceEDI()

                                 LEFT JOIN tmpMI_Float AS MIFloat_CountForPrice
                                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                 LEFT JOIN tmpMI_Float AS MIFloat_AmountSecond
                                                       ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                 LEFT JOIN tmpMI_Float AS MIFloat_Summ
                                                       ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                 LEFT JOIN tmpMI_Float AS MIFloat_PromoMovement
                                                       ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                 LEFT JOIN tmpMI_Float AS MIFloat_ChangePercent
                                                       ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                      AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                                 LEFT JOIN tmpMI_Date AS MIDate_StartBegin
                                                      ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                                     AND MIDate_StartBegin.DescId         = zc_MIDate_StartBegin()
                                 LEFT JOIN tmpMI_Date AS MIDate_EndBegin
                                                      ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                                     AND MIDate_EndBegin.DescId         = zc_MIDate_EndBegin()
                           )

           -- Связь с акциями для существующих MovementItem
         , tmpMIPromo_all AS (SELECT tmp.MovementId_Promo                          AS MovementId_Promo
                                   , MovementItem.Id                               AS MovementItemId
                                   , MovementItem.ObjectId                         AS GoodsId
                                   , MovementItem.Amount                           AS TaxPromo
                                  
                              FROM (SELECT DISTINCT tmpMI_Goods.MovementId_Promo :: Integer AS MovementId_Promo 
                                    FROM tmpMI_Goods 
                                    WHERE tmpMI_Goods.MovementId_Promo <> 0
                                    ) AS tmp
                                   INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId_Promo
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                             )

         , tmpPromoMI_LO AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMIPromo_all.MovementItemId FROM tmpMIPromo_all)
                               AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                             )

         , tmpPromoMI_Float AS (SELECT MovementItemFloat.*
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIPromo_all.MovementItemId FROM tmpMIPromo_all)
                                  AND MovementItemFloat.DescId = zc_MIFloat_PriceWithOutVAT()
                               )
         , tmpPromoMI_Float2 AS (SELECT MovementItemFloat.*
                                 FROM MovementItemFloat
                                 WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIPromo_all.MovementItemId FROM tmpMIPromo_all)
                                   AND MovementItemFloat.DescId = zc_MIFloat_CountForPrice()
                                )
           -- Акции по товарам для существующих MovementItem
         , tmpMIPromo AS (SELECT DISTINCT 
                                 tmpMIPromo_all.MovementId_Promo
                               , tmpMIPromo_all.GoodsId
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                               , CASE WHEN /*tmpMIPromo_all.TaxPromo <> 0*/ 1=1 THEN MIFloat_PriceWithOutVAT.ValueData / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END ELSE 0 END AS PricePromo
                          FROM tmpMIPromo_all
                               LEFT JOIN tmpPromoMI_LO AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = tmpMIPromo_all.MovementItemId
                               LEFT JOIN tmpPromoMI_Float AS MIFloat_PriceWithOutVAT
                                                          ON MIFloat_PriceWithOutVAT.MovementItemId = tmpMIPromo_all.MovementItemId
                               LEFT JOIN tmpPromoMI_Float2 AS MIFloat_CountForPrice
                                                           ON MIFloat_CountForPrice.MovementItemId = tmpMIPromo_all.MovementItemId
                         )

            -- Остатки
          , tmpRemains AS (SELECT Container.ObjectId                          AS GoodsId
                                , COALESCE (CLO_GoodsKind.ObjectId, 0)        AS GoodsKindId
                                , SUM (Container.Amount)            :: TFloat AS Amount
                           FROM ContainerLinkObject AS CLO_Unit
                                INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count() AND Container.Amount <> 0
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                              ON CLO_GoodsKind.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                           WHERE CLO_Unit.ObjectId = vbUnitId
                             AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                             AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                             AND vbIsOrderDnepr = FALSE
                           GROUP BY Container.ObjectId
                                  , COALESCE (CLO_GoodsKind.ObjectId, 0)
                          )
            -- LEFT JOIN Товаров из заявки - Акции + Остатки
          , tmpMI AS (SELECT COALESCE (tmpMI_Goods.MovementItemId, 0)                   AS MovementItemId
                           , COALESCE (tmpMI_Goods.GoodsId, tmpRemains.GoodsId)         AS GoodsId
                           , COALESCE (tmpMI_Goods.Amount, 0)                           AS Amount
                           , COALESCE (tmpRemains.Amount, 0)                            AS AmountRemains
                           , COALESCE (tmpMI_Goods.GoodsKindId, tmpRemains.GoodsKindId) AS GoodsKindId
                           , COALESCE (tmpMI_Goods.Price, 0)                            AS Price
                           , COALESCE (tmpMI_Goods.PriceEDI, 0)                         AS PriceEDI
                           , COALESCE (tmpMI_Goods.CountForPrice, 1)                    AS CountForPrice
                           , COALESCE (tmpMI_Goods.AmountSecond, 0)                     AS AmountSecond
                           , COALESCE (tmpMI_Goods.Summ, 0)                             AS Summ
                           , COALESCE (tmpMI_Goods.ChangePercent, 0)                    AS ChangePercent

                           , COALESCE (tmpMI_Goods.MovementId_Promo, 0)                 AS MovementId_Promo
                           , COALESCE (tmpMIPromo.PricePromo, 0)                        AS PricePromo

                           , COALESCE (tmpMI_Goods.StartBegin, NULL)    :: TDateTime    AS StartBegin
                           , COALESCE (tmpMI_Goods.EndBegin, NULL)      :: TDateTime    AS EndBegin
                           , COALESCE (tmpMI_Goods.diffBegin_sec, 0)    :: TFloat       AS diffBegin_sec
                           , COALESCE (tmpMI_Goods.isErased, FALSE)                     AS isErased 
                           --
                           , ((COALESCE (tmpMI_Goods.Amount, 0) + COALESCE (tmpMI_Goods.AmountSecond, 0)) 
                             *  CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight_all
                       FROM tmpMI_Goods
                            LEFT JOIN tmpMIPromo ON tmpMIPromo.MovementId_Promo = tmpMI_Goods.MovementId_Promo
                                                AND tmpMIPromo.GoodsId          = tmpMI_Goods.GoodsId
                                                AND (tmpMIPromo.GoodsKindId     = tmpMI_Goods.GoodsKindId
                                                  OR tmpMIPromo.GoodsKindId     = 0)
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI_Goods.GoodsId
                                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                            LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                                 ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_Goods.GoodsId
                                                AND tmpRemains.GoodsKindId = CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                                                                  , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                                                  , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                                                   )
                                                                                       THEN tmpMI_Goods.GoodsKindId
                                                                                  WHEN ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье                                                                                       THEN tmpMI_Goods.GoodsKindId
                                                                                       THEN tmpMI_Goods.GoodsKindId
                                                                                  ELSE 0
                                                                             END 

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = COALESCE (tmpMI_Goods.GoodsId, tmpRemains.GoodsId)
                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                  ON ObjectFloat_Weight.ObjectId = COALESCE (tmpMI_Goods.GoodsId, tmpRemains.GoodsId)
                                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                     )
            -- Товары из EDI
          , tmpMI_EDI_All AS (SELECT MovementItem.Id
                                   , MovementItem.ObjectId   AS GoodsId
                                   , MovementItem.Amount     AS Amount
                              FROM (SELECT MovementLinkMovement_Order.MovementChildId AS MovementId
                                    FROM MovementLinkMovement AS MovementLinkMovement_Order
                                    WHERE MovementLinkMovement_Order.MovementId = inMovementId
                                      AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                   ) AS tmpMovement
                                   INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = FALSE
                             )
          , tmpEDIMI_LO AS (SELECT MovementItemLinkObject.*
                            FROM MovementItemLinkObject
                            WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_EDI_All.Id FROM tmpMI_EDI_All)
                              AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                            )
  
          , tmpEDIMI_Float AS (SELECT MovementItemFloat.*
                               FROM MovementItemFloat
                               WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_EDI_All.Id FROM tmpMI_EDI_All)
                                 AND MovementItemFloat.DescId IN (zc_MIFloat_Price(), zc_MIFloat_CountForPrice())
                              )
          , tmpMI_EDI AS (SELECT MovementItem.GoodsId                         AS GoodsId
                               , SUM (MovementItem.Amount)                     AS Amount
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                               , COALESCE (MIFloat_Price.ValueData, 0)         AS PriceEDI
                               , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                          FROM tmpMI_EDI_All AS MovementItem
                               LEFT JOIN tmpEDIMI_LO AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                               LEFT JOIN tmpEDIMI_Float AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                               LEFT JOIN tmpEDIMI_Float AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                          GROUP BY MovementItem.GoodsId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                 , COALESCE (MIFloat_Price.ValueData, 0)
                                 , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                         )

          , tmpPriceList_EDI AS (-- цены из прайса напрямую, (т.к. теперь в EDI.zc_MIFloat_Price - хранится "их" цена
                                 SELECT DISTINCT
                                        tmpMI_EDI.GoodsId
                                      , ObjectLink_PriceListItem_GoodsKind.ChildObjectId               AS GoodsKindId
                                      , COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) AS PriceListPrice
                                 FROM tmpMI_EDI
                                      INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                            ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmpMI_EDI.GoodsId
                                                           AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                                      INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                            ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                           AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                                                           AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()

                                      LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                           ON ObjectLink_PriceListItem_GoodsKind.ObjectId      = ObjectLink_PriceListItem_PriceList.ObjectId
                                                          AND ObjectLink_PriceListItem_GoodsKind.DescId        = zc_ObjectLink_PriceListItem_GoodsKind()

                                      LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                              ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                             AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                             AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
                                      LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                                   ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                                  AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                )
            -- поиск для Товаров из EDI - MovementItemId из заявки
          , tmpMI_EDI_find AS (SELECT tmpMI_EDI.GoodsId
                                    , tmpMI_EDI.Amount
                                    , tmpMI_EDI.GoodsKindId
                                    , tmpMI_EDI.PriceEDI
                                    , COALESCE (tmpPriceList_EDI_Kind.PriceListPrice, tmpPriceList_EDI.PriceListPrice) AS PriceListPrice
                                    , tmpMI_EDI.CountForPrice
                                    , COALESCE (tmpMI.MovementItemId, 0) AS MovementItemId
                               FROM tmpMI_EDI
                                    -- привязываем цены 2 раза с видом товара и без
                                    LEFT JOIN tmpPriceList_EDI AS tmpPriceList_EDI_Kind
                                                               ON tmpPriceList_EDI_Kind.GoodsId                   = tmpMI_EDI.GoodsId
                                                              AND COALESCE (tmpPriceList_EDI_Kind.GoodsKindId, 0) = COALESCE (tmpMI_EDI.GoodsKindId, 0)
                                    LEFT JOIN tmpPriceList_EDI ON tmpPriceList_EDI.GoodsId     = tmpMI_EDI.GoodsId
                                                              AND tmpPriceList_EDI.GoodsKindId IS NULL


                                    LEFT JOIN (SELECT MAX (tmpMI.MovementItemId) AS MovementItemId
                                                    , tmpMI.GoodsId
                                                    , tmpMI.GoodsKindId
                                                    -- , tmpMI.Price
                                               FROM tmpMI
                                               WHERE tmpMI.isErased = FALSE
                                               GROUP BY tmpMI.GoodsId
                                                      , tmpMI.GoodsKindId
                                                      -- , tmpMI.Price
                                              ) AS tmpMI ON tmpMI.GoodsId     = tmpMI_EDI.GoodsId
                                                        AND tmpMI.GoodsKindId = tmpMI_EDI.GoodsKindId
                                                        -- AND tmpMI.Price       = tmpMI_EDI.Price
                              )
            -- FULL JOIN Товаров EDI - MovementItemId из заявки
          , tmpMI_all AS (SELECT tmpMI.MovementItemId
                               , COALESCE (tmpMI.GoodsId, tmpMI_EDI_find.GoodsId) AS GoodsId
                               , tmpMI.AmountRemains               AS AmountRemains
                               , tmpMI.Amount                      AS Amount
                               , COALESCE (tmpMI.AmountSecond, 0)  AS AmountSecond
                               , COALESCE (tmpMI.AmountWeight_all,0)   AS AmountWeight_all
                               , COALESCE (tmpMI.Summ, 0)          AS Summ
                               , tmpMI_EDI_find.Amount             AS AmountEDI
                               , COALESCE (tmpMI.GoodsKindId, tmpMI_EDI_find.GoodsKindId)     AS GoodsKindId
                               , COALESCE (tmpMI.Price, tmpMI_EDI_find.PriceListPrice)        AS Price
                               , COALESCE (tmpMI.PriceEDI, tmpMI_EDI_find.PriceEDI)           AS PriceEDI
                               , COALESCE (tmpMI.CountForPrice, tmpMI_EDI_find.CountForPrice) AS CountForPrice

                               , tmpMI.ChangePercent                                          AS ChangePercent
                               , tmpMI.MovementId_Promo                                       AS MovementId_Promo
                               , tmpMI.PricePromo                                             AS PricePromo

                               , tmpMI.StartBegin                  AS StartBegin
                               , tmpMI.EndBegin                    AS EndBegin
                               , tmpMI.diffBegin_sec               AS diffBegin_sec
                           
                               , COALESCE (tmpMI.isErased, FALSE)  AS isErased
                          FROM tmpMI
                               FULL JOIN tmpMI_EDI_find ON tmpMI_EDI_find.MovementItemId = tmpMI.MovementItemId
                         )
            -- Артикул GLN
          , tmpGoodsPropertyValue AS (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                                           , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                           , ObjectString_ArticleGLN.ValueData                                   AS ArticleGLN
                                      FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                                           ) AS tmpGoodsProperty
                                           INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                 ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                           LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                                                  ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                               AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                               AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                      WHERE ObjectString_ArticleGLN.ValueData <> ''
                                     )
          , tmpGoods AS (SELECT Object_Goods.Id                                        AS GoodsId
                              , Object_Goods.ObjectCode                                AS GoodsCode
                              , Object_Goods.ValueData                                 AS GoodsName
                              -- , zc_Enum_GoodsKind_Main()  AS GoodsKindId
                              -- , COALESCE (tmpGoodsByGoodsKind.GoodsKindId, COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0)) AS GoodsKindId
                              , COALESCE (tmpGoodsByGoodsKind.GoodsKindId, 0)          AS GoodsKindId
                              , ObjectString_Goods_GoodsGroupFull.ValueData            AS GoodsGroupNameFull
                              , tmpInfoMoney.InfoMoneyId
                              , tmpInfoMoney.InfoMoneyDestinationId
                         FROM tmpInfoMoney
                              JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                              ON ObjectLink_Goods_InfoMoney.ChildObjectId = tmpInfoMoney.InfoMoneyId
                                             AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                              JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                                         AND Object_Goods.isErased = FALSE
                              LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = Object_Goods.Id
                                                           /*AND (tmpInfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                          , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                          , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                           )
                                                             OR tmpInfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье + Основное сырье
                                                                                                       )
                                                               )*/
                                                           /*AND vbIsOrderDnepr = TRUE
                              LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                                    AND tmpInfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция + Доходы Мясное сырье
                                                                    AND vbIsOrderDnepr = FALSE*/

                              LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                     ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                                    AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                         WHERE tmpGoodsByGoodsKind.GoodsId > 0 -- OR vbIsOrderDnepr = FALSE
                            /*OR (tmpInfoMoney.InfoMoneyId NOT IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                               , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                               , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                )
                            AND tmpInfoMoney.InfoMoneyDestinationId NOT IN (zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье + Основное сырье
                                                                           )
                               )*/
                        )

          , tmpMI_Child AS (SELECT MovementItem.ParentId
                                 , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN MovementItem.Amount ELSE 0 END * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight
                                 , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 THEN MovementItem.Amount ELSE 0 END * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeightSecond
                                 , SUM (MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight_all
                            FROM MovementItem
                                 LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                             ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()  

                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                      ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                     AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                       ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                      AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Child()
                              AND MovementItem.isErased   = FALSE
                            GROUP BY MovementItem.ParentId
                           )
             
       SELECT
             0 :: Integer               AS Id
           , 0 :: Integer               AS LineNum
           , tmpGoods.GoodsId           AS GoodsId
           , tmpGoods.GoodsCode         AS GoodsCode
           , tmpGoods.GoodsName         AS GoodsName
           , tmpGoods.GoodsGroupNameFull

           , tmpRemains.Amount          AS AmountRemains
           , 0 :: TFloat                AS Amount
           , 0 :: TFloat                AS AmountEDI
           , 0 :: TFloat                AS AmountSecond
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , Object_Measure.ValueData   AS MeasureName
           , CASE WHEN /*tmpPromo.TaxPromo <> 0 AND*/ tmpPromo.GoodsId > 0 AND vbPriceWithVAT = TRUE THEN tmpPromo.PriceWithVAT
                  WHEN /*tmpPromo.TaxPromo <> 0*/ tmpPromo.GoodsId > 0 THEN tmpPromo.PriceWithOutVAT
                  ELSE COALESCE (tmpPriceList_Kind.Price_Pricelist, tmpPriceList.Price_Pricelist)
             END :: TFloat              AS Price
           , 0 :: TFloat                AS PriceEDI
           , 1 :: TFloat                AS CountForPrice
           , NULL :: TFloat             AS AmountSumm
           , NULL :: TFloat             AS AmountSumm_Partner
           , CASE WHEN COALESCE (tmpPromo.isChangePercent, TRUE) = TRUE THEN vbChangePercent ELSE 0 END :: TFloat AS ChangePercent

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , tmpGoodsPropertyValue.ArticleGLN

           , tmpPromo.MovementPromo
           , CAST (CASE WHEN /*tmpPromo.TaxPromo <> 0 AND*/ tmpPromo.GoodsId > 0 AND vbPriceWithVAT = TRUE THEN tmpPromo.PriceWithVAT_orig / tmpPromo.CountForPrice
                        WHEN /*tmpPromo.TaxPromo <> 0*/ tmpPromo.GoodsId > 0 THEN tmpPromo.PriceWithOutVAT_orig / tmpPromo.CountForPrice
                        ELSE 0
                   END AS Numeric (16,8)) AS PricePromo

           , FALSE AS isErased
           , FALSE AS isPriceEDIDiff
           
           , NULL                 :: TDateTime  AS StartBegin
           , NULL                 :: TDateTime  AS EndBegin
           , 0                    :: TFloat     AS diffBegin_sec

           , 0                    ::TFloat AS AmountWeight_child_one
           , 0                    ::TFloat AS AmountWeightSecond_child_sec
           , 0                    ::TFloat AS AmountWeight
           , 0                    ::TFloat AS AmountWeightDiff_child

       FROM tmpGoods

            LEFT JOIN tmpRemains ON tmpRemains.GoodsId     = tmpGoods.GoodsId
                                AND tmpRemains.GoodsKindId = CASE WHEN tmpGoods.InfoMoneyId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                              , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                              , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                               )
                                                                       THEN tmpGoods.GoodsKindId
                                                                  WHEN tmpGoods.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                                                       THEN tmpGoods.GoodsKindId
                                                                  ELSE 0
                                                             END
            LEFT JOIN tmpMI_all AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                                        AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId

            -- привязываем 2 раза по виду товара и без
            LEFT JOIN tmpPriceList AS tmpPriceList_Kind 
                                   ON tmpPriceList_Kind.GoodsId                   = tmpGoods.GoodsId
                                  AND COALESCE (tmpPriceList_Kind.GoodsKindId, 0) = COALESCE (tmpGoods.GoodsKindId, 0)
            LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId     = tmpGoods.GoodsId
                                  AND tmpPriceList.GoodsKindId IS NULL

            LEFT JOIN tmpPromo ON tmpPromo.GoodsId      = tmpGoods.GoodsId
                              AND (tmpPromo.GoodsKindId = tmpGoods.GoodsKindId OR tmpPromo.GoodsKindId = 0)

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN tmpGoodsPropertyValue ON tmpGoodsPropertyValue.GoodsId     = tmpGoods.GoodsId
                                           AND tmpGoodsPropertyValue.GoodsKindId = tmpGoods.GoodsKindId
                                  
       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             tmpMI.MovementItemId :: Integer    AS Id
           , CAST (row_number() OVER (ORDER BY tmpMI.MovementItemId) AS Integer) AS LineNum
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI.AmountRemains :: TFloat      AS AmountRemains
           , tmpMI.Amount :: TFloat             AS Amount
           , tmpMI.AmountEDI :: TFloat          AS AmountEDI
           , tmpMI.AmountSecond :: TFloat       AS AmountSecond
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName
           , tmpMI.Price :: TFloat              AS Price
           , tmpMI.PriceEDI :: TFloat           AS PriceEDI
           , tmpMI.CountForPrice :: TFloat      AS CountForPrice
           , CAST ((tmpMI.Amount + tmpMI.AmountSecond) * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2)) :: TFloat AS AmountSumm
           , tmpMI.Summ               :: TFloat AS AmountSumm_Partner
           , tmpMI.ChangePercent      :: TFloat AS ChangePercent

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , tmpGoodsPropertyValue.ArticleGLN
           
           , (CASE WHEN (tmpPromo.isChangePercent = TRUE  AND tmpMI.ChangePercent <> vbChangePercent)
                     OR (tmpPromo.isChangePercent = FALSE AND tmpMI.ChangePercent <> 0)
                        THEN 'ОШИБКА <(-)% Скидки (+)% Наценки>'
                   ELSE ''
              END
           || CASE WHEN tmpMI.MovementId_Promo = tmpPromo.MovementId
                       THEN tmpPromo.MovementPromo
                  WHEN tmpMI.MovementId_Promo <> COALESCE (tmpPromo.MovementId, 0) AND tmpMI.MovementId_Promo <> 0
                       THEN 'ОШИБКА ' || zfCalc_PromoMovementName (NULL, Movement_Promo_View.InvNumber :: TVarChar, Movement_Promo_View.OperDate, Movement_Promo_View.StartSale, Movement_Promo_View.EndSale)
                  WHEN COALESCE (tmpMI.MovementId_Promo, 0) <> tmpPromo.MovementId
                       THEN 'ОШИБКА ' || tmpPromo.MovementPromo 
                  ELSE ''
              END) :: TVarChar AS MovementPromo

           , CAST (CASE WHEN 1 = 0 AND tmpMI.PricePromo <> 0 THEN tmpMI.PricePromo
                        WHEN /*tmpPromo.TaxPromo <> 0 AND*/ tmpPromo.GoodsId > 0 AND vbPriceWithVAT = TRUE THEN tmpPromo.PriceWithVAT_orig / tmpPromo.CountForPrice
                        WHEN /*tmpPromo.TaxPromo <> 0*/ tmpPromo.GoodsId > 0 THEN tmpPromo.PriceWithOutVAT_orig / tmpPromo.CountForPrice
                        ELSE 0
                   END AS Numeric (16,8)) AS PricePromo

           , tmpMI.isErased

           , CASE WHEN tmpMI.PriceEDI > 0 
                       THEN CASE WHEN 100 * ABS (tmpMI.Price * (1 + tmpMI.ChangePercent / 100) - tmpMI.PriceEDI) / tmpMI.PriceEDI >= 1 THEN TRUE ELSE FALSE END
                  ELSE FALSE
             END ::Boolean AS isPriceEDIDiff

           , tmpMI.StartBegin                  AS StartBegin
           , tmpMI.EndBegin                    AS EndBegin
           , tmpMI.diffBegin_sec               AS diffBegin_sec
           
           , tmpMI_Child.AmountWeight       ::TFloat AS AmountWeight_child_one
           , tmpMI_Child.AmountWeightSecond ::TFloat AS AmountWeightSecond_child_sec                                                    
           , COALESCE (tmpMI_Child.AmountWeight_all, 0) ::TFloat AS AmountWeight_child
           , (COALESCE (tmpMI_Child.AmountWeight_all, 0) - COALESCE (tmpMI.AmountWeight_all,0) )  ::TFloat AS AmountWeightDiff_child
       FROM tmpMI_all AS tmpMI
            LEFT JOIN tmpPromo ON tmpPromo.GoodsId      = tmpMI.GoodsId
                              AND (tmpPromo.GoodsKindId = tmpMI.GoodsKindId OR tmpPromo.GoodsKindId = 0)

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
            LEFT JOIN tmpGoodsPropertyValue ON tmpGoodsPropertyValue.GoodsId     = tmpMI.GoodsId
                                           AND tmpGoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN Movement_Promo_View ON Movement_Promo_View.Id = tmpMI.MovementId_Promo
            
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.MovementItemId
           ;

     ELSE

     -- Результат другой
     RETURN QUERY
      WITH -- Акции по товарам на дату
           tmpPromo AS (SELECT tmp.*
                        FROM lpSelect_Movement_Promo_Data (inOperDate   := vbOperDate_promo
                                                         , inPartnerId  := vbPartnerId
                                                         , inContractId := vbContractId
                                                         , inUnitId     := vbUnitId
                                                          ) AS tmp
                       )
            -- Существующие MovementItem
          , tmpMI_G AS (SELECT MovementItem.Id
                             , MovementItem.ObjectId   AS GoodsId
                             , MovementItem.Amount     AS Amount
                             , MovementItem.isErased
                        FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                             INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = tmpIsErased.isErased
                        )
          , tmpMI_LO AS (SELECT MovementItemLinkObject.*
                         FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                              INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = tmpIsErased.isErased
                              LEFT JOIN MovementItemLinkObject
                                     ON MovementItemLinkObject.MovementItemId = MovementItem.Id
                                    AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                        )

          , tmpMI_Float AS (SELECT MovementItemFloat.*
                            FROM MovementItemFloat
                            WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                              AND MovementItemFloat.DescId IN (zc_MIFloat_Price()
                                                             , zc_MIFloat_PriceEDI()
                                                             , zc_MIFloat_CountForPrice()
                                                             , zc_MIFloat_AmountSecond()
                                                             , zc_MIFloat_Summ()
                                                             , zc_MIFloat_PromoMovementId()
                                                             , zc_MIFloat_ChangePercent()
                                                             )
                           )

          , tmpMI_Date AS (SELECT MovementItemDate.*
                           FROM MovementItemDate
                           WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                             AND MovementItemDate.DescId IN (zc_MIDate_StartBegin()
                                                           , zc_MIDate_EndBegin()
                                                            )
                           )

          , tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                 , MovementItem.GoodsId                          AS GoodsId
                                 , MovementItem.Amount                           AS Amount
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                                 , COALESCE (MIFloat_PriceEDI.ValueData, 0)      AS PriceEDI
                                 , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                                 , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent
                                 , MIFloat_AmountSecond.ValueData                AS AmountSecond
                                 , MIFloat_Summ.ValueData                        AS Summ
                                 , MIFloat_PromoMovement.ValueData               AS MovementId_Promo
                                 , MIDate_StartBegin.ValueData                   AS StartBegin
                                 , MIDate_EndBegin.ValueData                     AS EndBegin
                                 , EXTRACT (EPOCH FROM (COALESCE (MIDate_EndBegin.ValueData, zc_DateStart()) - COALESCE (MIDate_StartBegin.ValueData, zc_DateStart())) :: INTERVAL) :: TFloat AS diffBegin_sec
                                 , MovementItem.isErased
                            FROM tmpMI_G AS MovementItem
                                 LEFT JOIN tmpMI_LO AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               
                                 LEFT JOIN tmpMI_Float AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 LEFT JOIN tmpMI_Float AS MIFloat_PriceEDI
                                                       ON MIFloat_PriceEDI.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PriceEDI.DescId = zc_MIFloat_PriceEDI()
                                 LEFT JOIN tmpMI_Float AS MIFloat_CountForPrice
                                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                 LEFT JOIN tmpMI_Float AS MIFloat_AmountSecond
                                                       ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                 LEFT JOIN tmpMI_Float AS MIFloat_Summ
                                                       ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                 LEFT JOIN tmpMI_Float AS MIFloat_PromoMovement
                                                       ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                 LEFT JOIN tmpMI_Float AS MIFloat_ChangePercent
                                                       ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                      AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                                 LEFT JOIN tmpMI_Date AS MIDate_StartBegin
                                                      ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                                     AND MIDate_StartBegin.DescId         = zc_MIDate_StartBegin()
                                 LEFT JOIN tmpMI_Date AS MIDate_EndBegin
                                                      ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                                     AND MIDate_EndBegin.DescId         = zc_MIDate_EndBegin()
                          )

           -- Связь с акциями для существующих MovementItem
         , tmpMIPromo_all AS (SELECT tmp.MovementId_Promo                          AS MovementId_Promo
                                   , MovementItem.Id                               AS MovementItemId
                                   , MovementItem.ObjectId                         AS GoodsId
                                   , MovementItem.Amount                           AS TaxPromo
                                  
                              FROM (SELECT DISTINCT tmpMI_Goods.MovementId_Promo :: Integer AS MovementId_Promo 
                                    FROM tmpMI_Goods 
                                    WHERE tmpMI_Goods.MovementId_Promo <> 0
                                    ) AS tmp
                                   INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId_Promo
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                             )

         , tmpPromoMI_LO AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMIPromo_all.MovementItemId FROM tmpMIPromo_all)
                               AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                             )

         , tmpPromoMI_Float AS (SELECT MovementItemFloat.*
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIPromo_all.MovementItemId FROM tmpMIPromo_all)
                                  AND MovementItemFloat.DescId = zc_MIFloat_PriceWithOutVAT()
                               )
         , tmpPromoMI_Float2 AS (SELECT MovementItemFloat.*
                                 FROM MovementItemFloat
                                 WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIPromo_all.MovementItemId FROM tmpMIPromo_all)
                                   AND MovementItemFloat.DescId = zc_MIFloat_CountForPrice()
                                )
           -- Акции по товарам для существующих MovementItem
         , tmpMIPromo AS (SELECT DISTINCT 
                                 tmpMIPromo_all.MovementId_Promo
                               , tmpMIPromo_all.GoodsId
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                               , CASE WHEN /*tmpMIPromo_all.TaxPromo <> 0*/ 1=1 THEN MIFloat_PriceWithOutVAT.ValueData / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END ELSE 0 END AS PricePromo
                          FROM tmpMIPromo_all
                               LEFT JOIN tmpPromoMI_LO AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = tmpMIPromo_all.MovementItemId
                               LEFT JOIN tmpPromoMI_Float AS MIFloat_PriceWithOutVAT
                                                          ON MIFloat_PriceWithOutVAT.MovementItemId = tmpMIPromo_all.MovementItemId
                               LEFT JOIN tmpPromoMI_Float2 AS MIFloat_CountForPrice
                                                           ON MIFloat_CountForPrice.MovementItemId = tmpMIPromo_all.MovementItemId
                         )
            -- Остатки
          , tmpRemains AS (SELECT tmpMI_Goods.MovementItemId
                                , SUM (Container.Amount) :: TFloat AS Amount
                           FROM tmpMI_Goods
                                INNER JOIN Container ON Container.ObjectId = tmpMI_Goods.GoodsId
                                                    AND Container.DescId = zc_Container_Count()
                                                    AND Container.Amount <> 0
                                INNER JOIN ContainerLinkObject AS CLO_Unit
                                                               ON CLO_Unit.ContainerId = Container.Id
                                                              AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                              AND CLO_Unit.ObjectId = vbUnitId
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                              ON CLO_GoodsKind.ContainerId = Container.Id
                                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = Container.Id
                                                             AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                     ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI_Goods.GoodsId
                                                    AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

                           WHERE tmpMI_Goods.GoodsKindId = CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                                                , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                                , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                                 )
                                                                     THEN COALESCE (CLO_GoodsKind.ObjectId, 0)
                                                                WHEN CLO_GoodsKind.ObjectId > 0
                                                                     THEN CLO_GoodsKind.ObjectId
                                                                ELSE tmpMI_Goods.GoodsKindId
                                                           END
                             AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                             AND vbIsOrderDnepr = FALSE
                           GROUP BY tmpMI_Goods.MovementItemId
                          )
            -- LEFT JOIN Товаров из заявки + Акции + Остатки
          , tmpMI AS (SELECT COALESCE (tmpMI_Goods.MovementItemId, 0)                   AS MovementItemId
                           , COALESCE (tmpMI_Goods.GoodsId, 0)                          AS GoodsId
                           , COALESCE (tmpMI_Goods.Amount, 0)                           AS Amount
                           , COALESCE (tmpRemains.Amount, 0)                            AS AmountRemains
                           , COALESCE (tmpMI_Goods.GoodsKindId, 0)                      AS GoodsKindId
                           , COALESCE (tmpMI_Goods.Price, 0)                            AS Price
                           , COALESCE (tmpMI_Goods.PriceEDI, 0)                         AS PriceEDI
                           , COALESCE (tmpMI_Goods.CountForPrice, 1)                    AS CountForPrice
                           , COALESCE (tmpMI_Goods.AmountSecond, 0)                     AS AmountSecond
                           , COALESCE (tmpMI_Goods.Summ, 0)                             AS Summ
                           , COALESCE (tmpMI_Goods.ChangePercent, 0)                    AS ChangePercent

                           , COALESCE (tmpMI_Goods.MovementId_Promo, 0)                 AS MovementId_Promo
                           , COALESCE (tmpMIPromo.PricePromo, 0)                        AS PricePromo
                           , COALESCE (tmpMI_Goods.StartBegin, NULL)    :: TDateTime    AS StartBegin
                           , COALESCE (tmpMI_Goods.EndBegin, NULL)      :: TDateTime    AS EndBegin
                           , COALESCE (tmpMI_Goods.diffBegin_sec, 0)    :: TFloat       AS diffBegin_sec
                           , COALESCE (tmpMI_Goods.isErased, FALSE)                     AS isErased
                           --
                           , ((COALESCE (tmpMI_Goods.Amount, 0) + COALESCE (tmpMI_Goods.AmountSecond, 0)) 
                             *  CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight_all
                       FROM tmpMI_Goods
                            LEFT JOIN tmpMIPromo ON tmpMIPromo.MovementId_Promo = tmpMI_Goods.MovementId_Promo
                                                AND tmpMIPromo.GoodsId          = tmpMI_Goods.GoodsId
                                                AND (tmpMIPromo.GoodsKindId     = tmpMI_Goods.GoodsKindId
                                                  OR tmpMIPromo.GoodsKindId     = 0)
                            LEFT JOIN tmpRemains ON tmpRemains.MovementItemId = tmpMI_Goods.MovementItemId

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = COALESCE (tmpMI_Goods.GoodsId, 0)
                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                  ON ObjectFloat_Weight.ObjectId = COALESCE (tmpMI_Goods.GoodsId, 0)
                                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                     )
            -- Товары из EDI
          , tmpMI_EDI_All AS (SELECT MovementItem.Id
                                   , MovementItem.ObjectId   AS GoodsId
                                   , MovementItem.Amount     AS Amount
                              FROM (SELECT MovementLinkMovement_Order.MovementChildId AS MovementId
                                    FROM MovementLinkMovement AS MovementLinkMovement_Order
                                    WHERE MovementLinkMovement_Order.MovementId = inMovementId
                                      AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                   ) AS tmpMovement
                                   INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = FALSE
                             )
          , tmpEDIMI_LO AS (SELECT MovementItemLinkObject.*
                            FROM MovementItemLinkObject
                            WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_EDI_All.Id FROM tmpMI_EDI_All)
                              AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                            )
  
          , tmpEDIMI_Float AS (SELECT MovementItemFloat.*
                               FROM MovementItemFloat
                               WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_EDI_All.Id FROM tmpMI_EDI_All)
                                 AND MovementItemFloat.DescId IN (zc_MIFloat_Price(), zc_MIFloat_CountForPrice())
                              )
          , tmpMI_EDI AS (SELECT MovementItem.GoodsId                         AS GoodsId
                               , SUM (MovementItem.Amount)                     AS Amount
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                               , COALESCE (MIFloat_Price.ValueData, 0)         AS PriceEDI
                               , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                          FROM tmpMI_EDI_All AS MovementItem
                               LEFT JOIN tmpEDIMI_LO AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                               LEFT JOIN tmpEDIMI_Float AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                               LEFT JOIN tmpEDIMI_Float AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                          GROUP BY MovementItem.GoodsId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                 , COALESCE (MIFloat_Price.ValueData, 0)
                                 , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                         )

          , tmpPriceList_EDI AS (-- цены из прайса напрямую, (т.к. теперь в EDI.zc_MIFloat_Price - хранится "их" цена
                                 SELECT DISTINCT
                                        tmpMI_EDI.GoodsId
                                      , ObjectLink_PriceListItem_GoodsKind.ChildObjectId               AS GoodsKindId
                                      , COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) AS PriceListPrice
                                 FROM tmpMI_EDI
                                      INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                            ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmpMI_EDI.GoodsId
                                                           AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
            
                                      INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                            ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                           AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                                                           AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()

                                      LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                           ON ObjectLink_PriceListItem_GoodsKind.ObjectId      = ObjectLink_PriceListItem_PriceList.ObjectId
                                                          AND ObjectLink_PriceListItem_GoodsKind.DescId        = zc_ObjectLink_PriceListItem_GoodsKind()

                                      LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                              ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                             AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                             AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
                                      LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                                   ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                                  AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                )
            -- поиск для Товаров из EDI - MovementItemId из заявки
          , tmpMI_EDI_find AS (SELECT tmpMI_EDI.GoodsId
                                    , tmpMI_EDI.Amount
                                    , tmpMI_EDI.GoodsKindId
                                    , tmpMI_EDI.PriceEDI
                                    , COALESCE (tmpPriceList_EDI_Kind.PriceListPrice, tmpPriceList_EDI.PriceListPrice) AS PriceListPrice
                                    , tmpMI_EDI.CountForPrice
                                    , COALESCE (tmpMI.MovementItemId, 0) AS MovementItemId
                               FROM tmpMI_EDI
                                    -- привязываем цены 2 раза с видом товара и без
                                    LEFT JOIN tmpPriceList_EDI AS tmpPriceList_EDI_Kind
                                                               ON tmpPriceList_EDI_Kind.GoodsId                  = tmpMI_EDI.GoodsId
                                                              AND COALESCE (tmpPriceList_EDI_Kind.GoodsKindId,0) = COALESCE (tmpMI_EDI.GoodsKindId,0)
                                    LEFT JOIN tmpPriceList_EDI ON tmpPriceList_EDI.GoodsId    = tmpMI_EDI.GoodsId
                                                              AND tmpPriceList_EDI.GoodsKindId IS NULL

                                    LEFT JOIN (SELECT MAX (tmpMI.MovementItemId) AS MovementItemId
                                                    , tmpMI.GoodsId
                                                    , tmpMI.GoodsKindId
                                                    -- , tmpMI.Price
                                               FROM tmpMI
                                               WHERE tmpMI.isErased = FALSE
                                               GROUP BY tmpMI.GoodsId
                                                      , tmpMI.GoodsKindId
                                                      -- , tmpMI.Price
                                              ) AS tmpMI ON tmpMI.GoodsId     = tmpMI_EDI.GoodsId
                                                        AND tmpMI.GoodsKindId = tmpMI_EDI.GoodsKindId
                                                        -- AND tmpMI.Price       = tmpMI_EDI.Price
                              )
            -- FULL JOIN Товаров EDI - MovementItemId из заявки
          , tmpMI_all AS (SELECT tmpMI.MovementItemId
                               , COALESCE (tmpMI.GoodsId, tmpMI_EDI_find.GoodsId) AS GoodsId
                               , tmpMI.AmountRemains               AS AmountRemains
                               , tmpMI.Amount                      AS Amount
                               , COALESCE (tmpMI.AmountSecond, 0)  AS AmountSecond 
                               , COALESCE (tmpMI.AmountWeight_all,0) AS AmountWeight_all
                               , COALESCE (tmpMI.Summ, 0)          AS Summ
                               , COALESCE (tmpMI.ChangePercent, 0) AS ChangePercent
                               , tmpMI_EDI_find.Amount             AS AmountEDI
                               , COALESCE (tmpMI.GoodsKindId, tmpMI_EDI_find.GoodsKindId)     AS GoodsKindId
                               , COALESCE (tmpMI.Price, tmpMI_EDI_find.PriceListPrice)        AS Price
                               , COALESCE (tmpMI.PriceEDI, tmpMI_EDI_find.PriceEDI)           AS PriceEDI
                               , COALESCE (tmpMI.CountForPrice, tmpMI_EDI_find.CountForPrice) AS CountForPrice

                               , tmpMI.MovementId_Promo                                       AS MovementId_Promo
                               , tmpMI.PricePromo                                             AS PricePromo
                               , tmpMI.StartBegin                  AS StartBegin
                               , tmpMI.EndBegin                    AS EndBegin
                               , tmpMI.diffBegin_sec               AS diffBegin_sec
                               , COALESCE (tmpMI.isErased, FALSE)  AS isErased
                          FROM tmpMI
                               FULL JOIN tmpMI_EDI_find ON tmpMI_EDI_find.MovementItemId = tmpMI.MovementItemId
                         )
            -- Артикул GLN
          , tmpGoodsPropertyValue AS (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                                           , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                           , ObjectString_ArticleGLN.ValueData                                   AS ArticleGLN
                                      FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                                           ) AS tmpGoodsProperty
                                           INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                 ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                           LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                                                  ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                               AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                               AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                      WHERE ObjectString_ArticleGLN.ValueData <> ''
                                     )

          , tmpMI_Child AS (SELECT MovementItem.ParentId
                                 , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN MovementItem.Amount ELSE 0 END * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight
                                 , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 THEN MovementItem.Amount ELSE 0 END * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeightSecond
                                 , SUM (MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight_all
                            FROM MovementItem
                                 LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                             ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()  

                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                      ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                     AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                       ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                      AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Child()
                              AND MovementItem.isErased   = FALSE
                            GROUP BY MovementItem.ParentId
                            )

       SELECT
             tmpMI.MovementItemId :: Integer    AS Id
           , CAST (row_number() OVER (ORDER BY tmpMI.MovementItemId) AS Integer) AS LineNum
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI.AmountRemains :: TFloat      AS AmountRemains
           , tmpMI.Amount :: TFloat             AS Amount
           , tmpMI.AmountEDI :: TFloat          AS AmountEDI
           , tmpMI.AmountSecond :: TFloat       AS AmountSecond
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName
           , tmpMI.Price :: TFloat              AS Price
           , tmpMI.PriceEDI :: TFloat           AS PriceEDI
           , tmpMI.CountForPrice :: TFloat      AS CountForPrice
           , CAST ((tmpMI.Amount + tmpMI.AmountSecond) * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2)) :: TFloat AS AmountSumm
           , tmpMI.Summ               :: TFloat AS AmountSumm_Partner
           , tmpMI.ChangePercent      :: TFloat AS ChangePercent

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , tmpGoodsPropertyValue.ArticleGLN

           , (CASE WHEN (tmpPromo.isChangePercent = TRUE  AND tmpMI.ChangePercent <> vbChangePercent)
                     OR (tmpPromo.isChangePercent = FALSE AND tmpMI.ChangePercent <> 0)
                        THEN 'ОШИБКА <(-)% Скидки (+)% Наценки>'
                   ELSE ''
              END
           || CASE WHEN tmpMI.MovementId_Promo = tmpPromo.MovementId
                       THEN tmpPromo.MovementPromo
                  WHEN tmpMI.MovementId_Promo <> COALESCE (tmpPromo.MovementId, 0) AND tmpMI.MovementId_Promo <> 0
                       THEN 'ОШИБКА (1)' || zfCalc_PromoMovementName (NULL, Movement_Promo_View.InvNumber :: TVarChar, Movement_Promo_View.OperDate, Movement_Promo_View.StartSale, Movement_Promo_View.EndSale)
                             || '   (2)' || zfCalc_PromoMovementName (NULL, Movement_Promo_View_2.InvNumber :: TVarChar, Movement_Promo_View_2.OperDate, Movement_Promo_View_2.StartSale, Movement_Promo_View_2.EndSale)
                  WHEN COALESCE (tmpMI.MovementId_Promo, 0) <> tmpPromo.MovementId
                       THEN 'ОШИБКА ' || tmpPromo.MovementPromo
                       
                  ELSE ''
              END) :: TVarChar AS MovementPromo

           , CAST (CASE WHEN 1 = 0 AND tmpMI.PricePromo <> 0 THEN tmpMI.PricePromo
                        WHEN /*tmpPromo.TaxPromo <> 0 AND*/ tmpPromo.GoodsId > 0 AND vbPriceWithVAT = TRUE THEN tmpPromo.PriceWithVAT_orig / tmpPromo.CountForPrice
                        WHEN /*tmpPromo.TaxPromo <> 0*/ tmpPromo.GoodsId > 0 AND 1=1 THEN tmpPromo.PriceWithOutVAT_orig / tmpPromo.CountForPrice
                        ELSE 0
                   END AS Numeric (16,8)) AS PricePromo

           , tmpMI.isErased
           , CASE WHEN tmpMI.PriceEDI > 0 
                       THEN CASE WHEN 100 * ABS (tmpMI.Price * (1 + tmpMI.ChangePercent / 100) - tmpMI.PriceEDI) / tmpMI.PriceEDI >= 1 THEN TRUE ELSE FALSE END
                  ELSE FALSE
             END ::Boolean AS isPriceEDIDiff

           , tmpMI.StartBegin                  AS StartBegin
           , tmpMI.EndBegin                    AS EndBegin
           , tmpMI.diffBegin_sec               AS diffBegin_sec

           , tmpMI_Child.AmountWeight       ::TFloat AS AmountWeight_child_one
           , tmpMI_Child.AmountWeightSecond ::TFloat AS AmountWeightSecond_child_sec                                                    
           , COALESCE (tmpMI_Child.AmountWeight_all, 0) ::TFloat AS AmountWeight_child
           , (COALESCE (tmpMI_Child.AmountWeight_all, 0) - COALESCE (tmpMI.AmountWeight_all,0) )  ::TFloat AS AmountWeightDiff_child
          --, (COALESCE (tmpMI_Child.AmountWeight_all, 0) - COALESCE (tmpMI.AmountWeight_all,0) )  ::TFloat AS AmountDiff_child
       FROM tmpMI_all AS tmpMI
            LEFT JOIN tmpPromo ON tmpPromo.GoodsId      = tmpMI.GoodsId
                              AND (tmpPromo.GoodsKindId = tmpMI.GoodsKindId OR tmpPromo.GoodsKindId = 0)

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                                  
            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN tmpGoodsPropertyValue ON tmpGoodsPropertyValue.GoodsId     = tmpMI.GoodsId
                                           AND tmpGoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN Movement_Promo_View ON Movement_Promo_View.Id = tmpMI.MovementId_Promo
            LEFT JOIN Movement_Promo_View AS Movement_Promo_View_2
                                          ON Movement_Promo_View_2.Id = tmpPromo.MovementId
                                         AND tmpMI.MovementId_Promo <> COALESCE (tmpPromo.MovementId, 0) AND tmpMI.MovementId_Promo <> 0

            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.MovementItemId
       ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderExternal (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.12.19         * цена с учетом вида товара
 02.05.19         *
 27.03.18         *
 28.07.16         * add PriceEDI, isPriceEDIDiff
 17.06.15                                        * add vbIsOrderDnepr
 31.03.15         * add GoodsGroupNameFull
 20.10.14                                        * all
 26.08.14                                                        *
 18.08.14                                                        *
 06.06.14                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inPriceListId:= zc_PriceList_Basis(), inOperDate:= CURRENT_TIMESTAMP, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inPriceListId:= zc_PriceList_Basis(), inOperDate:= CURRENT_TIMESTAMP, inShowAll:= FALSE, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
