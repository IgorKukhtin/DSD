-- Function: gpSelect_MI_ProductionPeresort()

DROP FUNCTION IF EXISTS gpSelect_MI_ProductionPeresort (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionPeresort(
    IN inMovementId          Integer,
    IN inShowAll             Boolean,
    IN inisErased            Boolean      , --
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, LineNum Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsGroupNameFull TVarChar, MeasureName TVarChar, isAsset Boolean
             , GoodsChildId Integer, GoodsChildCode Integer, GoodsChildName TVarChar, GoodsChildGroupNameFull TVarChar, MeasureChildName TVarChar, isAssetChild Boolean
             , AmountOut TFloat, Amountin TFloat
             , Amount_Remains TFloat
             , PartionGoods TVarChar, PartionGoodsDate TDateTime
             , PartionGoodsChild TVarChar, PartionGoodsDateChild TDateTime
             , Comment TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , GoodsKindId_Complete Integer, GoodsKindCode_Complete Integer, GoodsKindName_Complete TVarChar
             , GoodsKindChildId Integer, GoodsKindChildCode Integer, GoodsKindChildName TVarChar
             , GoodsKindId_Complete_child Integer, GoodsKindCode_Complete_child Integer, GoodsKindName_Complete_child TVarChar 
             , StorageId Integer, StorageName TVarChar, PartNumber TVarChar, Model TVarChar
             , StorageId_child Integer, StorageName_child TVarChar, PartNumber_child TVarChar, Model_child TVarChar
             , isPeresort Boolean 
             , isErased Boolean
             , GoodsChildCode_et TVarChar
             , GoodsChildName_et TVarChar
             , GoodsKindChildName_et TVarChar
             , Amount_et TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);


   IF inShowAll = TRUE THEN

   RETURN QUERY  
         WITH tmpGoodsByGoodsKindSub AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                              , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                              , CASE WHEN COALESCE(ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId ,0)    <> 0
                                                       OR COALESCE(ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId,0) <> 0
                                                     THEN TRUE
                                                     ELSE FALSE
                                                END AS isPeresort
                                         FROM Object_GoodsByGoodsKind_View
                                              LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub
                                                                   ON ObjectLink_GoodsByGoodsKind_GoodsSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                                  AND ObjectLink_GoodsByGoodsKind_GoodsSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
                                              LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSub
                                                                   ON ObjectLink_GoodsByGoodsKind_GoodsKindSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                                  AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub()
                                         WHERE ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId     <> 0
                                            OR ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId <> 0
                                        )

            , tmpMI_Master AS (SELECT MovementItem.*
                               FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                    JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = tmpIsErased.isErased
                              )
            , tmpMI_Child AS (SELECT MovementItemChild.*
                              FROM tmpMI_Master AS MovementItem
                                    JOIN MovementItem AS MovementItemChild ON MovementItemChild.MovementId = inMovementId
                                                     AND MovementItemChild.ParentId   = MovementItem.Id
                                                     AND MovementItemChild.DescId     = zc_MI_Child()
                                                     AND (MovementItemChild.isErased = inisErased OR inisErased = TRUE) 
                              )

            , tmpMIBoolean_child AS (SELECT MIBoolean_Etiketka_child.*
                                     FROM MovementItemBoolean AS MIBoolean_Etiketka_child
                                     WHERE MIBoolean_Etiketka_child.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                                       AND MIBoolean_Etiketka_child.DescId = zc_MIBoolean_Etiketka()
                                    )


            , tmpMIChild AS (SELECT MovementItemChild.Id
                                  , MovementItemChild.ParentId
                                  , MovementItemChild.Amount
                                  , COALESCE (MIBoolean_Etiketka_child.ValueData, FALSE) :: Boolean  AS isEtiketka_child
                                  , Object_GoodsChild.Id                   AS GoodsChildId
                                  , Object_GoodsChild.ObjectCode           AS GoodsChildCode
                                  , Object_GoodsChild.ValueData            AS GoodsChildName
                                  , Object_GoodsKindChild.Id               AS GoodsKindChildId
                                  , Object_GoodsKindChild.ObjectCode       AS GoodsKindChildCode
                                  , Object_GoodsKindChild.ValueData        AS GoodsKindChildName
                             FROM tmpMI_Child AS MovementItemChild
                                  LEFT JOIN tmpMIBoolean_child AS MIBoolean_Etiketka_child
                                                               ON MIBoolean_Etiketka_child.MovementItemId = MovementItemChild.Id

                                  LEFT JOIN Object AS Object_GoodsChild ON Object_GoodsChild.Id = MovementItemChild.ObjectId

                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindChild
                                                                   ON MILinkObject_GoodsKindChild.MovementItemId = MovementItemChild.Id
                                                                  AND MILinkObject_GoodsKindChild.DescId = zc_MILinkObject_GoodsKind()
                                  LEFT JOIN Object AS Object_GoodsKindChild ON Object_GoodsKindChild.Id = MILinkObject_GoodsKindChild.ObjectId                                  
                            )
            , tmpEtiketka AS (SELECT MovementItemChild.ParentId
                                   , STRING_AGG (DISTINCT MovementItemChild.GoodsChildCode ::TVarChar, ';') AS GoodsChildCode
                                   , STRING_AGG (DISTINCT MovementItemChild.GoodsChildName ::TVarChar, ';') AS GoodsChildName
                                   , STRING_AGG (DISTINCT MovementItemChild.GoodsKindChildName ::TVarChar, ';') AS GoodsKindChildName
                                   , SUM (COALESCE (MovementItemChild.Amount,0))        AS Amount
                              FROM tmpMIChild AS MovementItemChild
                              WHERE MovementItemChild.isEtiketka_child = TRUE
                                AND MovementItemChild.Amount <> 0
                              GROUP BY MovementItemChild.ParentId
                              )
