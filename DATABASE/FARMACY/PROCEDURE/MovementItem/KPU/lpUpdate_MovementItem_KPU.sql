-- Function: lpUpdate_MovementItem_KPU (Integer)

DROP FUNCTION IF EXISTS lpUpdate_MovementItem_KPU (Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MovementItem_KPU(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
   DECLARE vbKPU                   TFloat;
   DECLARE vbUserId                Integer;
   DECLARE vbUnitId                Integer;
   DECLARE vbDateStart             TDateTime;
   DECLARE vbEndDate               TDateTime;
BEGIN
  IF COALESCE (inMovementId, 0) = 0
  THEN
    RAISE EXCEPTION '������.������� ��������� �� ��������.';
  END IF;

  vbKPU := 30;

  SELECT
    Movement.OperDate,
    MovementItem.ObjectId,
    MILinkObject_Unit.ObjectId
  INTO
    vbDateStart,
    vbUserId,
    vbUnitId
  FROM MovementItem
       INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
       LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                        ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                       AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
  WHERE MovementItem.ID = inMovementId;

  vbEndDate := date_trunc('month', vbDateStart) + Interval '1 MONTH';

  WITH tmpPlanAmount AS (SELECT
                                 Object_ReportSoldParams.UnitId                 AS UnitId,
                                 Object_ReportSoldParams.PlanAmount             AS PlanAmount
                          FROM
                               Object_ReportSoldParams_View AS Object_ReportSoldParams
                          WHERE Object_ReportSoldParams.PlanDate >= vbDateStart
                            AND Object_ReportSoldParams.PlanDate < vbEndDate
                            AND Object_ReportSoldParams.UnitId = vbUnitId),

        tmpFactAmount AS (SELECT
                                 MovementCheck.UnitId                           AS UnitID,
                                 SUM(TotalSumm)                                 AS FactAmount
                          FROM
                               Movement_Check_View AS MovementCheck
                          WHERE MovementCheck.OperDate >= vbDateStart
                            AND MovementCheck.OperDate < vbEndDate
                            AND MovementCheck.StatusId = zc_Enum_Status_Complete()
                            AND MovementCheck.UnitId = vbUnitId
                          GROUP BY  MovementCheck.UnitID)

  SELECT
    vbKPU
        + COALESCE (MIFloat_MarkRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_AmountTheFineTab.ValueData, 0) = 0 AND COALESCE (MIFloat_BonusAmountTab.ValueData, 0) = 0  THEN 0
            ELSE
              CASE WHEN upper(substring(Object_UnitCategory.ValueData, 1, 2)) = '��'
              THEN
                CASE WHEN MIFloat_TotalExecutionLine.ValueData >= 80 THEN 2
                ELSE
                  CASE WHEN MIFloat_TotalExecutionLine.ValueData >= 50 AND
                            COALESCE (MIFloat_AmountTheFineTab.ValueData, 0) <= COALESCE (MIFloat_BonusAmountTab.ValueData, 0) THEN 1
                  ELSE
                    CASE WHEN MIFloat_TotalExecutionLine.ValueData < 50 AND
                              COALESCE (MIFloat_AmountTheFineTab.ValueData, 0) <= COALESCE (MIFloat_BonusAmountTab.ValueData, 0) THEN 0
                    ELSE
                      -1
                    END
                  END
                END
              ELSE
                CASE WHEN MIFloat_TotalExecutionLine.ValueData >= 90 THEN 2
                ELSE
                  CASE WHEN MIFloat_TotalExecutionLine.ValueData >= 60 AND
                            COALESCE (MIFloat_AmountTheFineTab.ValueData, 0) <= COALESCE (MIFloat_BonusAmountTab.ValueData, 0) THEN 1
                  ELSE
                    CASE WHEN MIFloat_TotalExecutionLine.ValueData < 60 AND
                              COALESCE (MIFloat_AmountTheFineTab.ValueData, 0) <= COALESCE (MIFloat_BonusAmountTab.ValueData, 0) THEN 0
                    ELSE
                      -1
                    END
                  END
                END
              END
            END)
        + COALESCE (MIFloat_AverageCheckRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_PrevAverageCheck.ValueData, 0) = 0
            THEN 0 ELSE ROUND((COALESCE (MIFloat_AverageCheck.ValueData, 0) / COALESCE (MIFloat_PrevAverageCheck.ValueData, 0) - 1) * 100, 1)
            END)
        + COALESCE (MIFloat_NumberChecksRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_PrevNumberChecks.ValueData, 0) = 0
            THEN 0 ELSE ROUND((COALESCE (MIFloat_NumberChecks.ValueData, 0) / COALESCE (MIFloat_PrevNumberChecks.ValueData, 0) - 1) * 100, 1)
            END)
        + COALESCE (MIFloat_LateTimeRatio.ValueData, MIFloat_LateTimePenalty.ValueData, 0)
        + COALESCE (MIFloat_FinancPlanRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_FinancPlan.ValueData, 0) = 0 or COALESCE (MIFloat_FinancPlanFact.ValueData, 0) = 0
            THEN 0 ELSE CASE WHEN MIFloat_FinancPlan.ValueData <= MIFloat_FinancPlanFact.ValueData THEN 1 ELSE -1 END
            END)
        + COALESCE (MIFloat_IT_ExamRatio.ValueData, 0)
        + COALESCE (MIFloat_ComplaintsRatio.ValueData, 0)
        + COALESCE (MIFloat_DirectorRatio.ValueData, 0)
        + COALESCE (MIFloat_CollegeITRatio.ValueData, 0)
        + COALESCE (MIFloat_VIPDepartRatio.ValueData, 0)
        + COALESCE (MIFloat_ControlRGRatio.ValueData, 0)

  INTO
    vbKPU
  FROM MovementItem

       LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                        ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                       AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

       LEFT JOIN ObjectLink AS ObjectLink_Unit_Category
                            ON ObjectLink_Unit_Category.ObjectId = Object_Unit.Id
                           AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()
       LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = ObjectLink_Unit_Category.ChildObjectId

       LEFT JOIN MovementItemFloat AS MIFloat_TotalExecutionLine
                                   ON MIFloat_TotalExecutionLine.MovementItemId = MovementItem.Id
                                  AND MIFloat_TotalExecutionLine.DescId = zc_MIFloat_TotalExecutionLine()

       LEFT JOIN MovementItemFloat AS MIFloat_AmountTheFineTab
                                   ON MIFloat_AmountTheFineTab.MovementItemId = MovementItem.Id
                                  AND MIFloat_AmountTheFineTab.DescId = zc_MIFloat_AmountTheFineTab()

       LEFT JOIN MovementItemFloat AS MIFloat_BonusAmountTab
                                   ON MIFloat_BonusAmountTab.MovementItemId = MovementItem.Id
                                  AND MIFloat_BonusAmountTab.DescId = zc_MIFloat_BonusAmountTab()

       LEFT JOIN MovementItemFloat AS MIFloat_MarkRatio
                                   ON MIFloat_MarkRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_MarkRatio.DescId = zc_MIFloat_MarkRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_PrevAverageCheck
                                   ON MIFloat_PrevAverageCheck.MovementItemId = MovementItem.Id
                                  AND MIFloat_PrevAverageCheck.DescId = zc_MIFloat_PrevAverageCheck()

       LEFT JOIN MovementItemFloat AS MIFloat_AverageCheck
                                   ON MIFloat_AverageCheck.MovementItemId = MovementItem.Id
                                  AND MIFloat_AverageCheck.DescId = zc_MIFloat_AverageCheck()

       LEFT JOIN MovementItemFloat AS MIFloat_AverageCheckRatio
                                   ON MIFloat_AverageCheckRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_AverageCheckRatio.DescId = zc_MIFloat_AverageCheckRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_PrevNumberChecks
                                   ON MIFloat_PrevNumberChecks.MovementItemId = MovementItem.Id
                                  AND MIFloat_PrevNumberChecks.DescId = zc_MIFloat_PrevNumberChecks()

       LEFT JOIN MovementItemFloat AS MIFloat_NumberChecks
                                   ON MIFloat_NumberChecks.MovementItemId = MovementItem.Id
                                  AND MIFloat_NumberChecks.DescId = zc_MIFloat_NumberChecks()

       LEFT JOIN MovementItemFloat AS MIFloat_NumberChecksRatio
                                   ON MIFloat_NumberChecksRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_NumberChecksRatio.DescId = zc_MIFloat_NumberChecksRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_LateTimePenalty
                                   ON MIFloat_LateTimePenalty.MovementItemId = MovementItem.Id
                                  AND MIFloat_LateTimePenalty.DescId = zc_MIFloat_LateTimePenalty()


       LEFT JOIN MovementItemFloat AS MIFloat_LateTimeRatio
                                   ON MIFloat_LateTimeRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_LateTimeRatio.DescId = zc_MIFloat_LateTimeRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_FinancPlan
                                   ON MIFloat_FinancPlan.MovementItemId = MovementItem.Id
                                  AND MIFloat_FinancPlan.DescId = zc_MIFloat_FinancPlan()

       LEFT JOIN MovementItemFloat AS MIFloat_FinancPlanFact
                                   ON MIFloat_FinancPlanFact.MovementItemId = MovementItem.Id
                                  AND MIFloat_FinancPlanFact.DescId = zc_MIFloat_FinancPlanFact()

       LEFT JOIN MovementItemFloat AS MIFloat_FinancPlanRatio
                                   ON MIFloat_FinancPlanRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_FinancPlanRatio.DescId = zc_MIFloat_FinancPlanRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_IT_ExamRatio
                                   ON MIFloat_IT_ExamRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_IT_ExamRatio.DescId = zc_MIFloat_IT_ExamRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_ComplaintsRatio
                                   ON MIFloat_ComplaintsRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_ComplaintsRatio.DescId = zc_MIFloat_ComplaintsRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_DirectorRatio
                                   ON MIFloat_DirectorRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_DirectorRatio.DescId = zc_MIFloat_DirectorRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_CollegeITRatio
                                   ON MIFloat_CollegeITRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_CollegeITRatio.DescId = zc_MIFloat_CollegeITRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_VIPDepartRatio
                                   ON MIFloat_VIPDepartRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_VIPDepartRatio.DescId = zc_MIFloat_VIPDepartRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_ControlRGRatio
                                   ON MIFloat_ControlRGRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_ControlRGRatio.DescId = zc_MIFloat_ControlRGRatio()

  WHERE MovementItem.Id = inMovementId
    AND MovementItem.isErased = false;

    -- ��������� �������� <KPU>
  UPDATE MovementItem SET Amount = vbKPU WHERE ID = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpUpdate_MovementItem_KPU (Integer) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������ �.�.
 26.11.18         *
 12.11.18         *
 05.11.18         *
 05.10.18         *
*/
