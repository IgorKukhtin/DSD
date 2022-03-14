-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpSelect_Movement_LoadPriceListItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_LoadPriceListItem(
    IN inLoadPriceListId Integer ,   --
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, CommonCode Integer, BarCode TVarChar, CodeUKTZED TVarChar,
               GoodsCode TVarChar, GoodsName TVarChar, GoodsNDS TVarChar, 
               GoodsId Integer, Code Integer, Name TVarChar, LoadPriceListId Integer, 
               Price TFloat, Remains TFloat, ProducerName TVarChar, ExpirationDate TDateTime,
               PartnerGoodsID Integer, IsPromo Boolean, isResolution_224 Boolean, IsClose Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbAreaId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
--     vbUserId:= lpGetUserBySession (inSession);

     SELECT LoadPriceList.JuridicalId, COALESCE(LoadPriceList.AreaId, 0)
     INTO vbJuridicalId, vbAreaId
     FROM LoadPriceList
     WHERE LoadPriceList.Id = inLoadPriceListId;   
       
     RETURN QUERY
       SELECT
         LoadPriceListItem.Id, 
         LoadPriceListItem.CommonCode, 
         LoadPriceListItem.BarCode, 
         LoadPriceListItem.CodeUKTZED,
         LoadPriceListItem.GoodsCode, 
         LoadPriceListItem.GoodsName, 
         LoadPriceListItem.GoodsNDS, 
         LoadPriceListItem.GoodsId,
         Object_Goods.ObjectCode AS Code,
         Object_Goods.ValueData  AS Name, 
         LoadPriceListItem.LoadPriceListId, 
         LoadPriceListItem.Price, 
         LoadPriceListItem.Remains, 
         LoadPriceListItem.ProducerName, 
         LoadPriceListItem.ExpirationDate,
         PartnerGoods.ID                                         AS PartnerGoodsID,
         COALESCE(PartnerGoods.IsPromo, FALSE)                   AS IsPromo,
         COALESCE(Object_Goods_Main.isResolution_224, FALSE)     AS isResolution_224,
         COALESCE(Object_Goods_Main.IsClose, FALSE)              AS IsClose
       FROM LoadPriceListItem 

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = LoadPriceListItem.GoodsId
            
            LEFT JOIN Object_Goods_Juridical AS PartnerGoods ON PartnerGoods.JuridicalId  = vbJuridicalId
                                                            AND PartnerGoods.Code = LoadPriceListItem.GoodsCode
                                                            AND COALESCE(PartnerGoods.AreaId, 0) = vbAreaId

            LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id  = PartnerGoods.GoodsMainId
                                                         
      WHERE LoadPriceListItem.LoadPriceListId = inLoadPriceListId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_LoadPriceListItem (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.12.17         * LoadPriceListItem.CodeUKTZED
 17.10.14                        *                                 
 01.07.14                        *                                 

*/

-- тест
--  select * from gpSelect_Movement_LoadPriceListItem(inLoadPriceListId := 14774 ,  inSession := '3');

select * from gpSelect_Movement_LoadPriceListItem(inLoadPriceListId := 36140 ,  inSession := '3');