-- Function: gpSelect_MI_ProductionPeresort()

DROP FUNCTION IF EXISTS gpSelect_MI_ProductionPeresort (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionPeresort(
    IN inMovementId          Integer,
    IN inShowAll             Boolean,
    IN inisErased            Boolean      , --
    IN inSession             TVarChar       -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE (Id Integer, LineNum Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , GoodsChildId Integer, GoodsChildCode Integer, GoodsChildName TVarChar, GoodsChildGroupNameFull TVarChar, MeasureChildName TVarChar
             , AmountOut TFloat, Amountin TFloat
             , Amount_Remains TFloat
             , PartionGoods TVarChar, PartionGoodsDate TDateTime
             , PartionGoodsChild TVarChar, PartionGoodsDateChild TDateTime
             , Comment TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , GoodsKindId_Complete Integer, GoodsKindCode_Complete Integer, GoodsKindName_Complete TVarChar
             , GoodsKindChildId Integer, GoodsKindChildCode Integer, GoodsKindChildName TVarChar
             , GoodsKindId_Complete_child Integer, GoodsKindCode_Complete_child Integer, GoodsKindName_Complete_child TVarChar
             , isErased Boolean
             )
AS
$BODY$
  
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_MovementItem_ProductionUnion());
   IF inShowAll THEN
   RETURN QUERY  
       SELECT
              0                                     AS Id
            , 0                                     AS LineNum
            , tmpGoods.GoodsId                      AS GoodsId
            , tmpGoods.GoodsCode                    AS GoodsCode
            , tmpGoods.GoodsName                    AS GoodsName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_Measure.ValueData                    AS MeasureName

            , CAST (NULL AS Integer)                AS GoodsChildId
            , CAST (NULL AS Integer)                AS GoodsChildCode
            , CAST (NULL AS TVarchar)               AS GoodsChildName
            , CAST (NULL AS TVarchar)               AS GoodsChildGroupNameFull
            , CAST (NULL AS TVarchar)               AS MeasureChildName

            , CAST (NULL AS TFloat)                 AS AmountOut
            , CAST (NULL AS TFloat)                 AS AmountIn
            , CAST (NULL AS TFloat)                 AS Amount_Remains            

            , CAST (NULL AS TVarchar)               AS PartionGoods
            , CAST (NULL AS TDateTime)              AS PartionGoodsDate

            , CAST (NULL AS TVarchar)               AS PartionGoodsChild
            , CAST (NULL AS TDateTime)              AS PartionGoodsDateChild

            , CAST (NULL AS TVarchar)               AS Comment
    
            , CAST (NULL AS Integer)                AS GoodsKindId
            , CAST (NULL AS Integer)                AS GoodsKindCode
            , CAST (NULL AS TVarchar)               AS GoodsKindName
            , CAST (NULL AS Integer)                AS GoodsKindId_Complete
            , CAST (NULL AS Integer)                AS GoodsKindCode_Complete
            , CAST (NULL AS TVarchar)               AS GoodsKindName_Complete

            , CAST (NULL AS Integer)                AS GoodsKindChildId
            , CAST (NULL AS Integer)                AS GoodsKindChildCode
            , CAST (NULL AS TVarchar)               AS GoodsKindChildName
            , CAST (NULL AS Integer)                AS GoodsKindId_Complete_child
            , CAST (NULL AS Integer)                AS GoodsKindCode_Complete_child
            , CAST (NULL AS TVarchar)               AS GoodsKindName_Complete_child

            , FALSE                                  AS isErased

       FROM (SELECT Object_Goods.Id           AS GoodsId
                  , Object_Goods.ObjectCode   AS GoodsCode
                  , Object_Goods.ValueData    AS GoodsName
             FROM Object AS Object_Goods
             WHERE Object_Goods.DescId = zc_Object_Goods()
            ) AS tmpGoods

            LEFT JOIN (SELECT MovementItem.ObjectId                         AS GoodsId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       WHERE tmpMI.GoodsId IS NULL
      UNION ALL
       SELECT
             MovementItem.Id                    AS Id
--           , 0 AS LineNum
           , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS INTEGER) AS LineNum
            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_Measure.ValueData                    AS MeasureName

            , Object_GoodsChild.Id                   AS GoodsChildId
            , Object_GoodsChild.ObjectCode           AS GoodsChildCode
            , Object_GoodsChild.ValueData            AS GoodsChildName
            , ObjectString_GoodsChild_GoodsGroupFull.ValueData AS GoodsChildGroupNameFull
            , Object_MeasureChild.ValueData                    AS MeasureChildName

            , MovementItemChild.Amount            AS AmountOut
            , MovementItem.Amount                 AS Amountin
            , MIFloat_Remains.ValueData ::TFloat  AS Amount_Remains

            , MIString_PartionGoods.ValueData   AS PartionGoods
            , MIDate_PartionGoods.ValueData     AS PartionGoodsDate

            , MIString_PartionGoodsChild.ValueData   AS PartionGoodsChild
            , MIDate_PartionGoodsChild.ValueData     AS PartionGoodsDateChild

            , MIString_Comment.ValueData        AS Comment

            , Object_GoodsKind.Id               AS GoodsKindId
            , Object_GoodsKind.ObjectCode       AS GoodsKindCode
            , Object_GoodsKind.ValueData        AS GoodsKindName
            , Object_GoodsKind_Complete.Id               AS GoodsKindId_Complete
            , Object_GoodsKind_Complete.ObjectCode       AS GoodsKindCode_Complete
            , Object_GoodsKind_Complete.ValueData        AS GoodsKindName_Complete
            

            , Object_GoodsKindChild.Id               AS GoodsKindChildId
            , Object_GoodsKindChild.ObjectCode       AS GoodsKindChildCode
            , Object_GoodsKindChild.ValueData        AS GoodsKindChildName
            , Object_GoodsKind_Complete_child.Id               AS GoodsKindId_Complete_child
            , Object_GoodsKind_Complete_child.ObjectCode       AS GoodsKindCode_Complete_child
            , Object_GoodsKind_Complete_child.ValueData        AS GoodsKindName_Complete_child

            , MovementItem.isErased             AS isErased


       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_Complete
                                              ON MILinkObject_GoodsKind_Complete.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind_Complete.DescId         = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsKind_Complete ON Object_GoodsKind_Complete.Id = MILinkObject_GoodsKind_Complete.ObjectId

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN MovementItemString AS MIString_PartionGoods
                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                       AND MIDate_PartionGoods.MovementItemId =  MovementItem.Id

             LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                         ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                        AND MIFloat_Remains.DescId = zc_MIFloat_Remains()

             JOIN MovementItem AS MovementItemChild ON MovementItemChild.MovementId = inMovementId
                              AND MovementItemChild.ParentId   = MovementItem.Id
                              AND MovementItemChild.DescId     = zc_MI_Child()
                              AND MovementItemChild.isErased   = tmpIsErased.isErased

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                       
             LEFT JOIN Object AS Object_GoodsChild ON Object_GoodsChild.Id = MovementItemChild.ObjectId

             LEFT JOIN MovementItemString AS MIString_PartionGoodsChild
                                          ON MIString_PartionGoodsChild.DescId = zc_MIString_PartionGoods()
                                         AND MIString_PartionGoodsChild.MovementItemId =  MovementItemChild.Id

             LEFT JOIN MovementItemDate AS MIDate_PartionGoodsChild
                                        ON MIDate_PartionGoodsChild.DescId = zc_MIDate_PartionGoods()
                                       AND MIDate_PartionGoodsChild.MovementItemId =  MovementItemChild.Id

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindChild
                                              ON MILinkObject_GoodsKindChild.MovementItemId = MovementItemChild.Id
                                             AND MILinkObject_GoodsKindChild.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKindChild ON Object_GoodsKindChild.Id = MILinkObject_GoodsKindChild.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_Complete_child
                                              ON MILinkObject_GoodsKind_Complete_child.MovementItemId = MovementItemChild.Id
                                             AND MILinkObject_GoodsKind_Complete_child.DescId         = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsKind_Complete_child ON Object_GoodsKind_Complete_child.Id = MILinkObject_GoodsKind_Complete_child.ObjectId

             LEFT JOIN ObjectString AS ObjectString_GoodsChild_GoodsGroupFull
                                    ON ObjectString_GoodsChild_GoodsGroupFull.ObjectId = Object_GoodsChild.Id
                                   AND ObjectString_GoodsChild_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsChild_Measure
                                  ON ObjectLink_GoodsChild_Measure.ObjectId = Object_GoodsChild.Id
                                 AND ObjectLink_GoodsChild_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_MeasureChild ON Object_MeasureChild.Id = ObjectLink_Goods_Measure.ChildObjectId

        --ORDER BY 2   --MovementItem.Id 
            ;
   ELSE
 RETURN QUERY  
      SELECT
             MovementItem.Id					AS Id
           , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS INTEGER) AS  LineNum
            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_Measure.ValueData                    AS MeasureName

            , Object_GoodsChild.Id                   AS GoodsChildId
            , Object_GoodsChild.ObjectCode           AS GoodsChildCode
            , Object_GoodsChild.ValueData            AS GoodsChildName
            , ObjectString_GoodsChild_GoodsGroupFull.ValueData AS GoodsChildGroupNameFull
            , Object_MeasureChild.ValueData                    AS MeasureChildName

            , MovementItemChild.Amount            AS Amountout
            , MovementItem.Amount                 AS Amountin
            , MIFloat_Remains.ValueData ::TFloat  AS Amount_Remains

            , MIString_PartionGoods.ValueData   AS PartionGoods
            , MIDate_PartionGoods.ValueData     AS PartionGoodsDate

            , MIString_PartionGoodsChild.ValueData   AS PartionGoodsChild
            , MIDate_PartionGoodsChild.ValueData     AS PartionGoodsDateChild

            , MIString_Comment.ValueData        AS Comment

            , Object_GoodsKind.Id               AS GoodsKindId
            , Object_GoodsKind.ObjectCode       AS GoodsKindCode
            , Object_GoodsKind.ValueData        AS GoodsKindName
            , Object_GoodsKind_Complete.Id               AS GoodsKindId_Complete
            , Object_GoodsKind_Complete.ObjectCode       AS GoodsKindCode_Complete
            , Object_GoodsKind_Complete.ValueData        AS GoodsKindName_Complete

            , Object_GoodsKindChild.Id               AS GoodsKindChildId
            , Object_GoodsKindChild.ObjectCode       AS GoodsKindChildCode
            , Object_GoodsKindChild.ValueData        AS GoodsKindChildName
            , Object_GoodsKind_Complete_child.Id               AS GoodsKindId_Complete_child
            , Object_GoodsKind_Complete_child.ObjectCode       AS GoodsKindCode_Complete_child
            , Object_GoodsKind_Complete_child.ValueData        AS GoodsKindName_Complete_child

            , MovementItem.isErased             AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_Complete
                                              ON MILinkObject_GoodsKind_Complete.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind_Complete.DescId         = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsKind_Complete ON Object_GoodsKind_Complete.Id = MILinkObject_GoodsKind_Complete.ObjectId

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN MovementItemString AS MIString_PartionGoods
                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                       AND MIDate_PartionGoods.MovementItemId =  MovementItem.Id

             LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                         ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                        AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
              
             JOIN MovementItem AS MovementItemChild ON MovementItemChild.MovementId = inMovementId
                               AND MovementItemChild.ParentId   = MovementItem.Id
                               AND MovementItemChild.DescId     = zc_MI_Child()
                               AND MovementItemChild.isErased   = tmpIsErased.isErased

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                       
    
             LEFT JOIN Object AS Object_GoodsChild ON Object_GoodsChild.Id = MovementItemChild.ObjectId

             LEFT JOIN MovementItemString AS MIString_PartionGoodsChild
                                          ON MIString_PartionGoodsChild.DescId = zc_MIString_PartionGoods()
                                         AND MIString_PartionGoodsChild.MovementItemId =  MovementItemChild.Id

             LEFT JOIN MovementItemDate AS MIDate_PartionGoodsChild
                                        ON MIDate_PartionGoodsChild.DescId = zc_MIDate_PartionGoods()
                                       AND MIDate_PartionGoodsChild.MovementItemId =  MovementItemChild.Id

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindChild
                                              ON MILinkObject_GoodsKindChild.MovementItemId = MovementItemChild.Id
                                             AND MILinkObject_GoodsKindChild.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKindChild ON Object_GoodsKindChild.Id = MILinkObject_GoodsKindChild.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_Complete_child
                                              ON MILinkObject_GoodsKind_Complete_child.MovementItemId = MovementItemChild.Id
                                             AND MILinkObject_GoodsKind_Complete_child.DescId         = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsKind_Complete_child ON Object_GoodsKind_Complete_child.Id = MILinkObject_GoodsKind_Complete_child.ObjectId

             LEFT JOIN ObjectString AS ObjectString_GoodsChild_GoodsGroupFull
                                    ON ObjectString_GoodsChild_GoodsGroupFull.ObjectId = Object_GoodsChild.Id
                                   AND ObjectString_GoodsChild_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsChild_Measure
                                  ON ObjectLink_GoodsChild_Measure.ObjectId = Object_GoodsChild.Id
                                 AND ObjectLink_GoodsChild_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_MeasureChild ON Object_MeasureChild.Id = ObjectLink_GoodsChild_Measure.ChildObjectId

            ;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.   Ìàíüêî Ä.À.
 18.10.22         *
 31.03.15         * 
 11.12.14         *

*/

-- òåñò
--SELECT * FROM gpSelect_MI_ProductionPeresort (inMovementId:= 597574, inShowAll:= TRUE,  inisErased:= TRUE ,inSession:= '2')
--SELECT * FROM gpSelect_MI_ProductionPeresort (inMovementId:= 597574, inShowAll:= FALSE,  inisErased:= TRUE ,inSession:= '2')