-- Function: gpSelect_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternal_Price (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderInternal_Price(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementItemId Integer
             , Price TFloat
             , GoodsCode TVarChar, GoodsName TVarChar
             , MainGoodsName TVarChar
             , JuridicalName TVarChar
             , ContractName TVarChar
             , Deferment Integer
             , Bonus TFloat
             , Percent TFloat
             , SuperFinalPrice TFloat)
 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderInternal());

   vbUserId := inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    
   RETURN QUERY
       WITH PriceSettings AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval (inSession))

       SELECT ddd.Id
            , ddd.Price  
            , ddd.GoodsCode
            , ddd.GoodsName
            , ddd.MainGoodsName 
            , ddd.JuridicalName 
            , ddd.ContractName
            , ddd.Deferment
            , ddd.Bonus 
            , CASE ddd.Deferment 
                   WHEN 0 THEN 0
                   ELSE PriceSettings.Percent
              END::TFloat AS Percent
            , CASE ddd.Deferment 
                   WHEN 0 THEN FinalPrice
                   ELSE FinalPrice * (100 - PriceSettings.PERCENt)/100
              END::TFloat AS SuperFinalPrice   
         FROM 

     (SELECT movementItem.Id
          , PriceList.amount AS Price
          , min(PriceList.amount) OVER (PARTITION BY movementItem.Id) AS MinPrice
          , (PriceList.amount * (100 - COALESCE(JuridicalSettings.Bonus, 0))/100)::TFloat AS FinalPrice
          
          , COALESCE(JuridicalSettings.Bonus, 0)::TFloat AS Bonus
          
          , Object_JuridicalGoods.GoodsCode
          , Object_JuridicalGoods.GoodsName
          , MainGoods.valuedata AS MainGoodsName
          , Juridical.ValueData AS JuridicalName
          , Contract.ValueData AS ContractName
          , COALESCE(ObjectFloat_Deferment.ValueData, 0)::Integer AS Deferment
       FROM MovementItem  
   JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = movementItem.objectid
   JOIN LastPriceList_View ON true 
   JOIN MovementItem AS PriceList ON Object_LinkGoods_View.GoodsMainId = PriceList.objectid
                           AND PriceList.MovementId  = LastPriceList_View.MovementId 
   JOIN MovementItemLinkObject AS MILinkObject_Goods
                                    ON MILinkObject_Goods.MovementItemId = PriceList.Id
                                   AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
   LEFT JOIN Object_Goods_View AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId

   LEFT JOIN lpSelect_Object_JuridicalSettingsRetail(vbObjectId) AS JuridicalSettings ON JuridicalSettings.JuridicalId = LastPriceList_View.JuridicalId  

   JOIN OBJECT AS Goods ON Goods.Id = MovementItem.ObjectId

   JOIN OBJECT AS MainGoods ON MainGoods.Id = Object_LinkGoods_View.GoodsMainId

   JOIN OBJECT AS Juridical ON Juridical.Id = LastPriceList_View.JuridicalId

   LEFT JOIN OBJECT AS Contract ON Contract.Id = LastPriceList_View.ContractId

   LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                         ON ObjectFloat_Deferment.ObjectId = Contract.Id
                        AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
   
   WHERE movementItem.MovementId = inMovementId) AS ddd
   
   LEFT JOIN PriceSettings ON ddd.MinPrice BETWEEN PriceSettings.MinPrice AND PriceSettings.MaxPrice;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderInternal_Price (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.10.14                         *
 23.09.14                         *
 18.09.14                         *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
