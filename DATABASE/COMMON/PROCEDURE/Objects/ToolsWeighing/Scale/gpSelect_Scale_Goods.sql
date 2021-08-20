 -- Function: gpSelect_Scale_Goods()

-- DROP FUNCTION IF EXISTS gpSelect_Scale_Goods (TDateTime, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Scale_Goods (TDateTime, Integer, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Scale_Goods (Boolean, TDateTime, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Scale_Goods (Boolean, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Scale_Goods (Boolean, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Scale_Goods (Boolean, TDateTime, Integer, Integer, Integer, Integer, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Goods(
    IN inIsGoodsComplete       Boolean  ,    -- склад ГП/производство/упаковка or обвалка
    IN inOperDate              TDateTime,
    IN inMovementId            Integer,      -- Документ ИЛИ Контрагент (для возврата)
    IN inOrderExternalId       Integer,      -- Заявка ИЛИ Договор (для возврата)
    IN inPriceListId           Integer,
    IN inGoodsCode             Integer,
    IN inGoodsName             TVarChar,
    IN inDayPrior_PriceReturn  Integer,
    IN inBranchCode            Integer,      --
    IN inSession               TVarChar      -- сессия пользователя
)
RETURNS TABLE (GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar, GoodsKindId_list TVarChar, GoodsKindId_max Integer, GoodsKindCode_max Integer, GoodsKindName_max TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , ChangePercentAmount TFloat
             , Amount_Remains TFloat
             , Amount_Order TFloat
             , Amount_OrderWeight TFloat
             , Amount_Weighing TFloat
             , Amount_WeighingWeight TFloat
             , Amount_diff TFloat
             , Amount_diffWeight TFloat
             , isTax_diff Boolean
             , Price TFloat
             , Price_Return TFloat
             , CountForPrice         TFloat
             , CountForPrice_Return  TFloat
             , Color_calc            Integer
             , MovementId_Promo      Integer
             , isPromo               Boolean
             , isTare                Boolean
             , isNotPriceIncome      Boolean
             , tmpDate               TDateTime
             , Weight TFloat, WeightTare TFloat, CountForWeight TFloat
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyId Integer
              )
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbRetailId     Integer;
    DECLARE vbFromId_group Integer;
    DECLARE vbFromId       Integer;
    DECLARE vbToId         Integer;
    DECLARE vbGoodsId      Integer;
    DECLARE vbOperDate_price TDateTime;
    DECLARE vbPriceListId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

-- if vbUserId = 5 then return; end if;
-- if vbUserId = 5 then inMovementId:= 7505643; end if;


   IF (inBranchCode > 1000)
   THEN RETURN;
   END IF;


   -- товар которого нет как бы в заявке, но его все равно надо провести
   IF (inOrderExternalId > 0 OR inBranchCode BETWEEN 301 AND 310) AND inGoodsCode <> 0
   THEN
       vbGoodsId:= (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsCode AND Object.DescId = zc_Object_Goods() AND Object.isErased = FALSE);
   END IF;


   IF inOrderExternalId > 0
   THEN
        -- параметры из документа - Movement
        vbFromId_group:= (SELECT CASE WHEN ObjectLink_Unit_Parent_0.ChildObjectId = 8439
                                        OR ObjectLink_Unit_Parent_1.ChildObjectId = 8439
                                        OR ObjectLink_Unit_Parent_2.ChildObjectId = 8439
                                        OR ObjectLink_Unit_Parent_3.ChildObjectId = 8439
                                        OR ObjectLink_Unit_Parent_4.ChildObjectId = 8439
                                        OR ObjectLink_Unit_Parent_5.ChildObjectId = 8439
                                           THEN 8439 -- Участок мясного сырья
                                      ELSE ObjectLink_Unit_Parent_0.ChildObjectId
                                 END
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                               LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent_0
                                                    ON ObjectLink_Unit_Parent_0.ObjectId = MovementLinkObject_From.ObjectId
                                                   AND ObjectLink_Unit_Parent_0.DescId   = zc_ObjectLink_Unit_Parent()
                               LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent_1
                                                    ON ObjectLink_Unit_Parent_1.ObjectId = ObjectLink_Unit_Parent_0.ChildObjectId
                                                   AND ObjectLink_Unit_Parent_1.DescId   = zc_ObjectLink_Unit_Parent()
                               LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent_2
                                                    ON ObjectLink_Unit_Parent_2.ObjectId = ObjectLink_Unit_Parent_1.ChildObjectId
                                                   AND ObjectLink_Unit_Parent_2.DescId   = zc_ObjectLink_Unit_Parent()
                               LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent_3
                                                    ON ObjectLink_Unit_Parent_3.ObjectId = ObjectLink_Unit_Parent_2.ChildObjectId
                                                   AND ObjectLink_Unit_Parent_3.DescId   = zc_ObjectLink_Unit_Parent()
                               LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent_4
                                                    ON ObjectLink_Unit_Parent_4.ObjectId = ObjectLink_Unit_Parent_3.ChildObjectId
                                                   AND ObjectLink_Unit_Parent_4.DescId   = zc_ObjectLink_Unit_Parent()
                               LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent_5
                                                    ON ObjectLink_Unit_Parent_5.ObjectId = ObjectLink_Unit_Parent_4.ChildObjectId
                                                   AND ObjectLink_Unit_Parent_5.DescId   = zc_ObjectLink_Unit_Parent()
                          WHERE Movement.Id = inMovementId
                         );
        -- параметры из документа - Order
        SELECT COALESCE (MovementLinkObject_Retail.ObjectId, 0)        AS RetailId
             , COALESCE (MovementLinkObject_From.ObjectId, 0)          AS FromId
             , CASE WHEN COALESCE (vbFromId_group, 0) = 0 
                         THEN CASE WHEN ObjectLink_Unit_Parent_0.ChildObjectId = 8439
                                     OR ObjectLink_Unit_Parent_1.ChildObjectId = 8439
                                     OR ObjectLink_Unit_Parent_2.ChildObjectId = 8439
                                     OR ObjectLink_Unit_Parent_3.ChildObjectId = 8439
                                     OR ObjectLink_Unit_Parent_4.ChildObjectId = 8439
                                     OR ObjectLink_Unit_Parent_5.ChildObjectId = 8439
                                        THEN 8439 -- Участок мясного сырья
                                   ELSE ObjectLink_Unit_Parent_0.ChildObjectId
                              END
                    ELSE vbFromId_group
               END
               INTO vbRetailId, vbFromId, vbFromId_group
        FROM Movement
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                          ON MovementLinkObject_Retail.MovementId = Movement.Id
                                         AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                         AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent_0
                                  ON ObjectLink_Unit_Parent_0.ObjectId = MovementLinkObject_To.ObjectId
                                 AND ObjectLink_Unit_Parent_0.DescId   = zc_ObjectLink_Unit_Parent()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent_1
                                  ON ObjectLink_Unit_Parent_1.ObjectId = ObjectLink_Unit_Parent_0.ChildObjectId
                                 AND ObjectLink_Unit_Parent_1.DescId   = zc_ObjectLink_Unit_Parent()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent_2
                                  ON ObjectLink_Unit_Parent_2.ObjectId = ObjectLink_Unit_Parent_1.ChildObjectId
                                 AND ObjectLink_Unit_Parent_2.DescId   = zc_ObjectLink_Unit_Parent()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent_3
                                  ON ObjectLink_Unit_Parent_3.ObjectId = ObjectLink_Unit_Parent_2.ChildObjectId
                                 AND ObjectLink_Unit_Parent_3.DescId   = zc_ObjectLink_Unit_Parent()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent_4
                                  ON ObjectLink_Unit_Parent_4.ObjectId = ObjectLink_Unit_Parent_3.ChildObjectId
                                 AND ObjectLink_Unit_Parent_4.DescId   = zc_ObjectLink_Unit_Parent()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent_5
                                  ON ObjectLink_Unit_Parent_5.ObjectId = ObjectLink_Unit_Parent_4.ChildObjectId
                                 AND ObjectLink_Unit_Parent_5.DescId   = zc_ObjectLink_Unit_Parent()
        WHERE Movement.Id = inOrderExternalId;


         IF vbGoodsId <> 0 AND inBranchCode NOT BETWEEN 301 AND 310
         THEN
              -- определили
              SELECT tmp.PriceListId, tmp.OperDate
                    INTO vbPriceListId, vbOperDate_price
              FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract()), 1)
                                                        , inPartnerId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                                        , inMovementDescId := zc_Movement_Sale()
                                                        , inOperDate_order := COALESCE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inOrderExternalId), CURRENT_TIMESTAMP)
                                                        , inOperDatePartner:= NULL
                                                        , inDayPrior_PriceReturn:= NULL
                                                        , inIsPrior        := FALSE -- !!!отказались от старых цен!!!
                                                        , inOperDatePartner_order:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inOrderExternalId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                         ) AS tmp;
         END IF;


         -- Результат - по заявке
         RETURN QUERY
            WITH tmpRemains AS (SELECT Container.ObjectId     AS GoodsId
                                     , SUM (Container.Amount) AS Amount
                                 FROM Container
                                      INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                     ON CLO_Unit.ContainerId = Container.Id
                                                                    AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                    AND CLO_Unit.ObjectId IN (2961184 -- Склад спецодежда б/у
                                                                                            , 8455    -- Склад специй
                                                                                            , 3398383 -- Склад резины
                                                                                            , 8456    -- Склад запчастей
                                                                                             )
                                 WHERE Container.DescId = zc_Container_Count()
                                   AND Container.Amount <> 0
                                   AND inBranchCode BETWEEN 301 AND 310
                                 GROUP BY Container.ObjectId
                                )
               , tmpMovement AS (SELECT Movement_find.Id     AS MovementId
                                      , Movement_find.DescId AS MovementDescId
                                 FROM (SELECT inOrderExternalId AS MovementId WHERE vbRetailId <> 0) AS tmpMovement
                                      INNER JOIN Movement ON Movement.Id = tmpMovement.MovementId
                                      INNER JOIN Movement AS Movement_find ON Movement_find.OperDate = Movement.OperDate
                                                                          AND Movement_find.DescId   = Movement.DescId
                                                                          AND Movement_find.StatusId = zc_Enum_Status_Complete()
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                                    ON MovementLinkObject_From_find.MovementId = Movement_find.Id
                                                                   AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                                                   AND MovementLinkObject_From_find.ObjectId = vbFromId
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_Retail_find
                                                                    ON MovementLinkObject_Retail_find.MovementId = Movement_find.Id
                                                                   AND MovementLinkObject_Retail_find.DescId = zc_MovementLinkObject_Retail()
                                                                   AND MovementLinkObject_Retail_find.ObjectId = vbRetailId
                                UNION
                                 SELECT inOrderExternalId AS MovementId, Movement.DescId AS MovementDescId FROM Movement WHERE Movement.Id = inOrderExternalId AND vbRetailId = 0
                                )
               , tmpMI_Order2 AS (SELECT COALESCE (MILinkObject_Goods.ObjectId, MovementItem.ObjectId) AS GoodsId
                                       , COALESCE (MILinkObject_GoodsKind.ObjectId, CASE WHEN inIsGoodsComplete = FALSE THEN zc_Enum_GoodsKind_Main() ELSE zc_Enum_GoodsKind_Main() END) AS GoodsKindId
                                       , CASE WHEN MILinkObject_Receipt.ObjectId > 0
                                               AND (ObjectLink_Goods_GoodsGroup.ChildObjectId  IN (1942, 5064881) -- СО-ЭМУЛЬСИИ + СО-ПОСОЛ
                                                 OR ObjectLink_GoodsGroup_parent.ChildObjectId IN (1942, 5064881) -- СО-ЭМУЛЬСИИ + СО-ПОСОЛ
                                                   )
                                                   THEN vbFromId
                                              WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье
                                                                                           , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные  + Прочие материалы
                                                                                           , zc_Enum_InfoMoneyDestination_30500() -- Доходы  + Прочие доходы
                                                                                            )
                                                   THEN 8455 -- Склад специй
                                              ELSE 8439 -- Участок мясного сырья
                                         END AS UnitId_order
                                       , View_InfoMoney.InfoMoneyDestinationId 
                                       , View_InfoMoney.InfoMoneyId
                                       , MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)   AS Amount
                                       , COALESCE (MIFloat_Price.ValueData, 0)                                AS Price
                                       , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                                       , COALESCE (MIFloat_PromoMovement.ValueData, 0)                        AS MovementId_Promo
                                       , FALSE AS isTare

                                 FROM tmpMovement
                                      INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                                             AND MovementItem.DescId     = zc_MI_Master()
                                                             AND MovementItem.isErased   = FALSE
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                       ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                                                                      AND tmpMovement.MovementDescId        = zc_Movement_OrderIncome()
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                                                       ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
                                      LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                  ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                      LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                  ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                      LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                                  ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                      LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                                  ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                      LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                           ON ObjectLink_Goods_GoodsGroup.ObjectId = MovementItem.ObjectId
                                                          AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
                                      LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                                           ON ObjectLink_GoodsGroup_parent.ObjectId = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                                          AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                                      LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                           ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                                          AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                      LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                                 WHERE MovementItem.Amount <> 0 OR COALESCE (MIFloat_AmountSecond.ValueData, 0) <> 0
                                )
               , tmpMI_Order AS (SELECT tmpMI_Order2.GoodsId
                                      , tmpMI_Order2.GoodsKindId
                                      , tmpMI_Order2.Amount
                                      , tmpMI_Order2.Price
                                      , tmpMI_Order2.CountForPrice
                                      , tmpMI_Order2.MovementId_Promo
                                      , tmpMI_Order2.isTare
                                 FROM tmpMI_Order2
                                 WHERE (tmpMI_Order2.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
                                                                              , zc_Enum_InfoMoneyDestination_20100() -- Запчасти и Ремонты
                                                                              , zc_Enum_InfoMoneyDestination_20200() -- Прочие ТМЦ
                                                                              , zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                                                              , zc_Enum_InfoMoneyDestination_20600() -- Прочие материалы
                                                                              , zc_Enum_InfoMoneyDestination_30500() -- Доходы  + Прочие доходы
                                                                               )
                                     OR tmpMI_Order2.InfoMoneyId IN (zc_Enum_InfoMoney_10105() -- Прочее мясное сырье
                                                                   , zc_Enum_InfoMoney_10106() -- Сыр
                                                                    )
                                     OR inBranchCode NOT BETWEEN 301 AND 310
                                       )
                                   AND (tmpMI_Order2.UnitId_order = vbFromId_group
                                     OR inBranchCode NOT BETWEEN 201 AND 210
                                       )
                                UNION ALL
                                 SELECT Object_Goods.Id AS GoodsId
                                      , CASE WHEN inIsGoodsComplete = FALSE THEN zc_Enum_GoodsKind_Main() ELSE zc_Enum_GoodsKind_Main() END  AS GoodsKindId
                                      , 0 AS Amount
                                      , 0 AS Price
                                      , 0 AS CountForPrice
                                      , 0 AS MovementId_Promo
                                      , TRUE AS isTare
                                 FROM Object_InfoMoney_View AS View_InfoMoney
                                      INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                            ON ObjectLink_Goods_InfoMoney.ChildObjectId = View_InfoMoney.InfoMoneyId
                                                           AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                      INNER JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                                                       AND Object_Goods.isErased = FALSE
                                                                       AND Object_Goods.ObjectCode > 0
                                 WHERE View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20500() -- Общефирменные + Оборотная тара
                                                                               , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные + Прочие материалы
                                                                               , zc_Enum_InfoMoneyDestination_30500() -- Доходы  + Прочие доходы
                                                                                )
                                  AND Object_Goods.Id NOT IN (SELECT tmpMI_Order2.GoodsId FROM tmpMI_Order2)
                                   -- AND vbUserId = 5
                                )
            , tmpMI_Weighing AS (SELECT MovementItem.ObjectId                         AS GoodsId
                                      , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_Enum_GoodsKind_Main()) AS GoodsKindId
                                      , MovementItem.Amount                           AS Amount
                                      , COALESCE (MIFloat_PromoMovement.ValueData, 0) AS MovementId_Promo
                                      , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                                      , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                                 FROM MovementLinkMovement
                                      INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementId
                                                         AND Movement.DescId = zc_Movement_WeighingPartner()
                                                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                                      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                             AND MovementItem.DescId     = zc_MI_Master()
                                                             AND MovementItem.isErased   = FALSE
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                      LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                  ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                      LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                                  ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                      LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                                  ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                 WHERE MovementLinkMovement.MovementChildId = inOrderExternalId
                                   AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
                                   -- AND inSession <> '5'
                                )
                     , tmpGoods_byName AS (-- По Названию - Склад Специй
                                           SELECT Object.Id            AS GoodsId
                                                , zc_GoodsKind_Basis() AS GoodsKindId
                                                , 0                    AS Price
                                                , CASE WHEN UPPER (Object.ValueData) = UPPER (inGoodsName) THEN TRUE ELSE FALSE END AS isEqual
                                           FROM Object
                                                INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                      ON ObjectLink_Goods_InfoMoney.ObjectId = Object.Id
                                                                     AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                                INNER JOIN Object_InfoMoney_View AS View_InfoMoney
                                                                                 ON View_InfoMoney.InfoMoneyId            = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                                AND (View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
                                                                                                                             , zc_Enum_InfoMoneyDestination_20100() -- Запчасти и Ремонты
                                                                                                                             , zc_Enum_InfoMoneyDestination_20200() -- Прочие ТМЦ
                                                                                                                             , zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                                                                                                             , zc_Enum_InfoMoneyDestination_20600() -- Прочие материалы
                                                                                                                             , zc_Enum_InfoMoneyDestination_30500() -- Доходы  + Прочие доходы
                                                                                                                              )
                                                                                  OR View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_10105() -- Прочее мясное сырье
                                                                                                                  , zc_Enum_InfoMoney_10106() -- Сыр
                                                                                                                   )
                                                                                    )
                                           WHERE inBranchCode BETWEEN 301 AND 310
                                             AND TRIM (inGoodsName)  <> ''
                                             AND Object.DescId = zc_Object_Goods() AND Object.isErased = FALSE
                                             AND Object.ValueData ILIKE ('%' || TRIM (inGoodsName) || '%')
                                          )
                     , tmpMI AS (SELECT tmpMI.GoodsId
                                      , tmpMI.GoodsKindId
                                      , tmpMI.Amount AS Amount_Order
                                      , 0            AS Amount_Weighing
                                      , tmpMI.MovementId_Promo
                                      , tmpMI.Price
                                      , tmpMI.CountForPrice
                                      , tmpMI.isTare
                                 FROM tmpMI_Order AS tmpMI
                                UNION ALL
                                 SELECT tmp.GoodsId
                                      , tmp.GoodsKindId
                                      , 0            AS Amount_Order
                                      , 0            AS Amount_Weighing
                                      , 0            AS MovementId_Promo
                                      , tmp.Price
                                      , 1 AS CountForPrice -- плохое решение
                                      , FALSE AS isTare
                                 FROM (-- По коду
                                       SELECT vbGoodsId AS GoodsId, zc_GoodsKind_Basis() AS GoodsKindId
                                            , (SELECT lpGet.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (vbOperDate_price, vbPriceListId, vbGoodsId, 0) AS lpGet) AS Price
                                       WHERE vbGoodsId <> 0
                                      UNION ALL
                                       -- По Названию - Склад Специй
                                       SELECT tmpGoods_byName.GoodsId
                                            , tmpGoods_byName.GoodsKindId
                                            , tmpGoods_byName.Price
                                       FROM tmpGoods_byName
                                       WHERE EXISTS (SELECT 1 FROM tmpGoods_byName WHERE tmpGoods_byName.isEqual = TRUE)
                                         AND tmpGoods_byName.isEqual = TRUE
                                      UNION ALL
                                       -- По Названию - Склад Специй
                                       SELECT tmpGoods_byName.GoodsId
                                            , tmpGoods_byName.GoodsKindId
                                            , tmpGoods_byName.Price
                                       FROM tmpGoods_byName
                                       WHERE NOT EXISTS (SELECT 1 FROM tmpGoods_byName WHERE tmpGoods_byName.isEqual = TRUE)

                                      UNION ALL
                                       -- По zc_ObjectBoolean_..._ScaleCeh() + zc_ObjectBoolean_..._Order
                                       SELECT DISTINCT
                                              ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     AS GoodsId
                                            , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId AS GoodsKindId
                                            , 0                                                   AS Price
                                       FROM ObjectBoolean AS ObjectBoolean_ScaleCeh
                                            INNER JOIN Object AS Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.Id = ObjectBoolean_ScaleCeh.ObjectId AND Object_GoodsByGoodsKind.isErased = FALSE
                                            INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                                  ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId = ObjectBoolean_ScaleCeh.ObjectId
                                                                 AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                                                 AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = vbGoodsId
                                            INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                                  ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectBoolean_ScaleCeh.ObjectId
                                                                 AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                                 AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId <> zc_GoodsKind_Basis()
                                       WHERE ObjectBoolean_ScaleCeh.DescId    IN (zc_ObjectBoolean_GoodsByGoodsKind_ScaleCeh(), zc_ObjectBoolean_GoodsByGoodsKind_Order())
                                         AND ObjectBoolean_ScaleCeh.ValueData = TRUE
                                      ) AS tmp
                                      LEFT JOIN tmpMI_Order ON tmpMI_Order.GoodsId     = tmp.GoodsId
                                                           AND tmpMI_Order.GoodsKindId = tmp.GoodsKindId
                                      LEFT JOIN tmpMI_Weighing ON tmpMI_Weighing.GoodsId     = tmp.GoodsId
                                                              AND tmpMI_Weighing.GoodsKindId = tmp.GoodsKindId
                                 WHERE tmpMI_Order.GoodsId IS NULL AND tmpMI_Weighing.GoodsId IS NULL
                                   AND inIsGoodsComplete = FALSE
                                UNION ALL
                                 SELECT tmpMI.GoodsId
                                      , tmpMI.GoodsKindId
                                      , 0            AS Amount_Order
                                      , tmpMI.Amount AS Amount_Weighing
                                      , tmpMI.MovementId_Promo
                                      , tmpMI.Price
                                      , tmpMI.CountForPrice
                                      , FALSE AS isTare
                                 FROM tmpMI_Weighing AS tmpMI
                                )
                     , tmpChangePercentAmount AS
                                (SELECT tmpMI.GoodsId
                                      , tmpMI.GoodsKindId
                                      , ObjectFloat_ChangePercentAmount.ValueData AS ChangePercentAmount
                                 FROM (SELECT DISTINCT tmpMI.GoodsId, tmpMI.GoodsKindId FROM tmpMI) AS tmpMI
                                      INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                            ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = tmpMI.GoodsId
                                                           AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                      LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                           ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                          AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                      LEFT JOIN ObjectFloat AS ObjectFloat_ChangePercentAmount
                                                            ON ObjectFloat_ChangePercentAmount.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                           AND ObjectFloat_ChangePercentAmount.DescId   = zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount()
                                 WHERE COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = tmpMI.GoodsKindId
                                )
            -- Результат - по заявке
            SELECT ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                 , Object_Goods.Id             AS GoodsId
                 , Object_Goods.ObjectCode     AS GoodsCode
                 , Object_Goods.ValueData      AS GoodsName
                 , Object_GoodsKind.Id         AS GoodsKindId
                 , Object_GoodsKind.ObjectCode AS GoodsKindCode
                 , Object_GoodsKind.ValueData  AS GoodsKindName
                 , Object_GoodsKind.Id :: TVarChar AS GoodsKindId_list
                 , Object_GoodsKind.Id         AS GoodsKindId_max
                 , Object_GoodsKind.ObjectCode AS GoodsKindCode_max
                 , Object_GoodsKind.ValueData  AS GoodsKindName_max
                 , Object_Measure.Id           AS MeasureId
                 , Object_Measure.ValueData    AS MeasureName
                 , CASE WHEN inBranchCode BETWEEN 301 AND 310
                             THEN 0
                        WHEN Object_Measure.Id = zc_Measure_Kg()
                             THEN CASE WHEN inIsGoodsComplete = FALSE
                                            THEN 0 -- COALESCE (tmpChangePercentAmount.ChangePercentAmount, 0)
                                       ELSE 1
                                  END
                        ELSE 0
                   END :: TFloat AS ChangePercentAmount

                 , tmpRemains.Amount :: TFloat AS Amount_Remains

                 , tmpMI.Amount_Order :: TFloat    AS Amount_Order
                 , (tmpMI.Amount_Order * CASE WHEN inBranchCode BETWEEN 301 AND 310 THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat    AS Amount_OrderWeight
                 , tmpMI.Amount_Weighing :: TFloat AS Amount_Weighing
                 , (tmpMI.Amount_Weighing * CASE WHEN inBranchCode BETWEEN 301 AND 310 THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat AS Amount_WeighingWeight
                 , (tmpMI.Amount_Order - tmpMI.Amount_Weighing) :: TFloat AS Amount_diff
                 , ((tmpMI.Amount_Order - tmpMI.Amount_Weighing)  * CASE WHEN inBranchCode BETWEEN 301 AND 310 THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat AS Amount_diffWeight
                 , CASE WHEN tmpMI.Amount_Weighing > tmpMI.Amount_Order
                             THEN CASE WHEN tmpMI.Amount_Order = 0
                                            THEN TRUE
                                       WHEN (tmpMI.Amount_Weighing / tmpMI.Amount_Order * 100 - 100) > 2
                                            THEN TRUE
                                       ELSE FALSE
                                  END
                             ELSE FALSE
                   END :: Boolean AS isTax_diff
                 , tmpMI.Price :: TFloat           AS Price
                 , 0 :: TFloat                     AS Price_Return
                 , tmpMI.CountForPrice :: TFloat   AS CountForPrice
                 , 0 :: TFloat                     AS CountForPrice_Return

                 , CASE WHEN (tmpMI.Amount_Order - tmpMI.Amount_Weighing) > 0
                             THEN 1118719 -- clRed
                        WHEN tmpMI.Amount_Weighing > tmpMI.Amount_Order
                             THEN CASE WHEN tmpMI.Amount_Order = 0
                                            THEN 16711680 -- clBlue
                                       WHEN (tmpMI.Amount_Weighing / tmpMI.Amount_Order * 100 - 100) > 2
                                            THEN 16711680 -- clBlue
                                       ELSE 0 -- clBlack
                                  END
                        ELSE 0 -- clBlack
                   END :: Integer AS Color_calc


                 , tmpMI.MovementId_Promo :: Integer AS MovementId_Promo
                 , CASE WHEN tmpMI.MovementId_Promo > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPromo
                 , CASE WHEN tmpMI.isTare_calc = 1 THEN TRUE ELSE FALSE END :: Boolean AS isTare

                 , CASE WHEN View_InfoMoney.InfoMoneyId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isNotPriceIncome

                 , CURRENT_DATE :: TDateTime AS tmpDate

                 , ObjectFloat_Weight.ValueData         AS Weight
                 , ObjectFloat_WeightTare.ValueData     AS WeightTare
                 , ObjectFloat_CountForWeight.ValueData AS CountForWeight

                 , View_InfoMoney_goods.InfoMoneyCode
                 , View_InfoMoney_goods.InfoMoneyGroupName
                 , View_InfoMoney_goods.InfoMoneyDestinationName
                 , View_InfoMoney_goods.InfoMoneyName
                 , View_InfoMoney_goods.InfoMoneyId

            FROM (SELECT tmpMI.GoodsId
                       , tmpMI.GoodsKindId
                       , SUM (tmpMI.Amount_Order)     AS Amount_Order
                       , SUM (tmpMI.Amount_Weighing)  AS Amount_Weighing
                       , MAX (tmpMI.MovementId_Promo) AS MovementId_Promo
                       , MAX (tmpMI.Price)            AS Price
                       , 1 AS CountForPrice -- tmpMI.CountForPrice
                       , MAX (CASE WHEN tmpMI.isTare = TRUE THEN 1 ELSE 0 END) AS isTare_calc
                  FROM tmpMI
                  GROUP BY tmpMI.GoodsId
                         , tmpMI.GoodsKindId
                         -- , tmpMI.Price
                         -- , tmpMI.CountForPrice
                         -- , tmpMI.isTare
                 ) AS tmpMI

                 LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI.GoodsId
                 LEFT JOIN tmpChangePercentAmount ON tmpChangePercentAmount.GoodsId     = tmpMI.GoodsId
                                                 AND tmpChangePercentAmount.GoodsKindId = tmpMI.GoodsKindId

                 LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpMI.GoodsId
                 LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

                 LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                        ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                       AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                 LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                       ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                      AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                 LEFT JOIN ObjectFloat AS ObjectFloat_WeightTare
                                       ON ObjectFloat_WeightTare.ObjectId = tmpMI.GoodsId
                                      AND ObjectFloat_WeightTare.DescId   = zc_ObjectFloat_Goods_WeightTare()
                 LEFT JOIN ObjectFloat AS ObjectFloat_CountForWeight
                                       ON ObjectFloat_CountForWeight.ObjectId = tmpMI.GoodsId
                                      AND ObjectFloat_CountForWeight.DescId   = zc_ObjectFloat_Goods_CountForWeight()
                                     
                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                      ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                     AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                 LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                 LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                      ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                     AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                 LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                                 ON View_InfoMoney.InfoMoneyId            = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20500()) -- Оборотная тара
                 LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_goods ON View_InfoMoney_goods.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
            ORDER BY Object_Goods.ValueData
                   , Object_GoodsKind.ValueData
                   -- , ObjectString_Goods_GoodsGroupFull.ValueData
           ;
   ELSE

        --
        CREATE TEMP TABLE _tmpWord_Goods (GoodsId Integer, GoodsKindId_max Integer, WordList TVarChar) ON COMMIT DROP;
        CREATE TEMP TABLE _tmpWord_Split_from (WordList TVarChar) ON COMMIT DROP;
        CREATE TEMP TABLE _tmpWord_Split_to (Ord Integer, Word TVarChar, WordList TVarChar) ON COMMIT DROP;
        --
        INSERT INTO _tmpWord_Goods (GoodsId, GoodsKindId_max, WordList)
           WITH tmpGoods_byName AS
                                -- По Названию - Склад Специй
                               (SELECT Object.Id AS GoodsId
                                     , 0   AS GoodsKindId_max
                                     , ''  AS WordList
                                     , CASE WHEN UPPER (Object.ValueData) = UPPER (inGoodsName) THEN TRUE ELSE FALSE END AS isEqual
                                FROM Object
                                     INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                           ON ObjectLink_Goods_InfoMoney.ObjectId = Object.Id
                                                          AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                     INNER JOIN Object_InfoMoney_View AS View_InfoMoney
                                                                      ON View_InfoMoney.InfoMoneyId            = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                     AND (View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
                                                                                                                  , zc_Enum_InfoMoneyDestination_20100() -- Запчасти и Ремонты
                                                                                                                  , zc_Enum_InfoMoneyDestination_20200() -- Прочие ТМЦ
                                                                                                                  , zc_Enum_InfoMoneyDestination_20300() -- МНМА
                                                                                                                  , zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                                                                                                  , zc_Enum_InfoMoneyDestination_20600() -- Прочие материалы
                                                                                                                  , zc_Enum_InfoMoneyDestination_30500() -- Доходы  + Прочие доходы
                                                                                                                   )
                                                                       OR View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_10105() -- Прочее мясное сырье
                                                                                                       , zc_Enum_InfoMoney_10106() -- Сыр
                                                                                                        )
                                                                         )
                                WHERE inBranchCode BETWEEN 301 AND 310
                                  AND TRIM (inGoodsName)  <> ''
                                  AND Object.DescId = zc_Object_Goods() AND Object.isErased = FALSE
                                  AND Object.ValueData ILIKE ('%' || TRIM (inGoodsName) || '%')
                               )
            -- Результат
            SELECT DISTINCT ObjectLink_GoodsListSale_Goods.ChildObjectId AS GoodsId
                 , COALESCE (ObjectLink_GoodsListSale_GoodsKind.ChildObjectId, zc_Enum_GoodsKind_Main()) AS GoodsKindId_max
                 , COALESCE (ObjectString_GoodsKind.ValueData, zc_Enum_GoodsKind_Main() :: TVarChar)       AS WordList
            FROM Object AS Object_GoodsListSale
                 INNER JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                       ON ObjectLink_GoodsListSale_Partner.ObjectId      = Object_GoodsListSale.Id
                                      AND ObjectLink_GoodsListSale_Partner.DescId        = zc_ObjectLink_GoodsListSale_Partner()
                                      -- !!!ограничение по контрагенту!!!
                                      AND ObjectLink_GoodsListSale_Partner.ChildObjectId = CASE WHEN inMovementId < 0 THEN -1 * inMovementId END :: Integer
                 INNER JOIN ObjectLink AS ObjectLink_GoodsListSale_Contract
                                       ON ObjectLink_GoodsListSale_Contract.ObjectId      = Object_GoodsListSale.Id
                                      AND ObjectLink_GoodsListSale_Contract.DescId        = zc_ObjectLink_GoodsListSale_Contract()
                                      -- !!!ограничение по договору!!!
                                      AND ObjectLink_GoodsListSale_Contract.ChildObjectId = CASE WHEN inOrderExternalId < 0 THEN -1 * inOrderExternalId ELSE ObjectLink_GoodsListSale_Contract.ChildObjectId END :: Integer
                 LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                      ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                                     AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                 LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_GoodsKind
                                      ON ObjectLink_GoodsListSale_GoodsKind.ObjectId = Object_GoodsListSale.Id
                                     AND ObjectLink_GoodsListSale_GoodsKind.DescId = zc_ObjectLink_GoodsListSale_GoodsKind()
                 LEFT JOIN ObjectString AS ObjectString_GoodsKind
                                        ON ObjectString_GoodsKind.ObjectId = Object_GoodsListSale.Id
                                       AND ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind()
                                       AND ObjectString_GoodsKind.ValueData <> '0'
            WHERE Object_GoodsListSale.DescId   = zc_Object_GoodsListSale()
              AND Object_GoodsListSale.isErased = FALSE
           UNION ALL
            -- Поставщики - Склад Специй
            SELECT DISTINCT ObjectLink_GoodsListIncome_Goods.ChildObjectId AS GoodsId
                 , 0   AS GoodsKindId_max
                 , ''  AS WordList
            FROM Object AS Object_GoodsListIncome
                 INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Partner
                                       ON ObjectLink_GoodsListIncome_Partner.ObjectId      = Object_GoodsListIncome.Id
                                      AND ObjectLink_GoodsListIncome_Partner.DescId        = zc_ObjectLink_GoodsListIncome_Partner()
                                      -- !!!ограничение по контрагенту!!!
                                      AND ObjectLink_GoodsListIncome_Partner.ChildObjectId = CASE WHEN inMovementId < 0 THEN -1 * inMovementId END :: Integer
                 INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Contract
                                       ON ObjectLink_GoodsListIncome_Contract.ObjectId      = Object_GoodsListIncome.Id
                                      AND ObjectLink_GoodsListIncome_Contract.DescId        = zc_ObjectLink_GoodsListIncome_Contract()
                                      -- !!!ограничение по договору!!!
                                      -- AND ObjectLink_GoodsListIncome_Contract.ChildObjectId = CASE WHEN inOrderExternalId < 0 THEN -1 * inOrderExternalId ELSE ObjectLink_GoodsListIncome_Contract.ChildObjectId END :: Integer
                 LEFT JOIN ObjectLink AS ObjectLink_GoodsListIncome_Goods
                                      ON ObjectLink_GoodsListIncome_Goods.ObjectId = Object_GoodsListIncome.Id
                                     AND ObjectLink_GoodsListIncome_Goods.DescId   = zc_ObjectLink_GoodsListIncome_Goods()
            WHERE Object_GoodsListIncome.DescId   = zc_Object_GoodsListIncome()
              AND Object_GoodsListIncome.isErased = FALSE
              AND inBranchCode                    BETWEEN 301 AND 310
           UNION ALL
            -- Перемещение - Склад Специй
            SELECT DISTINCT MovementItem.ObjectId AS GoodsId
                 , 0   AS GoodsKindId_max
                 , ''  AS WordList
            FROM Movement
                 INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                              AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                              AND MovementLinkObject_From.ObjectId   IN (8447, 8448, 8449) -- ЦЕХ колбасный + ЦЕХ деликатесов + ЦЕХ с/к
                 INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                              AND MovementLinkObject_To.ObjectId   = MovementLinkObject_From.ObjectId
                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.Amount     <> 0
                                        AND MovementItem.isErased   = FALSE
                 INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                       ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                      AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                 INNER JOIN Object_InfoMoney_View AS View_InfoMoney
                                                  ON View_InfoMoney.InfoMoneyId            = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                 AND (View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
                                                                                              , zc_Enum_InfoMoneyDestination_20100() -- Запчасти и Ремонты
                                                                                              , zc_Enum_InfoMoneyDestination_20200() -- Прочие ТМЦ
                                                                                              , zc_Enum_InfoMoneyDestination_20300() -- МНМА
                                                                                              , zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                                                                              , zc_Enum_InfoMoneyDestination_20600() -- Прочие материалы
                                                                                              , zc_Enum_InfoMoneyDestination_30500() -- Доходы  + Прочие доходы
                                                                                               )
                                                   OR View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_10105() -- Прочее мясное сырье
                                                                                   , zc_Enum_InfoMoney_10106() -- Сыр
                                                                                    )
                                                     )
            WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '3 DAY' AND CURRENT_DATE + INTERVAL '1 DAY'
              AND Movement.DescId = zc_Movement_OrderInternal()
              AND Movement.StatusId = zc_Enum_Status_Complete()
              AND inBranchCode                  BETWEEN 301 AND 310
              AND inMovementId                  = 0
           UNION ALL
            -- Цех Упаковки + ЦЕХ колбасный + ЦЕХ деликатесов + ЦЕХ копчения - втулки
            SELECT DISTINCT Object_Goods.Id AS GoodsId
                 , 0   AS GoodsKindId_max
                 , ''  AS WordList
            FROM Object AS Object_Goods
                 INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                       ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                      AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                 INNER JOIN Object_InfoMoney_View AS View_InfoMoney
                                                  ON View_InfoMoney.InfoMoneyId            = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                 AND (View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
                                                                                               )
                                                  AND View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_10202() -- Оболочка
                                                                                   , zc_Enum_InfoMoney_10203() -- Упаковка
                                                                                    )
                                                     )
            WHERE Object_Goods.DescId = zc_Object_Goods()
              AND inBranchCode IN (1, 102, 103)
           UNION ALL
            -- Производство - (201-210)Сырье
            SELECT DISTINCT Object_Goods.Id AS GoodsId
                 , 0   AS GoodsKindId_max
                 , ''  AS WordList
            FROM Object AS Object_Goods
                 INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                       ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                      AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                 INNER JOIN Object_InfoMoney_View AS View_InfoMoney
                                                  ON View_InfoMoney.InfoMoneyId            = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                 AND (View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
                                                                                               )
                                                  AND View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_10201() -- Специи
                                                                                   , zc_Enum_InfoMoney_10202() -- Оболочка
                                                                                   , zc_Enum_InfoMoney_10203() -- Упаковка
                                                                                    )
                                                     )
            WHERE Object_Goods.DescId = zc_Object_Goods()
              AND inBranchCode BETWEEN 201 AND 210
           UNION ALL
            -- По коду - Склад Специй
            SELECT vbGoodsId AS GoodsId
                 , 0   AS GoodsKindId_max
                 , ''  AS WordList
            WHERE inBranchCode BETWEEN 301 AND 310
              AND vbGoodsId    <> 0
           UNION ALL
            -- По Названию - Склад Специй
            SELECT tmpGoods_byName.GoodsId
                 , 0   AS GoodsKindId_max
                 , ''  AS WordList
            FROM tmpGoods_byName
            WHERE tmpGoods_byName.isEqual = TRUE
           UNION ALL
            -- По Названию - Склад Специй
            SELECT tmpGoods_byName.GoodsId
                 , 0   AS GoodsKindId_max
                 , ''  AS WordList
            FROM tmpGoods_byName
            WHERE NOT EXISTS (SELECT 1 FROM tmpGoods_byName WHERE tmpGoods_byName.isEqual = TRUE)
           ;
    
        --
        INSERT INTO _tmpWord_Split_from (WordList)
           SELECT DISTINCT _tmpWord_Goods.WordList FROM _tmpWord_Goods WHERE inOrderExternalId < 0 OR inBranchCode BETWEEN 301 AND 310;
    
        -- RAISE EXCEPTION '<%>   <%> ', (select count(* ) from _tmpWord_Goods), (select count(* ) from _tmpWord_Split_from);
    
    
        --
        inMovementId:= COALESCE (inMovementId, 0);
        -- Результат - все товары
        RETURN QUERY
           WITH tmpRemains AS (SELECT Container.ObjectId     AS GoodsId
                                     , SUM (Container.Amount) AS Amount
                                 FROM Container
                                      INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                     ON CLO_Unit.ContainerId = Container.Id
                                                                    AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                    AND CLO_Unit.ObjectId IN (2961184 -- Склад спецодежда б/у
                                                                                            , 8455    -- Склад специй
                                                                                            , 3398383 -- Склад резины
                                                                                            , 8456    -- Склад запчастей
                                                                                             )
                                 WHERE Container.DescId = zc_Container_Count()
                                   AND Container.Amount <> 0
                                   AND inBranchCode BETWEEN 301 AND 310
                                 GROUP BY Container.ObjectId
                                )
              , tmpInfoMoney AS (SELECT View_InfoMoney.InfoMoneyDestinationId, View_InfoMoney.InfoMoneyId, FALSE AS isTare
                                      , View_InfoMoney.InfoMoneyCode
                                      , View_InfoMoney.InfoMoneyGroupName
                                      , View_InfoMoney.InfoMoneyDestinationName
                                      , View_InfoMoney.InfoMoneyName
                                 FROM Object_InfoMoney_View AS View_InfoMoney
                                 WHERE inIsGoodsComplete = TRUE
                                   AND inBranchCode NOT BETWEEN 301 AND 310
                                   AND (View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901() -- Ирна + Ирна
                                                                     , zc_Enum_InfoMoney_30101() -- Доходы + Готовая продукция
                                                                     , zc_Enum_InfoMoney_30102() -- Доходы + Тушенка
                                                                     , zc_Enum_InfoMoney_30103() -- Доходы + Хлеб
                                                                     , zc_Enum_InfoMoney_30201() -- Доходы + Мясное сырье
                                                                      )
                                   OR View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
                                                                               )
                                     )
                                UNION
                                 SELECT View_InfoMoney.InfoMoneyDestinationId, View_InfoMoney.InfoMoneyId, FALSE AS isTare
                                      , View_InfoMoney.InfoMoneyCode
                                      , View_InfoMoney.InfoMoneyGroupName
                                      , View_InfoMoney.InfoMoneyDestinationName
                                      , View_InfoMoney.InfoMoneyName
                                 FROM Object_InfoMoney_View AS View_InfoMoney
                                 WHERE /*(inIsGoodsComplete = FALSE
                                     OR inBranchCode IN (103)
                                       )
                                AND*/ inBranchCode NOT BETWEEN 301 AND 310
                                   AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                                                               , zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
                                                                                )
                                UNION
                                 SELECT View_InfoMoney.InfoMoneyDestinationId, View_InfoMoney.InfoMoneyId, FALSE AS isTare
                                      , View_InfoMoney.InfoMoneyCode
                                      , View_InfoMoney.InfoMoneyGroupName
                                      , View_InfoMoney.InfoMoneyDestinationName
                                      , View_InfoMoney.InfoMoneyName
                                 FROM Object_InfoMoney_View AS View_InfoMoney
                                 WHERE inBranchCode NOT BETWEEN 301 AND 310
                                 --AND inIsGoodsComplete = FALSE
                                   AND View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_10204() -- Основное сырье + Прочее сырье
                                                                     )
                                UNION
                                 SELECT View_InfoMoney.InfoMoneyDestinationId, View_InfoMoney.InfoMoneyId, CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() THEN TRUE ELSE FALSE END AS isTare
                                      , View_InfoMoney.InfoMoneyCode
                                      , View_InfoMoney.InfoMoneyGroupName
                                      , View_InfoMoney.InfoMoneyDestinationName
                                      , View_InfoMoney.InfoMoneyName
                                 FROM Object_InfoMoney_View AS View_InfoMoney
                                 WHERE View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20500() -- Общефирменные + Оборотная тара
                                                                               , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные + Прочие материалы
                                                                               , zc_Enum_InfoMoneyDestination_30500() -- Доходы  + Прочие доходы
                                                                                )
                                   AND inBranchCode NOT BETWEEN 301 AND 310
    
                                UNION
                                 SELECT View_InfoMoney.InfoMoneyDestinationId, View_InfoMoney.InfoMoneyId, FALSE AS isTare
                                      , View_InfoMoney.InfoMoneyCode
                                      , View_InfoMoney.InfoMoneyGroupName
                                      , View_InfoMoney.InfoMoneyDestinationName
                                      , View_InfoMoney.InfoMoneyName
                                 FROM Object_InfoMoney_View AS View_InfoMoney
                                 WHERE inBranchCode BETWEEN 301 AND 310
                                   AND (View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
                                                                                , zc_Enum_InfoMoneyDestination_20200() -- Прочие ТМЦ
                                                                                , zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                                                                , zc_Enum_InfoMoneyDestination_20600() -- Прочие материалы
                                                                                , zc_Enum_InfoMoneyDestination_30500() -- Доходы  + Прочие доходы
                                                                                 )
                                     OR View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_10105() -- Прочее мясное сырье
                                                                     , zc_Enum_InfoMoney_10106() -- Сыр
                                                                       )
                                       )
                                UNION
                                 SELECT View_InfoMoney.InfoMoneyDestinationId, View_InfoMoney.InfoMoneyId, FALSE AS isTare
                                      , View_InfoMoney.InfoMoneyCode
                                      , View_InfoMoney.InfoMoneyGroupName
                                      , View_InfoMoney.InfoMoneyDestinationName
                                      , View_InfoMoney.InfoMoneyName
                                 FROM Object_InfoMoney_View AS View_InfoMoney
                                 -- Цех Упаковки + ЦЕХ колбасный + ЦЕХ деликатесов + ЦЕХ копчения - втулки
                                 WHERE inBranchCode IN (1, 102)
                                   AND (View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
                                                                                 )
                                    AND View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_10202() -- Оболочка
                                                                     , zc_Enum_InfoMoney_10203() -- Упаковка
                                                                      )
                                       )
                                UNION
                                 SELECT View_InfoMoney.InfoMoneyDestinationId, View_InfoMoney.InfoMoneyId, FALSE AS isTare
                                      , View_InfoMoney.InfoMoneyCode
                                      , View_InfoMoney.InfoMoneyGroupName
                                      , View_InfoMoney.InfoMoneyDestinationName
                                      , View_InfoMoney.InfoMoneyName
                                 FROM Object_InfoMoney_View AS View_InfoMoney
                                 -- Цех Тушенки
                                 WHERE inBranchCode IN (103)
                                   AND (View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
                                                                                 )
                                    AND View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_10201() -- Специи
                                                                     , zc_Enum_InfoMoney_10202() -- Оболочка
                                                                     , zc_Enum_InfoMoney_10203() -- Упаковка
                                                                      )
                                       )
                                UNION
                                 SELECT View_InfoMoney.InfoMoneyDestinationId, View_InfoMoney.InfoMoneyId, FALSE AS isTare
                                      , View_InfoMoney.InfoMoneyCode
                                      , View_InfoMoney.InfoMoneyGroupName
                                      , View_InfoMoney.InfoMoneyDestinationName
                                      , View_InfoMoney.InfoMoneyName
                                 FROM Object_InfoMoney_View AS View_InfoMoney
                                 -- Производство - (201-210)Сырье
                                 WHERE inBranchCode BETWEEN 201 AND 210
                                   AND (View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
                                                                                 )
                                    AND View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_10201() -- Специи
                                                                     , zc_Enum_InfoMoney_10202() -- Оболочка
                                                                     , zc_Enum_InfoMoney_10203() -- Упаковка
                                                                      )
                                       )
                                UNION
                                 SELECT View_InfoMoney.InfoMoneyDestinationId, View_InfoMoney.InfoMoneyId, FALSE AS isTare
                                      , View_InfoMoney.InfoMoneyCode
                                      , View_InfoMoney.InfoMoneyGroupName
                                      , View_InfoMoney.InfoMoneyDestinationName
                                      , View_InfoMoney.InfoMoneyName
                                 FROM Object_InfoMoney_View AS View_InfoMoney
                                 WHERE inBranchCode BETWEEN 302 AND 310
                               --WHERE inBranchCode BETWEEN 301 AND 310
                                   AND (View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Запчасти и Ремонты
                                                                                , zc_Enum_InfoMoneyDestination_20200() -- Прочие ТМЦ
                                                                                , zc_Enum_InfoMoneyDestination_20300() -- МНМА
                                                                                 )
                                       )
                                )
          , tmpGoods_Return AS (SELECT tmp.GoodsId
                                     , MAX (tmp.GoodsKindId_max) AS GoodsKindId_max
                                     , MAX (tmp.WordList) AS WordList
                                     , MAX (tmp.GoodsKindName_list) AS GoodsKindName_list
                                FROM
                               (SELECT _tmpWord_Goods.GoodsId
                                     , _tmpWord_Goods.GoodsKindId_max
                                     , _tmpWord_Goods.WordList
                                     , STRING_AGG (Object.ValueData :: TVarChar, ',')  AS GoodsKindName_list
                                FROM _tmpWord_Goods
                                     LEFT JOIN zfSelect_Word_Split (inSep:= ',', inUserId:= vbUserId) AS zfSelect ON zfSelect.WordList = _tmpWord_Goods.WordList
                                     LEFT JOIN Object ON Object.Id = zfSelect.Word :: Integer
                                GROUP BY _tmpWord_Goods.GoodsId
                                       , _tmpWord_Goods.GoodsKindId_max
                                       , _tmpWord_Goods.WordList
                               ) AS tmp
                                GROUP BY tmp.GoodsId
                               )
        , tmpGoods_ScaleCeh AS (SELECT tmp.GoodsId
                                     , STRING_AGG (tmp.GoodsKindId :: TVarChar, ',')   AS GoodsKindId_List
                                     , STRING_AGG (tmp.GoodsKindName, ',')             AS GoodsKindName_List
                                     , ABS (MIN (COALESCE (CASE WHEN tmp.GoodsKindId = zc_GoodsKind_Basis() THEN -1 ELSE 1 END * tmp.GoodsKindId, 0))) AS GoodsKindId_max
                                FROM
                               (SELECT DISTINCT
                                       ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId AS GoodsId
                                     , COALESCE (Object_GoodsKind.Id, 0)               AS GoodsKindId
                                     , COALESCE (Object_GoodsKind.ValueData, '')       AS GoodsKindName
                                FROM ObjectBoolean AS ObjectBoolean_ScaleCeh
                                     INNER JOIN Object AS Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.Id = ObjectBoolean_ScaleCeh.ObjectId AND Object_GoodsByGoodsKind.isErased = FALSE
                                     LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                          ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId = ObjectBoolean_ScaleCeh.ObjectId
                                                         AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                     LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                          ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectBoolean_ScaleCeh.ObjectId
                                                         AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                     LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, zc_Enum_GoodsKind_Main())
                                WHERE ObjectBoolean_ScaleCeh.DescId    IN (zc_ObjectBoolean_GoodsByGoodsKind_ScaleCeh(), zc_ObjectBoolean_GoodsByGoodsKind_Order())
                                  AND ObjectBoolean_ScaleCeh.ValueData = TRUE
                                  AND inMovementId >= 0
                                  AND inBranchCode NOT BETWEEN 301 AND 310
                               ) AS tmp
                                GROUP BY tmp.GoodsId
                               )
          , tmpGoods AS (SELECT Object_Goods.Id                               AS GoodsId
                              , Object_Goods.ObjectCode                       AS GoodsCode
                              , Object_Goods.ValueData                        AS GoodsName
                              , COALESCE (tmpGoods_ScaleCeh.GoodsKindId_list,   COALESCE (tmpGoods_Return.WordList, Object_GoodsKind_Main.Id :: TVarChar))         AS GoodsKindId_list
                              , COALESCE (tmpGoods_ScaleCeh.GoodsKindName_list, COALESCE (tmpGoods_Return.GoodsKindName_list, Object_GoodsKind_Main.ValueData))    AS GoodsKindName_list
                              , COALESCE (tmpGoods_ScaleCeh.GoodsKindId_max,    COALESCE (tmpGoods_Return.GoodsKindId_max, Object_GoodsKind_Main.Id))  AS GoodsKindId_max
                              , tmpInfoMoney.InfoMoneyId
                              , tmpInfoMoney.InfoMoneyDestinationId
                              , tmpInfoMoney.InfoMoneyCode
                              , tmpInfoMoney.InfoMoneyGroupName
                              , tmpInfoMoney.InfoMoneyDestinationName
                              , tmpInfoMoney.InfoMoneyName
                         FROM tmpInfoMoney
                              JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                              ON ObjectLink_Goods_InfoMoney.ChildObjectId = tmpInfoMoney.InfoMoneyId
                                             AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                              JOIN Object AS Object_Goods ON Object_Goods.Id       = ObjectLink_Goods_InfoMoney.ObjectId
                                                         AND Object_Goods.isErased = FALSE
                                                         AND (Object_Goods.ObjectCode <> 0 OR inBranchCode BETWEEN 301 AND 310)
                              LEFT JOIN tmpGoods_ScaleCeh ON tmpGoods_ScaleCeh.GoodsId = Object_Goods.Id
                              LEFT JOIN tmpGoods_Return ON tmpGoods_Return.GoodsId = Object_Goods.Id
                              LEFT JOIN Object AS Object_GoodsKind_Main ON Object_GoodsKind_Main.Id = zc_Enum_GoodsKind_Main()
                         WHERE (tmpGoods_Return.GoodsId > 0
                             OR inBranchCode BETWEEN 302 AND 310
                           --OR inBranchCode BETWEEN 301 AND 310
                             OR (inBranchCode = 301 AND inMovementId >= 0)
                             OR (inMovementId >= 0 AND inBranchCode NOT BETWEEN 301 AND 310)
                             OR tmpInfoMoney.isTare = TRUE
                             OR inBranchCode IN (103)
                               )
                        )
          , tmpPrice1 AS (SELECT tmpGoods.GoodsId
                               , COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) AS Price
                          FROM tmpGoods
                                INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                      ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmpGoods.GoodsId
                                                     AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                                INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                      ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                     AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis()
                                                     AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                     ON ObjectLink_PriceListItem_GoodsKind.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                    AND ObjectLink_PriceListItem_GoodsKind.DescId        = zc_ObjectLink_PriceListItem_GoodsKind()
                                LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                        ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                       AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                       AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
                                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                             ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                            AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                          WHERE ObjectLink_PriceListItem_GoodsKind.ChildObjectId IS NULL
                         )
          , tmpPrice2 AS (SELECT tmpGoods.GoodsId
                               , COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) AS Price
                          FROM tmpGoods
                                INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                      ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmpGoods.GoodsId
                                                     AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                                INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                      ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                     AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis()
                                                     AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                     ON ObjectLink_PriceListItem_GoodsKind.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                    AND ObjectLink_PriceListItem_GoodsKind.DescId        = zc_ObjectLink_PriceListItem_GoodsKind()
                                LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                        ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                       AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                       AND (inOperDate - (inDayPrior_PriceReturn :: TVarChar || ' DAY') :: INTERVAL) >= ObjectHistory_PriceListItem.StartDate
                                                       AND (inOperDate - (inDayPrior_PriceReturn :: TVarChar || ' DAY') :: INTERVAL) < ObjectHistory_PriceListItem.EndDate
                                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                             ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                            AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                          WHERE ObjectLink_PriceListItem_GoodsKind.ChildObjectId IS NULL
                         )
          , tmpChangePercentAmount AS
                         (SELECT tmpGoods.GoodsId
                               -- , COALESCE (ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId, zc_GoodsKind_Basis()) AS GoodsKindId
                               , MAX (COALESCE (ObjectFloat_ChangePercentAmount.ValueData, 0)) AS ChangePercentAmount
                          FROM tmpGoods
                               INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                     ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = tmpGoods.GoodsId
                                                    AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                               LEFT JOIN ObjectFloat AS ObjectFloat_ChangePercentAmount
                                                     ON ObjectFloat_ChangePercentAmount.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                    AND ObjectFloat_ChangePercentAmount.DescId   = zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount()
                          GROUP BY tmpGoods.GoodsId
                                 -- , COALESCE (ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId, zc_GoodsKind_Basis())
                         )
           -- Результат
           SELECT ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                , tmpGoods.GoodsId            AS GoodsId
                , tmpGoods.GoodsCode          AS GoodsCode
                , tmpGoods.GoodsName          AS GoodsName
                , 0                           AS GoodsKindId
                , 0                           AS GoodsKindCode
                , tmpGoods.GoodsKindName_list :: TVarChar AS GoodsKindName
                , tmpGoods.GoodsKindId_list   :: TVarChar AS GoodsKindId_list
                , tmpGoods.GoodsKindId_max    :: Integer  AS GoodsKindId_max
                , Object_GoodsKind_max.ObjectCode         AS GoodsKindCode_max
                , Object_GoodsKind_max.ValueData          AS GoodsKindName_max
                , Object_Measure.Id           AS MeasureId
                , Object_Measure.ValueData    AS MeasureName
                , CASE WHEN tmpGoods.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30300() THEN 0 -- Доходы + Переработка
                       WHEN Object_Measure.Id = zc_Measure_Kg()
                            THEN CASE WHEN inIsGoodsComplete = FALSE -- AND zc_Movement_Sale() = (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementDesc())
                                           THEN 0 -- COALESCE (tmpChangePercentAmount.ChangePercentAmount, 0)
                                      WHEN inIsGoodsComplete = FALSE
                                           THEN 0
                                      ELSE 1
                                 END
                       ELSE 0
                  END :: TFloat AS ChangePercentAmount

                 , tmpRemains.Amount :: TFloat AS Amount_Remains

                , 0 :: TFloat AS Amount_Order
                , 0 :: TFloat AS Amount_OrderWeight
                , 0 :: TFloat AS Amount_Weighing
                , 0 :: TFloat AS Amount_WeighingWeight
                , 0 :: TFloat AS Amount_diff
                , 0 :: TFloat AS Amount_diffWeight
                , FALSE :: Boolean AS isTax_diff
                , lfObjectHistory_PriceListItem.Price        :: TFloat AS Price
                , lfObjectHistory_PriceListItem_Return.Price :: TFloat AS Price_Return
                , 1 :: TFloat                 AS CountForPrice
                , 1 :: TFloat                 AS CountForPrice_Return
                , 0                           AS Color_calc -- clBlack
                , 0                           AS MovementId_Promo
                , FALSE                       AS isPromo
                , FALSE                       AS isTare
    
                , CASE WHEN View_InfoMoney.InfoMoneyId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isNotPriceIncome

                , CURRENT_DATE :: TDateTime   AS tmpDate
    
                , ObjectFloat_Weight.ValueData         AS Weight
                , ObjectFloat_WeightTare.ValueData     AS WeightTare
                , ObjectFloat_CountForWeight.ValueData AS CountForWeight

                , tmpGoods.InfoMoneyCode
                , tmpGoods.InfoMoneyGroupName
                , tmpGoods.InfoMoneyDestinationName
                , tmpGoods.InfoMoneyName
                , tmpGoods.InfoMoneyId
           FROM tmpGoods
    
                LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpGoods.GoodsId

                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = tmpGoods.GoodsId
                                     AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                LEFT JOIN ObjectFloat AS ObjectFloat_WeightTare
                                      ON ObjectFloat_WeightTare.ObjectId = tmpGoods.GoodsId
                                     AND ObjectFloat_WeightTare.DescId   = zc_ObjectFloat_Goods_WeightTare()
                LEFT JOIN ObjectFloat AS ObjectFloat_CountForWeight
                                      ON ObjectFloat_CountForWeight.ObjectId = tmpGoods.GoodsId
                                     AND ObjectFloat_CountForWeight.DescId   = zc_ObjectFloat_Goods_CountForWeight()

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                      AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
    
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                LEFT JOIN Object AS Object_GoodsKind_max ON Object_GoodsKind_max.Id = tmpGoods.GoodsKindId_max :: Integer
    
                LEFT JOIN tmpChangePercentAmount ON tmpChangePercentAmount.GoodsId     = tmpGoods.GoodsId
    
                LEFT JOIN tmpPrice1 AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = tmpGoods.GoodsId
                LEFT JOIN tmpPrice2 AS lfObjectHistory_PriceListItem_Return ON lfObjectHistory_PriceListItem_Return.GoodsId = tmpGoods.GoodsId
    
                LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                     ON ObjectLink_Goods_InfoMoney.ObjectId = tmpGoods.GoodsId
                                    AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                                ON View_InfoMoney.InfoMoneyId            = ObjectLink_Goods_InfoMoney.ChildObjectId
                                               AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20500()) -- Оборотная тара

           ORDER BY tmpGoods.GoodsName
                  -- , ObjectString_Goods_GoodsGroupFull.ValueData
          ;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.11.15                                        *
 18.01.15                                        *
*/

/*
-- update Object set ValueData = '978932' where Id in (
-- select * from Object where Id in (

-- select Id
 select *
from gpSelect_Object_ToolsWeighing (inSession := '5') as a
where (namefull  like '%ScaleCeh_201 Movement%'  or namefull  like '%Scale_201 Movement%' )
   and Name = 'GoodsKindWeighingGroupId'
-- )
*/

-- тест
-- SELECT * FROM gpSelect_Scale_Goods (inIsGoodsComplete:= TRUE, inOperDate:= CURRENT_DATE, inMovementId:= -79137, inOrderExternalId:= 0, inPriceListId:=0, inGoodsCode:= 0, inGoodsName:= '', inDayPrior_PriceReturn:= 10, inBranchCode:= 1, inSession:=zfCalc_UserAdmin()) WHERE GoodsCode = 901
