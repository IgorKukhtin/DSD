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
     -- �������
     DELETE FROM _tmpMovement_Recalc;
     -- �������
     DELETE FROM _tmpMI_Recalc;

          -- ����������� ������ - ��� ��������� ��� ������������� �� ��������������� <����� ����������>
          WITH tmpMovement AS (SELECT MovementDate_ServiceDate.ValueData AS ServiceDate
                               FROM Movement
                                    LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                                           ON MovementDate_ServiceDate.MovementId = Movement.Id
                                                          AND MovementDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                                  ON MovementLinkObject_PersonalServiceList.MovementId = MovementDate_ServiceDate.MovementId
                                                                 AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                                                 AND MovementLinkObject_PersonalServiceList.ObjectId IN (293716 -- ��������� �������� �� ����
                                                                                                                       , 413454 -- ��������� �������� �� ������
                                                                                                                        )
                               WHERE Movement.Id = inMovementId
                                 AND Movement.DescId = zc_Movement_PersonalService()
                                 -- AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                               )
            , tmpMovement_to AS (SELECT Movement.Id AS MovementId, Movement.StatusId
                                 FROM tmpMovement
                                      INNER JOIN MovementDate AS MovementDate_ServiceDate
                                                              ON MovementDate_ServiceDate.ValueData = tmpMovement.ServiceDate
                                                             AND MovementDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                                             -- AND MovementDate_ServiceDate.MovementId <> tmpMovement.MovementId
                                      INNER JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
                                                         -- AND Movement.OperDate BETWEEN tmpMovement.StartDate AND tmpMovement.EndDate
	                                                 AND Movement.DescId = zc_Movement_PersonalService()
                                                         -- AND Movement.StatusId = zc_Enum_Status_Complete()
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                                    ON MovementLinkObject_PersonalServiceList.MovementId = MovementDate_ServiceDate.MovementId
                                                                   AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                                                   AND MovementLinkObject_PersonalServiceList.ObjectId NOT IN (293716 -- ��������� �������� �� ����
                                                                                                                             , 413454 -- ��������� �������� �� ������
                                                                                                                              )
                                )
     -- ������ �� ���� ���������� ��� ������������� �� ��������������� <����� ����������>
     INSERT INTO _tmpMovement_Recalc (MovementId, StatusId)
       SELECT MovementId, StatusId FROM tmpMovement_to WHERE MovementId <> inMovementId;

     -- !!!!!!!!!!!!!!!!!!!!!!!
     ANALYZE _tmpMovement_Recalc;

     -- ����������� ������ �� ��������� ��� �������������
     WITH tmpMovement AS (SELECT MovementDate_ServiceDate.ValueData AS ServiceDate
                          FROM Movement
                               LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                                      ON MovementDate_ServiceDate.MovementId = Movement.Id
                                                     AND MovementDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                               INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                             ON MovementLinkObject_PersonalServiceList.MovementId = MovementDate_ServiceDate.MovementId
                                                            AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                                            AND MovementLinkObject_PersonalServiceList.ObjectId IN (293716 -- ��������� �������� �� ����
                                                                                                                  , 413454 -- ��������� �������� �� ������
                                                                                                                   )
                          WHERE Movement.Id = inMovementId
                            AND Movement.DescId = zc_Movement_PersonalService()
                            -- AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                          )
            -- ��� ��������� � ������� ����� ������ zc_MIFloat_SummCardRecalc
          , tmpMovement_from AS (SELECT Movement.Id AS MovementId
                                 FROM tmpMovement
                                      INNER JOIN MovementDate AS MovementDate_ServiceDate
                                                              ON MovementDate_ServiceDate.ValueData = tmpMovement.ServiceDate
                                                             AND MovementDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                      INNER JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
	                                                 AND Movement.DescId = zc_Movement_PersonalService()
                                                         AND (Movement.StatusId = zc_Enum_Status_Complete()
                                                           OR Movement.Id = inMovementId)
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                                    ON MovementLinkObject_PersonalServiceList.MovementId = MovementDate_ServiceDate.MovementId
                                                                   AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                                                   AND MovementLinkObject_PersonalServiceList.ObjectId IN (293716 -- ��������� �������� �� ����
                                                                                                                         , 413454 -- ��������� �������� �� ������
                                                                                                                          )
                                )
          -- �������� � ������ ��� ������������
        , tmpMI_from AS (SELECT MovementItem.Id                               AS MovementItemId
                              , tmpMovement_from.MovementId                   AS MovementId
                              , COALESCE (MovementItem.ObjectId, 0)           AS ObjectId
                              , COALESCE (MILinkObject_Unit.ObjectId, 0)      AS UnitId
                              , COALESCE (MILinkObject_Position.ObjectId, 0)  AS PositionId
                              , COALESCE (MILinkObject_InfoMoney.ObjectId, 0) AS InfoMoneyId
                              , (MIFloat_SummCardRecalc.ValueData)            AS SummCardRecalc
                         FROM tmpMovement_from
                              INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement_from.MovementId
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
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
                        )

          -- ��� ��������� � ������� ����� ������������ ����� zc_MIFloat_SummCardRecalc
        , tmpMovement_to AS (SELECT MovementId FROM _tmpMovement_Recalc WHERE StatusId = zc_Enum_Status_Complete() AND EXISTS (SELECT SummCardRecalc FROM tmpMI_from))

              -- ��� �������� � ������� ����� ������������ ����� zc_MIFloat_SummCardRecalc
          , tmpMI_to_all AS (SELECT MovementItem.Id AS MovementItemId
                                  , COALESCE (MovementItem.ObjectId, 0)           AS ObjectId
                                  , COALESCE (MILinkObject_Unit.ObjectId, 0)      AS UnitId
                                  , COALESCE (MILinkObject_Position.ObjectId, 0)  AS PositionId
                                  , COALESCE (MILinkObject_InfoMoney.ObjectId, 0) AS InfoMoneyId
                                  , COALESCE (MIFloat_SummService.ValueData, 0)
                                  - COALESCE (MIFloat_SummMinus.ValueData, 0)
                                  + COALESCE (MIFloat_SummAdd.ValueData, 0)
                                  + COALESCE (MIFloat_SummSocialAdd.ValueData, 0) AS SummToPay
                                  , COALESCE (MIFloat_SummChild.ValueData, 0)     AS SummChild
                             FROM tmpMovement_to
                                  INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement_to.MovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
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
              , tmpMI_to AS (SELECT tmpMI_from.MovementId     AS MovementId_from
                                  , tmpMI_from.MovementItemId AS MovementItemId_from
                                  , COALESCE (tmpMI_to_all.MovementItemId, 0) AS MovementItemId_to
                                  , tmpMI_from.SummCardRecalc
                             FROM tmpMI_from
                                  LEFT JOIN tmpMI_to_all ON tmpMI_to_all.ObjectId    = tmpMI_from.ObjectId
                                                        AND tmpMI_to_all.UnitId      = tmpMI_from.UnitId
                                                        AND tmpMI_to_all.PositionId  = tmpMI_from.PositionId
                                                        AND tmpMI_to_all.InfoMoneyId = tmpMI_from.InfoMoneyId
                                                        AND tmpMI_to_all.SummToPay   >= tmpMI_from.SummCardRecalc
                            )
     -- ������ �� ��������� ��� �������������
     INSERT INTO _tmpMI_Recalc (MovementId_from, MovementItemId_from, MovementItemId_to, SummCardRecalc)
       SELECT MovementId_from, MovementItemId_from, MAX (MovementItemId_to), SummCardRecalc FROM tmpMI_to GROUP BY MovementId_from, MovementItemId_from, SummCardRecalc;
     -- !!!!!!!!!!!!!!!!!!!!!!!
     ANALYZE _tmpMI_Recalc;


     -- !!!����� ���� ��� <����� �� �������� (��) ��� �������������>!!!
     IF NOT EXISTS (SELECT MovementId_from FROM _tmpMI_Recalc)
     THEN RETURN;
     END IF;


     -- ��������������� � 0 �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(), MovementItem.Id, 0)
     FROM _tmpMovement_Recalc
          INNER JOIN MovementItem ON MovementItem.MovementId = _tmpMovement_Recalc.MovementId AND MovementItem.DescId = zc_MI_Master();

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(), MovementItemId_to, SummCardRecalc)
     FROM _tmpMI_Recalc
     WHERE MovementItemId_to <> 0;

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(), MovementItemId_from, CASE WHEN MovementItemId_to <> 0 THEN 0 ELSE SummCardRecalc END)
     FROM _tmpMI_Recalc;

     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (tmp.MovementId_from)
     FROM (SELECT MovementId_from FROM _tmpMI_Recalc GROUP BY MovementId_from) AS tmp;

     -- ����������� �������� �����
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
