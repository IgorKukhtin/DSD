-- Function: gpSelect_Movement_ProductionUnion_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionUnion_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionUnion_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

    OPEN Cursor1 FOR
      
       SELECT
             Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , Object_From.ValueData                              AS FromName
           , Object_To.ValueData                                AS ToName
           , Object_SubjectDoc.ValueData                        AS SubjectDocName
       
       FROM Movement
   
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
  
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId IN (zc_Movement_ProductionUnion())
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR

      SELECT
             MovementItem.Id                    AS MovementItemId
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
         
            , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN MovementItem.Amount   ELSE 0 END                                 :: TFloat AS Amountin
            , (MovementItem.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)  :: TFloat AS WeightIn

            , CASE WHEN Object_MeasureChild.Id = zc_Measure_Sh() THEN MovementItemChild.Amount   ELSE 0 END                                     :: TFloat AS AmountOut
            , (MovementItemChild.Amount * CASE WHEN Object_MeasureChild.Id = zc_Measure_Sh() THEN ObjectFloat_WeightChild.ValueData ELSE 1 END) :: TFloat AS WeightOut         

            , MIString_PartionGoods.ValueData   AS PartionGoods
            , MIDate_PartionGoods.ValueData     AS PartionGoodsDate

            , MIString_PartionGoodsChild.ValueData   AS PartionGoodsChild
            , MIDate_PartionGoodsChild.ValueData     AS PartionGoodsDateChild

            , Object_GoodsKind.ObjectCode       AS GoodsKindCode
            , Object_GoodsKind.ValueData        AS GoodsKindName

            , Object_GoodsKindChild.ObjectCode       AS GoodsKindChildCode
            , Object_GoodsKindChild.ValueData        AS GoodsKindChildName


       FROM MovementItem 
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

             LEFT JOIN MovementItem AS MovementItemChild ON MovementItemChild.MovementId = MovementItem.MovementId
                              AND MovementItemChild.ParentId   = MovementItem.Id
                              AND MovementItemChild.DescId     = zc_MI_Child()
                              AND MovementItemChild.isErased   = False
             LEFT JOIN Object AS Object_GoodsChild ON Object_GoodsChild.Id = MovementItemChild.ObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

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

             LEFT JOIN ObjectString AS ObjectString_GoodsChild_GoodsGroupFull
                                    ON ObjectString_GoodsChild_GoodsGroupFull.ObjectId = Object_GoodsChild.Id
                                   AND ObjectString_GoodsChild_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsChild_Measure
                                  ON ObjectLink_GoodsChild_Measure.ObjectId = Object_GoodsChild.Id
                                 AND ObjectLink_GoodsChild_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_MeasureChild ON Object_MeasureChild.Id = ObjectLink_GoodsChild_Measure.ChildObjectId

             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
             LEFT JOIN ObjectFloat AS ObjectFloat_WeightChild
                                   ON ObjectFloat_WeightChild.ObjectId = Object_GoodsChild.Id
                                  AND ObjectFloat_WeightChild.DescId = zc_ObjectFloat_Goods_Weight() 
             
        WHERE  MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Master()
           AND MovementItem.isErased   = False
 
        ;


    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_ProductionUnion_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.07.15         *
*/

-- SELECT * FROM gpSelect_Movement_ProductionUnion_Print (inMovementId := 570596, inSession:= '5');
