-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpCalculate_ExternalOrder (Integer, TVarChar);

-- Function: gpcalculate_externalorder(integer, tvarchar)

-- DROP FUNCTION gpcalculate_externalorder(integer, tvarchar);

CREATE OR REPLACE FUNCTION gpcalculate_externalorder(ininternalorder integer, insession tvarchar)
  RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbObjectId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId := lpGetUserBySession (inSession);   
     vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

     
     
    SELECT  MovementLinkObject_Unit.ObjectId INTO vbUnitId 
      FROM  MovementLinkObject AS MovementLinkObject_Unit
      WHERE MovementLinkObject_Unit.MovementId = inInternalOrder
        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit();

   
   -- Просто запрос, где у позиции определяется лучший поставщик. Если поставщика нет, то закинуть в пустой документ. 

   --WITH PriceSettings AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval (inSession))

   PERFORM lpCreate_ExternalOrder(
             inInternalOrder := inInternalOrder ,
               inJuridicalId := ddd.JuridicalId,
                inContractId := ddd.ContractId,
                    inUnitId := vbUnitId,
               inMainGoodsId := ddd.MainGoodsId,
                   inGoodsId := ddd.GoodsId,
                    inAmount := ddd.Amount, 
                     inPrice := ddd.Price, 
                    inUserId := vbUserId)
         FROM 

       (WITH PriceSettings AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval (inSession)) ,
            JuridicalSettingsPriceList AS (SELECT * FROM lpSelect_Object_JuridicalSettingsPriceListRetail (vbObjectId))
       
       SELECT * FROM (
SELECT * FROM (
SELECT 
*, MIN(RowNumber) OVER (PARTITION BY MainGoodsId) AS MinRowNumber FROM ( 
 SELECT *
   , row_number() OVER (order by 1, 4, 8, 7 desc) AS RowNumber FROM (
       SELECT ddd.Id
            , ddd.Price  
            , ddd.amount          
            , ddd.GoodsId
            , ddd.MainGoodsId
            , ddd.JuridicalId
            , ddd.ContractId
            , ddd.Deferment
            , CASE ddd.Deferment 
                   WHEN 0 THEN FinalPrice
                   ELSE FinalPrice * (100 - PriceSettings.PERCENt)/100
              END::TFloat AS SuperFinalPrice   
            , MIN (CASE ddd.Deferment 
                   WHEN 0 THEN FinalPrice
                   ELSE FinalPrice * (100 - PriceSettings.PERCENt)/100
              END::TFloat) OVER (PARTITION BY Id) AS MINSuperFinalPrice   
         FROM 
         

     (SELECT movementItem.Id
          , MovementItem.amount
          , PriceList.amount AS Price
          , min(PriceList.amount) OVER (PARTITION BY movementItem.Id) AS MinPrice
          , (PriceList.amount * (100 - COALESCE(JuridicalSettings.Bonus, 0))/100)::TFloat AS FinalPrice
          
          , COALESCE(JuridicalSettings.Bonus, 0)::TFloat AS Bonus
          
          , Object_JuridicalGoods.Id AS GoodsId
          , Object_LinkGoods_View.GoodsMainId AS MainGoodsId
          , LastPriceList_View.JuridicalId
          , LastPriceList_View.ContractId
          , COALESCE(ObjectFloat_Deferment.ValueData, 0)::Integer AS Deferment
          
       FROM MovementItem  
   JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = movementItem.objectid
   JOIN MovementItem AS PriceList ON Object_LinkGoods_View.GoodsMainId = PriceList.objectid
   JOIN MovementItemLinkObject AS MILinkObject_Goods
                                    ON MILinkObject_Goods.MovementItemId = PriceList.Id
                                   AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
   LEFT JOIN Object_Goods_View AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId
   
   JOIN LastPriceList_View ON LastPriceList_View.MovementId =  PriceList.MovementId

   LEFT JOIN JuridicalSettingsPriceList 
                    ON JuridicalSettingsPriceList.JuridicalId = LastPriceList_View.JuridicalId 
                   AND JuridicalSettingsPriceList.ContractId = LastPriceList_View.ContractId 

   LEFT JOIN lpSelect_Object_JuridicalSettingsRetail(vbObjectId) AS JuridicalSettings ON JuridicalSettings.JuridicalId = LastPriceList_View.JuridicalId  

   JOIN OBJECT AS Goods ON Goods.Id = MovementItem.ObjectId

   LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                         ON ObjectFloat_Deferment.ObjectId = LastPriceList_View.ContractId
                        AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
   
   WHERE movementItem.MovementId = inInternalOrder AND COALESCE(JuridicalSettingsPriceList.isPriceClose, FALSE) <> true) AS ddd
   
   LEFT JOIN PriceSettings ON ddd.MinPrice BETWEEN PriceSettings.MinPrice AND PriceSettings.MaxPrice
   
       ORDER BY 1, 4, 8, 7 DESC) AS ddd WHERE ddd.SuperFinalPrice = ddd.MinSuperFinalPrice)
       AS ddd 
) AS DDD WHERE DDD.RowNumber = ddd.MinRowNumber) AS DDD

ORDER BY 4) AS ddd;

-- А тут встьавляются те, которых нет в прайсе

   PERFORM lpCreate_ExternalOrder(
             inInternalOrder := inInternalOrder ,
               inJuridicalId := 0,
                inContractId := 0,
                    inUnitId := vbUnitId,
               inMainGoodsId := ddd.ObjectId,
                   inGoodsId := ddd.ObjectId,
                    inAmount := ddd.Amount, 
                     inPrice := 0, 
                    inUserId := vbUserId)
         FROM 


(WITH DDD AS (SELECT DISTINCT MovementItem.Id 

    FROM MovementItem  
       JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = movementItem.objectid
       JOIN MovementItem AS PriceList ON Object_LinkGoods_View.GoodsMainId = PriceList.objectid

       JOIN LastPriceList_View ON LastPriceList_View.MovementId =  PriceList.MovementId
       
   WHERE MovementItem.MovementId = inInternalOrder)


SELECT * FROM MovementItem 

WHERE MovementId = inInternalOrder AND Id NOT IN(
SELECT Id FROM ddd
 )) AS DDD;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpcalculate_externalorder(integer, tvarchar)
  OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.09.14                         *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_Income (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')