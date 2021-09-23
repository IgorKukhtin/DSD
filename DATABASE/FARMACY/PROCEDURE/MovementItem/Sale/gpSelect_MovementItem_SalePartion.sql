-- Function: gpSelect_MovementItem_SalePartion()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_SalePartion (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SalePartion(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- Показать все
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer
             , Remains TFloat
             , PriceWithVAT TFloat, SummWithVAT TFloat
             , PriceWithOutVAT TFloat, SummWithOutVAT TFloat
             , PriseSale TFloat
             , SummSale TFloat
             , ChargePersent TFloat
             , FromName TVarChar
             , SummOut TFloat, Margin TFloat, MarginPercent TFloat
             , NDS TFloat
             , OperDate TDateTime
             , InvNumber TVarChar
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется подразделение
    SELECT
        Movement_Sale.UnitId
       ,Movement_Sale.StatusId
    INTO
        vbUnitId
       ,vbStatusId
    FROM
        Movement_Sale_View AS Movement_Sale
    WHERE
        Movement_Sale.Id = inMovementId;

    -- Результат
    IF vbStatusId <> zc_Enum_Status_Complete() THEN
        -- Результат такой
        IF inShowAll THEN
            RETURN QUERY
                WITH
                    tmpMovementItemContainer AS (SELECT MovementItemContainer.ContainerID        AS Id
                                                      , SUM(-MovementItemContainer.Amount)       AS Amount
                                                 FROM  MovementItemContainer
                                                 WHERE MovementItemContainer.MovementId = inMovementId
                                                   AND vbStatusId = zc_Enum_Status_UnComplete()
                                                 GROUP BY MovementItemContainer.ContainerID
                                                 )
                   ,tmpRemainsAll AS(
                                    SELECT
                                         Container.Id
                                       , Container.ObjectId
                                       , Container.Amount
                                    FROM Container
                                    WHERE Container.DescId = zc_Container_Count()
                                      AND Container.WhereObjectId = vbUnitId
                                      AND Container.Amount > 0
                                 )
                   ,tmpRemains AS(
                                    SELECT
                                         Container.Id
                                       , Container.ObjectId
                                       , Container.Amount + COALESCE (tmpMovementItemContainer.Amount, 0) AS Amount
                                    FROM tmpRemainsAll AS Container
                                         LEFT JOIN tmpMovementItemContainer ON tmpMovementItemContainer.ID = Container.Id
                                    WHERE (Container.Amount + COALESCE (tmpMovementItemContainer.Amount, 0)) > 0
                                 )
                  ,tmpRemainsPrice AS (SELECT tmpRemains.*
                                             , COALESCE (MI_Income_find.Id,MI_Income.Id)                    AS IncomeId
                                             , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)    AS MovementId
                                             , MIFloat_Price.ValueData                                      AS Price
                                        FROM
                                            tmpRemains

                                            LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                          ON ContainerLinkObject_MovementItem.Containerid = tmpRemains.Id
                                                                         AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                            LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                            -- элемент прихода
                                            LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                            -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                        ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                            -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                            LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                        ON MIFloat_Price.MovementItemId = MI_Income.Id
                                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 )
                  ,tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                                       , ObjectFloat_NDSKind_NDS.ValueData
                                  FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                 )


                  ,tmpRemainsPartion AS (SELECT tmpRemains.*
                                               , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = TRUE
                                                 THEN  tmpRemains.Price
                                                 ELSE (tmpRemains.Price * (1 + ObjectFloat_NDSKind_NDS.ValueData/100))::TFloat
                                                 END::TFloat AS PriceWithVAT
                                               , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = FALSE
                                                 THEN  tmpRemains.Price
                                                 ELSE (tmpRemains.Price / (1 + ObjectFloat_NDSKind_NDS.ValueData/100))::TFloat
                                                 END::TFloat AS PriceWithOutVAT
                                               , ObjectFloat_NDSKind_NDS.ValueData AS NDS
                                        FROM
                                            tmpRemainsPrice AS tmpRemains

                                            LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = tmpRemains.ObjectId
                                            LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId


                                            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                                      ON MovementBoolean_PriceWithVAT.MovementId = tmpRemains.MovementId
                                                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                            LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                                            ON MovementBoolean_UseNDSKind.MovementId = tmpRemains.MovementId
                                                                           AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                                            LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                                         ON MovementLinkObject_NDSKind.MovementId = tmpRemains.MovementId
                                                                        AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                            LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                                 ON ObjectFloat_NDSKind_NDS.ObjectId = CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                                                                                              OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                                                                                             THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END

                                          )
                   ,tmpRemainsInfo AS (SELECT tmpRemains.ObjectId            AS GoodsId
                                            , SUM(tmpRemains.Amount)::TFloat AS Amount
                                            , tmpRemains.PriceWithVAT        AS PriceWithVAT
                                            , tmpRemains.PriceWithOutVAT      AS PriceWithOutVAT
                                            , MLO_From.ObjectId              AS JuridicalId
                                            , tmpRemains.NDS                 AS NDS
                                            , tmpRemains.MovementId          AS MovementId
                                        FROM
                                            tmpRemainsPartion AS tmpRemains

                                            LEFT OUTER JOIN MovementLinkObject AS MLO_From
                                                                               ON MLO_From.MovementId = tmpRemains.MovementId
                                                                              AND MLO_From.DescId = zc_MovementLinkObject_From()
                                        GROUP BY tmpRemains.ObjectId
                                               , tmpRemains.PriceWithVAT
                                               , tmpRemains.PriceWithOutVAT
                                               , MLO_From.ObjectId
                                               , tmpRemains.NDS
                                               , tmpRemains.MovementId
                                      )

                  , tmpPrice AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                              AND ObjectFloat_Goods_Price.ValueData > 0
                                             THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                             ELSE ROUND (Price_Value.ValueData, 2)
                                        END :: TFloat                           AS Price
                                      , Price_Goods.ChildObjectId               AS GoodsId
                                 FROM ObjectLink AS ObjectLink_Price_Unit
                                    LEFT JOIN ObjectLink AS Price_Goods
                                                         ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                        AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                    LEFT JOIN ObjectFloat AS Price_Value
                                                          ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                         AND Price_Value.DescId = zc_ObjectFloat_Price_Value()

                                    -- Фикс цена для всей Сети
                                    LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                           ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                          AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                                    LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                            ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                           AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                                 WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                   AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                                 )


                SELECT
                     tmpRemainsInfo.GoodsId
                   , tmpRemainsInfo.Amount
                   , tmpRemainsInfo.PriceWithVAT
                   , ROUND(tmpRemainsInfo.Amount * tmpRemainsInfo.PriceWithVAT,2)::TFloat AS SummWithVAT
                   , tmpRemainsInfo.PriceWithOutVAT
                   , ROUND(tmpRemainsInfo.Amount * tmpRemainsInfo.PriceWithOutVAT,2)::TFloat AS SummWithOutVAT
                   , tmpPrice.Price :: TFloat AS PriseSale
                   , (tmpRemainsInfo.Amount * tmpPrice.Price) :: TFloat AS SummSale
                   , CASE WHEN COALESCE (tmpRemainsInfo.PriceWithVAT,0) <> 0 THEN (tmpPrice.Price - tmpRemainsInfo.PriceWithVAT) *100 / tmpRemainsInfo.PriceWithVAT ELSE 0 END :: TFloat AS ChargePersent
                   , Object_Juridical.ValueData
                   , NULL::TFloat AS SummOut
                   , NULL::TFloat AS Margin
                   , NULL::TFloat AS MarginPercent
                   , tmpRemainsInfo.NDS ::TFloat

                   , Movement.OperDate
                   , Movement.InvNumber
                FROM
                    tmpRemainsInfo
                    LEFT OUTER JOIN Object AS Object_Juridical
                                           ON Object_Juridical.Id = tmpRemainsInfo.JuridicalId
                    LEFT JOIN Movement ON Movement.Id = tmpRemainsInfo.MovementId

                    LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpRemainsInfo.GoodsId
                    ;
        ELSE
            RETURN QUERY
                WITH
                    tmpSale AS (SELECT
                                    MovementItem.ObjectId
                                FROM
                                    MovementItem
                                WHERE
                                    MovementItem.MovementId = inMovementId
                                    AND
                                    MovementItem.DescId = zc_MI_Master()
                               )
                  , tmpMovementItemContainer AS (SELECT MovementItemContainer.ContainerID        AS Id
                                                      , SUM(-MovementItemContainer.Amount)       AS Amount
                                                 FROM  MovementItemContainer
                                                 WHERE MovementItemContainer.MovementId = inMovementId
                                                   AND vbStatusId = zc_Enum_Status_UnComplete()
                                                 GROUP BY MovementItemContainer.ContainerID
                                                 )
                  , tmpRemains AS(SELECT
                                      Container.Id                                                     AS ContainerId
                                     ,Container.ObjectId                                               AS GoodsId
                                     ,Container.Amount + COALESCE (tmpMovementItemContainer.Amount, 0) AS Amount
                                  FROM Container
                                       LEFT JOIN tmpMovementItemContainer ON tmpMovementItemContainer.ID = Container.Id
                                  WHERE Container.ObjectId in (SELECT DISTINCT tmpSale.ObjectId FROM tmpSale)
                                    AND Container.DescId = zc_Container_Count()
                                    AND Container.WhereObjectId = vbUnitId
                                    AND (Container.Amount + COALESCE (tmpMovementItemContainer.Amount, 0)) > 0
                                 )
                  , tmpRemainsInfoAll AS (
                                 SELECT
                                      tmpRemains.ContainerId
                                    , tmpRemains.GoodsId
                                    , tmpRemains.Amount
                                    , CASE WHEN MovementBoolean_PriceWithVAT.ValueData THEN  MIFloat_Price.ValueData
                                         ELSE (MIFloat_Price.ValueData * (1 + Movement_Income.NDS/100))::TFloat END AS PriceWithVAT

                                    , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = FALSE
                                      THEN  MIFloat_Price.ValueData
                                      ELSE (MIFloat_Price.ValueData / (1 + ObjectFloat_NDSKind_NDS.ValueData/100))::TFloat
                                      END::TFloat AS PriceWithOutVAT

                                    , MovementLinkObject_From.ObjectId        AS JuridicalId
                                    , ObjectFloat_NDSKind_NDS.ValueData       AS NDS
                                    , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)  AS MovementId

                                 FROM
                                     tmpRemains

                                     LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                   ON ContainerLinkObject_MovementItem.Containerid = tmpRemains.ContainerId
                                                                  AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                     LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                     -- элемент прихода
                                     LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                     -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                     LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                 ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                     -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                     LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                                     LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = tmpRemains.GoodsId
                                     LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

                                     LEFT JOIN Movement_Income_View AS Movement_Income ON Movement_Income.Id = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)

                                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                 ON MIFloat_Price.MovementItemId =  COALESCE (MI_Income_find.Id,MI_Income.Id)
                                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()

                                     LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                               ON MovementBoolean_PriceWithVAT.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                              AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                     LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                                     ON MovementBoolean_UseNDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                                    AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                                  ON MovementLinkObject_NDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                                 AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                     LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                           ON ObjectFloat_NDSKind_NDS.ObjectId = CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                                                                                        OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                                                                                      THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END
                                                          AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 )
                  , tmpRemainsInfo AS (
                                 SELECT
                                      tmpRemainsInfoAll.GoodsId
                                    , Sum(tmpRemainsInfoAll.Amount)::TFloat           AS Amount
                                    , tmpRemainsInfoAll.PriceWithVAT
                                    , SUM((tmpRemainsInfoAll.Amount
                                         *tmpRemainsInfoAll.PriceWithVAT))::TFloat    AS SummWithVAT

                                    , tmpRemainsInfoAll.PriceWithOutVAT

                                    , tmpRemainsInfoAll.JuridicalId
                                    , tmpRemainsInfoAll.NDS
                                    , tmpRemainsInfoAll.MovementId

                                 FROM
                                     tmpRemainsInfoAll

                                 GROUP BY
                                          tmpRemainsInfoAll.GoodsId
                                        , tmpRemainsInfoAll.PriceWithVAT
                                        , tmpRemainsInfoAll.PriceWithOutVAT
                                        , tmpRemainsInfoAll.JuridicalId
                                        , tmpRemainsInfoAll.NDS
                                        , tmpRemainsInfoAll.MovementId
                                 )

                  , tmpPrice AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                              AND ObjectFloat_Goods_Price.ValueData > 0
                                             THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                             ELSE ROUND (Price_Value.ValueData, 2)
                                        END :: TFloat                           AS Price
                                      , Price_Goods.ChildObjectId               AS GoodsId
                                 FROM ObjectLink AS ObjectLink_Price_Unit
                                    LEFT JOIN ObjectLink AS Price_Goods
                                                         ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                        AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                    INNER JOIN (SELECT DISTINCT tmpRemainsInfo.GoodsId FROM tmpRemainsInfo) AS tmpRemainsInfo ON tmpRemainsInfo.GoodsId = Price_Goods.ChildObjectId

                                    LEFT JOIN ObjectFloat AS Price_Value
                                                          ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                         AND Price_Value.DescId = zc_ObjectFloat_Price_Value()

                                    -- Фикс цена для всей Сети
                                    LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                           ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                          AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                                    LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                            ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                           AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                                 WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                   AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                                 )

                SELECT
                     tmpRemainsInfo.GoodsId
                   , tmpRemainsInfo.Amount
                   , tmpRemainsInfo.PriceWithVAT
                   , ROUND(tmpRemainsInfo.Amount * tmpRemainsInfo.PriceWithVAT,2)::TFloat AS SummWithVAT
                   , tmpRemainsInfo.PriceWithOutVAT
                   , ROUND(tmpRemainsInfo.Amount * tmpRemainsInfo.PriceWithOutVAT,2)::TFloat AS SummWithOutVAT

                   , tmpPrice.Price :: TFloat AS PriseSale
                   , (tmpRemainsInfo.Amount * tmpPrice.Price) :: TFloat AS SummSale
                   , CASE WHEN COALESCE (tmpRemainsInfo.PriceWithVAT,0) <> 0 THEN (tmpPrice.Price - tmpRemainsInfo.PriceWithVAT) *100 / tmpRemainsInfo.PriceWithVAT ELSE 0 END :: TFloat AS ChargePersent

                   , Object_Juridical.ValueData
                   , NULL::TFloat AS SummOut
                   , NULL::TFloat AS Margin
                   , NULL::TFloat AS MarginPercent
                   , tmpRemainsInfo.NDS ::TFloat

                   , Movement.OperDate
                   , Movement.InvNumber
                FROM
                    tmpRemainsInfo
                    LEFT OUTER JOIN Object AS Object_Juridical
                                           ON Object_Juridical.Id = tmpRemainsInfo.JuridicalId

                    LEFT JOIN Movement ON Movement.Id = tmpRemainsInfo.MovementId

                    LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpRemainsInfo.GoodsId
                ;

        END IF;
    ELSE
        -- Результат другой
        RETURN QUERY
            WITH
                MIC AS (
                        SELECT
                             MovementItem.ObjectId                  AS GoodsId
                           , MovementItemContainer.ContainerId
                           , (-MovementItemContainer.Amount)::TFloat AS Amount
                           , MIFloat_Price.ValueData AS PriceOut
                        FROM
                            MovementItemContainer
                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = MovementItemContainer.MovementItemId
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            LEFT OUTER JOIN MovementItem AS MovementItem
                                                         ON MovementItem.Id = MovementItemContainer.MovementItemId
                                                        AND MovementItem.DescId =  zc_MI_Master()
                        WHERE
                            MovementItemContainer.MovementId = inMovementId
                            AND
                            MovementItemContainer.DescId = zc_MIContainer_Count()
                       )
              , MIC_InfoFull AS (
                             SELECT
                                  MIC.ContainerId
                                , MIC.GoodsId
                                , MIC.Amount
                                , MIC.PriceOut
                                , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementIncomeId
                                , COALESCE (MI_Income_find.Id,MI_Income.Id)                 AS MIIncomeId

                             FROM
                                 MIC

                                 LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                               ON ContainerLinkObject_MovementItem.Containerid = MIC.ContainerId
                                                              AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                 LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                 -- элемент прихода
                                 LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                 -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                 LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                             ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                            AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                 -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                 LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                             )
              , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                                    , ObjectFloat_NDSKind_NDS.ValueData
                               FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                               WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                               )
              , tmpMLinkObject AS (SELECT * FROM MovementLinkObject 
                                   WHERE MovementId IN (SELECT DISTINCT MIC_InfoFull.MovementIncomeId FROM MIC_InfoFull))
              , MIC_InfoAll AS (
                             SELECT
                                  MIC.ContainerId
                                , MIC.GoodsId
                                , MIC.Amount
                                , MIC.PriceOut
                                , CASE WHEN MovementBoolean_PriceWithVAT.ValueData THEN  MIFloat_Price.ValueData
                                     ELSE (MIFloat_Price.ValueData * (1 + ObjectFloat_NDSKind_NDS.ValueData /100))::TFloat END AS PriceWithVAT

                                , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = FALSE
                                  THEN  MIFloat_Price.ValueData
                                  ELSE (MIFloat_Price.ValueData / (1 + ObjectFloat_NDSKind_NDS.ValueData/100))::TFloat
                                  END::TFloat AS PriceWithOutVAT

                                , MovementLinkObject_From.ObjectId        AS JuridicalId
                                , Object_Juridical.ValueData              AS JuridicalName
                                , ObjectFloat_NDSKind_NDS.ValueData       AS NDS
                                , MIC.MovementIncomeId                    AS MovementId

                             FROM
                                 MIC_InfoFull AS MIC

                                 LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MIC.GoodsId
                                 LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId =  MIC.MIIncomeId
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()

                                 LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                           ON MovementBoolean_PriceWithVAT.MovementId = MIC.MovementIncomeId
                                                          AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                 LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                                 ON MovementBoolean_UseNDSKind.MovementId = MIC.MovementIncomeId
                                                                AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                              ON MovementLinkObject_NDSKind.MovementId = MIC.MovementIncomeId
                                                             AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                 LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                      ON ObjectFloat_NDSKind_NDS.ObjectId = CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                                                                                   OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                                                                                 THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END
                                 LEFT JOIN tmpMLinkObject AS MovementLinkObject_From
                                                           ON MovementLinkObject_From.MovementId = MIC.MovementIncomeId
                                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 LEFT JOIN Object AS Object_Juridical
                                                  ON Object_Juridical.Id = MovementLinkObject_From.ObjectId
                             )
              , MIC_Info AS (
                             SELECT
                                  MIC_InfoAll.GoodsId
                                , Sum(MIC_InfoAll.Amount)::TFloat                 AS Amount
                                , MIC_InfoAll.PriceWithVAT
                                , SUM((MIC_InfoAll.Amount
                                     *MIC_InfoAll.PriceWithVAT))::TFloat          AS SummWithVAT
                                , SUM((MIC_InfoAll.Amount
                                      *MIC_InfoAll.PriceOut))::TFloat             AS SummOut

                                , MIC_InfoAll.PriceWithOutVAT

                                , MIC_InfoAll.JuridicalName
                                , MIC_InfoAll.NDS
                                , MIC_InfoAll.MovementId

                             FROM
                                 MIC_InfoAll
                             GROUP BY
                                      MIC_InfoAll.GoodsId
                                    , MIC_InfoAll.PriceWithVAT
                                    , MIC_InfoAll.PriceWithOutVAT
                                    , MIC_InfoAll.JuridicalName
                                    , MIC_InfoAll.NDS
                                    , MIC_InfoAll.MovementId
                             )
              , tmpPrice AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                          AND ObjectFloat_Goods_Price.ValueData > 0
                                         THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                         ELSE ROUND (Price_Value.ValueData, 2)
                                    END :: TFloat                           AS Price
                                  , Price_Goods.ChildObjectId               AS GoodsId
                             FROM ObjectLink AS ObjectLink_Price_Unit
                                LEFT JOIN ObjectLink AS Price_Goods
                                                     ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                    AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                INNER JOIN (SELECT DISTINCT MIC_Info.GoodsId FROM MIC_Info) AS MIC_Info ON MIC_Info.GoodsId = Price_Goods.ChildObjectId

                                LEFT JOIN ObjectFloat AS Price_Value
                                                      ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND Price_Value.DescId = zc_ObjectFloat_Price_Value()

                                -- Фикс цена для всей Сети
                                LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                       ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                      AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                                LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                        ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                       AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                             WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                               AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                             )
              , tmpMovement AS (SELECT * FROM Movement
                                WHERE Movement.Id IN (SELECT DISTINCT MIC_Info.MovementId FROM MIC_Info))

            --
            SELECT
                 MIC_Info.GoodsId
               , MIC_Info.Amount
               , MIC_Info.PriceWithVAT
               , MIC_Info.SummWithVAT
               , MIC_Info.PriceWithOutVAT
               , (MIC_Info. Amount * MIC_Info.PriceWithOutVAT):: TFloat AS SummWithOutVAT

               , tmpPrice.Price :: TFloat AS PriseSale
               , (MIC_Info.Amount * tmpPrice.Price) :: TFloat AS SummSale
               , CASE WHEN COALESCE (MIC_Info.PriceWithVAT,0) <> 0 THEN (tmpPrice.Price - MIC_Info.PriceWithVAT) *100 / MIC_Info.PriceWithVAT ELSE 0 END :: TFloat AS ChargePersent


               , MIC_Info.JuridicalName
               , MIC_Info.SummOut
               , (MIC_Info.SummOut - MIC_Info.SummWithVAT)::TFloat                                AS Margin
               , CASE WHEN COALESCE(MIC_Info.SummWithVAT,0)<> 0
                     THEN 100*((MIC_Info.SummOut - MIC_Info.SummWithVAT) / MIC_Info.SummWithVAT)
                 END::TFloat                                                                      AS MarginPercent
               , MIC_Info.NDS ::TFloat

               , Movement.OperDate
               , Movement.InvNumber
            FROM
                MIC_Info

                LEFT JOIN tmpMovement AS Movement ON Movement.Id = MIC_Info.MovementId
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MIC_Info.GoodsId
            ;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_MovementItem_SalePartion (Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.   Шаблий О.В.
 19.06.20                                                                         * Оптимизация
 11.05.20                                                                         *               
 21.01.20                                                                         * Оптимизация
 22.11.19         *
 18.01.18         *
 26.12.15                                                          *
*/
-- select * from gpSelect_MovementItem_SalePartion(inMovementId := 19240372   , inShowAll := 'False' ,  inSession := '3');

select * from gpSelect_MovementItem_SalePartion(inMovementId := 23745396 , inShowAll := 'False' ,  inSession := '3');