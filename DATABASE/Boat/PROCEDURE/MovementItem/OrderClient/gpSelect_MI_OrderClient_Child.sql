-- Function: gpSelect_MI_Invoice_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderClient_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderClient_Child(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ObjectId Integer, ObjectCode Integer, Article_Object TVarChar, ObjectName TVarChar, DescName TVarChar
             , GoodsId Integer, GoodsCode Integer, Article TVarChar, GoodsName TVarChar
             , UnitId Integer, UnitName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , Amount TFloat, AmountPartner TFloat
             , OperPrice TFloat
             , TotalSumm_unit TFloat
             , TotalSumm_partner TFloat
             , TotalSumm TFloat
             , isErased Boolean
             , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar
             , MeasureName TVarChar
             , GoodsTagName    TVarChar
             , GoodsTypeName   TVarChar
             , ProdColorName   TVarChar
             , ProdOptionsName TVarChar
             , TaxKindName    TVarChar
             , Amount_in      TFloat -- Итого кол-во Приход от поставщика
             , EKPrice        TFloat -- Цена вх.
             , CountForPrice  TFloat -- Кол. в цене вх.
             , OperPriceList  TFloat -- Цена по прайсу  
             , CostPrice      TFloat -- Цена вх + затрата 
             , OperPrice_cost TFloat -- сумма затраты
             , tmp1           TDateTime 
             
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры

     vbUserId:= lpGetUserBySession (inSession);

      RETURN QUERY
        WITH -- существующие элементы ProdColorItems - у Лодки (здесь Boat Structure)
             tmpProdColorItems AS (SELECT ObjectLink_Product.ChildObjectId          AS ProductId
                                        , ObjectLink_ProdColorPattern.ChildObjectId AS ProdColorPatternId
                                          -- здесь цвет (когда нет GoodsId)
                                        , CASE WHEN TRIM (ObjectString_Comment.ValueData) <> '' THEN TRIM (ObjectString_Comment.ValueData) ELSE TRIM (COALESCE (ObjectString_ProdColorPattern_Comment.ValueData, '')) END AS ProdColorName
        
                                   FROM Object AS Object_ProdColorItems
                                        -- Лодка
                                        INNER JOIN ObjectLink AS ObjectLink_Product
                                                              ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                                             AND ObjectLink_Product.DescId   = zc_ObjectLink_ProdColorItems_Product()
                                        -- Заказ Клиента
                                        INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                                               ON ObjectFloat_MovementId_OrderClient.ObjectId = Object_ProdColorItems.Id
                                                              AND ObjectFloat_MovementId_OrderClient.DescId   = zc_ObjectFloat_ProdColorItems_OrderClient()
                                                              AND ObjectFloat_MovementId_OrderClient.ValueData = inMovementId
        
                                        -- здесь цвет, если было изменение для Лодки (когда нет GoodsId)
                                        LEFT JOIN ObjectString AS ObjectString_Comment
                                                               ON ObjectString_Comment.ObjectId = Object_ProdColorItems.Id
                                                              AND ObjectString_Comment.DescId   = zc_ObjectString_ProdColorItems_Comment()
        
                                        -- если меняли на другой товар, не тот что в ReceiptGoodsChild
                                        LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                             ON ObjectLink_Goods.ObjectId = Object_ProdColorItems.Id
                                                            AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorItems_Goods()
                                        -- Элемент
                                        LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                             ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                                            AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                        -- здесь цвет из Boat Structure (когда нет GoodsId)
                                        LEFT JOIN ObjectString AS ObjectString_ProdColorPattern_Comment
                                                               ON ObjectString_ProdColorPattern_Comment.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                              AND ObjectString_ProdColorPattern_Comment.DescId   = zc_ObjectString_ProdColorPattern_Comment()
        
                                        -- Шаблон Boat Structure
                                        LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                                             ON ObjectLink_ColorPattern.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                            AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()

                                   WHERE Object_ProdColorItems.DescId   = zc_Object_ProdColorItems()
                                     AND Object_ProdColorItems.isErased = FALSE
                                     -- !!!если Товара НЕТ!!!
                                     AND ObjectLink_Goods.ChildObjectId IS NULL
                                  )
            , tmpItem AS (SELECT MILinkObject_Goods.ObjectId            AS GoodsId
                               , MILinkObject_ProdColorPattern.ObjectId AS ProdColorPatternId
                               , MILinkObject_ColorPattern.ObjectId     AS ColorPatternId
                          FROM MovementItem
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                                                ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_ColorPattern
                                                                ON MILinkObject_ColorPattern.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_ColorPattern.DescId         = zc_MILinkObject_ColorPattern()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Child()
                         )
   -- все Элементы сборки Модели - у Лодки - здесь вся база
 , tmpReceiptProdModelChild_all AS (SELECT tmpProduct.Id          AS ProductId
                                           --
                                         , lpSelect.ReceiptProdModelId, lpSelect.ReceiptProdModelChildId
                                           --
                                         , lpSelect.ObjectId_parent
                                           -- либо Goods "такой" как в Boat Structure /либо другой Goods, не такой как в Boat Structure /либо ПУСТО
                                         , lpSelect.ObjectId
                                           --
                                         , lpSelect.ProdColorPatternId
                                         , lpSelect.ProdOptionsId

                                    FROM lpSelect_Object_ReceiptProdModelChild_detail (vbUserId) AS lpSelect
                                         -- ограничили элементом Сборки
                                         JOIN (SELECT DISTINCT ObjectLink_ReceiptProdModel.ChildObjectId AS ReceiptProdModelId
                                               FROM tmpProdColorItems
                                                    JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                                    ON ObjectLink_ReceiptProdModel.ObjectId = tmpProdColorItems.ProductId
                                                                   AND ObjectLink_ReceiptProdModel.DescId   = zc_ObjectLink_Product_ReceiptProdModel()
                                              ) ON tmpProduct.ReceiptProdModelId = lpSelect.ReceiptProdModelId
                                         -- ограничили элементом Сборки
                                         JOIN (SELECT DISTINCT tmpItem.GoodsId FROM tmpItem) AS tmpItem ON tmpItem.GoodsId = lpSelect.ObjectId_parent
                                   )
        -- Результат
        SELECT
             MovementItem.Id                          AS Id

           , Object_Object.Id                         AS ObjectId
           , Object_Object.ObjectCode                 AS ObjectCode
           , ObjectString_Article_Object.ValueData    AS Article_Object
           , Object_Object.ValueData                  AS ObjectName
           , ObjectDesc_Object.ItemName               AS DescName

           , Object_Goods.Id                          AS GoodsId
           , Object_Goods.ObjectCode                  AS GoodsCode
           , ObjectString_Article.ValueData           AS Article
           , Object_Goods.ValueData                   AS GoodsName

           , Object_Unit.Id                           AS UnitId
           , Object_Unit.ValueData                    AS UnitName 
           , Object_Partner.Id                        AS PartnerId
           , Object_Partner.ValueData                 AS PartnerName 
           , MovementItem.Amount             ::TFloat AS Amount            --Количество резерв
           , MIFloat_AmountPartner.ValueData ::TFloat AS AmountPartner     --Количество заказ поставщику
           , MIFloat_OperPrice.ValueData     ::TFloat AS OperPrice         -- Цена вх без НДС

           , (MovementItem.Amount * MIFloat_OperPrice.ValueData)                                                                 :: TFloat AS TotalSumm_unit
           , (MIFloat_AmountPartner.ValueData * MIFloat_OperPrice.ValueData)                                                     :: TFloat AS TotalSumm_partner
           , ((COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountPartner.ValueData, 0)) * MIFloat_OperPrice.ValueData) :: TFloat AS TotalSumm

           , MovementItem.isErased

           , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.ValueData       AS MeasureName
           , Object_GoodsTag.ValueData      AS GoodsTagName
           , Object_GoodsType.ValueData     AS GoodsTypeName
           , CASE WHEN Object_ProdColor.ValueData <> ''
                  THEN Object_ProdColor.ValueData
                    || CASE WHEN tmpProdColorItems.ProdColorName <> '' THEN '; ' || tmpProdColorItems.ProdColorName ELSE '' END
                  ELSE tmpProdColorItems.ProdColorName
             END :: TVarChar AS ProdColorName
           , Object_ProdOptions.ValueData   AS ProdOptionsName
           , Object_TaxKind.ValueData       AS TaxKindName
           , Object_PartionGoods.Amount     AS Amount_in
           , Object_PartionGoods.EKPrice
           , Object_PartionGoods.CountForPrice
           , Object_PartionGoods.OperPriceList ::TFloat                                                                                                     -- Цена по прайсу
           , Object_PartionGoods.CostPrice     ::TFloat                                                                                                     -- Цена затраты без НДС 
           , (Object_PartionGoods.EKPrice / Object_PartionGoods.CountForPrice + COALESCE (Object_PartionGoods.CostPrice,0) ) ::TFloat AS OperPrice_cost     -- Цена вх. с затратами без НДС
           
           , CURRENT_DATE :: TDateTime AS tmp1
                           
       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Child()
                                   AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId

            LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementItem.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Article_object
                                   ON ObjectString_Article_object.ObjectId = Object_Object.Id
                                  AND ObjectString_Article_object.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectDesc AS ObjectDesc_Object ON ObjectDesc_Object.Id = Object_Object.DescId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MILinkObject_Goods.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = Object_Goods.Id
                                  AND ObjectString_Article.DescId   = zc_ObjectString_Article()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                             ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = MovementItem.ObjectId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                 ON ObjectLink_ProdColor.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsTag
                                 ON ObjectLink_GoodsTag.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_GoodsTag.DescId   = zc_ObjectLink_Goods_GoodsTag()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsType
                                 ON ObjectLink_GoodsType.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()
            LEFT JOIN ObjectLink AS ObjectLink_Measure
                                 ON ObjectLink_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                 ON ObjectLink_GoodsGroup.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                             ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ProdOptions.DescId = zc_MILinkObject_ProdOptions()
            LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = MILinkObject_ProdOptions.ObjectId
            --
            LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = COALESCE (Object_PartionGoods.FromId, MILinkObject_Partner.ObjectId)
            LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = COALESCE (Object_PartionGoods.GoodsGroupId, ObjectLink_GoodsGroup.ChildObjectId)
            LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = COALESCE (Object_PartionGoods.MeasureId, ObjectLink_Measure.ChildObjectId)
            LEFT JOIN Object AS Object_GoodsTag    ON Object_GoodsTag.Id    = COALESCE (Object_PartionGoods.GoodsTagId, ObjectLink_GoodsTag.ChildObjectId)
            LEFT JOIN Object AS Object_GoodsType   ON Object_GoodsType.Id   = COALESCE (Object_PartionGoods.GoodsTypeId, ObjectLink_GoodsType.ChildObjectId)
            LEFT JOIN Object AS Object_ProdColor   ON Object_ProdColor.Id   = COALESCE (Object_PartionGoods.ProdColorId, ObjectLink_ProdColor.ChildObjectId)
            LEFT JOIN Object AS Object_TaxKind     ON Object_TaxKind.Id     = Object_PartionGoods.TaxKindId
            
            LEFT JOIN MovementItemLinkObject AS MILinkObject_ColorPattern
                                             ON MILinkObject_ColorPattern.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ColorPattern.DescId         = zc_MILinkObject_ColorPattern()
            LEFT JOIN (SELECT tmpItem.GoodsId
                            , STRING_AGG (tmpProdColorItems.ProdColorName, ';') AS ProdColorName
                       FROM tmpProdColorItems
                            JOIN tmpItem ON tmpItem.ColorPatternId = tmpProdColorItems.ColorPatternId
                       GROUP BY tmpItem.GoodsId
                      ) AS tmpProdColorItems ON tmpProdColorItems.GoodsId = MILinkObject_Goods.ObjectId
                                            AND Object_Object.DescId      = zc_Object_ReceiptService()
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 18.07.16         * 
*/

-- тест
-- SELECT * from gpSelect_MI_OrderClient_Child (inMovementId:= 224, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
