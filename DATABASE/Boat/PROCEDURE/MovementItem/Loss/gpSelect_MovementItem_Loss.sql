-- Function: gpSelect_MovementItem_Loss()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Loss (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Loss (
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, Amount_unit TFloat
             , CountForPrice TFloat
             , OperPrice TFloat
             , Summ TFloat
             , Comment TVarChar
             , isErased Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , Article TVarChar
             , GoodsGroupName TVarChar
             , GoodsGroupNameFull TVarChar
             , MeasureName TVarChar
             )
AS
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbToId         Integer;
  DECLARE vbFromId       Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Loss());
    vbUserId := lpGetUserBySession (inSession);

    SELECT MovementLinkObject_From.ObjectId        AS FromId
         , MovementLinkObject_To.ObjectId          AS ToId
    INTO vbFromId
       , vbToId
    FROM Movement AS Movement_Loss
        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement_Loss.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement_Loss.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

    WHERE Movement_Loss.Id = inMovementId
      AND Movement_Loss.DescId = zc_Movement_Loss();


                   
    IF inShowAll
    THEN
        RETURN QUERY
        WITH
       tmpIsErased AS (SELECT FALSE AS isErased
                        UNION ALL
                       SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                      )

       -- остатки
     , tmpContainer_All AS (SELECT Container.*
                            FROM Container
                             WHERE (Container.WhereObjectId = vbFromId or COALESCE (vbFromId,0) = 0)
                               AND COALESCE(Container.Amount,0) <> 0
                               AND Container.DescId = zc_Container_Count()
                            )
       -- партии товаров на остатке
     , tmpObject_PartionGoods AS (SELECT Object_PartionGoods.*
                                  FROM Object_PartionGoods
                                  WHERE Object_PartionGoods.ObjectId IN (SELECT DISTINCT tmpContainer_All.ObjectId FROM tmpContainer_All)
                                  )

     , tmpMI AS   (SELECT MovementItem.ObjectId   AS GoodsId
                        , MovementItem.Amount
                        , MIFloat_OperPrice.ValueData     AS OperPrice
                        , COALESCE (MIFloat_CountForPrice.ValueData, 1) AS CountForPrice
 
                        , MovementItem.Id
                        , MovementItem.isErased
                        
                        , MIString_Comment.ValueData  AS Comment
 
                        , Object_Insert.ValueData     AS InsertName
                        , MIDate_Insert.ValueData     AS InsertDate
 
                   FROM tmpIsErased
                      JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = tmpIsErased.isErased

                      LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                  ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                 AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()

                      LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                  ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                 AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

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
       --резерв
     , tmpMI_Child AS (SELECT MovementItem.ParentId
                            , SUM (COALESCE (MovementItem.Amount,0)) AS Amount
                       FROM MovementItem
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Child()
                         AND MovementItem.isErased   = FALSE
                       GROUP BY MovementItem.ParentId
                      )


            SELECT
                0                          AS Id
              , Object_Goods.Id                AS GoodsId
              , Object_Goods.ObjectCode        AS GoodsCode
              , Object_Goods.ValueData         AS GoodsName
              , CAST (NULL AS TFloat)      AS Amount
              , CAST (NULL AS TFloat)      AS Amount_unit
              , CAST (1 AS TFloat)         AS CountForPrice
              , tmpObject_PartionGoods.EKPrice ::TFloat AS OperPrice
              , CAST (NULL AS TFloat)      AS Summ
              
              , NULL::TVarChar             AS Comment
              
              , FALSE ::Boolean            AS isErased

              , NULL::TVarChar             AS InsertName
              , NULL::TDateTime            AS InsertDate
              --
              , ObjectString_Article.ValueData AS Article              
              , Object_GoodsGroup.ValueData    AS GoodsGroupName
              , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
              , Object_Measure.ValueData       AS MeasureName

            FROM tmpObject_PartionGoods
                LEFT JOIN tmpMI ON tmpMI.GoodsId = tmpObject_PartionGoods.ObjectId

                LEFT JOIN Object AS Object_Goods   ON Object_Goods.Id   = tmpObject_PartionGoods.ObjectId
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpObject_PartionGoods.GoodsGroupId
                LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = tmpObject_PartionGoods.MeasureId
    
                LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                       ON ObjectString_GoodsGroupFull.ObjectId = tmpObject_PartionGoods.ObjectId
                                      AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
                LEFT JOIN ObjectString AS ObjectString_Article
                                       ON ObjectString_Article.ObjectId = tmpObject_PartionGoods.ObjectId
                                      AND ObjectString_Article.DescId = zc_ObjectString_Article()
            WHERE tmpMI.GoodsId IS NULL
          UNION ALL
            SELECT
                MovementItem.Id           AS Id
              , MovementItem.GoodsId      AS GoodsId
              , Object_Goods.ObjectCode   AS GoodsCode
              , Object_Goods.ValueData    AS GoodsName
              , MovementItem.Amount           ::TFloat
              , tmpMI_Child.Amount            :: TFloat AS Amount_unit
              , MovementItem.CountForPrice    ::TFloat
              , MovementItem.OperPrice        ::TFloat

              , CAST (CASE WHEN MovementItem.CountForPrice > 0
                           THEN CAST (COALESCE (MovementItem.Amount, 0) * MovementItem.OperPrice / MovementItem.CountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (COALESCE (MovementItem.Amount, 0) * MovementItem.OperPrice AS NUMERIC (16, 2))
                       END AS TFloat) AS Summ

              , MovementItem.Comment    :: TVarChar
              , MovementItem.isErased
              
              , MovementItem.InsertName
              , MovementItem.InsertDate
              
              --
              , tmpGoodsParams.Article
              , tmpGoodsParams.GoodsGroupName
              , tmpGoodsParams.GoodsGroupNameFull
              , tmpGoodsParams.MeasureName

            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
                 LEFT JOIN tmpGoodsParams AS tmpGoodsParams ON tmpGoodsParams.GoodsId = MovementItem.GoodsId
                 LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id
            ;
    ELSE
       RETURN QUERY
       WITH
       tmpIsErased AS (SELECT FALSE AS isErased
                        UNION ALL
                       SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                      )
     , tmpMI AS   (SELECT MovementItem.ObjectId                           AS GoodsId
                        , MovementItem.Amount
                        , MIFloat_OperPrice.ValueData                     AS OperPrice
                        , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice

                        , MovementItem.Id
                        , MovementItem.isErased
                        , MIString_Comment.ValueData  AS Comment
 
                        , Object_Insert.ValueData             AS InsertName
                        , MIDate_Insert.ValueData             AS InsertDate
 
                   FROM tmpIsErased
                      JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = tmpIsErased.isErased
                      LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                  ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                 AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
 
                      LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                  ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                 AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

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
       --резерв
     , tmpMI_Child AS (SELECT MovementItem.ParentId
                            , SUM (COALESCE (MovementItem.Amount,0)) AS Amount
                       FROM MovementItem
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Child()
                         AND MovementItem.isErased   = FALSE
                       GROUP BY MovementItem.ParentId
                      )

         -- результат
            SELECT
                MovementItem.Id           AS Id
              , MovementItem.GoodsId      AS GoodsId
              , Object_Goods.ObjectCode   AS GoodsCode
              , Object_Goods.ValueData    AS GoodsName
              , MovementItem.Amount           ::TFloat
              , tmpMI_Child.Amount            ::TFloat AS Amount_unit
              , MovementItem.CountForPrice    ::TFloat
              , MovementItem.OperPrice        ::TFloat

              , zfCalc_SummIn (COALESCE (MovementItem.Amount, 0), MovementItem.OperPrice, MovementItem.CountForPrice)        ::TFloat AS Summ

              , MovementItem.Comment ::TVarChar
              , MovementItem.isErased

              , MovementItem.InsertName
              , MovementItem.InsertDate

              --
              , tmpGoodsParams.Article
              , tmpGoodsParams.GoodsGroupName
              , tmpGoodsParams.GoodsGroupNameFull
              , tmpGoodsParams.MeasureName
            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
                 LEFT JOIN tmpGoodsParams AS tmpGoodsParams ON tmpGoodsParams.GoodsId = MovementItem.GoodsId
                 LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id
            ;
    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.04.21         * BasisPrice
 15.02.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Loss (inMovementId:= 0, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
-- select * from gpSelect_MovementItem_Loss (inMovementId:= 218 , inShowAll:= TRUE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());