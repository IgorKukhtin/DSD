-- Function: gpSelect_Object_PartionGoods()


DROP FUNCTION IF EXISTS gpSelect_Object_PartionGoods (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionGoods(
    IN inGoodsId      Integer   ,
    IN inUnitId       Integer   ,
    IN inShowAll      Boolean   ,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id  Integer
             , MovementId_ Integer
             , DescName TVarChar
             , InvNumber TVarChar, InvNumberFull TVarChar
             , OperDate Tdatetime 
  
             , UnitId Integer
             , UnitName TVarChar
             , PartnerId Integer
             , PartnerName TVarChar
             , GoodsId Integer
             , GoodsCode Integer
             , GoodsName TVarChar
             , Article TVarChar
             , PartNumber TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , MeasureName TVarChar
             , GoodsTagName TVarChar
             , GoodsTypeName TVarChar
             , ProdColorName TVarChar
             , TaxKindName TVarChar
             , GoodsSizeName TVarChar
             
             , EKPrice TFloat
             , CountForPrice TFloat
             , CostPrice     TFloat
             , OperPrice_cost TFloat
             , OperPriceList  TFloat
             , Amount_in TFloat
             , Remains TFloat
             , isErased Boolean   
             , MovementId_OrderClient Integer
             , InvNumberFull_OrderClient TVarChar
             , FromId_OrderClient Integer , FromName_OrderClient TVarChar
             , ProductName_OrderClient TVarChar
             , CIN_OrderClient TVarChar, ModelName_OrderClient TVarChar
              ) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_PartionGoods());

     RETURN QUERY 
  
   --остатки
   WITH
     tmpPriceBasis AS (SELECT tmp.GoodsId
                            , tmp.ValuePrice
                       FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                , inOperDate   := CURRENT_DATE) AS tmp
                       WHERE (tmp.GoodsId = inGoodsId OR inGoodsId = 0)
                       )

   , tmpObject_PartionGoods AS (SELECT Object_PartionGoods.MovementId
                                     , Object_PartionGoods.MovementItemId
                                     , Object_PartionGoods.UnitId
                                     , Object_PartionGoods.FromId
                                     , Object_PartionGoods.ObjectId
                                     , Object_PartionGoods.GoodsGroupId
                                     , Object_PartionGoods.MeasureId
                                     , Object_PartionGoods.GoodsTagId
                                     , Object_PartionGoods.GoodsTypeId
                                     , Object_PartionGoods.ProdColorId
                                     , Object_PartionGoods.TaxKindId
                                     , Object_PartionGoods.GoodsSizeId
                                     , Object_PartionGoods.CountForPrice
                                     , Object_PartionGoods.EKPrice
                                     , Object_PartionGoods.CostPrice
                                     , Object_PartionGoods.OperPriceList
                                     , Object_PartionGoods.isErased
                                     , SUM (COALESCE (Container.Amount, 0)) AS Remains
                                     , MIFloat_MovementId.ValueData ::Integer AS MovementId_orderclient
                                FROM Object_PartionGoods
                                     JOIN Container ON Container.PartionId      = Object_PartionGoods.MovementItemId
                                                   AND Container.DescId         = zc_Container_Count()
                                                   AND (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                                                   AND (Container.Amount        <> 0 OR inShowAll = TRUE)  
                                     LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                                 ON MIFloat_MovementId.MovementItemId = Object_PartionGoods.MovementItemId
                                                                AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId() 
                                WHERE (Object_PartionGoods.ObjectId = inGoodsId OR inGoodsId = 0)
                                GROUP BY Object_PartionGoods.MovementId
                                       , Object_PartionGoods.MovementItemId
                                       , Object_PartionGoods.UnitId
                                       , Object_PartionGoods.FromId
                                       , Object_PartionGoods.ObjectId
                                       , Object_PartionGoods.GoodsGroupId
                                       , Object_PartionGoods.MeasureId
                                       , Object_PartionGoods.GoodsTagId
                                       , Object_PartionGoods.GoodsTypeId
                                       , Object_PartionGoods.ProdColorId
                                       , Object_PartionGoods.TaxKindId
                                       , Object_PartionGoods.GoodsSizeId
                                       , Object_PartionGoods.CountForPrice
                                       , Object_PartionGoods.EKPrice
                                       , Object_PartionGoods.CostPrice
                                       , Object_PartionGoods.OperPriceList
                                       , Object_PartionGoods.isErased
                                       , MIFloat_MovementId.ValueData
                               )

     -- Результат
     SELECT  tmpObject_PartionGoods.MovementItemId AS Id
           , tmpObject_PartionGoods.MovementId AS MovementId
           , MovementDesc_Partion.ItemName     AS DescName
           , Movement_Partion.InvNumber        AS InvNumber 
           , zfCalc_InvNumber_isErased (MovementDesc_Partion.ItemName, Movement_Partion.InvNumber, Movement_Partion.OperDate, Movement_Partion.StatusId) :: TVarChar AS InvNumberFull
           , Movement_Partion.OperDate         AS OperDate
           
           , Object_Unit.Id                 AS UnitId
           , Object_Unit.ValueData          AS UnitName
           , Object_Partner.Id              AS PartnerId
           , Object_Partner.ValueData       AS PartnerName

           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , ObjectString_Article.ValueData AS Article
           , MIString_PartNumber.ValueData ::TVarChar AS PartNumber
           , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.ValueData       AS MeasureName

           , Object_GoodsTag.ValueData      AS GoodsTagName
           , Object_GoodsType.ValueData     AS GoodsTypeName
           , Object_ProdColor.ValueData     AS ProdColorName
           , Object_TaxKind.ValueData       AS TaxKindName
           , Object_GoodsSize.ValueData     AS GoodsSizeName
           
           , tmpObject_PartionGoods.EKPrice
           , tmpObject_PartionGoods.CountForPrice
             -- Цена без НДС затраты
           , tmpObject_PartionGoods.CostPrice     ::TFloat
             -- Цена вх. с затратами без НДС
           , (tmpObject_PartionGoods.EKPrice / tmpObject_PartionGoods.CountForPrice + COALESCE (tmpObject_PartionGoods.CostPrice,0) ) ::TFloat AS OperPrice_cost
           , COALESCE (tmpPriceBasis.ValuePrice, tmpObject_PartionGoods.OperPriceList) AS OperPriceList
           , CASE WHEN MovementItem.isErased = FALSE AND Movement_Partion.StatusId = zc_Enum_Status_Complete() THEN MovementItem.Amount ELSE 0 END :: TFloat AS Amount_in
           , tmpObject_PartionGoods.Remains       ::TFloat
           , tmpObject_PartionGoods.isErased

           , Movement_OrderClient.Id              AS MovementId_OrderClient
           , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) ::TVarChar AS InvNumberFull_OrderClient
           , Object_From.Id                       AS FromId_OrderClient 
           , Object_From.ValueData    ::TVarChar  AS FromName_OrderClient 
           , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) ::TVarChar AS ProductName_OrderClient
           , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,Object_Product.isErased)::TVarChar AS CIN_OrderClient
           , Object_Model.ValueData   ::TVarChar  AS ModelName_OrderClient
     FROM tmpObject_PartionGoods
            LEFT JOIN Object AS Object_Unit    ON Object_Unit.Id    = tmpObject_PartionGoods.UnitId
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpObject_PartionGoods.FromId
            LEFT JOIN Object AS Object_Goods   ON Object_Goods.Id   = tmpObject_PartionGoods.ObjectId

            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpObject_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = tmpObject_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_GoodsTag   ON Object_GoodsTag.Id   = tmpObject_PartionGoods.GoodsTagId
            LEFT JOIN Object AS Object_GoodsType  ON Object_GoodsType.Id  = tmpObject_PartionGoods.GoodsTypeId
            LEFT JOIN Object AS Object_ProdColor  ON Object_ProdColor.Id  = tmpObject_PartionGoods.ProdColorId
            LEFT JOIN Object AS Object_TaxKind    ON Object_TaxKind.Id    = tmpObject_PartionGoods.TaxKindId
            LEFT JOIN Object AS Object_GoodsSize  ON Object_GoodsSize.Id  = tmpObject_PartionGoods.GoodsSizeId


            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = tmpObject_PartionGoods.ObjectId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmpObject_PartionGoods.ObjectId
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()

            LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id = tmpObject_PartionGoods.MovementId
            LEFT JOIN MovementDesc AS MovementDesc_Partion ON MovementDesc_Partion.Id = Movement_Partion.DescId

            LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = tmpObject_PartionGoods.ObjectId
 
            LEFT JOIN MovementItem ON MovementItem.Id = tmpObject_PartionGoods.MovementItemId
            LEFT JOIN MovementItemString AS MIString_PartNumber
                                         ON MIString_PartNumber.MovementItemId = tmpObject_PartionGoods.MovementItemId
                                        AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                                        
            LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = tmpObject_PartionGoods.MovementId_orderclient

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = MovementItem.MovementId_OrderClient
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                          ON MovementLinkObject_Product.MovementId = MovementItem.MovementId_OrderClient
                                         AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
             LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId  

             LEFT JOIN ObjectString AS ObjectString_CIN
                                    ON ObjectString_CIN.ObjectId = Object_Product.Id
                                   AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

             LEFT JOIN ObjectLink AS ObjectLink_Model
                                  ON ObjectLink_Model.ObjectId = Object_Product.Id
                                 AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model() 
             LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId

;

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.14         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PartionGoods(inGoodsId := 19757 , inUnitId := 38874 , inShowAll := 'False' ,  inSession := '5');
