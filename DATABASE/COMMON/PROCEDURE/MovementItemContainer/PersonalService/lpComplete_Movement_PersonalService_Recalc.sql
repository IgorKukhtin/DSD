-- Function: lpComplete_Movement_PersonalService_Recalc (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalService_Recalc (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PersonalService_Recalc(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
BEGIN

     -- ������� - �� ����������
     CREATE TEMP TABLE _tmpMovement_Recalc (MovementId Integer) ON COMMIT DROP;
     -- ������� - �� ���������
     CREATE TEMP TABLE _tmpMI_Recalc (MovementItemId Integer, SummCardRecalc TFloat, MovementItemId_find Integer) ON COMMIT DROP;

     -- 
     WITH tmpMovement AS (SELECT Movement.Id AS MovementId
                               , MovementDate_ServiceDate.ValueData AS ServiceDate
                               , Movement.OperDate AS StartDate
                               , Movement.OperDate AS EndDate
                          FROM Movement
                               LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                                      ON MovementDate_ServiceDate.MovementId = Movement.Id
                                                     AND MovementDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                          WHERE Movement.Id = inMovementId
                            AND Movement.DescId = zc_Movement_PersonalService()
                            AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                          )
        , tmpMovement_Recalc AS (SELECT Movement.Id AS MovementId
                                 FROM tmpMovement
                                      INNER JOIN MovementDate AS MovementDate_ServiceDate
                                                              ON MovementDate_ServiceDate.ValueData = tmpMovement.ServiceDate
                                                             AND MovementDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                                             AND MovementDate_ServiceDate.MovementId <> tmpMovement.MovementId
                                      INNER JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
                                                         AND Movement.OperDate BETWEEN tmpMovement.StartDate AND tmpMovement.EndDate
	                                                         AND Movement.DescId = zc_Movement_PersonalService()
                                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                )
     -- ������ �� ����������
     INSERT INTO _tmpMovement_Recalc (MovementId)
       SELECT MovementId FROM tmpMovement_Recalc;

     --
     WITH tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                         , COALESCE (MovementItem.ObjectId, 0)           AS ObjectId
                         , COALESCE (MILinkObject_Unit.ObjectId, 0)      AS UnitId
                         , COALESCE (MILinkObject_Position.ObjectId, 0)  AS PositionId
                         , COALESCE (MILinkObject_InfoMoney.ObjectId, 0) AS InfoMoneyId
                         , (MIFloat_SummCardRecalc.ValueData)            AS SummCardRecalc
                    FROM MovementItem
                         INNER JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                                      ON MIFloat_SummCardRecalc.MovementItemId = MovementItem.Id
                                                     AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc()
                                                     AND MIFloat_SummCardRecalc.ValueData <> 0
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                      ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                      ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                      ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                    WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
                   )
        , tmpMovement_Recalc AS (SELECT MovementId FROM _tmpMovement_Recalc WHERE EXISTS (SELECT SummCardRecalc FROM tmpMI))
            , tmpMI_find AS (SELECT MovementItem.Id AS MovementItemId
                                  , COALESCE (MovementItem.ObjectId, 0)           AS ObjectId
                                  , COALESCE (MILinkObject_Unit.ObjectId, 0)      AS UnitId
                                  , COALESCE (MILinkObject_Position.ObjectId, 0)  AS PositionId
                                  , COALESCE (MILinkObject_InfoMoney.ObjectId, 0) AS InfoMoneyId
                                  , COALESCE (MIFloat_SummService.ValueData, 0)
                                  - COALESCE (MIFloat_SummMinus.ValueData, 0)
                                  + COALESCE (MIFloat_SummAdd.ValueData, 0)
                                  + COALESCE (MIFloat_SummSocialAdd.ValueData, 0) AS SummToPay
                                  , COALESCE (MIFloat_SummChild.ValueData, 0)     AS SummChild
                             FROM tmpMovement_Recalc
                                  INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement_Recalc.MovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
                                  /*INNER JOIN MovementItemBoolean AS MIBoolean_Main
                                                                 ON MIBoolean_Main.MovementItemId = MovementItem.Id
                                                                AND MIBoolean_Main.DescId = zc_MIBoolean_Main()
                                                                AND MIBoolean_Main.ValueData = TRUE*/
                                  LEFT JOIN MovementItemFloat AS MIFloat_SummService
                                                              ON MIFloat_SummService.MovementItemId = MovementItem.Id
                                                             AND MIFloat_SummService.DescId = zc_MIFloat_SummService()
                                  LEFT JOIN MovementItemFloat AS MIFloat_SummMinus
                                                              ON MIFloat_SummMinus.MovementItemId = MovementItem.Id
                                                             AND MIFloat_SummMinus.DescId = zc_MIFloat_SummMinus()
                                  LEFT JOIN MovementItemFloat AS MIFloat_SummAdd
                                                              ON MIFloat_SummAdd.MovementItemId = MovementItem.Id
                                                             AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()
                                  LEFT JOIN MovementItemFloat AS MIFloat_SummSocialAdd
                                                              ON MIFloat_SummSocialAdd.MovementItemId = MovementItem.Id
                                                             AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()                                     
                                  LEFT JOIN MovementItemFloat AS MIFloat_SummChild
                                                              ON MIFloat_SummChild.MovementItemId = MovementItem.Id
                                                             AND MIFloat_SummChild.DescId = zc_MIFloat_SummChild()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                   ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                   ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                   ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                            )
          , tmpMI_Recalc AS (SELECT tmpMI.MovementItemId
                                  , tmpMI.SummCardRecalc
                                  , COALESCE (tmpMI_find.MovementItemId, 0) AS MovementItemId_find
                             FROM tmpMI
                                  LEFT JOIN tmpMI_find ON tmpMI_find.ObjectId    = tmpMI.ObjectId
                                                      AND tmpMI_find.UnitId      = tmpMI.UnitId
                                                      AND tmpMI_find.PositionId  = tmpMI.PositionId
                                                      AND tmpMI_find.InfoMoneyId = tmpMI.InfoMoneyId
                                                      AND tmpMI_find.SummToPay   >= tmpMI.SummCardRecalc
                            )
     -- ������ �� ���������
     INSERT INTO _tmpMI_Recalc (MovementItemId, SummCardRecalc, MovementItemId_find)
       SELECT MovementItemId, SummCardRecalc, MAX (MovementItemId_find) FROM tmpMI_Recalc GROUP BY MovementItemId, SummCardRecalc;


     -- !!!����� ���� ��� <����� �� �������� (��) ��� �������������>!!!
     IF NOT EXISTS (SELECT MovementItemId FROM _tmpMI_Recalc)
     THEN RETURN;
     END IF;


     -- ��������������� � 0 �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(), MovementItem.Id, 0)
     FROM _tmpMovement_Recalc
          INNER JOIN MovementItem ON MovementItem.MovementId = _tmpMovement_Recalc.MovementId AND MovementItem.DescId = zc_MI_Master();

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(), MovementItemId_find, SummCardRecalc)
     FROM _tmpMI_Recalc
     WHERE MovementItemId_find <> 0;

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(), MovementItemId, CASE WHEN MovementItemId_find <> 0 THEN 0 ELSE SummCardRecalc END)
     FROM _tmpMI_Recalc;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (MovementId)
     FROM _tmpMovement_Recalc;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.01.15                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_PersonalService_Recalc (inMovementId:= 429713, inUserId:= zfCalc_UserAdmin() :: Integer)

