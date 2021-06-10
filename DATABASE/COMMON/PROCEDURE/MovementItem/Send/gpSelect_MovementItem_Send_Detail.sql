 -- Function: gpSelect_MovementItem_Send_Detail()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Send_Detail (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Send_Detail(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount TFloat
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , SubjectDocId Integer, SubjectDocName  TVarChar
             , ReturnKindId Integer, ReturnKindName TVarChar
             , isErased Boolean
             , Ord Integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
     vbUserId:= lpGetUserBySession (inSession);
     

     -- Результат
     RETURN QUERY
       WITH tmpMI_Master AS (SELECT MovementItem.Id
                                  , MovementItem.ObjectId                         AS GoodsId
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                  , MovementItem.Amount
                             FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                  JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = tmpIsErased.isErased
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            )
          , tmpMI_Detail AS (SELECT MovementItem.Id
                                  , MovementItem.ParentId
                                  , MovementItem.ObjectId          AS GoodsId
                                  , MovementItem.Amount
                                  , Object_SubjectDoc.Id           AS SubjectDocId
                                  , Object_SubjectDoc.ValueData    AS SubjectDocName
                                  , Object_ReturnKind.Id           AS ReturnKindId
                                  , Object_ReturnKind.ValueData    AS ReturnKindName
                                  , SUM (COALESCE (MovementItem.Amount,0)) OVER (PARTITION BY MovementItem.ParentId) AS TotalAmount 
                             FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                  JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId     = zc_MI_Detail()
                                                   AND MovementItem.isErased   = tmpIsErased.isErased
                                  LEFT JOIN MovementItemLinkObject AS MILO_SubjectDoc
                                                                   ON MILO_SubjectDoc.MovementItemId = MovementItem.Id
                                                                  AND MILO_SubjectDoc.DescId = zc_MILinkObject_SubjectDoc()
                                  LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MILO_SubjectDoc.ObjectId

                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_ReturnKind
                                                                   ON MILinkObject_ReturnKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_ReturnKind.DescId = zc_MILinkObject_ReturnKind()
                                  LEFT JOIN Object AS Object_ReturnKind ON Object_ReturnKind.Id = MILinkObject_ReturnKind.ObjectId
                            )
         , tmpDiff AS (SELECT tmpMI_Master.Id
                            , tmpMI_Master.GoodsId
                            , tmpMI_Master.GoodsKindId
                            , COALESCE (tmpMI_Master.Amount,0) - COALESCE (tmpDetail.TotalAmount,0) AS Amount
                       FROM tmpMI_Master
                            LEFT JOIN (SELECT DISTINCT tmpMI_Detail.ParentId, tmpMI_Detail.TotalAmount FROM tmpMI_Detail) AS tmpDetail ON tmpDetail.ParentId = tmpMI_Master.Id
                       WHERE COALESCE (tmpMI_Master.Amount,0) - COALESCE (tmpDetail.TotalAmount,0) > 0
                      )
          , tmpAll AS (SELECT COALESCE (tmpMI_Detail.Id,0) AS Id
                            , COALESCE (tmpMI_Detail.ParentId, tmpMI_Master.Id) AS ParentId
                            , tmpMI_Master.GoodsId
                            , tmpMI_Master.GoodsKindId
                            , COALESCE (tmpMI_Detail.Amount, tmpMI_Master.Amount) :: TFloat AS Amount
                            , tmpMI_Detail.SubjectDocId   ::Integer
                            , tmpMI_Detail.SubjectDocName ::TVarChar
                            , tmpMI_Detail.ReturnKindId   ::Integer
                            , tmpMI_Detail.ReturnKindName ::TVarChar
                              -- № п.п.
                            , ROW_NUMBER () OVER (PARTITION BY tmpMI_Master.GoodsId, tmpMI_Master.GoodsKindId ORDER BY tmpMI_Detail.Id ASC) AS Ord
                       FROM tmpMI_Master
                            INNER JOIN tmpMI_Detail ON tmpMI_Detail.ParentId = tmpMI_Master.Id
                     UNION 
                       SELECT 0 :: integer AS Id
                            , tmpMI_Master.Id AS ParentId
                            , tmpMI_Master.GoodsId
                            , tmpMI_Master.GoodsKindId
                            , tmpDiff.Amount :: TFloat AS Amount
                            , 0   ::Integer  AS SubjectDocId
                            , ''  ::TVarChar AS SubjectDocName
                            , 0   ::Integer  AS ReturnKindId
                            , ''  ::TVarChar AS ReturnKindName
                              -- № п.п. - здесь всегда последний
                            , 10000          AS ord
                       FROM tmpMI_Master
                            INNER JOIN tmpDiff ON tmpDiff.Id = tmpMI_Master.Id
                      )
       -- Результат
       SELECT
             COALESCE (tmpAll.Id,0) AS Id
           , tmpAll.ParentId
           , Object_Goods.Id            AS GoodsId
           , Object_Goods.ObjectCode    AS GoodsCode
           , Object_Goods.ValueData     AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , tmpAll.Amount :: TFloat AS Amount
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
 
           , tmpAll.SubjectDocId   ::Integer
           , tmpAll.SubjectDocName ::TVarChar
           , tmpAll.ReturnKindId   ::Integer
           , tmpAll.ReturnKindName ::TVarChar
           , FALSE                      AS isErased
             -- № п.п.
           , ROW_NUMBER () OVER (PARTITION BY tmpAll.GoodsId, tmpAll.GoodsKindId ORDER BY tmpAll.Ord ASC) :: Integer AS ord  
       FROM tmpAll
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpAll.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpAll.GoodsKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpAll.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpAll.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.21         *
 07.04.21         *
*/

-- тест
--
-- SELECT * FROM gpSelect_MovementItem_Send_Detail (inMovementId:= 20081622, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '9818')