, tmpMIString AS (
                   SELECT MovementItemString.*
                   FROM MovementItemString
                   WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                     AND MovementItemString.DescId IN (zc_MIString_PartNumber()
                                                     , zc_MIString_Comment() 
                                                     , zc_MIString_PartionGoods()
                                                     , zc_MIString_Model()
                                                      )
                   )

 , tmpMIString_child AS (SELECT MovementItemString.*
                         FROM MovementItemString
                         WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                           AND MovementItemString.DescId IN (zc_MIString_PartionGoods()
                                                           , zc_MIString_Model()
                                                           , zc_MIString_PartNumber()
                                                            )
                         )
  , tmpMIDate AS (SELECT MovementItemDate.*
                  FROM MovementItemDate
                  WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                    AND MovementItemDate.DescId IN (zc_MIDate_PartionGoods())
                  )

  , tmpMIDate_child AS (SELECT MovementItemDate.*
                         FROM MovementItemDate
                         WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                           AND MovementItemDate.DescId IN (zc_MIDate_PartionGoods())
                         )

  , tmpMILO_child AS (SELECT MovementItemLinkObject.*
                         FROM MovementItemLinkObject
                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                           AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKindComplete()
                                                               , zc_MILinkObject_Storage()
                                                                )
                         )

       SELECT
              0                                     AS Id
            , 0                                     AS LineNum
            , tmpGoods.GoodsId                      AS GoodsId
            , tmpGoods.GoodsCode                    AS GoodsCode
            , tmpGoods.GoodsName                    AS GoodsName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_Measure.ValueData                    AS MeasureName
            , COALESCE (ObjectBoolean_Goods_Asset.ValueData, FALSE) ::Boolean AS isAsset

            , CAST (NULL AS Integer)                AS GoodsChildId
            , CAST (NULL AS Integer)                AS GoodsChildCode
            , CAST (NULL AS TVarchar)               AS GoodsChildName
            , CAST (NULL AS TVarchar)               AS GoodsChildGroupNameFull
            , CAST (NULL AS TVarchar)               AS MeasureChildName
            , FALSE  ::Boolean                      AS isAssetChild

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

            , CAST (NULL AS Integer)                AS StorageId
            , CAST (NULL AS TVarChar)               AS StorageName            
            , '' ::TVarChar                         AS PartNumber
            , '' ::TVarChar                         AS Model
            
            , CAST (NULL AS Integer)                AS StorageId_child
            , CAST (NULL AS TVarChar)               AS StorageName_child            
            , '' ::TVarChar                         AS PartNumber_child
            , '' ::TVarChar                         AS Model_child
            , FALSE :: Boolean AS isPeresort
            

            , FALSE :: Boolean AS isErased

            , '' ::TVarChar AS GoodsChildCode_et
            , '' ::TVarChar AS GoodsChildName_et
            , '' ::TVarChar AS GoodsKindChildName_et
            , 0  ::TFloat   AS Amount_et
       FROM (SELECT Object_Goods.Id           AS GoodsId
                  , Object_Goods.ObjectCode   AS GoodsCode
                  , Object_Goods.ValueData    AS GoodsName
             FROM Object AS Object_Goods
             WHERE Object_Goods.DescId = zc_Object_Goods()
            ) AS tmpGoods

            LEFT JOIN (SELECT MovementItem.ObjectId                         AS GoodsId
                       FROM tmpMI_Master AS MovementItem
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Asset
                                    ON ObjectBoolean_Goods_Asset.ObjectId = tmpGoods.GoodsId 
                                   AND ObjectBoolean_Goods_Asset.DescId = zc_ObjectBoolean_Goods_Asset()
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
            , COALESCE (ObjectBoolean_Goods_Asset.ValueData, FALSE) ::Boolean AS isAsset

            , MovementItemChild.GoodsChildId
            , MovementItemChild.GoodsChildCode
            , MovementItemChild.GoodsChildName

            , ObjectString_GoodsChild_GoodsGroupFull.ValueData AS GoodsChildGroupNameFull
            , Object_MeasureChild.ValueData                    AS MeasureChildName
            , COALESCE (ObjectBoolean_GoodsChild_Asset.ValueData, FALSE) ::Boolean AS isAssetChild

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

            , MovementItemChild.GoodsKindChildId
            , MovementItemChild.GoodsKindChildCode
            , MovementItemChild.GoodsKindChildName
            , Object_GoodsKind_Complete_child.Id               AS GoodsKindId_Complete_child
            , Object_GoodsKind_Complete_child.ObjectCode       AS GoodsKindCode_Complete_child
            , Object_GoodsKind_Complete_child.ValueData        AS GoodsKindName_Complete_child

            , Object_Storage.Id                         AS StorageId
            , Object_Storage.ValueData                  AS StorageName
            , MIString_PartNumber.ValueData :: TVarChar AS PartNumber
            , MIString_Model.ValueData      :: TVarChar AS Model

            , Object_Storage_child.Id                         AS StorageId_child
            , Object_Storage_child.ValueData                  AS StorageName_child
            , MIString_PartNumber_child.ValueData :: TVarChar AS PartNumber_child
            , MIString_ModelChild.ValueData       :: TVarChar AS Model_child
            
            , CASE WHEN tmpGoodsByGoodsKindSub.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPeresort

            , MovementItem.isErased             AS isErased

            , tmpEtiketka.GoodsChildCode ::TVarChar AS GoodsChildCode_et
            , tmpEtiketka.GoodsChildName ::TVarChar AS GoodsChildName_et
            , tmpEtiketka.GoodsKindChildName ::TVarChar AS GoodsKindChildName_et
            , tmpEtiketka.Amount         ::TFloat   AS Amount_et

       FROM tmpMI_Master AS MovementItem
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_Complete
                                              ON MILinkObject_GoodsKind_Complete.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind_Complete.DescId         = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsKind_Complete ON Object_GoodsKind_Complete.Id = MILinkObject_GoodsKind_Complete.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                              ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Storage.DescId         = zc_MILinkObject_Storage()
             LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = MILinkObject_Storage.ObjectId

             LEFT JOIN tmpMIString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN tmpMIString AS MIString_PartionGoods
                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

            LEFT JOIN tmpMIString AS MIString_PartNumber
                                         ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                        AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

            LEFT JOIN tmpMIString AS MIString_Model
                                         ON MIString_Model.MovementItemId = MovementItem.Id
                                        AND MIString_Model.DescId = zc_MIString_Model()

             LEFT JOIN tmpMIDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                       AND MIDate_PartionGoods.MovementItemId =  MovementItem.Id

             LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                         ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                        AND MIFloat_Remains.DescId = zc_MIFloat_Remains()

             JOIN tmpMIChild AS MovementItemChild ON MovementItemChild.ParentId = MovementItem.Id
                            AND MovementItemChild.isEtiketka_child = FALSE
                           
             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                       
             --LEFT JOIN Object AS Object_GoodsChild ON Object_GoodsChild.Id = MovementItemChild.ObjectId

             LEFT JOIN tmpMIString_child AS MIString_PartionGoodsChild
                                          ON MIString_PartionGoodsChild.DescId = zc_MIString_PartionGoods()
                                         AND MIString_PartionGoodsChild.MovementItemId =  MovementItemChild.Id

             LEFT JOIN tmpMIString_child AS MIString_PartNumber_child
                                          ON MIString_PartNumber_child.MovementItemId = MovementItemChild.Id
                                         AND MIString_PartNumber_child.DescId = zc_MIString_PartNumber()
            LEFT JOIN tmpMIString_child AS MIString_ModelChild
                                         ON MIString_ModelChild.MovementItemId = MovementItemChild.Id
                                        AND MIString_ModelChild.DescId = zc_MIString_Model()

             LEFT JOIN tmpMIDate_child AS MIDate_PartionGoodsChild
                                        ON MIDate_PartionGoodsChild.DescId = zc_MIDate_PartionGoods()
                                       AND MIDate_PartionGoodsChild.MovementItemId =  MovementItemChild.Id

             /*LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindChild
                                              ON MILinkObject_GoodsKindChild.MovementItemId = MovementItemChild.Id
                                             AND MILinkObject_GoodsKindChild.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKindChild ON Object_GoodsKindChild.Id = MILinkObject_GoodsKindChild.ObjectId
             */
             LEFT JOIN tmpMILO_child AS MILinkObject_GoodsKind_Complete_child
                                              ON MILinkObject_GoodsKind_Complete_child.MovementItemId = MovementItemChild.Id
                                             AND MILinkObject_GoodsKind_Complete_child.DescId         = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsKind_Complete_child ON Object_GoodsKind_Complete_child.Id = MILinkObject_GoodsKind_Complete_child.ObjectId

             LEFT JOIN tmpMILO_child AS MILinkObject_Storage_child
                                              ON MILinkObject_Storage_child.MovementItemId = MovementItemChild.Id
                                             AND MILinkObject_Storage_child.DescId         = zc_MILinkObject_Storage()
             LEFT JOIN Object AS Object_Storage_child ON Object_Storage_child.Id = MILinkObject_Storage_child.ObjectId

             LEFT JOIN ObjectString AS ObjectString_GoodsChild_GoodsGroupFull
                                    ON ObjectString_GoodsChild_GoodsGroupFull.ObjectId = MovementItemChild.GoodsChildId
                                   AND ObjectString_GoodsChild_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsChild_Measure
                                  ON ObjectLink_GoodsChild_Measure.ObjectId = MovementItemChild.GoodsChildId
                                 AND ObjectLink_GoodsChild_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_MeasureChild ON Object_MeasureChild.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN tmpGoodsByGoodsKindSub ON tmpGoodsByGoodsKindSub.GoodsId     = Object_Goods.Id
                                             AND tmpGoodsByGoodsKindSub.GoodsKindId = Object_GoodsKind.Id
 
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Asset
                                   ON ObjectBoolean_Goods_Asset.ObjectId = Object_Goods.Id 
                                  AND ObjectBoolean_Goods_Asset.DescId = zc_ObjectBoolean_Goods_Asset()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsChild_Asset
                                   ON ObjectBoolean_GoodsChild_Asset.ObjectId = MovementItemChild.GoodsChildId
                                  AND ObjectBoolean_GoodsChild_Asset.DescId = zc_ObjectBoolean_Goods_Asset()

             LEFT JOIN tmpEtiketka ON tmpEtiketka.ParentId = MovementItem.Id

       ;


   ELSE

      RETURN QUERY  
         -- товары пересорт да/нет
         WITH tmpGoodsByGoodsKindSub AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                              , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                              , CASE WHEN COALESCE(ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId ,0)    <> 0
                                                       OR COALESCE(ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId,0) <> 0
                                                     THEN TRUE
                                                     ELSE FALSE
                                                END AS isPeresort
                                         FROM Object_GoodsByGoodsKind_View
                                              LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub
                                                                   ON ObjectLink_GoodsByGoodsKind_GoodsSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                                  AND ObjectLink_GoodsByGoodsKind_GoodsSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
                                              LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSub
                                                                   ON ObjectLink_GoodsByGoodsKind_GoodsKindSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                                  AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub()
                                         WHERE ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId     <> 0
                                            OR ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId <> 0
                                        )
            , tmpMI_Master AS (SELECT MovementItem.*
                               FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                    JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = tmpIsErased.isErased
                              )
            , tmpMI_Child AS (SELECT MovementItemChild.*
                              FROM tmpMI_Master AS MovementItem
                                    JOIN MovementItem AS MovementItemChild ON MovementItemChild.MovementId = inMovementId
                                                     AND MovementItemChild.ParentId   = MovementItem.Id
                                                     AND MovementItemChild.DescId     = zc_MI_Child()
                                                     AND (MovementItemChild.isErased = inisErased OR inisErased = TRUE) 
                              )

            , tmpMIBoolean_child AS (SELECT MIBoolean_Etiketka_child.*
                                     FROM MovementItemBoolean AS MIBoolean_Etiketka_child
                                     WHERE MIBoolean_Etiketka_child.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                                       AND MIBoolean_Etiketka_child.DescId = zc_MIBoolean_Etiketka()
                                    )


            , tmpMIChild AS (SELECT MovementItemChild.Id
                                  , MovementItemChild.ParentId
                                  , MovementItemChild.Amount
                                  , COALESCE (MIBoolean_Etiketka_child.ValueData, FALSE) :: Boolean  AS isEtiketka_child
                                  , Object_GoodsChild.Id                   AS GoodsChildId
                                  , Object_GoodsChild.ObjectCode           AS GoodsChildCode
                                  , Object_GoodsChild.ValueData            AS GoodsChildName
                                  , Object_GoodsKindChild.Id               AS GoodsKindChildId
                                  , Object_GoodsKindChild.ObjectCode       AS GoodsKindChildCode
                                  , Object_GoodsKindChild.ValueData        AS GoodsKindChildName
                             FROM tmpMI_Child AS MovementItemChild
                                  LEFT JOIN tmpMIBoolean_child AS MIBoolean_Etiketka_child
                                                               ON MIBoolean_Etiketka_child.MovementItemId = MovementItemChild.Id

                                  LEFT JOIN Object AS Object_GoodsChild ON Object_GoodsChild.Id = MovementItemChild.ObjectId

                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindChild
                                                                   ON MILinkObject_GoodsKindChild.MovementItemId = MovementItemChild.Id
                                                                  AND MILinkObject_GoodsKindChild.DescId = zc_MILinkObject_GoodsKind()
                                  LEFT JOIN Object AS Object_GoodsKindChild ON Object_GoodsKindChild.Id = MILinkObject_GoodsKindChild.ObjectId                                  
                            )
            , tmpEtiketka AS (SELECT MovementItemChild.ParentId
                                   , STRING_AGG (DISTINCT MovementItemChild.GoodsChildCode::TVarChar, ';') AS GoodsChildCode
                                   , STRING_AGG (DISTINCT MovementItemChild.GoodsChildName::TVarChar, ';') AS GoodsChildName
                                   , STRING_AGG (DISTINCT MovementItemChild.GoodsKindChildName::TVarChar, ';') AS GoodsKindChildName
                                   , SUM (COALESCE (MovementItemChild.Amount,0))        AS Amount
                              FROM tmpMIChild AS MovementItemChild
                              WHERE MovementItemChild.isEtiketka_child = TRUE
                                AND MovementItemChild.Amount <> 0
                              GROUP BY MovementItemChild.ParentId
                              )
