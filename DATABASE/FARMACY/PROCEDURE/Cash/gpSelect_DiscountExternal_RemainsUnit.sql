-- Function: gpSelect_DiscountExternal_RemainsUnit()

DROP FUNCTION IF EXISTS gpSelect_DiscountExternal_RemainsUnit(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_DiscountExternal_RemainsUnit(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, BarCodeName TVarChar,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               ObjectId Integer, ObjectName TVarChar, Price TFloat, Amount TFloat, AmountProject TFloat
               ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_BarCode());

    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());
                     
   RETURN QUERY 
       WITH 
          tmpGoods AS (SELECT 
                               Object_BarCode.Id           AS Id
                             , Object_BarCode.ObjectCode   AS Code
                             , Object_BarCode.ValueData    AS BarCodeName
                               
                             , Object_Goods.Id             AS GoodsId
                             , Object_Goods.ObjectCode     AS GoodsCode
                             , Object_Goods.ValueData      AS GoodsName 
                                           
                             , Object_Object.Id            AS ObjectId
                             , Object_Object.ValueData     AS ObjectName 
                                                                  
                         FROM Object AS Object_BarCode
                             LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                  ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                 AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_BarCode_Goods.ChildObjectId
                                 
                             LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                  ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                 AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                             LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           


                         WHERE Object_BarCode.DescId = zc_Object_BarCode()
                           AND Object_BarCode.isErased = False),
          tmpContainer AS (SELECT tmpGoods.GoodsId,
                                  SUM(Container.Amount)   AS Amount,
                                  SUM(CASE WHEN zfPermit_Juridical_Discount (tmpGoods.ObjectId, MovementLinkObject_From.ObjectId) > 0 THEN Container.Amount END) AS AmountProject
                           FROM tmpGoods
                           
                                LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId
                                LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail 
                                                              ON Object_Goods_Retail.GoodsMainId = Object_Goods.GoodsMainId
                                                             AND Object_Goods_Retail.RetailID = vbRetailId
                           
                                LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                                   AND Container.WhereObjectId = vbUnitId
                                                   AND Container.ObjectId = Object_Goods_Retail.ID
                                                   AND Container.Amount <> 0
                             
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

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = COALESCE (MI_Income_find.MovementId ,MI_Income.MovementId)
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                           GROUP BY tmpGoods.GoodsId),
          tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
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
             tmpGoods.Id
           , tmpGoods.Code
           , tmpGoods.BarCodeName
         
           , tmpGoods.GoodsId
           , tmpGoods.GoodsCode
           , tmpGoods.GoodsName 
                     
           , tmpGoods.ObjectId
           , tmpGoods.ObjectName 
           
           , COALESCE(tmpObject_Price.Price,0)::TFloat
           , tmpContainer.Amount::TFloat
           , tmpContainer.AmountProject::TFloat
                      
       FROM tmpGoods
       
            LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpGoods.GoodsId
            
            LEFT OUTER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = tmpGoods.GoodsId
       ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.03.21                                                       *

*/

-- тест
-- select * from gpSelect_DiscountExternal_RemainsUnit( inSession := '3');