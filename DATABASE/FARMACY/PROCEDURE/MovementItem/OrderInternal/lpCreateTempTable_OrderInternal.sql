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
            JuridicalSettings AS (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (inObjectId) AS T WHERE T.MainJuridicalId = vbMainJuridicalId),
         MovementItemOrder AS (SELECT MovementItem.*, Object_LinkGoods_View.GoodsMainId, PriceList_GoodsLink.GoodsId  FROM MovementItem    
                                    JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = movementItem.objectid -- Связь товара сети с общим
                               LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- связь товара в прайсе с главным товаром
                                      ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId

                                    WHERE movementid = inMovementId  AND ((inGoodsId = 0) OR (inGoodsId = movementItem.objectid))  
                                    )
       INSERT INTO _tmpMI 

           -- Маркетинговый контракт
           WITH tmpOperDate AS (SELECT date_trunc ('day', Movement.OperDate) AS OperDate FROM Movement WHERE Movement.Id = inMovementId)
              , GoodsPromo AS (SELECT tmp.JuridicalId
                                    , tmp.GoodsId        -- здесь товар "сети"
                                    , tmp.ChangePercent
                               FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                       ) AS tmp
                              )
              , LastPriceList_View AS (SELECT * FROM lpSelect_LastPriceList_View_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                                       , inUserId  := inUserId) AS tmp
                                      )
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
              END :: TFloat AS Percent
            , CASE WHEN ddd.Deferment = 0 OR ddd.isTOP = TRUE
                        THEN FinalPrice
                   ELSE FinalPrice * (100 - PriceSettings.Percent) / 100
              END :: TFloat AS SuperFinalPrice   
         FROM 

     (SELECT DISTINCT MovementItemOrder.Id
          , MovementItemLastPriceList_View.Price AS Price
          , MovementItemLastPriceList_View.MovementItemId AS PriceListMovementItemId
          , MovementItemLastPriceList_View.PartionGoodsDate
          , min(MovementItemLastPriceList_View.Price) OVER (PARTITION BY MovementItemOrder.Id) AS MinPrice
          , CASE 
              -- если ТОП-позиция или Цена поставщика >= PriceLimit (до какой цены учитывать бонус при расчете миним. цены)
              WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE OR COALESCE (JuridicalSettings.PriceLimit, 0) <= MovementItemLastPriceList_View.Price
                   THEN MovementItemLastPriceList_View.Price
                       -- И учитывается % бонуса из Маркетинговый контракт
                     * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
              ELSE (MovementItemLastPriceList_View.Price * (100 - COALESCE(JuridicalSettings.Bonus, 0))/100)::TFloat 
                    -- И учитывается % бонуса из Маркетинговый контракт
                 * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
            END AS FinalPrice          
          , COALESCE(JuridicalSettings.Bonus, 0)::TFloat AS Bonus

          , MovementItemLastPriceList_View.GoodsId         
          , MovementItemLastPriceList_View.GoodsCode
          , MovementItemLastPriceList_View.GoodsName
          , MovementItemLastPriceList_View.MakerName
          , MainGoods.valuedata AS MainGoodsName
          , Juridical.ID AS JuridicalId
          , Juridical.ValueData AS JuridicalName
          , Contract.Id AS ContractId
          , Contract.ValueData AS ContractName
          , COALESCE(ObjectFloat_Deferment.ValueData, 0)::Integer AS Deferment
          , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false) AS isTOP
    
       FROM MovementItemOrder 
            LEFT OUTER JOIN MovementItemLastPriceList_View ON MovementItemLastPriceList_View.GoodsId = MovementItemOrder.GoodsId
            
/*            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods -- товары в прайс-листе
                                    ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                   AND MILinkObject_Goods.ObjectId = MovementItemOrder.GoodsId 

           JOIN  MovementItem AS PriceList  -- Прайс-лист
                   ON PriceList.Id = MILinkObject_Goods.MovementItemId
             JOIN LastPriceList_View  -- Прайс-лист
                   ON LastPriceList_View.MovementId  = PriceList.MovementId

   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                              ON MIDate_PartionGoods.MovementItemId =  PriceList.Id
                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
*/
            LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId = MovementItemLastPriceList_View.JuridicalId 
                                       AND JuridicalSettings.ContractId = MovementItemLastPriceList_View.ContractId 

              
   -- товар "поставщика", если он есть в прайсах !!!а он есть!!!
            --LEFT JOIN Object AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId
   --LEFT JOIN ObjectString AS ObjectString_GoodsCode ON ObjectString_GoodsCode.ObjectId = MILinkObject_Goods.ObjectId
   --                      AND ObjectString_GoodsCode.DescId = zc_ObjectString_Goods_Code()
    --LEFT JOIN ObjectString AS ObjectString_Goods_Maker
    --                           ON ObjectString_Goods_Maker.ObjectId = MILinkObject_Goods.ObjectId
    --                          AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()                     
   
   JOIN OBJECT AS Juridical ON Juridical.Id = MovementItemLastPriceList_View.JuridicalId

   LEFT JOIN OBJECT AS Contract ON Contract.Id = MovementItemLastPriceList_View.ContractId

   LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                         ON ObjectFloat_Deferment.ObjectId = Contract.Id
                        AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
   

  LEFT JOIN OBJECT AS MainGoods ON MainGoods.Id = MovementItemOrder.GoodsMainId 
  
   LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                           ON ObjectBoolean_Goods_TOP.ObjectId = MovementItemOrder.ObjectId 
                          AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
                          
--   LEFT JOIN Object_Goods_View AS Goods  -- Элемент документа заявка
--     ON Goods.Id = MovementItemOrder.ObjectId
         
            -- % бонуса из Маркетинговый контракт
            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     = MovementItemOrder.ObjectId
                                AND GoodsPromo.JuridicalId = MovementItemLastPriceList_View.JuridicalId

   WHERE  COALESCE(JuridicalSettings.isPriceClose, FALSE) <> TRUE 
     ) AS ddd
   
   LEFT JOIN PriceSettings ON ddd.MinPrice BETWEEN PriceSettings.MinPrice AND PriceSettings.MaxPrice;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpCreateTempTable_OrderInternal (Integer, Integer, Integer, Integer) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.03.15                         *  
 17.02.15                         *  JuridicalSettings с бонусом и закрытием прайсов
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
-- SELECT lpCreateTempTable_OrderInternal(inMovementId := 2158888, inObjectId := 4, inGoodsId := 0, inUserId := 3); SELECT * FROM _tmpMI;