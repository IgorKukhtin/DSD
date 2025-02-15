--DROP FUNCTION IF EXISTS gpReport_Promo_DetailError(TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Promo_DetailError(TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Promo_DetailError(
    IN inStartDate      TDateTime, --���� ������ �������
    IN inEndDate        TDateTime, --���� ��������� ������� 
    IN inisGoods        Boolean ,  -- ���������� �� �������
    IN inSession        TVarChar   --������ ������������
)
RETURNS TABLE(
     MovementId              Integer   --�� ��������� �����
    ,OperDate                TDateTime --����
    ,InvNumber               Integer   --� ��������� �����       
    ,isOut                   Boolean   -- ���������� �� ���� �������
    ,isReal                  Boolean   -- ���������� �� ������. ������� 
    ,isOperDate              Boolean   --������. ������ ����� ���� ��������
    , GoodsId                Integer --�� ������� <�����>
    , GoodsCode              Integer --��� �������  <�����>
    , GoodsName              TVarChar --������������ ������� <�����>
    , MeasureName            TVarChar --������� ���������
    , GoodsWeight            TFloat -- ��� ������
    , GoodsKindId            Integer --�� ������� <��� ������>
    , GoodsKindName          TVarChar --������������ ������� <��� ������>
    , GoodsKindCompleteId    Integer --�� ������� <��� ������ (����������)>
    , GoodsKindCompleteName  TVarChar --������������ ������� <��� ������(����������)>
    , AmountOutWeight        TFloat -- ����� ������, ��
    , AmountOutWeight_det    TFloat -- ����� ������, ��
    , AmountRealWeight       TFloat -- ����� ������ � ����������� ������, ��
    , AmountRealWeight_det   TFloat -- ����� ������ � ����������� ������, ��
    )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


    -- ���������
    RETURN QUERY
       WITH 
        tmpMovement AS (SELECT Movement.*
                        FROM Movement
                        WHERE Movement.DescId = zc_Movement_Promo()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate --'01.01.2025' AND '01.06.2025'
--AND Movement.Id = 30156300
                         )

      , tmpMI_Master AS (SELECT MovementItem.*
                         FROM MovementItem
                         WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                            AND MovementItem.DescId = zc_MI_Master()
                            AND MovementItem.isErased = FALSE
                         )


      , tmpMI_Detail AS (SELECT MovementItem.*
                         FROM MovementItem
                         WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                            AND MovementItem.DescId = zc_MI_Detail()
                            AND MovementItem.isErased = FALSE
                         )

      , tmpMIFloat_Master AS (SELECT MovementItemFloat.*
                              FROM MovementItemFloat
                              WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                AND MovementItemFloat.DescId IN (zc_MIFloat_AmountReal()
                                                               , zc_MIFloat_AmountOut()
                                                                 )
                              )
                                               
      , tmpMIFloat_Detail AS (SELECT MovementItemFloat.*
                              FROM MovementItemFloat
                              WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Detail.Id FROM tmpMI_Detail)
                                AND MovementItemFloat.DescId IN (zc_MIFloat_AmountReal()
                                                               )
                              )
                  
      , tmpDetail AS (SELECT MovementItem.MovementId
                           , CASE WHEN inisGoods = TRUE THEN MovementItem.ParentId ELSE 0 END AS ParentId
                           , SUM (COALESCE (MovementItem.Amount,0))          AS AmountOut
                           , SUM (COALESCE (MIFloat_AmountReal.ValueData,0)) AS AmountReal
                      FROM tmpMI_Detail AS MovementItem
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountReal
                                                       ON MIFloat_AmountReal.MovementItemId = MovementItem.Id 
                                                      AND MIFloat_AmountReal.DescId = zc_MIFloat_AmountReal()
                      GROUP BY MovementItem.MovementId
                             , CASE WHEN inisGoods = TRUE THEN MovementItem.ParentId ELSE 0 END
                      )
       , tmpMaster AS (SELECT MovementItem.MovementId
                            , CASE WHEN inisGoods = TRUE THEN MovementItem.Id ELSE 0 END       AS MovementItemId
                            , CASE WHEN inisGoods = TRUE THEN MovementItem.ObjectId ELSE 0 END AS GoodsId
                            , SUM (COALESCE (MIFloat_AmountOut.ValueData,0))  AS AmountOut
                            , SUM (COALESCE (MIFloat_AmountReal.ValueData,0)) AS AmountReal
                       FROM tmpMI_Master AS MovementItem
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountReal
                                                        ON MIFloat_AmountReal.MovementItemId = MovementItem.Id 
                                                       AND MIFloat_AmountReal.DescId = zc_MIFloat_AmountReal()
                            LEFT JOIN tmpMIFloat_Master AS MIFloat_AmountOut
                                                        ON MIFloat_AmountOut.MovementItemId = MovementItem.Id 
                                                       AND MIFloat_AmountOut.DescId = zc_MIFloat_AmountOut()
                       WHERE (COALESCE (MIFloat_AmountOut.ValueData,0)) <> 0
                          OR (COALESCE (MIFloat_AmountReal.ValueData,0)) <> 0
                       GROUP BY MovementItem.MovementId
                              , CASE WHEN inisGoods = TRUE THEN MovementItem.Id ELSE 0 END
                              , CASE WHEN inisGoods = TRUE THEN MovementItem.ObjectId ELSE 0 END
                       )           
      , tmpDiff AS (SELECT tmpMaster.MovementId
                         , tmpMaster.MovementItemId
                         , tmpMaster.GoodsId
                         , CASE WHEN SUM (COALESCE (tmpMaster.AmountReal,0)) <> SUM (COALESCE (tmpDetail.AmountReal,0)) THEN TRUE ELSE FALSE END AS isReal
                         , CASE WHEN SUM (COALESCE (tmpMaster.AmountOut,0)) <> SUM (COALESCE (tmpDetail.AmountOut,0)) THEN TRUE ELSE FALSE END   AS isOut 
                         , SUM (COALESCE (tmpMaster.AmountReal,0)) AS AmountReal 
                         , SUM (COALESCE (tmpDetail.AmountReal,0)) AS AmountReal_det
                         , SUM (COALESCE (tmpMaster.AmountOut,0))  AS AmountOut
                         , SUM (COALESCE (tmpDetail.AmountOut,0))  AS AmountOut_det
                    FROM tmpMaster
                        LEFT JOIN tmpDetail ON tmpDetail.MovementId = tmpMaster.MovementId
                                           AND tmpDetail.ParentId = tmpMaster.MovementItemId 
                    GROUP BY tmpMaster.MovementId
                           , tmpMaster.MovementItemId
                           , tmpMaster.GoodsId
                    HAVING SUM (COALESCE (tmpMaster.AmountReal,0)) <> SUM (COALESCE (tmpDetail.AmountReal,0))
                        OR SUM (COALESCE (tmpMaster.AmountOut,0)) <> SUM (COALESCE (tmpDetail.AmountOut,0))                      
                    )

      , tmpMILO AS (SELECT MovementItemLinkObject.*
                    FROM MovementItemLinkObject
                    WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpDiff.MovementItemId FROM tmpDiff)
                      AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind()
                                                          , zc_MILinkObject_GoodsKindComplete()
                                                           ) 
                      AND inisGoods = TRUE
                   )

      SELECT tmpMovement.Id        ::Integer
           , tmpMovement.OperDate  ::TDateTime
           , tmpMovement.InvNumber ::Integer
           , tmpDiff.isOut         ::Boolean
           , tmpDiff.isReal        ::Boolean
           , CASE WHEN Movement_Promo.StartSale <= Movement_Promo.OperDateStart THEN TRUE ELSE FALSE END ::Boolean AS isOperDate 

             , Object_Goods.Id                        AS GoodsId             --�� ������� <�����>
             , Object_Goods.ObjectCode::Integer       AS GoodsCode           --��� �������  <�����>
             , Object_Goods.ValueData                 AS GoodsName           --������������ ������� <�����>
             , Object_Measure.ValueData               AS Measure             --������� ���������
             , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END::TFloat as GoodsWeight -- ���  
             
             --������������� �� �������
             , MILinkObject_GoodsKind.ObjectId        AS GoodsKindId                 --�� ������� <��� ������>
             , Object_GoodsKind.ValueData             AS GoodsKindName               --������������ ������� <��� ������>
             , Object_GoodsKindComplete.Id            AS GoodsKindCompleteId         --�� ��� ������(����������)
             , Object_GoodsKindComplete.ValueData     AS GoodsKindCompleteName       --������������ ������� <��� ������(����������)>

             , (tmpDiff.AmountOut      * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END)  ::TFloat AS AmountOutWeight     
             , (tmpDiff.AmountOut_det  * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END)  ::TFloat AS AmountOutWeight_det 
             , (tmpDiff.AmountReal     * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END)  ::TFloat AS AmountRealWeight    
             , (tmpDiff.AmountReal_det * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END)  ::TFloat AS AmountRealWeight_det

      FROM tmpMovement
           INNER JOIN tmpDiff ON tmpDiff.MovementId = tmpMovement.Id
           LEFT JOIN Movement_Promo_View AS Movement_Promo ON Movement_Promo.Id = tmpMovement.Id

           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpDiff.GoodsId
                                           
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                ON ObjectLink_Goods_Measure.ObjectId = tmpDiff.GoodsId
                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

           LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                       ON ObjectFloat_Goods_Weight.ObjectId = tmpDiff.GoodsId
                                      AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()

           LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                             ON MILinkObject_GoodsKind.MovementItemId = tmpDiff.MovementItemId
                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

           LEFT JOIN tmpMILO AS MILinkObject_GoodsKindComplete
                             ON MILinkObject_GoodsKindComplete.MovementItemId = tmpDiff.MovementItemId
                            AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
           LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILinkObject_GoodsKindComplete.ObjectId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.02.25         *
*/

-- ����
-- SELECT * FROM gpReport_Promo_DetailError (inStartDate:= ('01.04.2024')::TDateTime , inEndDate:= ('01.04.2024')::TDateTime , inisGoods := true, inSession := '5'::TVarchar) 