-- Function: gpSelect_Movement_Sale_Order_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Order_Print (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_Order_Print(
    IN inMovementId                 Integer  , -- ���� ��������� ������
    IN inMovementId_Weighing        Integer  , -- ���� ��������� �����������
    IN inSession                    TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbMovementId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     
     SELECT  Movement.Id
     	INTO vbMovementId
     FROM MovementLinkMovement 
          inner join Movement on Movement.Id = MovementLinkMovement.MovementId
                             AND Movement.DescId = zc_Movement_Sale()
                             AND Movement.StatusId <> zc_Enum_Status_Erased()
     WHERE MovementLinkMovement.MovementChildId = inMovementId   
       AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()

    ;

    --
    OPEN Cursor1 FOR
    
     SELECT
           Movement.InvNumber             AS InvNumber
         , Movement.OperDate              AS OperDate

         , Object_From.ValueData          AS FromName
         , Object_To.ValueData            AS ToName
      
     FROM Movement 
         
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
       
       WHERE Movement.Id = vbMovementId
         AND Movement.StatusId <> zc_Enum_Status_Erased()
      ;



    RETURN NEXT Cursor1;
    OPEN Cursor2 FOR

     WITH tmpWeighing AS (SELECT MovementItem.ObjectId                                     AS GoodsId
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)             AS GoodsKindId
                               , COALESCE (MIString_PartionGoods.ValueData, '')            AS PartionGoods
                               , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())  AS PartionGoodsDate
                               , SUM (MovementItem.Amount)                                 AS Amount
                          FROM (SELECT Movement.Id AS MovementId
                                FROM MovementLinkMovement AS MLM_Weighing 
                                    INNER JOIN Movement ON Movement.Id = MLM_Weighing.MovementId
                                                       AND Movement.DescId = zc_Movement_WeighingPartner()
                                                       AND Movement.StatusId = zc_Enum_Status_unComplete()
                                                       AND (Movement.Id = inMovementId_Weighing OR COALESCE (inMovementId_Weighing, 0) = 0)
                                WHERE MLM_Weighing.MovementChildId = inMovementId -- MLM_Order.MovementChildId   id ������ 
                                  
                                ) AS tmp
                                INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                                LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                           ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                          AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                             ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                                            AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                          GROUP BY MovementItem.ObjectId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                 , COALESCE (MIString_PartionGoods.ValueData, '')
                                 , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())
                         )
              , tmpMI AS (SELECT MovementItem.ObjectId                                     AS GoodsId
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)             AS GoodsKindId
                               , COALESCE (MIString_PartionGoods.ValueData, '')            AS PartionGoods
                               , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())  AS PartionGoodsDate
                               , SUM (MovementItem.Amount)                                 AS Amount
                           FROM MovementItem
                                LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                           ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                          AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                             ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                                            AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                          WHERE MovementItem.MovementId = vbMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                            AND MovementItem.Amount <> 0
                          GROUP BY MovementItem.ObjectId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                 , COALESCE (MIString_PartionGoods.ValueData, '')
                                 , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())
                          )
                        

         , tmpMIOrder AS ( SELECT MovementItem.ObjectId AS GoodsId 
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                               , COALESCE (MIString_PartionGoods.ValueData, '')            AS PartionGoods
                               , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())  AS PartionGoodsDate
                            
                               , SUM (MovementItem.Amount) AS Amount
                               , SUM (MIFloat_AmountSecond.ValueData)     AS AmountSecond  

                          FROM MovementItem         
                               LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                           ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id 
                                                          AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                               LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                          ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                         AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                               LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                            ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                                           AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()                               

                          WHERE MovementItem.MovementId = inMovementId 
                            AND MovementItem.isErased   = FALSE   
                          GROUP BY MovementItem.ObjectId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) 
                                 , COALESCE (MIString_PartionGoods.ValueData, '')
                                 , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())
                         ) 
                   
        , tmpResult_1 AS (SELECT COALESCE (tmpWeighing.GoodsId, tmpMI.GoodsId)                   AS GoodsId
                               , COALESCE (tmpWeighing.GoodsKindId, tmpMI.GoodsKindId)           AS GoodsKindId
                               , COALESCE (tmpWeighing.PartionGoods, tmpMI.PartionGoods)         AS PartionGoods
                               , COALESCE (tmpWeighing.PartionGoodsDate, tmpMI.PartionGoodsDate) AS PartionGoodsDate
                               , COALESCE (tmpWeighing.Amount, 0)                                AS Amount_Weighing
                               , COALESCE (tmpMI.Amount, 0)                                      AS Amount
                           FROM tmpWeighing
                                FULL JOIN tmpMI ON tmpMI.GoodsId          =  tmpWeighing.GoodsId
                                               AND tmpMI.GoodsKindId      =  tmpWeighing.GoodsKindId
                                               AND tmpMI.PartionGoods     =  tmpWeighing.PartionGoods
                                               AND tmpMI.PartionGoodsDate =  tmpWeighing.PartionGoodsDate
                         )
          , tmpResult as (SELECT COALESCE (tmpResult_1.GoodsId, tmpMIOrder.GoodsId)                   AS GoodsId
                               , COALESCE (tmpResult_1.GoodsKindId, tmpMIOrder.GoodsKindId)           AS GoodsKindId
                               , COALESCE (tmpResult_1.PartionGoods, tmpMIOrder.PartionGoods)         AS PartionGoods
                               , COALESCE (tmpResult_1.PartionGoodsDate, tmpMIOrder.PartionGoodsDate) AS PartionGoodsDate
                               , COALESCE (tmpResult_1.Amount, 0)                                AS Amount_Weighing
                               , COALESCE (tmpResult_1.Amount, 0)                                AS Amount
                               , COALESCE (tmpMIOrder.Amount, 0)                                 AS Amount_Order
                               , COALESCE (tmpMIOrder.AmountSecond, 0)                           AS AmountSecond_Order
                           FROM tmpResult_1
                                FULL JOIN tmpMIOrder ON tmpMIOrder.GoodsId          =  tmpResult_1.GoodsId
                                                    AND tmpMIOrder.GoodsKindId      =  tmpResult_1.GoodsKindId
                                                    AND tmpMIOrder.PartionGoods     =  tmpResult_1.PartionGoods
                                                    AND tmpMIOrder.PartionGoodsDate =  tmpResult_1.PartionGoodsDate
                           )

       SELECT Object_Goods.ObjectCode  			  AS GoodsCode
            , Object_Goods.ValueData   			  AS GoodsName
            , Object_GoodsKind.ValueData                  AS GoodsKindName
            , Object_GoodsGroup.ValueData   		  AS GoodsGroupName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , tmpResult1.MeasureName
            
            , tmpResult1.Amount_Sh
            , tmpResult1.Amount_Weight

            , tmpResult1.Amount_Weighing_Sh
            , tmpResult1.Amount_Weighing_Weight

            , tmpResult1.PartionGoods

            , tmpResult1.Amount_Order_Sh
            , tmpResult1.Amount_Order_Weight

            , tmpResult1.AmountSecond_Order_Sh
            , tmpResult1.AmountSecond_Order_Weight
            
            , CASE WHEN tmpResult1.Amount_Weight-tmpResult1.Amount_Order_Weight-tmpResult1.AmountSecond_Order_Weight > 0 
                   THEN tmpResult1.Amount_Weight-tmpResult1.Amount_Order_Weight-tmpResult1.AmountSecond_Order_Weight 
                   ELSE 0 END AS WeightDiff_B

            , CASE WHEN tmpResult1.Amount_Weight-tmpResult1.Amount_Order_Weight-tmpResult1.AmountSecond_Order_Weight < 0 
                   THEN (-1)*(tmpResult1.Amount_Weight-tmpResult1.Amount_Order_Weight-tmpResult1.AmountSecond_Order_Weight) 
                   ELSE 0 END AS WeightDiff_M

       FROM ( SELECT tmpResult.GoodsId 			
                   , tmpResult.GoodsKindId
                   
                   , Object_Measure.ValueData    AS MeasureName

                   , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.Amount ELSE 0 END                                :: TFloat AS Amount_Sh
                   , tmpResult.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END :: TFloat AS Amount_Weight

                   , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.Amount_Weighing ELSE 0 END                                :: TFloat AS Amount_Weighing_Sh
                   , tmpResult.Amount_Weighing * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END :: TFloat AS Amount_Weighing_Weight

                   , CASE WHEN tmpResult.PartionGoods <> '' THEN tmpResult.PartionGoods WHEN tmpResult.PartionGoodsDate <> zc_DateStart() THEN TO_CHAR (tmpResult.PartionGoodsDate, 'DD.MM.YYYY') ELSE '' END :: TVarChar AS PartionGoods

                   , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.Amount_Order ELSE 0 END                                :: TFloat AS Amount_Order_Sh
                   , tmpResult.Amount_Order * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END :: TFloat AS Amount_Order_Weight

                   , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.AmountSecond_Order ELSE 0 END                                :: TFloat AS AmountSecond_Order_Sh
                   , tmpResult.AmountSecond_Order * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END :: TFloat AS AmountSecond_Order_Weight

             FROM tmpResult

                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpResult.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                  LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                  
                  LEFT JOIN ObjectFloat AS ObjectFloat_Weight	
                                  ON ObjectFloat_Weight.ObjectId = tmpResult.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
              ) AS tmpResult1

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult1.GoodsId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpResult1.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult1.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpResult1.GoodsId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
            
      ;
      

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Sale_Order_Print (Integer,Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.07.15         *
*/
-- ����
-- SELECT * FROM gpSelect_Movement_Sale_Order_Print (inMovementId := 597300, inMovementId_Weighing:= 0, inSession:= zfCalc_UserAdmin());
--select * from gpSelect_Movement_Sale_Order_Print(inMovementId := 1815949 , inMovementId_Weighing := 0 ,  inSession := '5');
