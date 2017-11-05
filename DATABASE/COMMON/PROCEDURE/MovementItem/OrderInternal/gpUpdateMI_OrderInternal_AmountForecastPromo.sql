-- Function: gpUpdateMI_OrderInternal_AmountForecastPromo()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountForecastPromo (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountForecastPromo(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStartDate           TDateTime , -- ���� ���������
    IN inEndDate             TDateTime , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsPack  Boolean;
   DECLARE vbIsBasis Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());


     -- ������� -
     CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountForecastOrder TFloat, AmountForecastOrderPromo TFloat, AmountForecast TFloat, AmountForecastPromo TFloat) ON COMMIT DROP;
                                 WITH -- ��������� - ������ ���� + ����������
                                      tmpUnit AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect_Object_Unit_byGroup)
                                      -- ��������� - ������ ��
                                    , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                                                   FROM Object_InfoMoney_View
                                                        INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                              ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                             AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                                                   WHERE Object_InfoMoney_View.InfoMoneyId IN (zc_Enum_InfoMoney_20901() -- ����
                                                                                             , zc_Enum_InfoMoney_30101() -- ������� ���������
                                                                                             , zc_Enum_InfoMoney_30201() -- ������ �����
                                                                                              )
                                                  )
                                    , tmpMIAll AS
                                      (-- 1.1 ������
                                       SELECT MovementItem.ObjectId                                                    AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())         AS GoodsKindId
                                            , SUM (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountOrder
                                            , SUM (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountOrderPromo
                                            , 0                                                                        AS AmountSale
                                            , 0                                                                        AS AmountSalePromo
                                       FROM Movement 
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId
                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                            LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                                                        ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_PromoMovementId.DescId         = zc_MIFloat_PromoMovementId()
                                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                         AND Movement.DescId = zc_Movement_OrderExternal()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                       GROUP BY MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                       HAVING SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) <> 0
                                      UNION ALL
                                       -- 1.2. �������
                                       SELECT MovementItem.ObjectId                               AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                                            , 0                                                   AS AmountOrder
                                            , 0                                                   AS AmountOrderPromo
                                            , SUM (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountSale
                                            , SUM (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountSalePromo
                                       -- FROM MovementDate AS MovementDate_OperDatePartner
                                       FROM Movement
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                          ON MovementLinkObject_From.MovementId = Movement.Id -- MovementDate_OperDatePartner.MovementId
                                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_From.ObjectId
                                            /*INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                                               AND Movement.DescId = zc_Movement_Sale()
                                                               AND Movement.StatusId = zc_Enum_Status_Complete()*/
                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                            LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                                                        ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_PromoMovementId.DescId         = zc_MIFloat_PromoMovementId()
                                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                         AND Movement.DescId   = zc_Movement_Sale()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                       -- WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                                       --   AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                                       GROUP BY MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                       HAVING SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) <> 0   

                                      UNION ALL
                                       -- 1.3 ����������� �� ������
                                       SELECT MovementItem.ObjectId                               AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                                            , 0                                                   AS AmountOrder
                                            , 0                                                   AS AmountOrderPromo
                                            , SUM (COALESCE (MovementItem.Amount, 0))             AS AmountSale
                                            , 0                                                   AS AmountSalePromo
                                       FROM Movement
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_From.ObjectId

                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                         AND Movement.DescId = zc_Movement_SendOnPrice()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                       GROUP BY MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                       HAVING SUM (COALESCE (MovementItem.Amount, 0)) <> 0   
                                      )
                                    , tmpMI AS
                                      (SELECT MovementItem.Id                               AS MovementItemId 
                                            , MovementItem.ObjectId                         AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                       FROM MovementItem 
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                       WHERE MovementItem.MovementId = inMovementId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE
                                      )
                               INSERT INTO tmpAll (MovementItemId, GoodsId, GoodsKindId, AmountForecastOrder, AmountForecastOrderPromo, AmountForecast, AmountForecastPromo)
                                 SELECT tmpMI.MovementItemId
                                       , COALESCE (tmpMI.GoodsId,tmpAll.GoodsId)          AS GoodsId
                                       , COALESCE (tmpMI.GoodsKindId, tmpAll.GoodsKindId) AS GoodsKindId
                                       , COALESCE (tmpAll.AmountOrder, 0)                 AS AmountForecastOrder
                                       , COALESCE (tmpAll.AmountOrderPromo, 0)            AS AmountForecastOrderPromo
                                       , COALESCE (tmpAll.AmountSale, 0)                  AS AmountForecast
                                       , COALESCE (tmpAll.AmountSalePromo, 0)             AS AmountForecastPromo
                                 FROM (SELECT tmpMIAll.GoodsId
                                            , tmpMIAll.GoodsKindId
                                            , SUM (tmpMIAll.AmountOrder)      AS AmountOrder
                                            , SUM (tmpMIAll.AmountOrderPromo) AS AmountOrderPromo
                                            , SUM (tmpMIAll.AmountSale)       AS AmountSale
                                            , SUM (tmpMIAll.AmountSalePromo)  AS AmountSalePromo
                                       FROM tmpMIAll
                                       GROUP BY tmpMIAll.GoodsId
                                              , tmpMIAll.GoodsKindId
                                       ) AS tmpAll
                                 FULL JOIN tmpMI ON tmpMI.GoodsId     = tmpAll.GoodsId
                                                AND tmpMI.GoodsKindId = tmpAll.GoodsKindId
                     ;

       -- ���������
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                 := tmpAll.MovementItemId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := tmpAll.GoodsId
                                                 , inGoodsKindId        := tmpAll.GoodsKindId
                                                 , inAmount_Param       := tmpAll.AmountForecast * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param       := zc_MIFloat_AmountForecast()
                                                 , inAmount_ParamOrder  := tmpAll.AmountForecastPromo * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamOrder  := zc_MIFloat_AmountForecastPromo()
                                                 , inAmount_ParamSecond := tmpAll.AmountForecastOrder * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamSecond := zc_MIFloat_AmountForecastOrder()
                                                 , inAmount_ParamAdd    := tmpAll.AmountForecastOrderPromo * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamAdd    := zc_MIFloat_AmountForecastOrderPromo()
                                                 , inIsPack             := NULL
                                                 , inUserId             := vbUserId
                                                  ) 
       FROM tmpAll
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpAll.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpAll.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.06.15                                        * ������, �������� �����������
 19.06.15                                        * all
 03.03.15         *
*/

-- ����
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountForecastPromo (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
