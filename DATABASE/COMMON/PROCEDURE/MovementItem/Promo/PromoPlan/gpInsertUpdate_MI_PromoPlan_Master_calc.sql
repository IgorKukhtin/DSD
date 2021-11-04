-- Function: gpInsertUpdate_MI_PromoPlan_Master_calc()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PromoPlan_Master_calc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PromoPlan_Master_calc(
    IN inMovementId            Integer   , -- ���� ������� <�����>
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE vbUnitId Integer;
   DECLARE vbMovementId_plan Integer;

   DECLARE vbStartSale TDateTime;
   DECLARE vbEndSale   TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo());

     -- ���� ������ �����
    SELECT Movement.OperDate
         , MovementDate_StartSale.ValueData AS StartSale
         , MovementDate_EndSale.ValueData   AS EndSale
   INTO vbOperDate, vbStartSale, vbEndSale
      FROM Movement
           LEFT JOIN MovementDate AS MovementDate_StartSale
                                  ON MovementDate_StartSale.MovementId = Movement.Id
                                 AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
           LEFT JOIN MovementDate AS MovementDate_EndSale
                                  ON MovementDate_EndSale.MovementId = Movement.Id
                                 AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
      WHERE Movement.Id = inMovementId;
     
    --������� ��� ����, ���� ��� �������
    vbMovementId_plan := (SELECT Movement.Id FROM Movement WHERE Movement.ParentId = inMovementId AND Movement.DescId = zc_Movement_PromoPlan()); 
    IF COALESCE (vbMovementId_plan,0) = 0
    THEN
        --
        vbMovementId_plan := lpInsertUpdate_Movement (0, zc_Movement_PromoPlan(), '', vbOperDate, inMovementId, 0);
    END IF;

    -- ��������� �������� <������>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId_plan, TRUE);


    --������� ������ ����, ������������ �� ��������� ����������
    CREATE TEMP TABLE _tmpData (OperDate TDateTime, GoodsId Integer, GoodsKindId Integer, Amount_calc TFloat, isDnepr Boolean) ON COMMIT DROP;

    INSERT INTO _tmpData (OperDate, GoodsId, GoodsKindId, Amount_calc, isDnepr)
       WITH
       tmpMI_Promo AS (SELECT MovementItem.ObjectId AS GoodsId
                            --, MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                            , SUM (COALESCE (MIFloat_AmountPlanMax.ValueData,0)) AS AmountPlanMax
                       FROM MovementItem
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                                        ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId = zc_MI_Master()
                         AND MovementItem.isErased = FALSE
                       GROUP BY MovementItem.ObjectId
                              --, MILinkObject_GoodsKind.ObjectId
                       )

     , tmpMI AS (SELECT MovementItem.*
                      , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                      , ROW_NUMBER() OVER(PARTITION BY MovementItem.ObjectId, MILinkObject_GoodsKind.ObjectId ORDER BY MovementItem.Id) AS Ord
                 FROM Movement
                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId = zc_MI_Master()
                                            AND MovementItem.isErased = FALSE
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind 
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 WHERE Movement.DescId = zc_Movement_PromoStat()
                   AND Movement.ParentId = inMovementId
                 )
     , tmpMIFloat AS (SELECT MovementItemFloat.*
                      FROM MovementItemFloat
                      WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                        AND MovementItemFloat.DescId IN (zc_MIFloat_Plan1(), zc_MIFloat_Plan2(), zc_MIFloat_Plan3(), zc_MIFloat_Plan4(), zc_MIFloat_Plan5(), zc_MIFloat_Plan6(), zc_MIFloat_Plan7()
                                                       , zc_MIFloat_PlanBranch1(), zc_MIFloat_PlanBranch2(), zc_MIFloat_PlanBranch3(), zc_MIFloat_PlanBranch4(), zc_MIFloat_PlanBranch5(), zc_MIFloat_PlanBranch6(), zc_MIFloat_PlanBranch7())
                     )
     -- �������� ������ ���� � ������� ������� �������� �� 1 ����, ���� ��������� �� 5 ������, ������� /5
     , tmpMIFloat_avg AS (SELECT tmpMI.ObjectId AS GoodsId
                               , tmpMI.GoodsKindId
                               , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan1(), zc_MIFloat_PlanBranch1()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan1
                               , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan2(), zc_MIFloat_PlanBranch2()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan2
                               , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan3(), zc_MIFloat_PlanBranch3()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan3
                               , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan4(), zc_MIFloat_PlanBranch4()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan4
                               , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan5(), zc_MIFloat_PlanBranch5()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan5
                               , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan6(), zc_MIFloat_PlanBranch6()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan6
                               , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan7(), zc_MIFloat_PlanBranch7()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan7
                               , SUM (COALESCE (tmpMIFloat.ValueData,0)) AS TotalPlan
                               , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan1(), zc_MIFloat_Plan2(), zc_MIFloat_Plan3(), zc_MIFloat_Plan4(), zc_MIFloat_Plan5(), zc_MIFloat_Plan6(), zc_MIFloat_Plan7()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END) AS Plan_dn
                               , SUM (CASE WHEN tmpMIFloat.DescId NOT IN (zc_MIFloat_Plan1(), zc_MIFloat_Plan2(), zc_MIFloat_Plan3(), zc_MIFloat_Plan4(), zc_MIFloat_Plan5(), zc_MIFloat_Plan6(), zc_MIFloat_Plan7()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END) AS Plan_f
                          FROM tmpMIFloat
                               LEFT JOIN tmpMI ON tmpMI.Id = tmpMIFloat.MovementItemId
                          GROUP BY tmpMI.ObjectId
                                 , tmpMI.GoodsKindId
                          )
     --���� ������
     , tmpListDateSale AS (SELECT generate_series(vbStartSale::TDateTime, vbEndSale::TDateTime, '1 DAY'::interval) AS OperDate)
     
     -- ������� ���� �� ���� ������ �����
     , tmpCalc AS (SELECT tmpListDateSale.OperDate
                        , tmpGoods.GoodsId
                        , tmpGoods.GoodsKindId
                        , (CASE WHEN tmpWeekDay.Number = 1 THEN COALESCE (tmpMIFloat_avg.Plan1,0)
                                WHEN tmpWeekDay.Number = 2 THEN COALESCE (tmpMIFloat_avg.Plan2,0)
                                WHEN tmpWeekDay.Number = 3 THEN COALESCE (tmpMIFloat_avg.Plan3,0)
                                WHEN tmpWeekDay.Number = 4 THEN COALESCE (tmpMIFloat_avg.Plan4,0)
                                WHEN tmpWeekDay.Number = 5 THEN COALESCE (tmpMIFloat_avg.Plan5,0)
                                WHEN tmpWeekDay.Number = 6 THEN COALESCE (tmpMIFloat_avg.Plan6,0)
                                WHEN tmpWeekDay.Number = 7 THEN COALESCE (tmpMIFloat_avg.Plan7,0)
                           ELSE 0 END) Amount
                        --, (SELECT tmp.TotalPlan FROM tmpMIFloat_avg AS tmp) AS TotalPlan
                        , SUM (CASE WHEN tmpWeekDay.Number = 1 THEN COALESCE (tmpMIFloat_avg.Plan1,0) ELSE 0 END
                             + CASE WHEN tmpWeekDay.Number = 2 THEN COALESCE (tmpMIFloat_avg.Plan2,0) ELSE 0 END
                             + CASE WHEN tmpWeekDay.Number = 3 THEN COALESCE (tmpMIFloat_avg.Plan3,0) ELSE 0 END
                             + CASE WHEN tmpWeekDay.Number = 4 THEN COALESCE (tmpMIFloat_avg.Plan4,0) ELSE 0 END
                             + CASE WHEN tmpWeekDay.Number = 5 THEN COALESCE (tmpMIFloat_avg.Plan5,0) ELSE 0 END
                             + CASE WHEN tmpWeekDay.Number = 6 THEN COALESCE (tmpMIFloat_avg.Plan6,0) ELSE 0 END
                             + CASE WHEN tmpWeekDay.Number = 7 THEN COALESCE (tmpMIFloat_avg.Plan7,0) ELSE 0 END) OVER (PARTITION BY tmpGoods.GoodsId, tmpGoods.GoodsKindId) AS TotalPlan

                        , CASE WHEN COALESCE (tmpMIFloat_avg.Plan_dn,0) <> 0 THEN TRUE ELSE FALSE END AS isDnepr
                   FROM tmpListDateSale
                    LEFT JOIN zfCalc_DayOfWeekName (tmpListDateSale.OperDate) AS tmpWeekDay ON 1=1
                    LEFT JOIN (SELECT tmpMI.ObjectId AS GoodsId, tmpMI.GoodsKindId FROM tmpMI WHERE tmpMI.Ord = 1) AS tmpGoods ON  1=1
                    LEFT JOIN tmpMIFloat_avg ON tmpMIFloat_avg.GoodsId = tmpGoods.GoodsId
                                            AND tmpMIFloat_avg.GoodsKindId = tmpGoods.GoodsKindId
                   )

       SELECT tmpCalc.OperDate
            , tmpCalc.GoodsId
            , tmpCalc.GoodsKindId
            , CAST (CASE WHEN COALESCE (tmpCalc.TotalPlan,0) <> 0 THEN tmpCalc.Amount * tmpMI_Promo.AmountPlanMax / tmpCalc.TotalPlan ELSE 0 END AS NUMERIC (16,3)) AS Amount_calc
            , tmpCalc.isDnepr
       FROM tmpMI_Promo
           LEFT JOIN tmpCalc ON tmpCalc.GoodsId = tmpMI_Promo.GoodsId
                            --AND tmpCalc.GoodsKindId = tmpMI_Promo.GoodsKindId
       WHERE CASE WHEN COALESCE (tmpCalc.TotalPlan,0) <> 0 THEN tmpCalc.Amount * tmpMI_Promo.AmountPlanMax / tmpCalc.TotalPlan ELSE 0 END <> 0
       ;


