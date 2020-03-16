-- Function: gpSelect_GoodsPriceWithVAT_ForSite()

DROP FUNCTION IF EXISTS gpSelect_GoodsPriceWithVAT_ForSite (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsPriceWithVAT_ForSite(
    IN inGoodsID        Integer,    -- Товар
    IN inUnitID         Integer,    -- Подразделение
    IN inPreceWithVAT   TFloat,     -- Цена с НДС
   OUT outPreceWithVAT  TFloat,     -- Цена с НДС
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TFloat

AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbObjectId   Integer;
  DECLARE vbUnitId     Integer;
  DECLARE vbUnitIdStr  TVarChar;
  DECLARE vbAreaId     Integer;
  DECLARE vbGoodsId     Integer;
BEGIN

     IF inPreceWithVAT > 15 
     THEN
       outPreceWithVAT := inPreceWithVAT;
       RETURN;
     END IF;
     
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
     vbUserId := inSession;
     vbObjectId := COALESCE (lpGet_DefaultValue ('zc_Object_Retail', vbUserId), '0');

     -- проверяем регион пользователя
     vbAreaId:= (SELECT outAreaId FROM gpGet_Area_byUser(inSession));

     -- получаем главный товар
     vbGoodsId:= (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inGoodsID);

     if COALESCE (vbAreaId, 0) = 0
     THEN
       vbAreaId:= (SELECT AreaId FROM gpGet_User_AreaId(inSession));
     END IF;

     WITH DD AS (SELECT DISTINCT
            Object_MarginCategoryItem_View.MarginPercent,
            Object_MarginCategoryItem_View.MinPrice,
            Object_MarginCategoryItem_View.MarginCategoryId,
            ROW_NUMBER()OVER(PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId ORDER BY Object_MarginCategoryItem_View.MinPrice) as ORD
        FROM Object_MarginCategoryItem_View
             INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id = Object_MarginCategoryItem_View.Id
                                                           AND Object_MarginCategoryItem.isErased = FALSE
                )
        , MarginCondition AS (SELECT
            D1.MarginCategoryId,
            D1.MarginPercent,
            D1.MinPrice,
            COALESCE(D2.MinPrice, 1000000) AS MaxPrice
        FROM DD AS D1
            LEFT OUTER JOIN DD AS D2 ON D1.MarginCategoryId = D2.MarginCategoryId AND D1.ORD = D2.ORD-1)

          -- Список цены + ТОП
        , GoodsPrice AS
             (SELECT ObjectLink_Price_Goods.ChildObjectId AS GoodsId, COALESCE (ObjectBoolean_Top.ValueData, FALSE) AS isTOP, COALESCE (ObjectFloat_PercentMarkup.ValueData, 0) AS PercentMarkup
              FROM ObjectLink AS ObjectLink_Price_Unit
                   INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                         ON ObjectLink_Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                        AND ObjectLink_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                           ON ObjectBoolean_Top.ObjectId  = ObjectLink_Price_Unit.ObjectId
                                          AND ObjectBoolean_Top.DescId    = zc_ObjectBoolean_Price_Top()
                   LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                         ON ObjectFloat_PercentMarkup.ObjectId = ObjectLink_Price_Unit.ObjectId
                                        AND ObjectFloat_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
              WHERE ObjectLink_Price_Goods.ChildObjectId = inGoodsID
                AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                AND ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Goods()
                AND (ObjectBoolean_Top.ValueData = TRUE OR ObjectFloat_PercentMarkup.ValueData <> 0)
             )
          , JuridicalSettings AS
             (SELECT DISTINCT JuridicalId, ContractId, isPriceCloseOrder
                           FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId) AS JuridicalSettings
                     LEFT JOIN Object AS Object_ContractSettings ON Object_ContractSettings.Id = JuridicalSettings.MainJuridicalId
              WHERE COALESCE (Object_ContractSettings.isErased, FALSE) = FALSE
                   AND JuridicalSettings.MainJuridicalId <> 5603474
             )

          , GoodsPriceAll AS 
             (SELECT
                     LinkGoodsObject.GoodsId             AS GoodsId,
                     Round(LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100, 2) AS Price,
                     zfCalc_SalePrice((LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100),                         -- Цена С НДС
                             CASE WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                      THEN MarginCondition.MarginPercent + COALESCE (ObjectFloat_Contract_Percent.valuedata, 0)
                                  ELSE MarginCondition.MarginPercent + COALESCE (ObjectFloat_Juridical_Percent.valuedata, 0)
                             END,                                                                             -- % наценки в КАТЕГОРИИ
                             COALESCE (NULLIF (GoodsPrice.isTOP, FALSE), ObjectGoodsView.isTop),              -- ТОП позиция
                             COALESCE (NULLIF (GoodsPrice.PercentMarkup, 0), ObjectGoodsView.PercentMarkup),  -- % наценки у товара
                             0.0, --ObjectFloat_Juridical_Percent.valuedata,                                  -- % корректировки у Юр Лица для ТОПа
                             ObjectGoodsView.Price                                                            -- Цена у товара (фиксированная)
                           )         :: TFloat AS PriceOut

                   FROM LoadPriceListItem

                        INNER JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId

                        LEFT JOIN JuridicalSettings
                                ON JuridicalSettings.JuridicalId = LoadPriceList.JuridicalId
                               AND JuridicalSettings.ContractId = LoadPriceList.ContractId

                        LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                              ON ObjectFloat_Juridical_Percent.ObjectId = LoadPriceList.JuridicalId
                                             AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

                        LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                                              ON ObjectFloat_Contract_Percent.ObjectId = LoadPriceList.ContractId
                                             AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

                        LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink
                                                                 ON (Object_MarginCategoryLink.UnitId = vbUnitId)
                                                                AND Object_MarginCategoryLink.JuridicalId = LoadPriceList.JuridicalId

                        LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_all
                                                                 ON COALESCE (Object_MarginCategoryLink_all.UnitId, 0) = 0
                                                                AND Object_MarginCategoryLink_all.JuridicalId = LoadPriceList.JuridicalId
                                                                AND Object_MarginCategoryLink_all.isErased    = FALSE
                                                                AND Object_MarginCategoryLink.JuridicalId IS NULL

                        LEFT JOIN Object_Goods_Main_View AS Object_Goods ON Object_Goods.Id = LoadPriceListItem.GoodsId

                        LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = COALESCE (Object_MarginCategoryLink.MarginCategoryId, Object_MarginCategoryLink_all.MarginCategoryId)
                                                AND (LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice

                        LEFT JOIN Object_Goods_View AS PartnerGoods ON PartnerGoods.ObjectId  = LoadPriceList.JuridicalId
                                                                   AND PartnerGoods.GoodsCode = LoadPriceListItem.GoodsCode
                        LEFT JOIN Object_LinkGoods_View AS LinkGoods ON LinkGoods.GoodsMainId = Object_Goods.Id
                                                                    AND LinkGoods.GoodsId     = PartnerGoods.Id
                        LEFT JOIN Object_LinkGoods_View AS LinkGoodsObject ON LinkGoodsObject.GoodsMainId = Object_Goods.Id
                                                                          AND LinkGoodsObject.ObjectId    = vbObjectId
                        LEFT JOIN Object_Goods_View AS ObjectGoodsView ON ObjectGoodsView.Id = LinkGoodsObject.GoodsId

                        LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = LinkGoodsObject.GoodsId


                  WHERE LoadPriceListItem.GoodsId = vbGoodsId
                    AND COALESCE(JuridicalSettings.isPriceCloseOrder, TRUE)  = FALSE
                    AND (LoadPriceList.AreaId = 0 OR COALESCE (LoadPriceList.AreaId, 0) = vbAreaId OR COALESCE(vbAreaId, 0) = 0 OR
                         COALESCE (LoadPriceList.AreaId, 0) = zc_Area_Basis()))
          , GoodsPriceOne AS 
              (SELECT
                      ROW_NUMBER() OVER (PARTITION BY GoodsPriceAll.GoodsId ORDER BY GoodsPriceAll.PriceOut)::Integer AS Ord,
                      GoodsPriceAll.GoodsId           AS GoodsId,
                      GoodsPriceAll.Price             AS Price
               FROM GoodsPriceAll)

     SELECT GoodsPriceOne.Price
     INTO outPreceWithVAT
     FROM GoodsPriceOne
     WHERE Ord = 1;
     
     outPreceWithVAT := COALESCE(outPreceWithVAT, inPreceWithVAT);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 05.12.18                                                                                     *
 26.11.18                                                                                     *
 11.09.18        *
*/

-- тест
-- 
SELECT * FROM gpSelect_GoodsPriceWithVAT_ForSite (inGoodsID := 5740550, inUnitID := 377610, inPreceWithVAT := 10, inSession := '3354092');