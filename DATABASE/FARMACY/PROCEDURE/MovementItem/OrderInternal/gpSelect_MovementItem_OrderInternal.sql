-- Function: gpSelect_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternal (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderInternal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)

RETURNS SETOF refcursor 

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderInternal());
     vbUserId := inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   CREATE TEMP TABLE _tmpMI (Id integer, MovementItemId Integer
             , Price TFloat
             , GoodsCode TVarChar, GoodsName TVarChar
             , MainGoodsName TVarChar
             , JuridicalName TVarChar
             , ContractName TVarChar
             , Deferment Integer
             , Bonus TFloat
             , Percent TFloat
             , SuperFinalPrice TFloat) ON COMMIT DROP;




       WITH PriceSettings AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval (inSession)),
            JuridicalSettingsPriceList AS (SELECT * FROM lpSelect_Object_JuridicalSettingsPriceListRetail (vbObjectId))

       INSERT INTO _tmpMI 

       SELECT row_number() OVER ()
            , ddd.Id AS MovementItemId 
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
   LEFT JOIN JuridicalSettingsPriceList 
                    ON JuridicalSettingsPriceList.JuridicalId = LastPriceList_View.JuridicalId 
                   AND JuridicalSettingsPriceList.ContractId = LastPriceList_View.ContractId 
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
   
   WHERE movementItem.MovementId = inMovementId AND COALESCE(JuridicalSettingsPriceList.isPriceClose, FALSE) <> true) AS ddd
   
   LEFT JOIN PriceSettings ON ddd.MinPrice BETWEEN PriceSettings.MinPrice AND PriceSettings.MaxPrice;

     OPEN Cursor1 FOR
       SELECT
             tmpMI.Id                   AS Id
           , COALESCE(tmpMI.GoodsId, tmpGoods.GoodsId)     AS GoodsId
           , COALESCE(tmpMI.GoodsCode, tmpGoods.GoodsCode) AS GoodsCode
           , COALESCE(tmpMI.GoodsName, tmpGoods.GoodsName) AS GoodsName
           , tmpMI.Amount               AS Amount
           , tmpMI.Summ                 AS Summ
           , FALSE                      AS isErased
           , tmpMI.Price
           , tmpMI.PartnerGoodsCode 
           , tmpMI.PartnerGoodsName
           , tmpMI.JuridicalName 
           , tmpMI.ContractName 
           , tmpMI.SuperFinalPrice 

       FROM (SELECT Object_Goods.Id                              AS GoodsId
                  , Object_Goods.GoodsCodeInt                    AS GoodsCode
                  , Object_Goods.GoodsName                       AS GoodsName
             FROM Object_Goods_View AS Object_Goods
             WHERE Object_Goods.ObjectId = vbObjectId AND Object_Goods.isErased = FALSE
                   AND inShowAll = true       
            ) AS tmpGoods

            FULL JOIN (SELECT MovementItem.Id
                            , MovementItem.ObjectId              AS GoodsId
                            , MovementItem.Amount                AS Amount
                            , MIFloat_Summ.ValueData             AS Summ
                            , Object_Goods.GoodsCodeInt          AS GoodsCode
                            , Object_Goods.GoodsName             AS GoodsName
                            , MinPrice.Price
                            , MinPrice.GoodsCode                 AS PartnerGoodsCode 
                            , MinPrice.GoodsName                 AS PartnerGoodsName
                            , MinPrice.JuridicalName 
                            , MinPrice.ContractName 
                            , MinPrice.SuperFinalPrice 

                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                                             
                       LEFT JOIN (SELECT * FROM
                               (SELECT *
                                   , MIN(SuperFinalPrice) OVER(PARTITION BY MovementItemId) AS MinSuperFinalPrice
                                   , MIN(Id) OVER(PARTITION BY SuperFinalPrice) AS MinId
                                 FROM _tmpMI) AS DDD
                        WHERE DDD.Id = DDD.MinId AND DDD.SuperFinalPrice = DDD.MinSuperFinalPrice) AS MinPrice
                              ON MinPrice.MovementItemId = MovementItem.Id
                                             
                       JOIN Object_Goods_View AS Object_Goods 
                                              ON Object_Goods.Id = MovementItem.ObjectId 
                  LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                              ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                             AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId;
        RETURN NEXT Cursor1;
     

     OPEN Cursor2 FOR
      SELECT * FROM _tmpMI;

   RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderInternal (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.10.14                         *
 15.07.14                                                       *
 15.07.14                                                       *
 03.07.14                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
