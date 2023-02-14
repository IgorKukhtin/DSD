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
             , ReceiptLevelId    Integer , ReceiptLevelName     TVarChar
             , ProdOptionsId      Integer, ProdOptionsName      TVarChar
             , ProdColorPatternId Integer, ProdColorPatternName TVarChar
             , ColorPatternId     Integer, ColorPatternName     TVarChar
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
             , isErased Boolean
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar, Comment_goods TVarChar
             , Value TFloat, Value_service TFloat
             , Amount_diff TFloat
             , Color_value Integer
             , Color_Level Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
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
      , tmpMIContainer AS (SELECT MIContainer.MovementItemId
                                , SUM (-1 * MIContainer.Amount) AS Amount
                           FROM MovementItemContainer AS MIContainer
                           WHERE MIContainer.MovementId = inMovementId
                             AND MIContainer.DescId     = zc_MIContainer_Summ()
                           GROUP BY MIContainer.MovementItemId
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
        -- результат
        SELECT
            MovementItem.Id
          , ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId ORDER BY MovementItem.Id ASC) :: Integer AS NPP
          , MovementItem.ParentId
          , MovementItem.ObjectId          AS ObjectId
          , Object_Object.ObjectCode       AS ObjectCode
          , Object_Object.ValueData        AS ObjectName
          , ObjectDesc.ItemName            AS DescName
          , Object_ReceiptLevel.Id         AS ReceiptLevelId
          , Object_ReceiptLevel.ValueData  AS ReceiptLevelName
          , Object_ProdOptions.Id          AS ProdOptionsId
          , Object_ProdOptions.ValueData   AS ProdOptionsName
          , Object_ProdColorPattern.Id     AS ProdColorPatternName
          , zfCalc_ProdColorPattern_isErased (Object_ProdColorGroup.ValueData, Object_ProdColorPattern.ValueData, Object_Model_pcp.ValueData, Object_ProdColorPattern.isErased) :: TVarChar AS ProdColorPatternName
          , Object_ColorPattern.ValueData      AS ColorPatternName

          , MovementItem.Amount   :: TFloat AS Amount
          , (tmpMIContainer.Amount / CASE WHEN MovementItem.Amount > 0 THEN MovementItem.Amount ELSE 1 END) ::TFloat AS Price
          , tmpMIContainer.Amount :: TFloat AS Summ

          , MovementItem.isErased

          , ObjectString_GoodsGroupFull.ValueData                                                           ::TVarChar  AS GoodsGroupNameFull
          , Object_GoodsGroup.ValueData                                                                     ::TVarChar  AS GoodsGroupName
          , ObjectString_Article.ValueData                                                                              AS Article
          , Object_ProdColor.ValueData                                                                                  AS ProdColorName
          , Object_Measure.ValueData                                                                        ::TVarChar  AS MeasureName
          , ObjectString_Goods_Comment.ValueData                                                                        AS Comment_goods

          , Null                                                                                            ::TFloat    AS Value
          , Null                                                                                            ::TFloat    AS Value_service
          , Null                                                                                            ::TFloat    AS Amount_diff

          , Null                                                                                            :: Integer AS Color_value
          , Null                                                                                            :: Integer AS Color_Level

        FROM tmpMI AS MovementItem
             LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = MovementItem.Id

             LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementItem.ObjectId
             LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

             LEFT JOIN tmpMI_Master ON tmpMI_Master.Id = MovementItem.ParentId

             LEFT JOIN MovementItemLinkObject AS MILO_ReceiptLevel
                                              ON MILO_ReceiptLevel.MovementItemId = MovementItem.Id
                                             AND MILO_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()
             LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = MILO_ReceiptLevel.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILO_ProdOptions
                                              ON MILO_ProdOptions.MovementItemId = MovementItem.Id
                                             AND MILO_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
             LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = MILO_ProdOptions.ObjectId

             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = MovementItem.ObjectId
                                   AND ObjectString_Article.DescId   = zc_ObjectString_Article()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                  ON ObjectLink_Goods_ProdColor.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
             LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

             -- Шаблон Boat Structure
             LEFT JOIN MovementItemLinkObject AS MILO_ColorPattern
                                              ON MILO_ColorPattern.MovementItemId = MovementItem.Id
                                             AND MILO_ColorPattern.DescId         = zc_MILinkObject_ColorPattern()
             LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = MILO_ColorPattern.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Model_pcp
                                  ON ObjectLink_Model_pcp.ObjectId = Object_ColorPattern.Id
                                 AND ObjectLink_Model_pcp.DescId   = zc_ObjectLink_ColorPattern_Model()
             LEFT JOIN Object AS Object_Model_pcp ON Object_Model_pcp.Id = ObjectLink_Model_pcp.ChildObjectId

             -- Boat Structure
             LEFT JOIN MovementItemLinkObject AS MILO_ProdColorPattern
                                              ON MILO_ProdColorPattern.MovementItemId = MovementItem.Id
                                             AND MILO_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
             LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = MILO_ProdColorPattern.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                  ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ProdColorGroup.DescId   = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
             LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId


             LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                    ON ObjectString_Goods_Comment.ObjectId = Object_Object.Id
                                   AND ObjectString_Goods_Comment.DescId   = zc_ObjectString_Goods_Comment()

             LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                    ON ObjectString_GoodsGroupFull.ObjectId = MovementItem.ObjectId
                                   AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId  

        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.21         *
*/

-- тест
-- SELECT * from gpSelect_MI_ProductionUnion_Child (inMovementId:= 306, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
