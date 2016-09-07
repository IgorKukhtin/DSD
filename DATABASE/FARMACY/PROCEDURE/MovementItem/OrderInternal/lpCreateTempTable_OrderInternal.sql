-- Function: lpCreateTempTable_OrderInternal()

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
  DECLARE vbUnitId Integer;
BEGIN

     SELECT Object_Unit_View.JuridicalId, MovementLinkObject.ObjectId
            INTO vbMainJuridicalId, vbUnitId
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


      -- Сохраниели данные
      INSERT INTO _tmpMI 

           WITH -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту) !!!внутри проц определяется ObjectId!!!
                PriceSettings    AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval    (inUserId::TVarChar))
              , PriceSettingsTOP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval (inUserId::TVarChar))

              , JuridicalSettings AS (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (inObjectId) AS T WHERE T.MainJuridicalId = vbMainJuridicalId)
              , MovementItemOrder AS (SELECT MovementItem.*, Object_LinkGoods_View.GoodsMainId, PriceList_GoodsLink.GoodsId
                                      FROM MovementItem    
                                           INNER JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = MovementItem.ObjectId -- Связь товара сети с общим
                                           LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- связь товара в прайсе с главным товаром
                                                                           ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
                                      WHERE MovementItem.MovementId = inMovementId
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND ((inGoodsId = 0) OR (inGoodsId = MovementItem.ObjectId))
                                  )
                -- Маркетинговый контракт
              , tmpOperDate AS (SELECT date_trunc ('day', Movement.OperDate) AS OperDate FROM Movement WHERE Movement.Id = inMovementId)
              , GoodsPromo AS (SELECT tmp.JuridicalId
                                    , tmp.GoodsId        -- здесь товар "сети"
                                    , tmp.ChangePercent
                               FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                       ) AS tmp
                              )
              , LastPriceList_View AS (SELECT * FROM lpSelect_LastPriceList_View_onDate (inOperDate:= (SELECT tmpOperDate.OperDate FROM tmpOperDate)
                                                                                       , inUserId  := inUserId) AS tmp
                                      )
                -- Список цены + ТОП
              , GoodsPrice AS (SELECT MovementItemOrder.ObjectId AS GoodsId, ObjectBoolean_Top.ValueData AS isTOP
                               FROM MovementItemOrder
                                    INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                                          ON ObjectLink_Price_Goods.ChildObjectId = MovementItemOrder.ObjectId
                                                         AND ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                          ON ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                                                         AND ObjectLink_Price_Unit.ObjectId = ObjectLink_Price_Goods.ObjectId
                                                         AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                    INNER JOIN ObjectBoolean AS ObjectBoolean_Top
                                                             ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                                            AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
                                                            AND ObjectBoolean_Top.ValueData = TRUE
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
/* * /
            , CASE WHEN ddd.Deferment = 0
                        THEN 0
                   WHEN ddd.isTOP = TRUE
                        THEN COALESCE (PriceSettingsTOP.Percent, 0)
                   ELSE PriceSettings.Percent
              END :: TFloat AS Percent
            , CASE WHEN ddd.Deferment = 0
                        THEN FinalPrice
                   WHEN ddd.Deferment = 0 OR ddd.isTOP = TRUE
                        THEN FinalPrice * (100 - COALESCE (PriceSettingsTOP.Percent, 0)) / 100
                   ELSE FinalPrice * (100 - PriceSettings.Percent) / 100
              END :: TFloat AS SuperFinalPrice   
/ */
            , CASE WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                        THEN COALESCE (PriceSettingsTOP.Percent, 0)
                   WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                        THEN COALESCE (PriceSettings.Percent, 0)
                   ELSE 0
              END :: TFloat AS Percent
            , CASE WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                        THEN FinalPrice * (100 + COALESCE (PriceSettingsTOP.Percent, 0)) / 100
                   WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                        THEN FinalPrice * (100 + COALESCE (PriceSettings.Percent, 0)) / 100
                   ELSE FinalPrice
              END :: TFloat AS SuperFinalPrice   
/**/
         FROM 

     (SELECT DISTINCT MovementItemOrder.Id
          , MovementItemLastPriceList_View.Price AS Price
          , MovementItemLastPriceList_View.MovementItemId AS PriceListMovementItemId
          , MovementItemLastPriceList_View.PartionGoodsDate
          , min(MovementItemLastPriceList_View.Price) OVER (PARTITION BY MovementItemOrder.Id) AS MinPrice
          , CASE 
              -- если Цена поставщика >= PriceLimit (до какой цены учитывать бонус при расчете миним. цены)
              WHEN COALESCE (JuridicalSettings.PriceLimit, 0) <= MovementItemLastPriceList_View.Price
                   THEN MovementItemLastPriceList_View.Price
                       -- И учитывается % бонуса из Маркетинговый контракт
                     * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)

              ELSE -- иначе учитывается бонус - для ТОП-позиции или НЕ ТОП-позиции
                   (MovementItemLastPriceList_View.Price * (100 - COALESCE(JuridicalSettings.Bonus, 0)) / 100) :: TFloat 
                    -- И учитывается % бонуса из Маркетинговый контракт
                  * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
            END AS FinalPrice          
          , CASE WHEN COALESCE (JuridicalSettings.PriceLimit, 0) <= MovementItemLastPriceList_View.Price
                      THEN 0
                 ELSE COALESCE(JuridicalSettings.Bonus, 0)
            END :: TFloat AS Bonus

          , MovementItemLastPriceList_View.GoodsId         
          , MovementItemLastPriceList_View.GoodsCode
          , MovementItemLastPriceList_View.GoodsName
          , MovementItemLastPriceList_View.MakerName
          , MainGoods.valuedata AS MainGoodsName
          , Juridical.ID AS JuridicalId
          , Juridical.ValueData AS JuridicalName
          , Contract.Id AS ContractId
          , Contract.ValueData AS ContractName
          , COALESCE (ObjectFloat_Deferment.ValueData, 0)::Integer AS Deferment
          , COALESCE (GoodsPrice.isTOP, COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE)) AS isTOP
    
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
   LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = MovementItemOrder.ObjectId
                          
--   LEFT JOIN Object_Goods_View AS Goods  -- Элемент документа заявка
--     ON Goods.Id = MovementItemOrder.ObjectId
         
            -- % бонуса из Маркетинговый контракт
            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     = MovementItemOrder.ObjectId
                                AND GoodsPromo.JuridicalId = MovementItemLastPriceList_View.JuridicalId

   WHERE  COALESCE(JuridicalSettings.isPriceClose, FALSE) <> TRUE 
     ) AS ddd
   
   LEFT JOIN PriceSettings    ON ddd.MinPrice BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice
   LEFT JOIN PriceSettingsTOP ON ddd.MinPrice BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice
  ;

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
