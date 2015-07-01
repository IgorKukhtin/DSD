-- Function: gpSelect_Movement_Pri/ceList()      

DROP FUNCTION IF EXISTS gpSelect_GoodsPrice (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsPrice(
    IN inGoodsCode     Integer    -- поиск товаров
  , IN inUnitId        Integer     -- 
  , IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsCode Integer, GoodsName TVarChar, NewPrice TFloat)

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
     vbUserId := inSession;
     vbObjectId := COALESCE(lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');

     RETURN QUERY
     WITH DD AS (SELECT DISTINCT Object_MarginCategoryItem_View.MarginPercent
                               , Object_MarginCategoryItem_View.MinPrice
                               , Object_MarginCategoryItem_View.MarginCategoryId
                 FROM Object_MarginCategoryItem_View ),
                MarginCondition AS (SELECT DD.MarginCategoryId, DD.MarginPercent, DD.MinPrice, 
                                    COALESCE((SELECT MIN(FF.minprice) 
                                              FROM DD AS FF WHERE FF.MinPrice > DD.MinPrice AND FF.MarginCategoryId = DD.MarginCategoryId), 1000000) AS MaxPrice 
                               FROM DD), 

   DDD AS (SELECT DD.Code, DD.Name, DD.NewPrice FROM (
   SELECT
         Object_Goods.GoodsCode AS Code,
         Object_Goods.GoodsName  AS Name, 
         zfCalc_SalePrice((LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100), -- Цена С НДС
                           MarginCondition.MarginPercent + COALESCE(ObjectFloat_Percent.valuedata, 0), -- % наценки
                           ObjectGoodsView.isTop, -- ТОП позиция
                           ObjectGoodsView.PercentMarkup, -- % наценки у товара
                           ObjectFloat_Percent.valuedata,
                           ObjectGoodsView.Price)::TFloat AS NewPrice

       FROM LoadPriceListItem 

            JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
            LEFT JOIN (SELECT DISTINCT JuridicalId, ContractId, isPriceClose
                         FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId)) AS JuridicalSettings
                    ON JuridicalSettings.JuridicalId = LoadPriceList.JuridicalId 
                   AND JuridicalSettings.ContractId = LoadPriceList.ContractId 

            LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                  ON ObjectFloat_Percent.ObjectId = LoadPriceList.JuridicalId
                                 AND ObjectFloat_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

            LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink  
                                                     ON (Object_MarginCategoryLink.UnitId = inUnitId)    
                                                    AND Object_MarginCategoryLink.JuridicalId = LoadPriceList.JuridicalId

            LEFT JOIN Object_Goods_Main_View AS Object_Goods ON Object_Goods.Id = LoadPriceListItem.GoodsId
            LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = Object_MarginCategoryLink.MarginCategoryId
                                     AND (LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100)::TFloat 
                                     BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = LoadPriceList.JuridicalId
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = LoadPriceList.ContractId
            LEFT JOIN Object_Goods_View AS PartnerGoods ON PartnerGoods.ObjectId = LoadPriceList.JuridicalId 
                                       AND PartnerGoods.GoodsCode = LoadPriceListItem.GoodsCode
            LEFT JOIN Object_LinkGoods_View AS LinkGoods ON LinkGoods.GoodsMainId = Object_Goods.Id 
                                                        AND LinkGoods.GoodsId = PartnerGoods.Id
            LEFT JOIN Object_LinkGoods_View AS LinkGoodsObject ON LinkGoodsObject.GoodsMainId = Object_Goods.Id 
                                                              AND LinkGoodsObject.ObjectId = vbObjectId
            LEFT JOIN Object_Goods_View AS ObjectGoodsView ON ObjectGoodsView.Id = LinkGoodsObject.GoodsId
      WHERE Object_Goods.GoodsCode = inGoodsCode
        AND COALESCE(JuridicalSettings.isPriceClose, FALSE) <> TRUE) AS DD)

        SELECT * FROM DDD
        WHERE DDD.NewPrice > 0.01
        order by DDD.NewPrice
        limit 1; 

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsPrice (Integer, Integer,  TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.06.15                        *
 27.04.15                        *
 02.04.15                        *
 29.10.14                        *

*/

-- тест
-- SELECT * FROM gpSelect_GoodsPrice (1001, 183293, inSession:= '2')