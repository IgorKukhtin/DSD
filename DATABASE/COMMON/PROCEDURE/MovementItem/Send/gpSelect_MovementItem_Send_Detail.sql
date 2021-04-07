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
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     IF inShowAll THEN

     -- Результат такой
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
                            
       -- Результат
       SELECT
             COALESCE (tmpMI_Detail.Id,0) AS Id
           , COALESCE (tmpMI_Detail.ParentId, tmpMI_Master.Id) AS ParentId
           , Object_Goods.Id            AS GoodsId
           , Object_Goods.ObjectCode    AS GoodsCode
           , Object_Goods.ValueData     AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , COALESCE (tmpMI_Detail.Amount, tmpMI_Master.Amount) :: TFloat AS Amount
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
 
           , tmpMI_Detail.SubjectDocId  ::Integer
           , tmpMI_DetailSubjectDocName ::TVarChar
           , tmpMI_DetailReturnKindId   ::Integer
           , tmpMI_DetailReturnKindName ::TVarChar
           , FALSE                      AS isErased
       FROM tmpMI_Master
            LEFT JOIN tmpMI_Detail ON tmpMI_Detail.ParentId = tmpMI_Master.Id
            
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Master.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI_Master.GoodsKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI_Master.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI_Master.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
            ;
     ELSE

     -- Результат другой
     RETURN QUERY
       SELECT
             MovementItem.Id                AS Id
           , MovementItem.ParentId          AS ParentId
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData       AS MeasureName

           , MovementItem.Amount            AS Amount
           , Object_GoodsKind.Id            AS GoodsKindId
           , Object_GoodsKind.ValueData     AS GoodsKindName
           , Object_SubjectDoc.Id           AS SubjectDocId
           , Object_SubjectDoc.ValueData    AS SubjectDocName
           , Object_ReturnKind.Id           AS ReturnKindId
           , Object_ReturnKind.ValueData    AS ReturnKindName

           , MovementItem.isErased          AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Detail()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.ParentId
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILO_SubjectDoc
                                             ON MILO_SubjectDoc.MovementItemId = MovementItem.Id
                                            AND MILO_SubjectDoc.DescId = zc_MILinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MILO_SubjectDoc.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_ReturnKind
                                             ON MILinkObject_ReturnKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ReturnKind.DescId = zc_MILinkObject_ReturnKind()
            LEFT JOIN Object AS Object_ReturnKind ON Object_ReturnKind.Id = MILinkObject_ReturnKind.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
           ;


     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.04.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Send_Detail (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')