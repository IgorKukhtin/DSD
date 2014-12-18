-- Function: gpSelect_Movement_ProductionUnionTech()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionUnionTech (TDateTime,TDateTime,Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionUnionTech(
    IN inStartDate      TDateTime,
    IN inEndDate        TDateTime,
    IN inFromId         Integer,
    IN inToId           Integer,
    IN inGoodsGroupId   Integer,
    IN inisErased       Boolean, --
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ProductionUnion());
     vbUserId := inSession;

    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;

    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
          SELECT GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE
        INSERT INTO _tmpGoods (GoodsId)
          SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
    END IF;

--*******
    OPEN Cursor1 FOR
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

       SELECT
              Movement.Id					    AS MovementId
            , MovementItem.Id					AS Id
            , Movement.InvNumber                AS InvNumber
            , Movement.OperDate                 AS OperDate
            , Object_From.Id                    AS FromId
            , Object_From.ValueData             AS FromName
            , Object_To.Id                      AS ToId
            , Object_To.ValueData               AS ToName

--            , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS INTEGER) AS  LineNum
            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName

            , MovementItem.Amount               AS Amount

            , MIBoolean_PartionClose.ValueData  AS PartionClose
            , MIString_PartionGoods.ValueData   AS PartionGoods

            , MIString_Comment.ValueData        AS Comment
            , MIFloat_Count.ValueData           AS Count
            , MIFloat_RealWeight.ValueData      AS RealWeight
            , MIFloat_CuterCount.ValueData      AS CuterCount
            , tmpMovementItemOrder.AmountOrder  AS AmountOrder

            , Object_GoodsKind.Id               AS GoodsKindId
            , Object_GoodsKind.ObjectCode       AS GoodsKindCode
            , Object_GoodsKind.ValueData        AS GoodsKindName

            , Object_Receipt.Id                 AS ReceiptId
            , Object_Receipt.ObjectCode         AS ReceiptCode
            , Object_Receipt.ValueData          AS ReceiptName
            , Object_Status.ObjectCode          AS StatusCode
            , Object_Status.ValueData           AS StatusName


            , MovementItem.isErased             AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_ProductionUnion() AND Movement.StatusId = tmpStatus.StatusId
--                  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            ) AS tmpMovement ON 1=1

             JOIN Movement ON Movement.Id = tmpMovement.Id
             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

             JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                             ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()


             JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId


             LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                              ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
             LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILinkObject_Receipt.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN MovementItemFloat AS MIFloat_Count
                                         ON MIFloat_Count.MovementItemId = MovementItem.Id
                                        AND MIFloat_Count.DescId = zc_MIFloat_Count()

             LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                         ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                        AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()

             LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                         ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                        AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()

             LEFT JOIN MovementItemBoolean AS MIBoolean_PartionClose
                                           ON MIBoolean_PartionClose.MovementItemId = MovementItem.Id
                                          AND MIBoolean_PartionClose.DescId = zc_MIBoolean_PartionClose()

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN MovementItemString AS MIString_PartionGoods
                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId


     FULL JOIN (  SELECT Movement.OperDate                                                AS OperDate
                       , MovementItem.ObjectId                                          AS ObjectId
                       , MILO_GoodsKind.ObjectId                                        AS GoodsKindId
                       , MLO_From.ObjectId                                              AS FromId
                       , MLO_To.ObjectId                                                AS ToId
                       , MovementItem.Amount + COALESCE(MovementItemFloat.ValueData, 0) AS AmountOrder
                    FROM Movement
                    JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                     AND MovementItem.DescId     = zc_MI_Master()
               LEFT JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                     AND MovementItemFloat.DescId = zc_MIFloat_AmountSecond()
               LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                               AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
               LEFT JOIN MovementLinkObject AS MLO_From
                                            ON MLO_From.MovementId = Movement.Id
                                           AND MLO_From.DescId = zc_MovementLinkObject_From()
               LEFT JOIN MovementLinkObject AS MLO_To
                                            ON MLO_To.MovementId = Movement.Id
                                           AND MLO_To.DescId = zc_MovementLinkObject_To()

                   WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                     AND Movement.DescId = zc_Movement_OrderInternal()
                     AND Movement.StatusId <> zc_Enum_Status_Erased()

                ) AS tmpMovementItemOrder ON tmpMovementItemOrder.ObjectId = MovementItem.ObjectId
                                         AND tmpMovementItemOrder.GoodsKindId = MILO_GoodsKind.ObjectId
                                         AND tmpMovementItemOrder.OperDate = Movement.OperDate
                                         AND tmpMovementItemOrder.FromId = MovementLinkObject_From.ObjectId
                                         AND tmpMovementItemOrder.ToId = MovementLinkObject_To.ObjectId


       WHERE MovementLinkObject_From.ObjectId = CASE WHEN inFromId = 0 THEN MovementLinkObject_From.ObjectId ELSE inFromId END
         AND MovementLinkObject_To.ObjectId   = CASE WHEN inToId = 0   THEN MovementLinkObject_To.ObjectId ELSE inToId END

       ORDER BY MovementItem.Id
            ;
    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
       SELECT
              Movement.Id					    AS MovementId
            , MovementItem.Id					AS Id

            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName

            , MovementItem.Amount               AS Amount
            , MovementItem.ParentId             AS ParentId

            , MIFloat_AmountReceipt.ValueData   AS AmountReceipt

            , MIDate_PartionGoods.ValueData     AS PartionGoodsDate
            , MIString_PartionGoods.ValueData   AS PartionGoods

            , MIString_Comment.ValueData        AS Comment

            , Object_GoodsKind.Id               AS GoodsKindId
            , Object_GoodsKind.ObjectCode       AS GoodsKindCode
            , Object_GoodsKind.ValueData        AS GoodsKindName

            , MovementItem.isErased             AS isErased


       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
             JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_ProductionUnion()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = tmpIsErased.isErased
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                       AND MIDate_PartionGoods.MovementItemId =  MovementItem.Id

             LEFT JOIN MovementItemString AS MIString_PartionGoods
                                          ON MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                         AND MIString_PartionGoods.MovementItemId =  MovementItem.Id

             LEFT JOIN MovementItemFloat AS MIFloat_AmountReceipt
                                         ON MIFloat_AmountReceipt.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountReceipt.DescId = zc_MIFloat_AmountReceipt()

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
       WHERE MovementLinkObject_From.ObjectId = CASE WHEN inFromId = 0 THEN MovementLinkObject_From.ObjectId ELSE inFromId END
         AND MovementLinkObject_To.ObjectId   = CASE WHEN inToId = 0   THEN MovementLinkObject_To.ObjectId ELSE inToId END

       ORDER BY MovementItem.Id
            ;
    RETURN NEXT Cursor2;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_ProductionUnionTech (TDateTime,TDateTime,Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.12.14                                                        *
*/

-- тест
/*
BEGIN;
select * from gpSelect_Movement_ProductionUnionTech(inStartDate := ('01.06.2014')::TDateTime , inEndDate := ('01.06.2014')::TDateTime , inFromId := 0 , inToId := 0 , inGoodsGroupId := 0 , inIsErased := 'False' ,  inSession := '5');
COMMIT;
*/