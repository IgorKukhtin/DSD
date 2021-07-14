-- Function: gpSelect_MI_ProductionUnion_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_ProductionUnion_Child (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionUnion_Child(
    IN inMovementId       Integer      , -- ключ Документа
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, NPP Integer, ParentId Integer
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar
             , DescName TVarChar
             , Amount TFloat
             , isErased Boolean
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar
             , Value TFloat, Value_servise TFloat
             , Amount_diff TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры

     vbUserId:= lpGetUserBySession (inSession);

    IF inShowAll
    THEN
     RETURN QUERY
     WITH
     tmpIsErased AS (SELECT FALSE AS isErased
                                UNION ALL
                               SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                              )
   , tmpMI_Master AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId
                           , MILO_ReceiptProdModel.ObjectId AS ReceiptProdModelId
                      FROM tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                           LEFT JOIN MovementItemLinkObject AS MILO_ReceiptProdModel
                                                            ON MILO_ReceiptProdModel.MovementItemId = MovementItem.Id
                                                           AND MILO_ReceiptProdModel.DescId = zc_MILinkObject_ReceiptProdModel()
                     )

   , tmpReceiptProdModelChild AS (SELECT tmpMI_Master.Id AS ParentId
                                       , ObjectFloat_Value.ValueData       ::TFloat   AS Value
                                       , Object_Object.DescId
                                       , ObjectDesc.ItemName               ::TVarChar AS DescName
                                       , Object_Object.Id                  ::Integer  AS ObjectId
                                       , Object_Object.ObjectCode          ::Integer  AS ObjectCode
                                       , Object_Object.ValueData           ::TVarChar AS ObjectName
                                  FROM tmpMI_Master
                                       INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                             ON ObjectLink_ReceiptProdModel.ChildObjectId = tmpMI_Master.ReceiptProdModelId  --Object_ReceiptProdModelChild.Id
                                                            AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                       LEFT JOIN Object AS Object_ReceiptProdModelChild
                                                        ON Object_ReceiptProdModelChild.Id = ObjectLink_ReceiptProdModel.ObjectId
                                                       AND Object_ReceiptProdModelChild.DescId = zc_Object_ReceiptProdModelChild()
                                                       AND Object_ReceiptProdModelChild.isErased = FALSE
                             
                                       LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                             ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                                                            AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptProdModelChild_Value() 

                                       INNER JOIN ObjectLink AS ObjectLink_Object
                                                            ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                           AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptProdModelChild_Object()
                                       INNER JOIN Object AS Object_Object
                                                        ON Object_Object.Id = ObjectLink_Object.ChildObjectId
                                                       AND Object_Object.DescId = zc_Object_Goods()
                                       LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId
                                  WHERE COALESCE (tmpMI_Master.ReceiptProdModelId,0) <> 0
                                  )

   , tmpReceiptGoodsChild AS (SELECT tmpMI_Master.Id AS ParentId
                                   , ObjectFloat_Value.ValueData       ::TFloat   AS Value
                                   , Object_Object.DescId
                                   , ObjectDesc.ItemName               ::TVarChar AS DescName
                                   , Object_Object.Id                  ::Integer  AS ObjectId
                                   , Object_Object.ObjectCode          ::Integer  AS ObjectCode
                                   , Object_Object.ValueData           ::TVarChar AS ObjectName
                              FROM tmpMI_Master
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                        ON ObjectLink_ReceiptGoods.ChildObjectId = tmpMI_Master.ObjectId
                                                       AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()

                                   LEFT JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id = ObjectLink_ReceiptGoods.ObjectId 

                                   LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                         ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                                        AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptGoodsChild_Value()  

                                   LEFT JOIN ObjectLink AS ObjectLink_Object
                                                        ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                       AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
      
                                   INNER JOIN Object AS Object_Object
                                                    ON Object_Object.Id = ObjectLink_Object.ChildObjectId
                                                   AND Object_Object.DescId = zc_Object_Goods()
                                   LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId
                              WHERE COALESCE (tmpMI_Master.ReceiptProdModelId,0) = 0
                              )

   , tmpMI AS (SELECT MovementItem.ObjectId   AS ObjectId
                    , MovementItem.Amount
                    , MovementItem.Id
                    , MovementItem.ParentId
                    , MovementItem.isErased
               FROM tmpIsErased
                    JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                     AND MovementItem.DescId     = zc_MI_Child()
                                     AND MovementItem.isErased   = tmpIsErased.isErased
              )

     , tmpGoodsParams AS (SELECT tmpGoods.ObjectId
                               , ObjectString_Article.ValueData     AS Article
                               , Object_GoodsGroup.Id               AS GoodsGroupId
                               , Object_GoodsGroup.ValueData        AS GoodsGroupName
                               , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                               , Object_Measure.Id                  AS MeasureId
                               , Object_Measure.ValueData           AS MeasureName
                               , Object_ProdColor.ValueData            :: TVarChar AS ProdColorName

                          FROM (SELECT tmpReceiptProdModelChild.ObjectId AS ObjectId
                                FROM tmpReceiptProdModelChild
                             UNION
                                SELECT tmpReceiptGoodsChild.ObjectId AS ObjectId
                                FROM tmpReceiptGoodsChild
                             UNION
                                SELECT tmpMI.ObjectId AS ObjectId
                                FROM tmpMI
                                ) AS tmpGoods
                              LEFT JOIN ObjectString AS ObjectString_Article
                                                     ON ObjectString_Article.ObjectId = tmpGoods.ObjectId
                                                    AND ObjectString_Article.DescId = zc_ObjectString_Article()

                              LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                     ON ObjectString_GoodsGroupFull.ObjectId = tmpGoods.ObjectId
                                                    AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.ObjectId
                                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                              LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                   ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.ObjectId
                                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                   ON ObjectLink_Goods_ProdColor.ObjectId = tmpGoods.ObjectId
                                                  AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                              LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId
                          )


     SELECT
         0 AS Id
       , 0 :: Integer AS NPP
       , tmpReceiptProdModelChild.ParentId
       , tmpReceiptProdModelChild.ObjectId       AS ObjectId
       , tmpReceiptProdModelChild.ObjectCode     AS ObjectCode
       , tmpReceiptProdModelChild.ObjectName     AS ObjectName
       , tmpReceiptProdModelChild.DescName ::TVarChar
       , 0 ::TFloat AS Amount
       , FALSE                                   AS isErased

       , tmpGoodsParams.GoodsGroupNameFull
       , tmpGoodsParams.GoodsGroupName
       , tmpGoodsParams.Article
       , tmpGoodsParams.ProdColorName
       , tmpGoodsParams.MeasureName
       , CASE WHEN tmpReceiptProdModelChild.DescId <> zc_Object_ReceiptService() THEN tmpReceiptProdModelChild.Value ELSE 0 END ::TFloat   AS Value
       , CASE WHEN tmpReceiptProdModelChild.DescId =  zc_Object_ReceiptService() THEN tmpReceiptProdModelChild.Value ELSE 0 END ::TFloat   AS Value_servise
       --разница от введенного
       , (0 - tmpReceiptProdModelChild.Value) :: TFloat AS Amount_diff
     FROM tmpReceiptProdModelChild
          LEFT JOIN tmpMI ON tmpMI.Id = tmpReceiptProdModelChild.ParentId
          LEFT JOIN tmpGoodsParams ON tmpGoodsParams.ObjectId = tmpReceiptProdModelChild.ObjectId
     WHERE tmpMI.ObjectId IS NULL
  UNION ALL
     SELECT
         0 AS Id
       , 0 :: Integer AS NPP
       , tmpReceiptGoodsChild.ParentId
       , tmpReceiptGoodsChild.ObjectId       AS ObjectId
       , tmpReceiptGoodsChild.ObjectCode     AS ObjectCode
       , tmpReceiptGoodsChild.ObjectName     AS ObjectName
       , tmpReceiptGoodsChild.DescName    ::TVarChar
       , 0 ::TFloat AS Amount
       , FALSE                               AS isErased

       , tmpGoodsParams.GoodsGroupNameFull
       , tmpGoodsParams.GoodsGroupName
       , tmpGoodsParams.Article
       , tmpGoodsParams.ProdColorName
       , tmpGoodsParams.MeasureName
       , CASE WHEN tmpReceiptGoodsChild.DescId <> zc_Object_ReceiptService() THEN tmpReceiptGoodsChild.Value ELSE 0 END ::TFloat   AS Value
       , CASE WHEN tmpReceiptGoodsChild.DescId =  zc_Object_ReceiptService() THEN tmpReceiptGoodsChild.Value ELSE 0 END ::TFloat   AS Value_servise
       --разница от введенного
       , (0 - tmpReceiptGoodsChild.Value) :: TFloat AS Amount_diff       
     FROM tmpReceiptGoodsChild
          LEFT JOIN tmpMI ON tmpMI.Id = tmpReceiptGoodsChild.ParentId
          LEFT JOIN tmpGoodsParams ON tmpGoodsParams.ObjectId = tmpReceiptGoodsChild.ObjectId
     WHERE tmpMI.ObjectId IS NULL
  UNION ALL
     SELECT
         MovementItem.Id
       , ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId ORDER BY MovementItem.Id ASC) :: Integer AS NPP
       , MovementItem.ParentId
       , MovementItem.ObjectId      AS ObjectId
       , Object_Object.ObjectCode   AS ObjectCode
       , Object_Object.ValueData    AS ObjectName
       , ObjectDesc.ItemName               ::TVarChar AS DescName
       , MovementItem.Amount           ::TFloat
       , MovementItem.isErased

       , tmpGoodsParams.GoodsGroupNameFull
       , tmpGoodsParams.GoodsGroupName
       , tmpGoodsParams.Article
       , tmpGoodsParams.ProdColorName
       , tmpGoodsParams.MeasureName
       , CASE WHEN Object_Object.DescId <> zc_Object_ReceiptService() THEN COALESCE (tmpReceiptProdModelChild.Value, tmpReceiptGoodsChild.Value) ELSE 0 END ::TFloat   AS Value
       , CASE WHEN Object_Object.DescId =  zc_Object_ReceiptService() THEN COALESCE (tmpReceiptProdModelChild.Value, tmpReceiptGoodsChild.Value) ELSE 0 END ::TFloat   AS Value_servise
       --разница от введенного
       , ( MovementItem.Amount - COALESCE (tmpReceiptProdModelChild.Value, tmpReceiptGoodsChild.Value)) :: TFloat AS Amount_diff
     FROM tmpMI AS MovementItem
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementItem.ObjectId
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId
          
          LEFT JOIN tmpGoodsParams ON tmpGoodsParams.ObjectId = MovementItem.ObjectId

          LEFT JOIN tmpReceiptProdModelChild ON tmpReceiptProdModelChild.ParentId = MovementItem.ParentId
                                            AND tmpReceiptProdModelChild.ObjectId = MovementItem.ObjectId
          LEFT JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ParentId = MovementItem.ParentId
                                        AND tmpReceiptGoodsChild.ObjectId = MovementItem.ObjectId
     ;
   ELSE 
   RETURN QUERY
    WITH
     tmpIsErased AS (SELECT FALSE AS isErased
                                UNION ALL
                               SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                              )

   , tmpMI_Master AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId
                           , MILO_ReceiptProdModel.ObjectId AS ReceiptProdModelId
                      FROM tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                           LEFT JOIN MovementItemLinkObject AS MILO_ReceiptProdModel
                                                            ON MILO_ReceiptProdModel.MovementItemId = MovementItem.Id
                                                           AND MILO_ReceiptProdModel.DescId = zc_MILinkObject_ReceiptProdModel()
                     )

   , tmpReceiptProdModelChild AS (SELECT tmpMI_Master.Id AS ParentId
                                       , ObjectFloat_Value.ValueData       ::TFloat   AS Value
                                       , ObjectDesc.ItemName               ::TVarChar AS DescName
                                       , Object_Object.Id                  ::Integer  AS ObjectId
                                       , Object_Object.ObjectCode          ::Integer  AS ObjectCode
                                       , Object_Object.ValueData           ::TVarChar AS ObjectName
                                  FROM tmpMI_Master
                                       INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                             ON ObjectLink_ReceiptProdModel.ChildObjectId = tmpMI_Master.ReceiptProdModelId  --Object_ReceiptProdModelChild.Id
                                                            AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                       LEFT JOIN Object AS Object_ReceiptProdModelChild
                                                        ON Object_ReceiptProdModelChild.Id = ObjectLink_ReceiptProdModel.ObjectId
                                                       AND Object_ReceiptProdModelChild.DescId = zc_Object_ReceiptProdModelChild()
                                                       AND Object_ReceiptProdModelChild.isErased = FALSE
                             
                                       LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                             ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                                                            AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptProdModelChild_Value() 

                                       INNER JOIN ObjectLink AS ObjectLink_Object
                                                            ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                           AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptProdModelChild_Object()
                                       INNER JOIN Object AS Object_Object
                                                        ON Object_Object.Id = ObjectLink_Object.ChildObjectId
                                                       AND Object_Object.DescId IN (zc_Object_Goods(),zc_Object_ReceiptService())
                                       LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId
                                  WHERE COALESCE (tmpMI_Master.ReceiptProdModelId,0) <> 0
                                  )

   , tmpReceiptGoodsChild AS (SELECT tmpMI_Master.Id AS ParentId
                                   , ObjectFloat_Value.ValueData       ::TFloat   AS Value
                                   , ObjectDesc.ItemName               ::TVarChar AS DescName
                                   , Object_Object.Id                  ::Integer  AS ObjectId
                                   , Object_Object.ObjectCode          ::Integer  AS ObjectCode
                                   , Object_Object.ValueData           ::TVarChar AS ObjectName
                              FROM tmpMI_Master
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                        ON ObjectLink_ReceiptGoods.ChildObjectId = tmpMI_Master.ObjectId
                                                       AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()

                                   LEFT JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id = ObjectLink_ReceiptGoods.ObjectId 

                                   LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                         ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                                        AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptGoodsChild_Value()  

                                   LEFT JOIN ObjectLink AS ObjectLink_Object
                                                        ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                       AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
      
                                   INNER JOIN Object AS Object_Object
                                                    ON Object_Object.Id = ObjectLink_Object.ChildObjectId
                                                   AND Object_Object.DescId IN (zc_Object_Goods(),zc_Object_ReceiptService())
                                   LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId
                              WHERE COALESCE (tmpMI_Master.ReceiptProdModelId,0) = 0
                              )

   , tmpMI AS (SELECT MovementItem.ObjectId   AS ObjectId
                    , MovementItem.Amount
                    , MovementItem.Id
                    , MovementItem.ParentId
                    , MovementItem.isErased
               FROM tmpIsErased
                    JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                     AND MovementItem.DescId     = zc_MI_Child()
                                     AND MovementItem.isErased   = tmpIsErased.isErased
              )


     SELECT
         MovementItem.Id
       , ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId ORDER BY MovementItem.Id ASC) :: Integer AS NPP
       , MovementItem.ParentId
       , MovementItem.ObjectId      AS ObjectId
       , Object_Object.ObjectCode   AS ObjectCode
       , Object_Object.ValueData    AS ObjectName
       , ObjectDesc.ItemName ::TVarChar AS DescName
       , MovementItem.Amount           ::TFloat
       , MovementItem.isErased

       , ObjectString_GoodsGroupFull.ValueData ::TVarChar  AS GoodsGroupNameFull
       , Object_GoodsGroup.ValueData           ::TVarChar  AS GoodsGroupName
       , ObjectString_Article.ValueData        ::TVarChar  AS Article
       , Object_ProdColor.ValueData            :: TVarChar AS ProdColorName
       , Object_Measure.ValueData              ::TVarChar  AS MeasureName
       , CASE WHEN Object_Object.DescId <> zc_Object_ReceiptService() THEN COALESCE (tmpReceiptProdModelChild.Value, tmpReceiptGoodsChild.Value) ELSE 0 END ::TFloat   AS Value
       , CASE WHEN Object_Object.DescId =  zc_Object_ReceiptService() THEN COALESCE (tmpReceiptProdModelChild.Value, tmpReceiptGoodsChild.Value) ELSE 0 END ::TFloat   AS Value_servise
       --разница от введенного
       , ( MovementItem.Amount - COALESCE (tmpReceiptProdModelChild.Value, tmpReceiptGoodsChild.Value)) :: TFloat AS Amount_diff
     FROM tmpMI AS MovementItem
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementItem.ObjectId
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId
          
          --
          LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                 ON ObjectString_GoodsGroupFull.ObjectId = Object_Object.Id
                                AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectString AS ObjectString_Article
                                 ON ObjectString_Article.ObjectId = Object_Object.Id
                                AND ObjectString_Article.DescId = zc_ObjectString_Article()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                               ON ObjectLink_Goods_ProdColor.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
          LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
          
          LEFT JOIN tmpReceiptProdModelChild ON tmpReceiptProdModelChild.ParentId = MovementItem.ParentId
                                            AND tmpReceiptProdModelChild.ObjectId = MovementItem.ObjectId
          LEFT JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ParentId = MovementItem.ParentId
                                        AND tmpReceiptGoodsChild.ObjectId = MovementItem.ObjectId
     ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.21         *
*/

-- тест
-- SELECT * from gpSelect_MI_ProductionUnion_Child (inMovementId:= 306,inShowAll:=true,  inIsErased:= true, inSession:= zfCalc_UserAdmin());