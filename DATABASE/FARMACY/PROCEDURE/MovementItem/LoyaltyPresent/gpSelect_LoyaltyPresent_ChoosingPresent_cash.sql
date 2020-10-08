-- Function: gpSelect_LoyaltyPresent_ChoosingPresent_cash()

DROP FUNCTION IF EXISTS gpSelect_LoyaltyPresent_ChoosingPresent_cash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_LoyaltyPresent_ChoosingPresent_cash(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Remains TFloat, Amount TFloat, Price TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
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

    -- Результат другой
    RETURN QUERY
    WITH tmpLoyaltyPresentList AS (SELECT Object_Goods_Retail.Id               AS GoodsID
                                        , MovementItem.ObjectId                AS MainGoodsID
                                   FROM MovementItem

                                        INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = MovementItem.ObjectId
                                                                                             AND Object_Goods_Retail.retailid = vbRetailId

                                   WHERE MovementItem.MovementId = inMovementId
                                     AND MovementItem.DescId = zc_MI_Master()
                                     AND MovementItem.isErased = FALSE)
        , tmpContainer AS (SELECT Container.ObjectId    AS GoodsID
                                , tmpLoyaltyPresentList.MainGoodsID
                                , SUM(Container.Amount) AS Amount
                           FROM tmpLoyaltyPresentList
                                INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                    AND Container.Amount <> 0
                                                    AND Container.ObjectId = tmpLoyaltyPresentList.GoodsID
                                                    AND Container.WhereObjectId = vbUnitId
                           GROUP BY Container.ObjectId
                                  , tmpLoyaltyPresentList.MainGoodsID
                           HAVING SUM(Container.Amount) >= 1)
        , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                           AND ObjectFloat_Goods_Price.ValueData > 0
                                          THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                          ELSE ROUND (Price_Value.ValueData, 2)
                                     END :: TFloat                           AS Price
                                   , Price_Goods.ChildObjectId               AS GoodsId
                              FROM ObjectLink AS ObjectLink_Price_Unit
                                 LEFT JOIN ObjectLink AS Price_Goods
                                                      ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                     AND Price_Goods.ChildObjectId IN (SELECT DISTINCT tmpLoyaltyPresentList.GoodsID FROM tmpLoyaltyPresentList)
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
                              
     SELECT MI_PromoCode.GoodsID        AS GoodsId
          , Object_Goods.ObjectCode     AS GoodsCode
          , Object_Goods.Name           AS GoodsName
          , MI_PromoCode.Amount::TFloat AS Remains
          , 0::TFloat                   AS Amount
          , Object_Price.Price          AS Price 
     FROM tmpContainer AS MI_PromoCode
 
         LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MI_PromoCode.MainGoodsID  
         
         LEFT JOIN tmpObject_Price AS Object_Price ON Object_Price.GoodsId = MI_PromoCode.GoodsID  
 ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.10.20                                                       *
*/

-- 
select * from gpSelect_LoyaltyPresent_ChoosingPresent_cash(inMovementId := 20428980 , inSession := '3'::TVarChar);