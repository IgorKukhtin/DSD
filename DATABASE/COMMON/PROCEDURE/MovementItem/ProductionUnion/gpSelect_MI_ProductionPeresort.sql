-- Function: gpSelect_MI_ProductionPeresort()

DROP FUNCTION IF EXISTS gpSelect_MI_ProductionPeresort (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionPeresort(
    IN inMovementId          Integer,
    IN inShowAll             Boolean,
    IN inisErased            Boolean      , --
    IN inSession             TVarChar       -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE (Id Integer, LineNum Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsChildId Integer, GoodsChildCode Integer, GoodsChildName TVarChar
             , Amount TFloat
             , PartionGoods TVarChar, PartionGoodsDate TDateTime
             , PartionGoodsChild TVarChar, PartionGoodsDateChild TDateTime
             , Comment TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , GoodsKindChildId Integer, GoodsKindChildCode Integer, GoodsKindChildName TVarChar
            
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

            , CAST (NULL AS Integer)                AS GoodsChildId
            , CAST (NULL AS Integer)                AS GoodsChildCode
            , CAST (NULL AS TVarchar)               AS GoodsChildName

            , CAST (NULL AS TFloat)                 AS Amount

            , CAST (NULL AS TVarchar)               AS PartionGoods
            , CAST (NULL AS TDateTime)              AS PartionGoodsDate

            , CAST (NULL AS TVarchar)               AS PartionGoodsChild
            , CAST (NULL AS TDateTime)              AS PartionGoodsDateChild

            , CAST (NULL AS TVarchar)               AS Comment
    
            , CAST (NULL AS Integer)                AS GoodsKindId
            , CAST (NULL AS Integer)                AS GoodsKindCode
            , CAST (NULL AS TVarchar)               AS GoodsKindName

            , CAST (NULL AS Integer)                AS GoodsKindChildId
            , CAST (NULL AS Integer)                AS GoodsKindChildCode
            , CAST (NULL AS TVarchar)               AS GoodsKindChildName

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

       WHERE tmpMI.GoodsId IS NULL
      UNION ALL
       SELECT
             MovementItem.Id                    AS Id
--           , 0 AS LineNum
           , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS INTEGER) AS LineNum
            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName

            , Object_GoodsChild.Id                   AS GoodsChildId
            , Object_GoodsChild.ObjectCode           AS GoodsChildCode
            , Object_GoodsChild.ValueData            AS GoodsChildName
            , MovementItem.Amount               AS Amount

            , MIString_PartionGoods.ValueData   AS PartionGoods
            , MIDate_PartionGoods.ValueData     AS PartionGoodsDate

            , MIString_PartionGoodsChild.ValueData   AS PartionGoodsChild
            , MIDate_PartionGoodsChild.ValueData     AS PartionGoodsDateChild

            , MIString_Comment.ValueData        AS Comment

            , Object_GoodsKind.Id               AS GoodsKindId
            , Object_GoodsKind.ObjectCode       AS GoodsKindCode
            , Object_GoodsKind.ValueData        AS GoodsKindName

            , Object_GoodsKindChild.Id               AS GoodsKindChildId
            , Object_GoodsKindChild.ObjectCode       AS GoodsKindChildCode
            , Object_GoodsKindChild.ValueData        AS GoodsKindChildName

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

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN MovementItemString AS MIString_PartionGoods
                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                       AND MIDate_PartionGoods.MovementItemId =  MovementItem.Id

             JOIN MovementItem AS MovementItemChild ON MovementItemChild.MovementId = inMovementId
                              AND MovementItemChild.DescId     = zc_MI_Child()
                              AND MovementItemChild.isErased   = tmpIsErased.isErased
                       
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

            , Object_GoodsChild.Id                   AS GoodsChildId
            , Object_GoodsChild.ObjectCode           AS GoodsChildCode
            , Object_GoodsChild.ValueData            AS GoodsChildName

            , MovementItem.Amount               AS Amount

            , MIString_PartionGoods.ValueData   AS PartionGoods
            , MIDate_PartionGoods.ValueData     AS PartionGoodsDate

            , MIString_PartionGoodsChild.ValueData   AS PartionGoodsChild
            , MIDate_PartionGoodsChild.ValueData     AS PartionGoodsDateChild

            , MIString_Comment.ValueData        AS Comment

            , Object_GoodsKind.Id               AS GoodsKindId
            , Object_GoodsKind.ObjectCode       AS GoodsKindCode
            , Object_GoodsKind.ValueData        AS GoodsKindName

            , Object_GoodsKindChild.Id               AS GoodsKindChildId
            , Object_GoodsKindChild.ObjectCode       AS GoodsKindChildCode
            , Object_GoodsKindChild.ValueData        AS GoodsKindChildName

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

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN MovementItemString AS MIString_PartionGoods
                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                       AND MIDate_PartionGoods.MovementItemId =  MovementItem.Id
              
            JOIN MovementItem AS MovementItemChild ON MovementItemChild.MovementId = inMovementId
                              AND MovementItemChild.DescId     = zc_MI_Child()
                              AND MovementItemChild.isErased   = tmpIsErased.isErased
                       
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

      
            ;
   
   END IF;

   


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_ProductionPeresort (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.   Ìàíüêî Ä.À.
 11.12.14         *

*/

-- òåñò
--SELECT * FROM gpSelect_MI_ProductionPeresort (inMovementId:= 597574, inShowAll:= TRUE,  inisErased:= TRUE ,inSession:= '2')
--SELECT * FROM gpSelect_MI_ProductionPeresort (inMovementId:= 597574, inShowAll:= FALSE,  inisErased:= TRUE ,inSession:= '2')