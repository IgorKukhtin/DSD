-- Function: gpSelect_CashGoods()

DROP FUNCTION IF EXISTS gpSelect_CashGoods (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashGoods(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id              Integer, 
               GoodsCode       Integer, 
               GoodsName       TVarChar, 
               Price           TFloat
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
BEGIN
-- if inSession = '3' then return; end if;

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    
    
    -- поиск <Торговой сети>
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
   
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey ::Integer;

    RETURN QUERY
    WITH
    -- все товары сети
    tmpGoodsRetail AS (SELECT DISTINCT ObjectLink_Goods_Object.ObjectId                    AS GoodsId
                       FROM ObjectLink AS ObjectLink_Goods_Object
                       WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                         AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId)
    -- цены аптеки
  , GoodsPrice AS (SELECT ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                        , MCS_Value.ValueData                     AS MCSValue
                        , COALESCE (ObjectBoolean_Top.ValueData, FALSE)     AS isTOP
                        , COALESCE (ObjectFloat_PercentMarkup.ValueData, 0) AS PercentMarkup
                        , Price_Goods.ChildObjectId               AS GoodsId
                   FROM ObjectLink AS ObjectLink_Price_Unit
                      LEFT JOIN ObjectLink AS Price_Goods
                                           ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                          AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                      LEFT JOIN ObjectFloat AS Price_Value
                                            ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                           AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                      LEFT JOIN ObjectFloat AS MCS_Value
                                            ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                           AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                              ON ObjectBoolean_Top.ObjectId  = ObjectLink_Price_Unit.ObjectId
                                             AND ObjectBoolean_Top.DescId    = zc_ObjectBoolean_Price_Top()
                      LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                            ON ObjectFloat_PercentMarkup.ObjectId = ObjectLink_Price_Unit.ObjectId
                                           AND ObjectFloat_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
                   WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                     AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                   )
  -- нужно определить цены для товаров, которых нет в прайсе аптеки ( как в gpSelect_GoodsSearch Ф12)
  , tmpMargin AS (SELECT DISTINCT Object_MarginCategoryItem_View.MarginPercent
                                , Object_MarginCategoryItem_View.MinPrice
                                , Object_MarginCategoryItem_View.MarginCategoryId
                  FROM Object_MarginCategoryItem_View
                       INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id = Object_MarginCategoryItem_View.Id
                                                                     AND Object_MarginCategoryItem.isErased = FALSE
                 )
  , MarginCondition AS (SELECT DD.MarginCategoryId, DD.MarginPercent, DD.MinPrice
                             , COALESCE ((SELECT MIN (FF.minprice) FROM tmpMargin AS FF WHERE FF.MinPrice > DD.MinPrice AND FF.MarginCategoryId = DD.MarginCategoryId)
                                       , 1000000) AS MaxPrice 
                        FROM tmpMargin AS DD)
                              
         
  , tmpPriceListItem AS ( SELECT LinkGoodsObject.GoodsId AS GoodsId_retail
                                 -- берем мин цену по посавщикам
                               , MIN(zfCalc_SalePrice((LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100),                         -- Цена С НДС
                                                   CASE WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0 
                                                            THEN MarginCondition.MarginPercent + COALESCE (ObjectFloat_Contract_Percent.valuedata, 0)
                                                        ELSE MarginCondition.MarginPercent + COALESCE (ObjectFloat_Juridical_Percent.valuedata, 0)
                                                   END,                                                                             -- % наценки в КАТЕГОРИИ
                                                   COALESCE (NULLIF (GoodsPrice.isTOP, FALSE), ObjectGoodsView.isTop),              -- ТОП позиция
                                                   COALESCE (NULLIF (GoodsPrice.PercentMarkup, 0), ObjectGoodsView.PercentMarkup),  -- % наценки у товара
                                                   0.0, --ObjectFloat_Juridical_Percent.valuedata,                                  -- % корректировки у Юр Лица для ТОПа
                                                   ObjectGoodsView.Price                                                           -- Цена у товара (фиксированная)
                                                 )  )       :: TFloat AS NewPrice
                        
                          FROM LoadPriceListItem 
                               INNER JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
                               LEFT JOIN (SELECT DISTINCT JuridicalId, ContractId, isPriceClose
                                            FROM lpSelect_Object_JuridicalSettingsRetail (/*vbObjectId*/ 4)) AS JuridicalSettings
                                       ON JuridicalSettings.JuridicalId = LoadPriceList.JuridicalId 
                                      AND JuridicalSettings.ContractId = LoadPriceList.ContractId 

                               LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                                     ON ObjectFloat_Juridical_Percent.ObjectId = LoadPriceList.JuridicalId
                                                    AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

                               LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                                                     ON ObjectFloat_Contract_Percent.ObjectId = LoadPriceList.ContractId
                                                    AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

                               LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink  
                                                                        ON (Object_MarginCategoryLink.UnitId = 183292 /*vbUnitId*/)    
                                                                       AND Object_MarginCategoryLink.JuridicalId = LoadPriceList.JuridicalId

                               LEFT JOIN Object_Goods_Main_View AS Object_Goods ON Object_Goods.Id = LoadPriceListItem.GoodsId

                               LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = Object_MarginCategoryLink.MarginCategoryId
                                                        AND (LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice

                               LEFT JOIN Object_LinkGoods_View AS LinkGoodsObject 
                                                               ON LinkGoodsObject.GoodsMainId = Object_Goods.Id 
                                                              AND LinkGoodsObject.ObjectId    = 4--vbObjectId
                               LEFT JOIN Object_Goods_View AS ObjectGoodsView ON ObjectGoodsView.Id = LinkGoodsObject.GoodsId

                               LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = LinkGoodsObject.GoodsId

                          WHERE COALESCE(JuridicalSettings.isPriceClose, FALSE) = FALSE
                          GROUP BY LinkGoodsObject.GoodsId
                        )
                                                
    SELECT tmpGoodsRetail.GoodsId                                             AS GoodsId
         , Object_Goods.ObjectCode                                            AS GoodsCode
         , Object_Goods.ValueData                                             AS GoodsName
         , COALESCE (GoodsPrice.Price, tmpPriceListItem.NewPrice, 0) ::TFloat AS Price
    FROM tmpGoodsRetail
         LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = tmpGoodsRetail.GoodsId
         LEFT JOIN tmpPriceListItem ON tmpPriceListItem.GoodsId_retail = tmpGoodsRetail.GoodsId

         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoodsRetail.GoodsId
    ORDER BY Object_Goods.ObjectCode;
    
    -- старая выборка только товары из прайса подразделения
    /*tmpObject_Price AS (SELECT ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , Price_Goods.ChildObjectId               AS GoodsId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                        WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                        )

    SELECT tmpObject_Price.GoodsId                     AS GoodsId
         , Object_Goods.ObjectCode                     AS GoodsCode
         , Object_Goods.ValueData                      AS GoodsName
         , COALESCE(tmpObject_Price.Price,0)::TFloat   AS Price
    FROM
        tmpObject_Price

        LEFT OUTER JOIN Object AS Object_Goods 
                               ON Object_Goods.Id = tmpObject_Price.GoodsId
    ORDER BY Object_Goods.ObjectCode;
    */


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 11.09.18        *

*/

-- тест
-- SELECT * FROM gpSelect_CashGoods(inSession:= '308120');