------------------------------------------------------------------
       -- ����� ������� ����������� ������ ����� �����������
       UPDATE MovementItem
       SET isErased = TRUE
       WHERE MovementItem.MovementId = vbMovementId_plan
         AND MovementItem.DescId = zc_MI_Master()
         AND MovementItem.IsErased = FALSE;

       --
       PERFORM lpInsertUpdate_MovementItem_PromoPlan_Master(ioId          := 0                    ::Integer   -- ���� ������� <������� ���������>
                                                          , inMovementId  := vbMovementId_plan    ::Integer   -- ���� ������� <��������>
                                                          , inGoodsId     := _tmpData.GoodsId     ::Integer   -- ������
                                                          , inGoodsKindId := _tmpData.GoodsKindId ::Integer   --�� ������� <��� ������>
                                                          , inOperDate    := _tmpData.OperDate    ::TDateTime --
                                                          , inAmount       := CASE WHEN _tmpData.isDnepr = TRUE  THEN _tmpData.Amount_calc ELSE 0 END ::TFloat    --   zc_Branch_Basis()
                                                          , inAmountPartner:= CASE WHEN _tmpData.isDnepr = FALSE THEN _tmpData.Amount_calc ELSE 0 END ::TFloat    -- 
                                                          , inUserId      := vbUserId             ::Integer)
       FROM _tmpData;  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.11.21         *
*/

-- ����
--