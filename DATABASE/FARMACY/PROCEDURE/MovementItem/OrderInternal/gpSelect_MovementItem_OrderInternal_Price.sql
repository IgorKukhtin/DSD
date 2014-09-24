-- Function: gpSelect_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternal_Price (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderInternal_Price(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementItemId Integer, Price TFloat
             , GoodsCode TVarChar, GoodsName TVarChar
             , MainGoodsName TVarChar
             , JuridicalName TVarChar
             , ContractName TVarChar)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderInternal());
     vbUserId := inSession;
    
   RETURN QUERY
     SELECT movementItem.Id
          , PriceList.amount AS Price
          , Object_JuridicalGoods.GoodsCode
          , Object_JuridicalGoods.GoodsName
          , MainGoods.valuedata AS MainGoodsName
          , Juridical.ValueData AS JuridicalName
          , Contract.ValueData AS ContractName
       FROM MovementItem 
   JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = movementItem.objectid
   JOIN MovementItem AS PriceList ON Object_LinkGoods_View.GoodsMainId = PriceList.objectid
   JOIN MovementItemLinkObject AS MILinkObject_Goods
                                    ON MILinkObject_Goods.MovementItemId = PriceList.Id
                                   AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
   LEFT JOIN Object_Goods_View AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId
   JOIN LastPriceList_View ON LastPriceList_View.MovementId =  PriceList.MovementId
   JOIN OBJECT AS Goods ON Goods.Id = MovementItem.ObjectId
   JOIN OBJECT AS MainGoods ON MainGoods.Id = Object_LinkGoods_View.GoodsMainId
   JOIN OBJECT AS Juridical ON Juridical.Id = LastPriceList_View.JuridicalId
   LEFT JOIN OBJECT AS Contract ON Contract.Id = LastPriceList_View.ContractId
   
   WHERE movementItem.MovementId = inMovementId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderInternal_Price (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.09.14                         *
 18.09.14                         *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