, tmpMIString AS (
                   SELECT MovementItemString.*
                   FROM MovementItemString
                   WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                     AND MovementItemString.DescId IN (zc_MIString_PartNumber()
                                                     , zc_MIString_Comment() 
                                                     , zc_MIString_PartionGoods()
                                                     , zc_MIString_Model()
                                                      )
                   )

 , tmpMIString_child AS (SELECT MovementItemString.*
                         FROM MovementItemString
                         WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                           AND MovementItemString.DescId IN (zc_MIString_PartionGoods()
                                                           , zc_MIString_Model()
                                                           , zc_MIString_PartNumber()
                                                            )
                         )
  , tmpMIDate AS (SELECT MovementItemDate.*
                  FROM MovementItemDate
                  WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                    AND MovementItemDate.DescId IN (zc_MIDate_PartionGoods())
                  )

  , tmpMIDate_child AS (SELECT MovementItemDate.*
                         FROM MovementItemDate
                         WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                           AND MovementItemDate.DescId IN (zc_MIDate_PartionGoods())
                         )

  , tmpMILO_child AS (SELECT MovementItemLinkObject.*
                         FROM MovementItemLinkObject
                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                           AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKindComplete()
                                                               , zc_MILinkObject_Storage()
                                                                )
                         )

      SELECT
             MovementItem.Id					AS Id
           , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS INTEGER) AS  LineNum
            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_Measure.ValueData                    AS MeasureName
            , COALESCE (ObjectBoolean_Goods_Asset.ValueData, FALSE) ::Boolean AS isAsset

            , MovementItemChild.GoodsChildId
            , MovementItemChild.GoodsChildCode
            , MovementItemChild.GoodsChildName
            , ObjectString_GoodsChild_GoodsGroupFull.ValueData AS GoodsChildGroupNameFull
            , Object_MeasureChild.ValueData                    AS MeasureChildName
            , COALESCE (ObjectBoolean_GoodsChild_Asset.ValueData, FALSE) ::Boolean AS isAssetChild

            , MovementItemChild.Amount            AS Amountout
            , MovementItem.Amount                 AS Amountin
            , MIFloat_Remains.ValueData ::TFloat  AS Amount_Remains

            , MIString_PartionGoods.ValueData   AS PartionGoods
            , MIDate_PartionGoods.ValueData     AS PartionGoodsDate

            , MIString_PartionGoodsChild.ValueData   AS PartionGoodsChild
            , MIDate_PartionGoodsChild.ValueData     AS PartionGoodsDateChild

            , CASE WHEN vbUserId = 5 THEN COALESCE (MIString_Comment.ValueData, '') || ' ' || MovementItem.Id :: TVarChar ELSE MIString_Comment.ValueData END :: TVarChar AS Comment

            , Object_GoodsKind.Id               AS GoodsKindId
            , Object_GoodsKind.ObjectCode       AS GoodsKindCode
            , Object_GoodsKind.ValueData        AS GoodsKindName
            , Object_GoodsKind_Complete.Id               AS GoodsKindId_Complete
            , Object_GoodsKind_Complete.ObjectCode       AS GoodsKindCode_Complete
            , Object_GoodsKind_Complete.ValueData        AS GoodsKindName_Complete

            , MovementItemChild.GoodsKindChildId
            , MovementItemChild.GoodsKindChildCode
            , MovementItemChild.GoodsKindChildName
            , Object_GoodsKind_Complete_child.Id               AS GoodsKindId_Complete_child
            , Object_GoodsKind_Complete_child.ObjectCode       AS GoodsKindCode_Complete_child
            , Object_GoodsKind_Complete_child.ValueData        AS GoodsKindName_Complete_child

            , Object_Storage.Id                         AS StorageId
            , Object_Storage.ValueData                  AS StorageName
            , MIString_PartNumber.ValueData :: TVarChar AS PartNumber
            , MIString_Model.ValueData      :: TVarChar AS Model

            , Object_Storage_child.Id                         AS StorageId_child
            , Object_Storage_child.ValueData                  AS StorageName_child
            , MIString_PartNumber_child.ValueData :: TVarChar AS PartNumber_child
            , MIString_ModelChild.ValueData       :: TVarChar AS Model_child
            
            , CASE WHEN tmpGoodsByGoodsKindSub.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPeresort

            , MovementItem.isErased             AS isErased

            , tmpEtiketka.GoodsChildCode ::TVarChar AS GoodsChildCode_et
            , tmpEtiketka.GoodsChildName ::TVarChar AS GoodsChildName_et
            , tmpEtiketka.GoodsKindChildName ::TVarChar AS GoodsKindChildName_et
            , tmpEtiketka.Amount         ::TFloat   AS Amount_et 
       FROM tmpMI_Master AS MovementItem
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_Complete
                                              ON MILinkObject_GoodsKind_Complete.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind_Complete.DescId         = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsKind_Complete ON Object_GoodsKind_Complete.Id = MILinkObject_GoodsKind_Complete.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                              ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Storage.DescId         = zc_MILinkObject_Storage()
             LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = MILinkObject_Storage.ObjectId

             LEFT JOIN tmpMIString AS MIString_PartNumber
                                          ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                         AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

             LEFT JOIN tmpMIString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN tmpMIString AS MIString_PartionGoods
                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

             LEFT JOIN tmpMIDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                       AND MIDate_PartionGoods.MovementItemId =  MovementItem.Id

             LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                         ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                        AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
              
             JOIN tmpMIChild AS MovementItemChild ON MovementItemChild.ParentId = MovementItem.Id
                            AND MovementItemChild.isEtiketka_child = FALSE

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                       
    
             --LEFT JOIN Object AS Object_GoodsChild ON Object_GoodsChild.Id = MovementItemChild.ObjectId

             LEFT JOIN tmpMIString_child AS MIString_PartionGoodsChild
                                          ON MIString_PartionGoodsChild.DescId = zc_MIString_PartionGoods()
                                         AND MIString_PartionGoodsChild.MovementItemId =  MovementItemChild.Id
             LEFT JOIN tmpMIString AS MIString_Model
                                          ON MIString_Model.MovementItemId = MovementItem.Id
                                         AND MIString_Model.DescId = zc_MIString_Model()

             LEFT JOIN tmpMIDate_child AS MIDate_PartionGoodsChild
                                        ON MIDate_PartionGoodsChild.DescId = zc_MIDate_PartionGoods()
                                       AND MIDate_PartionGoodsChild.MovementItemId =  MovementItemChild.Id

             /*LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindChild
                                              ON MILinkObject_GoodsKindChild.MovementItemId = MovementItemChild.Id
                                             AND MILinkObject_GoodsKindChild.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKindChild ON Object_GoodsKindChild.Id = MILinkObject_GoodsKindChild.ObjectId
             */

             LEFT JOIN tmpMILO_child AS MILinkObject_GoodsKind_Complete_child
                                              ON MILinkObject_GoodsKind_Complete_child.MovementItemId = MovementItemChild.Id
                                             AND MILinkObject_GoodsKind_Complete_child.DescId         = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsKind_Complete_child ON Object_GoodsKind_Complete_child.Id = MILinkObject_GoodsKind_Complete_child.ObjectId

             LEFT JOIN tmpMILO_child AS MILinkObject_Storage_child
                                              ON MILinkObject_Storage_child.MovementItemId = MovementItemChild.Id
                                             AND MILinkObject_Storage_child.DescId         = zc_MILinkObject_Storage()
             LEFT JOIN Object AS Object_Storage_child ON Object_Storage_child.Id = MILinkObject_Storage_child.ObjectId

             LEFT JOIN tmpMIString_child AS MIString_PartNumber_child
                                          ON MIString_PartNumber_child.MovementItemId = MovementItemChild.Id
                                         AND MIString_PartNumber_child.DescId = zc_MIString_PartNumber()
            LEFT JOIN tmpMIString_child AS MIString_ModelChild
                                         ON MIString_ModelChild.MovementItemId = MovementItemChild.Id
                                        AND MIString_ModelChild.DescId = zc_MIString_Model()

             LEFT JOIN ObjectString AS ObjectString_GoodsChild_GoodsGroupFull
                                    ON ObjectString_GoodsChild_GoodsGroupFull.ObjectId = MovementItemChild.GoodsChildId
                                   AND ObjectString_GoodsChild_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsChild_Measure
                                  ON ObjectLink_GoodsChild_Measure.ObjectId = MovementItemChild.GoodsChildId
                                 AND ObjectLink_GoodsChild_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_MeasureChild ON Object_MeasureChild.Id = ObjectLink_GoodsChild_Measure.ChildObjectId
             
             LEFT JOIN tmpGoodsByGoodsKindSub ON tmpGoodsByGoodsKindSub.GoodsId     = Object_Goods.Id
                                             AND tmpGoodsByGoodsKindSub.GoodsKindId = Object_GoodsKind.Id

             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Asset
                                     ON ObjectBoolean_Goods_Asset.ObjectId = Object_Goods.Id 
                                    AND ObjectBoolean_Goods_Asset.DescId = zc_ObjectBoolean_Goods_Asset()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsChild_Asset
                                     ON ObjectBoolean_GoodsChild_Asset.ObjectId = MovementItemChild.GoodsChildId
                                    AND ObjectBoolean_GoodsChild_Asset.DescId = zc_ObjectBoolean_Goods_Asset()  
                                    
             LEFT JOIN tmpEtiketka ON tmpEtiketka.ParentId = MovementItem.Id

       ;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.05.23         *
 19.05.23         *
 05.05.23         *
 18.10.22         *
 31.03.15         * 
 11.12.14         *

*/

-- тест
-- SELECT * FROM gpSelect_MI_ProductionPeresort (inMovementId:= 597574, inShowAll:= TRUE,  inisErased:= TRUE ,inSession:= '2')
-- SELECT * FROM gpSelect_MI_ProductionPeresort (inMovementId:= 29015348 , inShowAll:= FALSE,  inisErased:= FALSE ,inSession:= '2')
