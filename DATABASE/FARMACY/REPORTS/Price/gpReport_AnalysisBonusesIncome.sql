-- Function: gpReport_AnalysisBonusesIncome()

DROP FUNCTION IF EXISTS gpReport_AnalysisBonusesIncome (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_AnalysisBonusesIncome(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inDiscount         TFloat   ,  -- Дисконт для подвсетки
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE ( GoodsId integer, GoodsCode Integer, GoodsName TVarChar
              , Remains TFloat, Price TFloat
              , PriceWithVATMin  TFloat, PriceWithVATMax TFloat
              , DiscountMin  TFloat, DiscountMax TFloat
              , ColorMin_calc Integer, ColorMax_calc Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                           , Object_Juridical.Id                AS JuridicalId
                           , Object_Unit.ValueData
                           , ObjectLink_Unit_Parent.ChildObjectId
                      FROM ObjectLink AS ObjectLink_Unit_Juridical

                         INNER JOIN Object AS Object_Juridical
                                           ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
                                          AND Object_Juridical.isErased = False

                         INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                              AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                                              
                         INNER JOIN ObjectLink AS ObjectLink_Unit_Parent
                                               ON ObjectLink_Unit_Parent.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                              AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                                              AND COALESCE(ObjectLink_Unit_Parent.ChildObjectId, 0) <> 0
                                              
                         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Juridical.ObjectId

                      WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        AND ObjectLink_Unit_Juridical.ChildObjectId <> 393053
                        AND ObjectLink_Unit_Juridical.ObjectId <> 389328
                        AND Object_Unit.ValueData NOT ILIKE '%ЗАКРЫТА%'
                        AND Object_Unit.ValueData NOT ILIKE '%Зачинена%'
                        AND Object_Unit.isErased = False
                        AND (ObjectLink_Unit_Juridical.ObjectId = inUnitId OR 0 = inUnitId)
                      ) 
        , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                           AND ObjectFloat_Goods_Price.ValueData > 0
                                          THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                          ELSE ROUND (Price_Value.ValueData, 2)
                                          END :: TFloat                           AS Price
                             , Price_Goods.ChildObjectId               AS GoodsId
                             , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
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
                          AND ObjectLink_Price_Unit.ChildObjectId IN (SELECT tmpUnit.UnitId FROM tmpUnit)
                        )
        , ContainerCount AS (SELECT Container.Id
                                  , Container.ObjectId      AS GoodsId
                                  , Container.WhereObjectId AS UnitId
                                  , Container.Amount
                             FROM Container  
                             WHERE Container.DescId = zc_Container_Count() 
                               AND Container.WhereObjectId IN (SELECT tmpUnit.UnitId FROM tmpUnit)
                               AND Container.Amount > 0
                             )
        , ContainerPrice AS (SELECT ContainerCount.GoodsId      AS GoodsId
                                  , Min(tmpObject_Price.Price)::TFloat AS Price
                             FROM ContainerCount  
                                  INNER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = ContainerCount.GoodsId
                                                            AND tmpObject_Price.UnitId = ContainerCount.UnitId
                             GROUP BY ContainerCount.GoodsId
                             )
        , tmpContainerIncome AS (SELECT Container.Id
                                      , MIFloat_Price.ValueData                AS PriceWithVAT
                                FROM ContainerCount AS Container
                                     LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                   ON ContainerLinkObject_MovementItem.Containerid = Container.Id
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
                                                                          -- AND 1=0
                                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                 ON MIFloat_Price.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id) 
                                                                AND MIFloat_Price.DescId = zc_MIFloat_PriceWithVAT()
                                                                          
                                )
        , tmpIncome AS (SELECT ContainerCount.GoodsId
                             , MAX(tmpContainerIncome.PriceWithVAT)::TFloat  AS PriceWithVATMax
                             , MIN(tmpContainerIncome.PriceWithVAT)::TFloat  AS PriceWithVATMin
                        FROM ContainerCount 
                             INNER JOIN tmpContainerIncome ON tmpContainerIncome.ID = ContainerCount.Id
                        GROUP BY ContainerCount.GoodsId)

       SELECT Object_Goods.Id 
            , Object_Goods.ObjectCode
            , Object_Goods.ValueData
            , ContainerCount.Amount
            , ContainerPrice.Price
            , tmpIncome.PriceWithVATMin
            , tmpIncome.PriceWithVATMax
            , (100 - (ContainerPrice.Price/tmpIncome.PriceWithVATMin - 1) * 100)::TFloat AS DiscountMin
            , (100 - (ContainerPrice.Price/tmpIncome.PriceWithVATMax - 1) * 100)::TFloat AS DiscountMax
            , CASE WHEN (100 - (ContainerPrice.Price/tmpIncome.PriceWithVATMin - 1) * 100) > inDiscount
                   THEN zc_Color_Red() 
                   ELSE zc_Color_White() END         AS ColorMin_calc
            , CASE WHEN (100 - (ContainerPrice.Price/tmpIncome.PriceWithVATMax - 1) * 100) > inDiscount
                   THEN zc_Color_Red() 
                   ELSE zc_Color_White() END         AS ColorMax_calc

       FROM (SELECT ContainerCount.GoodsId, SUM(ContainerCount.Amount)::TFloat AS Amount FROM ContainerCount GROUP BY ContainerCount.GoodsId) ContainerCount

           LEFT JOIN OBJECT AS Object_Goods ON Object_Goods.Id = ContainerCount.GoodsId
           
           LEFT JOIN ContainerPrice ON ContainerPrice.GoodsId  = ContainerCount.GoodsId
           
           LEFT JOIN tmpIncome ON tmpIncome.GoodsId  = ContainerCount.GoodsId
           
       WHERE COALESCE (tmpIncome.PriceWithVATMin, 0) <> 0

       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_AnalysisBonusesIncome (Integer, TFloat, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.07.22                                                       *

*/

-- тест
-- 
SELECT * FROM gpReport_AnalysisBonusesIncome (inUnitId := 472116, inDiscount := 80.0, inSession:= '2')