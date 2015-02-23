-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpSelect_GoodsSearch (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsSearch(
    IN inGoodsSearch   TVarChar    -- поиск товаров
  , IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, CommonCode Integer, BarCode TVarChar, 
               GoodsCode TVarChar, GoodsName TVarChar, GoodsNDS TVarChar, 
               GoodsId Integer, Code Integer, Name TVarChar, 
               Price TFloat, ProducerName TVarChar, JuridicalName TVarChar,
               ContractName TVarChar, ExpirationDate TDateTime, 
               MinimumLot TFloat, NDS TFloat
)

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
     vbUserId := inSession;
     vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

     RETURN QUERY
       SELECT
         LoadPriceListItem.Id, 
         LoadPriceListItem.CommonCode, 
         LoadPriceListItem.BarCode, 
         LoadPriceListItem.GoodsCode, 
         LoadPriceListItem.GoodsName, 
         LoadPriceListItem.GoodsNDS, 
         LoadPriceListItem.GoodsId,
         Object_Goods.GoodsCode AS Code,
         Object_Goods.GoodsName  AS Name, 
         LoadPriceListItem.Price, 
         LoadPriceListItem.ProducerName, 
         Object_Juridical.ValueData AS JuridicalName,
         Object_Contract.ValueData  AS ContractName,
         LoadPriceListItem.ExpirationDate,
         PartnerGoods.MinimumLot,
         Object_Goods.NDS

       FROM LoadPriceListItem 

            JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
            LEFT JOIN (SELECT DISTINCT JuridicalId, ContractId, isPriceClose
                         FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId)) AS JuridicalSettings
                    ON JuridicalSettings.JuridicalId = LoadPriceList.JuridicalId 
                   AND JuridicalSettings.ContractId = LoadPriceList.ContractId 

            LEFT JOIN Object_Goods_Main_View AS Object_Goods ON Object_Goods.Id = LoadPriceListItem.GoodsId
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = LoadPriceList.JuridicalId
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = LoadPriceList.ContractId
            LEFT JOIN Object_Goods_View AS PartnerGoods ON PartnerGoods.ObjectId = LoadPriceList.JuridicalId 
                                       AND PartnerGoods.GoodsCode = LoadPriceListItem.GoodsCode
      WHERE upper(LoadPriceListItem.GoodsName) LIKE UPPER('%'||inGoodsSearch||'%') AND inGoodsSearch <> ''
        AND COALESCE(JuridicalSettingsPriceList.isPriceClose, FALSE) <> TRUE; 

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsSearch (TVarChar, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.10.14                        *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_PriceList (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')