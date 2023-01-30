-- Function: gpSelect_MI_OrderInternal_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternal_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternal_Child(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar, MeasureName TVarChar
             , ProdColorName_goods TVarChar
             , Comment_goods TVarChar
             , Amount NUMERIC (16, 8), AmountReserv NUMERIC (16, 8), AmountSend NUMERIC (16, 8)
             , UnitId Integer, UnitName TVarChar
             , ReceiptLevelId Integer, ReceiptLevelName TVarChar
             , ColorPatternId Integer, ColorPatternName TVarChar
             , ProdColorPatternId Integer, ProdColorPatternName TVarChar
             , ProdOptionsId Integer, ProdOptionsName TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры

     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH tmpIsErased AS (SELECT FALSE AS isErased
                         UNION ALL
                          SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                         )
      -- Master
    , tmpMI_Master AS (SELECT MovementItem.Id              AS MovementItemId
                            , MIFloat_MovementId.ValueData AS MovementId_order
                       FROM MovementItem
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                        ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                      )
        -- Факт перемещения
      , tmpMI_Send AS (SELECT tmpMI_Master.MovementItemId  AS ParentId
                            , MovementItem.ObjectId        AS GoodsId
                            , SUM (MovementItem.Amount)    AS Amount
                       FROM tmpMI_Master
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                        ON MIFloat_MovementId.ValueData = tmpMI_Master.MovementId_order
                                                       AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
                            LEFT JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                  AND MovementItem.DescId   = zc_MI_Master()
                                                  AND MovementItem.isErased = FALSE
                            INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                               AND Movement.DescId   = zc_Movement_Send()
                                               AND Movement.StatusId = zc_Enum_Status_Complete()
                       GROUP BY tmpMI_Master.MovementItemId
                              , MovementItem.ObjectId
                      )
     -- Факт ProductionUnion - приход
   , tmpMI_Production AS (SELECT tmpMI_Master.MovementItemId  AS ParentId
                               , MovementItem.ObjectId        AS GoodsId
                               , SUM (MovementItem.Amount)    AS Amount
                          FROM tmpMI_Master
                               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                           ON MIFloat_MovementId.ValueData = tmpMI_Master.MovementId_order
                                                          AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
                               LEFT JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                     AND MovementItem.DescId   = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                               INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                  AND Movement.DescId   = zc_Movement_ProductionUnion()
                                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                          GROUP BY tmpMI_Master.MovementItemId
                                 , MovementItem.ObjectId
                         )
        -- Результат
        SELECT MovementItem.Id
             , MovementItem.ParentId
             , MovementItem.ObjectId                AS GoodsId
             , Object_Goods.ObjectCode              AS GoodsCode
             , Object_Goods.ValueData               AS GoodsName
             , ObjectString_Article.ValueData       AS Article
             , Object_Measure.ValueData             AS MeasureName
             , Object_ProdColor.ValueData           AS ProdColorName_goods
             , ObjectString_Goods_Comment.ValueData AS Comment_goods

             , zfCalc_Value_ForCount (MovementItem.Amount, MIFloat_ForCount.ValueData) AS Amount
             , zfCalc_Value_ForCount (MIFloat_AmountReserv.ValueData, MIFloat_ForCount.ValueData) AS AmountReserv
             , CASE WHEN tmpMI_Production.Amount > 0
                         THEN tmpMI_Production.Amount
                    WHEN tmpMI_Send.Amount >= zfCalc_Value_ForCount (MovementItem.Amount, MIFloat_ForCount.ValueData)
                         THEN zfCalc_Value_ForCount (MovementItem.Amount, MIFloat_ForCount.ValueData)
                    ELSE 0
               END :: NUMERIC (16, 8) AS AmountSend
             , Object_Unit.Id                       AS UnitId
             , Object_Unit.ValueData                AS UnitName
             , Object_ReceiptLevel.Id               AS ReceiptLevelId
             , Object_ReceiptLevel.ValueData        AS ReceiptLevelName
             , Object_ColorPattern.Id               AS ColorPatternId
             , Object_ColorPattern.ValueData        AS ColorPatternName
             , Object_ProdColorPattern.Id           AS ProdColorPatternId
             , zfCalc_ProdColorPattern_isErased (Object_ProdColorGroup.ValueData, Object_ProdColorPattern.ValueData, Object_Model_pcp.ValueData, Object_ProdColorPattern.isErased) :: TVarChar AS ProdColorPatternName
             , Object_ProdOptions.Id                AS ProdOptionsId
             , Object_ProdOptions.ValueData         AS ProdOptionsName
             , MovementItem.isErased

        FROM tmpIsErased
             INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Child()
                                    AND MovementItem.isErased   = tmpIsErased.isErased
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

             LEFT JOIN MovementItemFloat AS MIFloat_AmountReserv
                                         ON MIFloat_AmountReserv.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountReserv.DescId = zc_MIFloat_AmountReserv()
             LEFT JOIN tmpMI_Send ON tmpMI_Send.ParentId = MovementItem.ParentId
                                 AND tmpMI_Send.GoodsId  = MovementItem.ObjectId
             LEFT JOIN tmpMI_Production ON tmpMI_Production.ParentId = MovementItem.ParentId
                                       AND tmpMI_Production.GoodsId  = MovementItem.ObjectId

             LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                         ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                        AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = MovementItem.ObjectId
                                   AND ObjectString_Article.DescId   = zc_ObjectString_Article()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN MovementItemLinkObject AS MILO_ReceiptLevel
                                              ON MILO_ReceiptLevel.MovementItemId = MovementItem.Id
                                             AND MILO_ReceiptLevel.DescId          = zc_MILinkObject_ReceiptLevel()
             LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = MILO_ReceiptLevel.ObjectId

             -- Шаблон Boat Structure
             LEFT JOIN MovementItemLinkObject AS MILO_ColorPattern
                                              ON MILO_ColorPattern.MovementItemId = MovementItem.Id
                                             AND MILO_ColorPattern.DescId = zc_MILinkObject_ColorPattern()
             LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = MILO_ColorPattern.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Model_pcp
                                  ON ObjectLink_Model_pcp.ObjectId = Object_ColorPattern.Id
                                 AND ObjectLink_Model_pcp.DescId   = zc_ObjectLink_ColorPattern_Model()
             LEFT JOIN Object AS Object_Model_pcp ON Object_Model_pcp.Id = ObjectLink_Model_pcp.ChildObjectId

             -- Boat Structure
             LEFT JOIN MovementItemLinkObject AS MILO_ProdColorPattern
                                              ON MILO_ProdColorPattern.MovementItemId = MovementItem.Id
                                             AND MILO_ProdColorPattern.DescId = zc_MILinkObject_ProdColorPattern()
             LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = MILO_ProdColorPattern.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                  ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ProdColorGroup.DescId   = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
             LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId


             -- Options
             LEFT JOIN MovementItemLinkObject AS MILO_ProdOptions
                                              ON MILO_ProdOptions.MovementItemId = MovementItem.Id
                                             AND MILO_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
             LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = MILO_ProdOptions.ObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                    ON ObjectString_Goods_Comment.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_Comment.DescId   = zc_ObjectString_Goods_Comment()
             LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                  ON ObjectLink_ProdColor.ObjectId = Object_Goods.Id
                                 AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
             LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_ProdColor.ChildObjectId

    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.12.22         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderInternal_Child (inMovementId:= 224, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
