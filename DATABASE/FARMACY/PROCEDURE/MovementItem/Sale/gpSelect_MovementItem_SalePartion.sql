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
                  ,tmpRemainsIncome AS (SELECT tmpRemains.*
                                             , MI_Income.Id              AS IncomeId
                                             , MI_Income.MovementId      AS MovementId
                                        FROM
                                            tmpRemains
                                            LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                                                ON CLI_MI.ContainerId = tmpRemains.Id
                                                                               AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                            LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId

                                            LEFT OUTER JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode :: Integer
                                 )
                  ,tmpRemainsPrice AS ( SELECT tmpRemains.*
                                             , MIFloat_Price.ValueData     AS Price
                                        FROM
                                            tmpRemainsIncome AS tmpRemains

                                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                        ON MIFloat_Price.MovementItemId = tmpRemains.IncomeId
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

                                            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                                      ON MovementBoolean_PriceWithVAT.MovementId = tmpRemains.MovementId
                                                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                                                     
                                            LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                                         ON MovementLinkObject_NDSKind.MovementId = tmpRemains.MovementId
                                                                        AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                            LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                                 ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                                                 
                                                                 
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
                                      Container.Id
                                     ,Container.ObjectId
                                     ,Container.Amount + COALESCE (tmpMovementItemContainer.Amount, 0) AS Amount
                                  FROM Container 
                                       LEFT JOIN tmpMovementItemContainer ON tmpMovementItemContainer.ID = Container.Id
                                  WHERE Container.ObjectId in (SELECT DISTINCT tmpSale.ObjectId FROM tmpSale)
                                    AND Container.DescId = zc_Container_Count()
                                    AND Container.WhereObjectId = vbUnitId
                                    AND (Container.Amount + COALESCE (tmpMovementItemContainer.Amount, 0)) > 0
                                 )
                  , tmpRemainsInfo AS (SELECT
                                            tmpRemains.ObjectId                   AS GoodsId
                                          , SUM(tmpRemains.Amount)::TFloat        AS Amount
                                          , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = TRUE
                                               THEN  MIFloat_Price.ValueData
                                               ELSE (MIFloat_Price.ValueData * (1 + ObjectFloat_NDSKind_NDS.ValueData/100))::TFloat
                                            END::TFloat AS PriceWithVAT

                                          , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = FALSE
                                                 THEN  MIFloat_Price.ValueData
                                                 ELSE (MIFloat_Price.ValueData / (1 + ObjectFloat_NDSKind_NDS.ValueData/100))::TFloat
                                            END::TFloat AS PriceWithOutVAT

                                          , MLO_From.ObjectId                     AS JuridicalId
                                          , ObjectFloat_NDSKind_NDS.ValueData     AS NDS
                                          , MI_Income.MovementId                  AS MovementId
                                       FROM
                                           tmpRemains
                                           LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                                               ON CLI_MI.ContainerId = tmpRemains.Id
                                                                              AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                           LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                           LEFT OUTER JOIN MovementItem AS MI_Income
                                                                        ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                           LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                                             ON MIFloat_Price.MovementItemId = MI_Income.Id
                                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                           LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                                     ON MovementBoolean_PriceWithVAT.MovementId =  MI_Income.MovementId
                                                                    AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                                        ON MovementLinkObject_NDSKind.MovementId = MI_Income.MovementId
                                                                       AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                           LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                                 ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                                                AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
           
                                           LEFT OUTER JOIN MovementLinkObject AS MLO_From
                                                                              ON MLO_From.MovementId = MI_Income.MovementId
                                                                             AND MLO_From.DescId = zc_MovementLinkObject_From()
                                       GROUP BY
                                            tmpRemains.ObjectId
                                          , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = TRUE
                                               THEN  MIFloat_Price.ValueData
                                               ELSE (MIFloat_Price.ValueData * (1 + ObjectFloat_NDSKind_NDS.ValueData/100))::TFloat
                                            END
                                          , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = FALSE
                                                 THEN  MIFloat_Price.ValueData
                                                 ELSE (MIFloat_Price.ValueData / (1 + ObjectFloat_NDSKind_NDS.ValueData/100))::TFloat
                                            END
                                          , MLO_From.ObjectId
                                          , ObjectFloat_NDSKind_NDS.ValueData
                                          , MI_Income.MovementId
                                          , COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE)
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
                                    INNER JOIN tmpRemainsInfo ON tmpRemainsInfo.GoodsId = Price_Goods.ChildObjectId

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
                            MovementItemContainer.ContainerId
                           ,(-MovementItemContainer.Amount)::TFloat AS Amount
                           ,MIFloat_Price.ValueData AS PriceOut
                        FROM
                            MovementItemContainer
                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = MovementItemContainer.MovementItemId
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                        WHERE
                            MovementItemContainer.MovementId = inMovementId
                            AND
                            MovementItemContainer.DescId = zc_MIContainer_Count()
                       )
              , MIC_Info AS (
                             SELECT
                                 MI_Income.GoodsId
                                ,MIC.Amount
                                ,MI_Income.PriceWithVAT
                                ,SUM((MIC.Amount
                                     *MIC.PriceOut))::TFloat AS SummWithVAT
                                ,SUM((MIC.Amount
                                     *MIC.PriceOut))::TFloat           AS SummOut

                                , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = FALSE
                                  THEN  MI_Income.Price
                                  ELSE (MI_Income.Price / (1 + ObjectFloat_NDSKind_NDS.ValueData/100))::TFloat
                                  END::TFloat AS PriceWithOutVAT

                                ,MLO_From.ObjectId                     AS JuridicalId
                                ,ObjectFloat_NDSKind_NDS.ValueData     AS NDS
                                ,MI_Income.MovementId                  AS MovementId

                             FROM
                                 MIC
                                 LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                                     ON CLI_MI.ContainerId = MIC.ContainerId
                                                                    AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                 LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                 LEFT OUTER JOIN MovementItem_Income_View AS MI_Income
                                                                          ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                 LEFT OUTER JOIN MovementLinkObject AS MLO_From
                                                                    ON MLO_From.MovementId = MI_Income.MovementId
                                                                   AND MLO_From.DescId = zc_MovementLinkObject_From()

                                 LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                           ON MovementBoolean_PriceWithVAT.MovementId =  MI_Income.MovementId
                                                          AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                              ON MovementLinkObject_NDSKind.MovementId = MI_Income.MovementId
                                                             AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                       ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                                      AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
                             GROUP BY
                                  MI_Income.GoodsId
                                , MIC.Amount
                                , MI_Income.PriceWithVAT
                                , MLO_From.ObjectId 
                                , COALESCE(MovementBoolean_PriceWithVAT.ValueData, FALSE)
                                , ObjectFloat_NDSKind_NDS.ValueData
                                , MI_Income.Price
                                , MI_Income.MovementId
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
                                INNER JOIN MIC_Info ON MIC_Info.GoodsId = Price_Goods.ChildObjectId

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


               , Object_Juridical.ValueData
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
                LEFT OUTER JOIN Object AS Object_Juridical
                                       ON Object_Juridical.Id = MIC_Info.JuridicalId

                LEFT JOIN Movement ON Movement.Id = MIC_Info.MovementId
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MIC_Info.GoodsId
            ;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_MovementItem_SalePartion (Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 22.11.19         *
 18.01.18         *
 26.12.15                                                          *
*/
-- select * from gpSelect_MovementItem_SalePartion(inMovementId := 16414253 , inShowAll := 'false' ,  inSession := '3');
