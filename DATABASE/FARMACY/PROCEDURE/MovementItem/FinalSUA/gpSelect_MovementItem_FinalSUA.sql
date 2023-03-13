-- Function: gpSelect_MovementItem_FinalSUA()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_FinalSUA (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_FinalSUA(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , Remains TFloat, Amount TFloat, SendSUN TFloat, AmountOI TFloat
             , Price TFloat
             , isTop boolean, isClose boolean, isNot boolean, MCSIsClose boolean
             , isPromoBonus  Boolean, isLearnWeek Boolean
             , MCS TFloat
             , isErased Boolean)
 AS
$BODY$
    DECLARE vbUserId   Integer;
    DECLARE vbCalculation TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_FinalSUA());
    vbUserId:= lpGetUserBySession (inSession);
    
    SELECT MovementDate_Calculation.ValueData
    INTO vbCalculation
    FROM MovementDate AS MovementDate_Calculation
    WHERE MovementDate_Calculation.MovementId = inMovementId
      AND MovementDate_Calculation.DescId = zc_MovementDate_Calculation();

        -- Результат такой
        RETURN QUERY
               WITH
                   MI_Master AS (SELECT MovementItem.Id                         AS Id
                                      , MovementItem.ObjectId                   AS GoodsId
                                      , MILinkObject_Unit.ObjectId              AS UnitId
                                      , MovementItem.Amount                     AS Amount
                                      , MIFloat_SendSUN.ValueData               AS SendSUN
                                      , MovementItem.isErased                   AS isErased
                                 FROM MovementItem

                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                      ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                                     LEFT JOIN MovementItemFloat AS MIFloat_SendSUN
                                                                 ON MIFloat_SendSUN.MovementItemId = MovementItem.Id
                                                                AND MIFloat_SendSUN.DescId = zc_MIFloat_SendSUN()

                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.isErased = False OR inIsErased = True)
                                 )
                 , tmpContainer AS (SELECT MI_Master.GoodsId                  AS GoodsId
                                         , MI_Master.UnitId                   AS UnitId
                                         , Sum(Container.Amount)::TFloat      AS Amount
                                    FROM MI_Master
                                      
                                         INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                             AND Container.ObjectId = MI_Master.GoodsId
                                                             AND Container.WhereObjectId = MI_Master.UnitId
                                                             AND Container.Amount <> 0
                                    GROUP BY MI_Master.GoodsId
                                           , MI_Master.UnitId
                                    )
                 , tmpObject_Price AS (
                        SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                               END :: TFloat                           AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , COALESCE (ObjectBoolean_Price_MCSIsClose.ValueData, False) AS MCSIsClose
                             , Price_Goods.ChildObjectId               AS GoodsId
                             , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Price_MCSIsClose
                                                   ON ObjectBoolean_Price_MCSIsClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                  AND ObjectBoolean_Price_MCSIsClose.DescId   = zc_ObjectBoolean_Price_MCSIsClose()
                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId IN (SELECT DISTINCT MI_Master.UnitId FROM MI_Master)
                        )
               /*, tmpPromoBonus_GoodsWeek AS (SELECT * FROM gpSelect_PromoBonus_GoodsWeek(inSession := inSession))
               , PromoBonus AS (SELECT MovementItem.Id                               AS Id
                                     , MovementItem.ObjectId                         AS GoodsId
                                     , MovementItem.Amount                           AS Amount
                                     , COALESCE (tmpPromoBonus_GoodsWeek.ID, 0) <> 0 AS isLearnWeek
                                FROM MovementItem
                                     LEFT JOIN tmpPromoBonus_GoodsWeek ON tmpPromoBonus_GoodsWeek.ID = MovementItem.Id 
                                WHERE MovementItem.MovementId = (SELECT MAX(Movement.id) FROM Movement 
                                                                 WHERE Movement.OperDate <= CURRENT_DATE   
                                                                   AND Movement.DescId = zc_Movement_PromoBonus() 
                                                                   AND Movement.StatusId = zc_Enum_Status_Complete())
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND MovementItem.isErased = False
                                  AND MovementItem.Amount > 0)*/
               , tmpOrderInternal AS (SELECT Movement.id                          AS ID 
                                           , MovementLinkObject_Unit.ObjectId     AS UnitId 
                                      FROM Movement 
                                      
                                           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                       AND MovementLinkObject_Unit.ObjectId IN (SELECT MI_Master.UnitId FROM MI_Master) 
                                                                       
                                      WHERE Movement.OperDate >= vbCalculation
                                        AND Movement.OperDate <= vbCalculation + INTERVAL '6 DAY'
                                        AND Movement.DescId = zc_Movement_OrderInternal() 
                                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                                      )
               , tmpOIList AS (SELECT Movement.UnitId                           AS UnitId 
                                    , MovementItem.ObjectId                     AS GoodsId
                                    , SUM(MovementItemFloat.ValueData)::TFloat  AS Amount
                               FROM tmpOrderInternal AS Movement 
                                      
                                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                                        
                                    INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                                AND MovementItemFloat.DescId     = zc_MIFloat_AmountSUA()
                                                                
                               GROUP BY Movement.UnitId
                                      , MovementItem.ObjectId
                                      )
               , tmpRemains AS (SELECT AnalysisContainer.GoodsId                   AS GoodsId
                                     , AnalysisContainer.UnitId                    AS UnitId
                                     , SUM(AnalysisContainer.Saldo)                AS Saldo
                                FROM AnalysisContainer 
                                
                                     INNER JOIN (SELECT DISTINCT MI_Master.GoodsID FROM MI_Master) AS Goods ON Goods.GoodsID = AnalysisContainer.GoodsId
                                 
--                                WHERE AnalysisContainer.Saldo > 0
                                GROUP BY AnalysisContainer.GoodsId
                                       , AnalysisContainer.UnitId  
                                )
               , tmpRemainsMax AS (SELECT tmpRemains.GoodsId                   AS GoodsId
                                        , tmpRemains.UnitId                    AS UnitId
                                        , ObjectLink_Price_Unit.ObjectId       AS ObjectPrice
                                        , ROW_NUMBER() OVER (PARTITION BY tmpRemains.GoodsId ORDER BY tmpRemains.Saldo DESC) AS Ord
                                   FROM tmpRemains
             
                                        INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                              ON ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit() 
                                                             AND ObjectLink_Price_Unit.ChildObjectId = tmpRemains.UnitId
                                        
                                        INNER JOIN ObjectLink AS Price_Goods
                                                              ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                             AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                             AND Price_Goods.ChildObjectId  = tmpRemains.GoodsId
                                   )  
               , tmpObject_PriceSale AS (
                                SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                             AND ObjectFloat_Goods_Price.ValueData > 0
                                            THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                            ELSE ROUND (Price_Value.ValueData, 2)
                                       END :: TFloat                           AS Price
                                     , tmpRemainsMax.GoodsId                   AS GoodsId
                                     , tmpRemainsMax.UnitId                    AS UnitId
                                FROM tmpRemainsMax 

                                   LEFT JOIN ObjectFloat AS Price_Value
                                                         ON Price_Value.ObjectId = tmpRemainsMax.ObjectPrice
                                                        AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                   -- Фикс цена для всей Сети
                                   LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                          ON ObjectFloat_Goods_Price.ObjectId = tmpRemainsMax.GoodsId
                                                         AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                           ON ObjectBoolean_Goods_TOP.ObjectId = tmpRemainsMax.GoodsId
                                                          AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                                WHERE tmpRemainsMax.Ord = 1
                                )

               SELECT MI_Master.Id                                      AS Id
                    , MI_Master.GoodsId                                 AS GoodsId
                    , Object_Goods_Main.ObjectCode                      AS UnitCode
                    , Object_Goods_Main.Name                            AS UnitName
                    , Object_Unit.Id                                    AS UnitId
                    , Object_Unit.ObjectCode                            AS UnitCode
                    , Object_Unit.ValueData                             AS UnitName
                    , Container.Amount                                  AS Remains
                    , MI_Master.Amount                                  AS Amount
                    , MI_Master.SendSUN                                 AS SendSUN
                    , tmpOIList.Amount                                  AS AmountOI
                    , tmpObject_PriceSale.Price                             AS Price
                    , Object_Goods_Retail.isTop                         AS isTop
                    , Object_Goods_Main.isClose                         AS isClose
                    , Object_Goods_Main.isNot                           AS isNot
                    , COALESCE(tmpObject_Price.MCSIsClose, False)       AS MCSIsClose
                    --, COALESCE(PromoBonus.Amount, 0) > 0                AS isPromoBonus  
                    --, COALESCE(PromoBonus.isLearnWeek, FALSE)           AS isLearnWeek
                    , False                                             AS isPromoBonus  
                    , False                                             AS isLearnWeek  
                    , tmpObject_Price.MCSValue                          AS MCS 
                    , COALESCE(MI_Master.IsErased, False)               AS isErased
               FROM MI_Master

                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MI_Master.UnitId

                   -- получается GoodsMainId
                   LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MI_Master.GoodsId
                   LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

                   LEFT JOIN tmpContainer AS Container
                                          ON Container.GoodsId = MI_Master.GoodsId
                                         AND Container.UnitId = MI_Master.UnitId
                                         
                   LEFT JOIN tmpObject_Price ON tmpObject_Price.GoodsId = MI_Master.GoodsId
                                            AND tmpObject_Price.UnitId = MI_Master.UnitId

                   LEFT JOIN tmpObject_PriceSale ON tmpObject_PriceSale.GoodsId = MI_Master.GoodsId

                   -- Маркетинговый бонус
                   --LEFT JOIN PromoBonus ON PromoBonus.GoodsId = MI_Master.GoodsId
                   
                   -- Внешний заказ
                   LEFT JOIN tmpOIList ON tmpOIList.GoodsId = MI_Master.GoodsId
                                      AND tmpOIList.UnitId = MI_Master.UnitId
                   ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 11.02.21                                                      *
*/
-- 

select * from gpSelect_MovementItem_FinalSUA(inMovementId := 23672895 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');