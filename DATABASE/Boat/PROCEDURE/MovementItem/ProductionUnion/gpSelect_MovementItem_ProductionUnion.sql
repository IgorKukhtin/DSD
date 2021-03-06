-- Function: gpSelect_MovementItem_ProductionUnion()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ProductionUnion (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_ProductionUnion (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ProductionUnion (
    IN inMovementId  Integer      , -- ключ Документа
    --IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar
             , ReceiptProdModelId Integer, ReceiptProdModelCode Integer, ReceiptProdModelName TVarChar
             , Amount TFloat

             , Comment TVarChar
             , isErased Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , CIN TVarChar
             )
AS
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbToId         Integer;
  DECLARE vbFromId       Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ProductionUnion());
    vbUserId := lpGetUserBySession (inSession);

    SELECT MovementLinkObject_From.ObjectId        AS FromId
         , MovementLinkObject_To.ObjectId          AS ToId
    INTO vbFromId
       , vbToId
    FROM Movement AS Movement_ProductionUnion
        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement_ProductionUnion.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement_ProductionUnion.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

    WHERE Movement_ProductionUnion.Id = inMovementId
      AND Movement_ProductionUnion.DescId = zc_Movement_ProductionUnion();


                   
 /*   IF inShowAll
    THEN
        RETURN QUERY
        WITH
       tmpIsErased AS (SELECT FALSE AS isErased
                        UNION ALL
                       SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                      )
     --сохраненные строки
     , tmpMI AS   (SELECT MovementItem.ObjectId   AS GoodsId
                        , MovementItem.Amount
                        , MILO_ReceiptProdModel.ObjectId AS ReceiptProdModelId
 
                        , MovementItem.Id
                        , MovementItem.isErased
                        
                        , MIString_Comment.ValueData  AS Comment
 
                        , Object_Insert.ValueData     AS InsertName
                        , MIDate_Insert.ValueData     AS InsertDate
 
                   FROM tmpIsErased
                      JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = tmpIsErased.isErased

                      LEFT JOIN MovementItemLinkObject AS MILO_ReceiptProdModel
                                                       ON MILO_ReceiptProdModel.MovementItemId = MovementItem.Id
                                                      AND MILO_ReceiptProdModel.DescId = zc_MILinkObject_ReceiptProdModel()

                      LEFT JOIN MovementItemString AS MIString_Comment
                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                  AND MIString_Comment.DescId = zc_MIString_Comment()

                      LEFT JOIN MovementItemDate AS MIDate_Insert
                                                 ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                AND MIDate_Insert.DescId = zc_MIDate_Insert()
                      LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                       ON MILO_Insert.MovementItemId = MovementItem.Id
                                                      AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                      LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
                     )

     , tmpGoodsParams AS (SELECT tmpGoods.GoodsId
                               , ObjectString_Article.ValueData     AS Article
                               , Object_GoodsGroup.Id               AS GoodsGroupId
                               , Object_GoodsGroup.ValueData        AS GoodsGroupName
                               , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                               , Object_Measure.Id                  AS MeasureId
                               , Object_Measure.ValueData           AS MeasureName

                                 -- Цена вх. без НДС
                               , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice
                                 -- Цена вх. с НДС
                               , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                                    * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2)) ::TFloat AS EKPriceWVAT

                          FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmpGoods
                              LEFT JOIN ObjectString AS ObjectString_Article
                                                     ON ObjectString_Article.ObjectId = tmpGoods.GoodsId
                                                    AND ObjectString_Article.DescId = zc_ObjectString_Article()

                              LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                     ON ObjectString_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                                    AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                              LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                   ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                              LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                    ON ObjectFloat_EKPrice.ObjectId = tmpGoods.GoodsId
                                                   AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                   ON ObjectLink_Goods_TaxKind.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                              LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                    ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                                   AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
                          )
     -- все ReceiptGoods
     , tmpReceiptGoods AS (SELECT *
                           FROM gpSelect_Object_ReceiptGoods(isErased, inSession) AS tmp
                           )
     -- все лодки ( заказ клиента - проведен + еще не создали док произв.)
     -- Product
   , tmpProduct_all AS (SELECT Object_Product.Id                AS ProductId
                         , Object_Product.ObjectCode        AS ProductCode
                         , Object_Product.ValueData         AS ProductName
                         , ObjectLink_Model.ChildObjectId   AS ModelId
                         , COALESCE (ObjectLink_ReceiptProdModel.ChildObjectId,0) AS ReceiptProdModelId

                    FROM Object AS Object_Product
                         LEFT JOIN ObjectDate AS ObjectDate_DateSale
                                              ON ObjectDate_DateSale.ObjectId = Object_Product.Id
                                             AND ObjectDate_DateSale.DescId = zc_ObjectDate_Product_DateSale()
                         -- Заказы клиента
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                      ON MovementLinkObject_Product.ObjectId = Object_Product.Id
                                                     AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                         INNER JOIN Movement AS Movement_Order 
                                             ON Movement_Order.Id = MovementLinkObject_Product.MovementId
                                            AND Movement_Order.DescId = zc_Movement_OrderClient()
                                            AND Movement_Order.StatusId = zc_Enum_Status_Complete()

                         LEFT JOIN ObjectLink AS ObjectLink_Model
                                              ON ObjectLink_Model.ObjectId = Object_Product.Id
                                             AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model()

                         LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                              ON ObjectLink_ReceiptProdModel.ObjectId = Object_Product.Id
                                             AND ObjectLink_ReceiptProdModel.DescId   = zc_ObjectLink_Product_ReceiptProdModel()

                    WHERE Object_Product.DescId = zc_Object_Product()
                     AND Object_Product.isErased = FALSE
                     AND COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart()
                    )

   -- ищем док. ProductionUnion если какието лодки уже собраны
   , tmpMovProdUnion AS (SELECT MovementItem.ObjectId AS ProductId
                         FROM Movement
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                              INNER JOIN tmpProduct_all ON tmpProduct_all.ProductId = MovementItem.ObjectId
                         WHERE Movement.DescId = zc_Movement_ProductionUnion()
                           AND Movement.StatusId <> zc_Enum_Status_Erased()
                         )
   , tmpProduct AS (SELECT tmpProduct_all.*
                    FROM tmpProduct_all
                         LEFT JOIN tmpMovProdUnion ON tmpMovProdUnion.ProductId = tmpProduct_all.ProductId
                    WHERE tmpMovProdUnion.ProductId IS NULL
                    )
            --Product
            SELECT
                0                          AS Id
              , tmpProduct.ProductId       AS GoodsId
              , tmpProduct.ProductCode     AS GoodsCode
              , tmpProduct.ProductName     AS GoodsName
              , Object_ReceiptProdModel.Id         AS ReceiptProdModelId
              , Object_ReceiptProdModel.ObjectCode AS ReceiptProdModelCode
              , Object_ReceiptProdModel.ValueData  AS ReceiptProdModelName

              , CAST (NULL AS TFloat)      AS Amount
              
              , NULL::TVarChar             AS Comment
              
              , FALSE ::Boolean            AS isErased

              , NULL::TVarChar             AS InsertName
              , NULL::TDateTime            AS InsertDate
              --
              , NULL::TVarChar             AS Article              
              , NULL::TVarChar             AS GoodsGroupName
              , NULL::TVarChar             AS GoodsGroupNameFull
              , NULL::TVarChar             AS MeasureName
              , ObjectString_CIN.ValueData AS CIN

            FROM tmpProduct
                LEFT JOIN tmpMI ON tmpMI.GoodsId = tmpProduct.ProductId

                LEFT JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = tmpProduct.ReceiptProdModelId
    
                LEFT JOIN ObjectString AS ObjectString_CIN
                                       ON ObjectString_CIN.ObjectId = tmpProduct.ProductId
                                      AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

            WHERE tmpMI.GoodsId IS NULL
          UNION ALL
          --ReceiptGoods
            SELECT
                0                          AS Id
              , tmpReceiptGoods.Id       AS GoodsId
              , tmpReceiptGoods.Code     AS GoodsCode
              , tmpReceiptGoods.Name     AS GoodsName
              , 0                          AS ReceiptProdModelId
              , 0                          AS ReceiptProdModelCode
              , NULL::TVarChar             AS ReceiptProdModelName
              , CAST (NULL AS TFloat)      AS Amount
              
              , NULL::TVarChar             AS Comment
              
              , FALSE ::Boolean            AS isErased

              , NULL::TVarChar             AS InsertName
              , NULL::TDateTime            AS InsertDate
              --
              , tmpReceiptGoods.Article AS Article              
              , tmpReceiptGoods.GoodsGroupName     AS GoodsGroupName
              , tmpReceiptGoods.GoodsGroupNameFull AS GoodsGroupNameFull
              , tmpReceiptGoods.MeasureName        AS MeasureName
              , '':: TVarChar               AS CIN

            FROM tmpReceiptGoods
                LEFT JOIN tmpMI ON tmpMI.GoodsId = tmpReceiptGoods.Id
            WHERE tmpMI.GoodsId IS NULL
          UNION ALL
            SELECT
                MovementItem.Id           AS Id
              , MovementItem.GoodsId      AS GoodsId
              , Object_Goods.ObjectCode   AS GoodsCode
              , Object_Goods.ValueData    AS GoodsName

              , Object_ReceiptProdModel.Id         AS ReceiptProdModelId
              , Object_ReceiptProdModel.ObjectCode AS ReceiptProdModelCode
              , Object_ReceiptProdModel.ValueData  AS ReceiptProdModelName
              
              , MovementItem.Amount           ::TFloat

              , MovementItem.Comment    :: TVarChar
              , MovementItem.isErased
              
              , MovementItem.InsertName
              , MovementItem.InsertDate
              
              --
              , tmpGoodsParams.Article
              , tmpGoodsParams.GoodsGroupName
              , tmpGoodsParams.GoodsGroupNameFull
              , tmpGoodsParams.MeasureName
              , '':: TVarChar               AS CIN

            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
                 LEFT JOIN tmpGoodsParams AS tmpGoodsParams ON tmpGoodsParams.GoodsId = MovementItem.GoodsId
                 LEFT JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = MovementItem.ReceiptProdModelId
            ;
    ELSE
    */
       RETURN QUERY
       WITH
       tmpIsErased AS (SELECT FALSE AS isErased
                        UNION ALL
                       SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                      )
     , tmpMI AS   (SELECT MovementItem.ObjectId       AS ObjectId
                        , MILO_ReceiptProdModel.ObjectId AS ReceiptProdModelId
                        , MovementItem.Amount

                        , MovementItem.Id
                        , MovementItem.isErased
                        , MIString_Comment.ValueData  AS Comment
 
                        , Object_Insert.ValueData     AS InsertName
                        , MIDate_Insert.ValueData     AS InsertDate
 
                   FROM tmpIsErased
                      JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = tmpIsErased.isErased

                      LEFT JOIN MovementItemString AS MIString_Comment
                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                  AND MIString_Comment.DescId = zc_MIString_Comment()

                      LEFT JOIN MovementItemLinkObject AS MILO_ReceiptProdModel
                                                       ON MILO_ReceiptProdModel.MovementItemId = MovementItem.Id
                                                      AND MILO_ReceiptProdModel.DescId = zc_MILinkObject_ReceiptProdModel()

                      LEFT JOIN MovementItemDate AS MIDate_Insert
                                                 ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                AND MIDate_Insert.DescId = zc_MIDate_Insert()
                      LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                       ON MILO_Insert.MovementItemId = MovementItem.Id
                                                      AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                      LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
                     )

         -- результат
            SELECT
                MovementItem.Id           AS Id
              , MovementItem.ObjectId      AS ObjectId
              , Object_Object.ObjectCode   AS ObjectCode
              , Object_Object.ValueData    AS ObjectName

              , Object_ReceiptProdModel.Id         AS ReceiptProdModelId
              , Object_ReceiptProdModel.ObjectCode AS ReceiptProdModelCode
              , Object_ReceiptProdModel.ValueData  AS ReceiptProdModelName

              , MovementItem.Amount           ::TFloat

              , MovementItem.Comment ::TVarChar
              , MovementItem.isErased

              , MovementItem.InsertName
              , MovementItem.InsertDate

              , ObjectString_CIN.ValueData     AS CIN
            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementItem.ObjectId

                 LEFT JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = MovementItem.ReceiptProdModelId

                LEFT JOIN ObjectString AS ObjectString_CIN
                                       ON ObjectString_CIN.ObjectId = MovementItem.ObjectId
                                      AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
            ;
   -- END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.21         * 
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ProductionUnion (inMovementId:= 0, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
-- select * from gpSelect_MovementItem_ProductionUnion (inMovementId:= 218 , inShowAll:= TRUE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());