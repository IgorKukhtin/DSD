-- Function: lpCreateTempTable_OrderInternal()

DROP FUNCTION IF EXISTS lpCreateTempTable_OrderInternal (Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpCreateTempTable_OrderInternal (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpCreateTempTable_OrderInternal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inObjectId    Integer      , 
    IN inGoodsId     Integer      , 
    IN inUserId      Integer        -- сессия пользователя
)

RETURNS VOID

AS
$BODY$
  DECLARE vbMainJuridicalId Integer;
BEGIN

     SELECT Object_Unit_View.JuridicalId INTO vbMainJuridicalId
         FROM Object_Unit_View 
               JOIN  MovementLinkObject ON MovementLinkObject.ObjectId = Object_Unit_View.Id 
                AND  MovementLinkObject.MovementId = inMovementId 
                AND  MovementLinkObject.DescId = zc_MovementLinkObject_Unit();

     CREATE TEMP TABLE _tmpMI (Id integer
             , MovementItemId Integer
             , PriceListMovementItemId Integer
             , Price TFloat
             , PartionGoodsDate TDateTime
             , GoodsId Integer
             , GoodsCode TVarChar
             , GoodsName TVarChar
             , MainGoodsName TVarChar
             , JuridicalId Integer
             , JuridicalName TVarChar
             , MakerName TVarChar
             , ContractId Integer
             , ContractName TVarChar
             , Deferment Integer
             , Bonus TFloat
             , Percent TFloat
             , SuperFinalPrice TFloat) ON COMMIT DROP;


       WITH PriceSettings AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval (inUserId::TVarChar)),
            JuridicalSettingsPriceList AS (SELECT * FROM lpSelect_Object_JuridicalSettingsPriceListRetail (inObjectId)),
         MovementItemOrder AS (SELECT MovementItem.*, Object_LinkGoods_View.GoodsMainId, PriceList_GoodsLink.GoodsId  FROM MovementItem    
                                    JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = movementItem.objectid -- Связь товара сети с общим
                               LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- связь товара в прайсе с главным товаром
                                      ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId

                                    WHERE movementid = inMovementId  AND ((inGoodsId = 0) OR (inGoodsId = movementItem.objectid))  
                                    )
       INSERT INTO _tmpMI 

       SELECT row_number() OVER ()
            , ddd.Id AS MovementItemId 
            , ddd.PriceListMovementItemId
            , ddd.Price  
            , ddd.PartionGoodsDate
            , ddd.GoodsId
            , ddd.GoodsCode
            , ddd.GoodsName
            , ddd.MainGoodsName 
            , ddd.JuridicalId
            , ddd.JuridicalName 
            , ddd.MakerName
            , ddd.ContractId
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

     (SELECT DISTINCT MovementItemOrder.Id
          , PriceList.amount AS Price
          , PriceList.Id AS PriceListMovementItemId
          , MIDate_PartionGoods.ValueData      AS PartionGoodsDate
          , min(PriceList.amount) OVER (PARTITION BY MovementItemOrder.Id) AS MinPrice
          , (PriceList.amount * (100 - COALESCE(JuridicalSettings.Bonus, 0))/100)::TFloat AS FinalPrice
          
          , COALESCE(JuridicalSettings.Bonus, 0)::TFloat AS Bonus

          , Object_JuridicalGoods.Id AS GoodsId         
          , Object_JuridicalGoods.GoodsCode
          , Object_JuridicalGoods.GoodsName
          , Object_JuridicalGoods.MakerName
          , MainGoods.valuedata AS MainGoodsName
          , Juridical.ID AS JuridicalId
          , Juridical.ValueData AS JuridicalName
          , Contract.Id AS ContractId
          , Contract.ValueData AS ContractName
          , COALESCE(ObjectFloat_Deferment.ValueData, 0)::Integer AS Deferment

    
       FROM MovementItemOrder 
              
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods -- товары в прайс-листе
                                    ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                   AND MILinkObject_Goods.ObjectId = MovementItemOrder.GoodsId 

           JOIN  MovementItem AS PriceList  -- Прайс-лист
                   ON PriceList.Id = MILinkObject_Goods.MovementItemId
             JOIN LastPriceList_View  -- Прайс-лист
                   ON LastPriceList_View.MovementId  = PriceList.MovementId

   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                              ON MIDate_PartionGoods.MovementItemId =  PriceList.Id
                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

   LEFT JOIN JuridicalSettingsPriceList 
                    ON JuridicalSettingsPriceList.JuridicalId = LastPriceList_View.JuridicalId 
                   AND JuridicalSettingsPriceList.MainJuridicalId = vbMainJuridicalId 
                   AND JuridicalSettingsPriceList.ContractId = LastPriceList_View.ContractId 

              
   LEFT JOIN Object_Goods_View AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId

   LEFT JOIN lpSelect_Object_JuridicalSettingsRetail(inObjectId) AS JuridicalSettings ON JuridicalSettings.JuridicalId = LastPriceList_View.JuridicalId  
   
   JOIN OBJECT AS Juridical ON Juridical.Id = LastPriceList_View.JuridicalId

   LEFT JOIN OBJECT AS Contract ON Contract.Id = LastPriceList_View.ContractId

   LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                         ON ObjectFloat_Deferment.ObjectId = Contract.Id
                        AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
   

  LEFT JOIN OBJECT AS MainGoods ON MainGoods.Id = MovementItemOrder.GoodsMainId 
  
   LEFT JOIN OBJECT AS Goods-- Элемент документа заявка
     ON Goods.Id = MovementItemOrder.ObjectId
         
   WHERE  COALESCE(JuridicalSettingsPriceList.isPriceClose, FALSE) <> TRUE 
     ) AS ddd
   
   LEFT JOIN PriceSettings ON ddd.MinPrice BETWEEN PriceSettings.MinPrice AND PriceSettings.MaxPrice;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpCreateTempTable_OrderInternal (Integer, Integer, Integer, Integer) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.01.15                         *  учитываем наше юрлицо в закрытии прайсов
 05.12.14                         *  чуть оптимизировал
 06.11.14                         *  add PartionGoodsDate
 22.10.14                         *  add inGoodsId
 22.10.14                         *  add MakerName
 13.10.14                         *
 15.07.14                                                       *
 15.07.14                                                       *
 03.07.14                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
