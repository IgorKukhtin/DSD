-- Function: lpComplete_Movement_PersonalService_Recalc (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalService_Recalc (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PersonalService_Recalc(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbPersonalServiceListId_to_check Integer;
BEGIN
     -- �������
     DELETE FROM _tmpMovement_Recalc;
     -- �������
     DELETE FROM _tmpMI_Recalc;

     -- ��������� ������ �� ���� ���������� �� ��������������� <����� ����������>
     INSERT INTO _tmpMovement_Recalc (MovementId, StatusId, PersonalServiceListId, PaidKindId, ServiceDate)
        SELECT Movement.Id AS MovementId
             , Movement.StatusId
             , COALESCE (MovementLinkObject_PersonalServiceList.ObjectId, 0)       AS PersonalServiceListId
             , COALESCE (ObjectLink_PersonalServiceList_PaidKind.ChildObjectId, 0) AS PaidKindId
             , MovementDate_ServiceDate.ValueData                                  AS ServiceDate
        FROM MovementDate AS MovementDate_ServiceDate
             INNER JOIN MovementDate AS MovementDate_ServiceDate_find
                                     ON MovementDate_ServiceDate_find.ValueData = MovementDate_ServiceDate.ValueData
                                    AND MovementDate_ServiceDate_find.DescId = zc_MIDate_ServiceDate()
                                    -- AND MovementDate_ServiceDate.MovementId <> tmpMovement.MovementId
             INNER JOIN Movement ON Movement.Id = MovementDate_ServiceDate_find.MovementId
                                -- AND Movement.OperDate BETWEEN tmpMovement.StartDate AND tmpMovement.EndDate
	                        AND Movement.DescId = zc_Movement_PersonalService()
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
             INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                           ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                          AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
             LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                  ON ObjectLink_PersonalServiceList_PaidKind.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                                 AND ObjectLink_PersonalServiceList_PaidKind.DescId = zc_ObjectLink_PersonalServiceList_PaidKind()
        WHERE MovementDate_ServiceDate.MovementId = inMovementId
          AND MovementDate_ServiceDate.DescId = zc_MIDate_ServiceDate();
     -- !!!!!!!!!!!!!!!!!!!!!!!
     ANALYZE _tmpMovement_Recalc;


     -- ����������� ������ �� ��������� ��� �������� ������
     WITH -- ��� ��������� �� ������� ����� ���������� ����� zc_MIFloat_SummCardRecalc + zc_MIFloat_SummNalogRecalc, �� ���� ����� ���������� 2
          tmpMovement_from AS (SELECT _tmpMovement_Recalc.MovementId, _tmpMovement_Recalc.ServiceDate, _tmpMovement_Recalc.PersonalServiceListId
                               FROM _tmpMovement_Recalc
                               WHERE _tmpMovement_Recalc.PaidKindId = zc_Enum_PaidKind_FirstForm() -- ����������� ��
                                AND  (_tmpMovement_Recalc.StatusId = zc_Enum_Status_Complete()     -- ��� ����������� (�.�. ����� ��������� ���� zc_MIFloat_SummCard + zc_MIFloat_SummNalog)
                                   OR _tmpMovement_Recalc.MovementId = inMovementId)               -- ��� �������
                              )
          -- �������� � ������ ��� ��������
        , tmpMI_from AS (SELECT MovementItem.Id                                         AS MovementItemId
                              , tmpMovement_from.MovementId                             AS MovementId
                              , tmpMovement_from.ServiceDate                            AS ServiceDate
                              , tmpMovement_from.PersonalServiceListId                  AS PersonalServiceListId
                              , COALESCE (MovementItem.ObjectId, 0)                     AS ObjectId
                              , COALESCE (MILinkObject_Unit.ObjectId, 0)                AS UnitId
                              , COALESCE (MILinkObject_Position.ObjectId, 0)            AS PositionId
                              , COALESCE (MILinkObject_InfoMoney.ObjectId, 0)           AS InfoMoneyId
                              , COALESCE (MILinkObject_PersonalServiceList.ObjectId, 0) AS PersonalServiceListId_to -- !!!� ����� ����������� ����� ����������, ����� ��������� � ������� MovementItemId!!!
                              , COALESCE (MIFloat_SummCardRecalc.ValueData, 0)          AS SummCardRecalc
                              , COALESCE (MIFloat_SummNalogRecalc.ValueData, 0)         AS SummNalogRecalc
                         FROM tmpMovement_from
                              INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement_from.MovementId
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                              LEFT JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                                          ON MIFloat_SummCardRecalc.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRecalc
                                                          ON MIFloat_SummNalogRecalc.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummNalogRecalc.DescId = zc_MIFloat_SummNalogRecalc()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                               ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                               ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                               ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                                               ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_PersonalServiceList.DescId = zc_MILinkObject_PersonalServiceList()
                         -- �.�. ���� ��� ����������
                         WHERE MIFloat_SummCardRecalc.ValueData <> 0 OR MIFloat_SummNalogRecalc.ValueData <> 0
                        )

          -- ��� ��������� � ������� ����� ���������� ����� zc_MIFloat_SummCardRecalc + zc_MIFloat_SummNalogRecalc (����� ��� ���������� � ������� ����� "���������")
        , tmpMovement_to AS (SELECT MovementId, PersonalServiceListId, StatusId FROM _tmpMovement_Recalc WHERE PaidKindId <> zc_Enum_PaidKind_FirstForm() AND EXISTS (SELECT 1 FROM tmpMI_from))

            -- ��� �������� �� ������� ����� ������ ���� ���������� ����� zc_MIFloat_SummCardRecalc + zc_MIFloat_SummNalogRecalc
          , tmpMI_to_all AS (SELECT tmpMovement_to.PersonalServiceListId          AS PersonalServiceListId
                                  , tmpMovement_to.MovementId                     AS MovementId
                                  , MovementItem.Id                               AS MovementItemId
                                  , COALESCE (MovementItem.ObjectId, 0)           AS ObjectId
                                  , COALESCE (MILinkObject_Unit.ObjectId, 0)      AS UnitId
                                  , COALESCE (MILinkObject_Position.ObjectId, 0)  AS PositionId
                                  , COALESCE (MILinkObject_InfoMoney.ObjectId, 0) AS InfoMoneyId
                             FROM tmpMovement_to
                                  INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement_to.MovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
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
                -- ������� ��������� � �������� � ������� ��������� ����� zc_MIFloat_SummCardRecalc + zc_MIFloat_SummNalogRecalc
              , tmpMI_to AS (SELECT tmpMI_from.MovementId     AS MovementId_from
                                  , tmpMI_from.MovementItemId AS MovementItemId_from
                                  , COALESCE (tmpMovement_to.MovementId, COALESCE (tmpMovement_to_UnComplete.MovementId, 0)) AS MovementId_to
                                  , COALESCE (tmpMI_to_all.MovementItemId, 0)                                                AS MovementItemId_to
                             FROM tmpMI_from
                                  -- ������� ������ �������� zc_Enum_Status_Complete
                                  LEFT JOIN tmpMovement_to ON tmpMovement_to.PersonalServiceListId = tmpMI_from.PersonalServiceListId_to
                                                          AND tmpMovement_to.StatusId = zc_Enum_Status_Complete()
                                  -- ���� �� �����, ����� ��� �������� zc_Enum_Status_UnComplete
                                  LEFT JOIN tmpMovement_to AS tmpMovement_to_UnComplete
                                                           ON tmpMovement_to_UnComplete.PersonalServiceListId = tmpMI_from.PersonalServiceListId_to
                                                          AND tmpMovement_to.PersonalServiceListId IS NULL
                                  -- ������� ��������
                                  LEFT JOIN tmpMI_to_all ON tmpMI_to_all.MovementId            = COALESCE (tmpMovement_to.MovementId, tmpMovement_to_UnComplete.MovementId)
                                                        AND tmpMI_to_all.ObjectId              = tmpMI_from.ObjectId
                                                        AND tmpMI_to_all.UnitId                = tmpMI_from.UnitId
                                                        AND tmpMI_to_all.PositionId            = tmpMI_from.PositionId
                                                        AND tmpMI_to_all.InfoMoneyId           = tmpMI_from.InfoMoneyId
                                                        AND tmpMI_to_all.PersonalServiceListId = tmpMI_from.PersonalServiceListId_to
                            )
     -- ������ ��� ���� ���������
     INSERT INTO _tmpMI_Recalc (MovementId_from, MovementItemId_from, PersonalServiceListId_from, MovementId_to, MovementItemId_to, PersonalServiceListId_to, ServiceDate, UnitId, PersonalId, PositionId, InfoMoneyId, SummCardRecalc, SummNalogRecalc, isMovementComplete)
       SELECT tmpMI_from.MovementId            AS MovementId_from
            , tmpMI_from.MovementItemId        AS MovementItemId_from
            , tmpMI_from.PersonalServiceListId AS PersonalServiceListId_from
            , COALESCE (tmpMI_to.MovementId_to, tmpMI_to_Movement.MovementId_to) AS MovementId_to
            , COALESCE (tmpMI_to.MovementItemId_to, 0)                           AS MovementItemId_to
            , tmpMI_from.PersonalServiceListId_to
            , tmpMI_from.ServiceDate
            , tmpMI_from.UnitId
            , tmpMI_from.ObjectId
            , tmpMI_from.PositionId
            , tmpMI_from.InfoMoneyId
            , tmpMI_from.SummCardRecalc
            , tmpMI_from.SummNalogRecalc
            , CASE WHEN tmpMI_to.MovementItemId_to IS NULL AND tmpMovement_to.StatusId = zc_Enum_Status_Complete() THEN TRUE ELSE FALSE END AS isMovementComplete
       FROM tmpMI_from
            -- �� ������ ������� ������ ����
            LEFT JOIN (SELECT tmpMI_to.MovementItemId_from, MAX (tmpMI_to.MovementItemId_to) AS MovementItemId_to FROM tmpMI_to WHERE tmpMI_to.MovementItemId_to <> 0 GROUP BY tmpMI_to.MovementItemId_from) AS tmp ON tmp.MovementItemId_from = tmpMI_from.MovementItemId
            -- ���� ����� MovementItemId_to, ����� ����� ����� ��� MovementId_to
            LEFT JOIN tmpMI_to ON tmpMI_to.MovementItemId_from = tmp.MovementItemId_from
                              AND tmpMI_to.MovementItemId_to = tmp.MovementItemId_to
            -- ���� �� ����� MovementItemId_to, ����� ����� MovementId_to
            LEFT JOIN tmpMI_to AS tmpMI_to_Movement ON tmpMI_to_Movement.MovementItemId_from = tmpMI_from.MovementItemId
                                                   AND tmpMI_to_Movement.MovementItemId_to = 0
            LEFT JOIN tmpMovement_to ON tmpMovement_to.MovementId = COALESCE (tmpMI_to.MovementId_to, tmpMI_to_Movement.MovementId_to)
      ;
     -- !!!!!!!!!!!!!!!!!!!!!!!
     ANALYZE _tmpMI_Recalc;


     -- ������������� ���������
     PERFORM lpUnComplete_Movement (inMovementId := tmp.MovementId_to
                                  , inUserId     := inUserId)
     FROM (SELECT DISTINCT _tmpMI_Recalc.MovementId_to FROM _tmpMI_Recalc WHERE _tmpMI_Recalc.isMovementComplete = TRUE) AS tmp;


     -- ��������� ����� ��������� (!!!����� �� ���� ��������!!!)
     UPDATE _tmpMI_Recalc SET MovementId_to      = tmp.MovementId_to
                            , isMovementComplete = TRUE
     FROM (SELECT lpInsertUpdate_Movement_PersonalService (ioId                      := 0
                                                         , inInvNumber               := CAST (NEXTVAL ('movement_personalservice_seq') AS TVarChar)
                                                         , inOperDate                := DATE_TRUNC ('MONTH', tmp.ServiceDate + INTERVAL '1 MONTH')
                                                         , inServiceDate             := tmp.ServiceDate
                                                         , inComment                 := ''
                                                         , inPersonalServiceListId   := tmp.PersonalServiceListId_to
                                                         , inJuridicalId             := ObjectLink_PersonalServiceList_Juridical.ChildObjectId
                                                         , inUserId                  := inUserId
                                                          ) AS MovementId_to
                , tmp.PersonalServiceListId_to
           FROM (SELECT _tmpMI_Recalc.PersonalServiceListId_to
                      , _tmpMI_Recalc.ServiceDate
                 FROM _tmpMI_Recalc
                 WHERE _tmpMI_Recalc.MovementId_to = 0
                   AND _tmpMI_Recalc.PersonalServiceListId_to <> 0 -- !!!�����, �.�. ���� ������� ���� ����������!!!
                 GROUP BY _tmpMI_Recalc.PersonalServiceListId_to
                        , _tmpMI_Recalc.ServiceDate
                ) AS tmp
                LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Juridical
                                     ON ObjectLink_PersonalServiceList_Juridical.ObjectId = tmp.PersonalServiceListId_to
                                    AND ObjectLink_PersonalServiceList_Juridical.DescId = zc_ObjectLink_PersonalServiceList_Juridical()
         ) AS tmp
     WHERE _tmpMI_Recalc.PersonalServiceListId_to = tmp.PersonalServiceListId_to;

     -- ��������� ����� ��������
     UPDATE _tmpMI_Recalc SET MovementItemId_to = tmp.MovementItemId_to
     FROM (SELECT lpInsertUpdate_MovementItem_PersonalService_item (ioId                 := 0
                                                                  , inMovementId         := _tmpMI_Recalc.MovementId_to
                                                                  , inPersonalId         := _tmpMI_Recalc.PersonalId
                                                                  , inIsMain             := MIBoolean_Main.ValueData
                                                                  , inSummService        := 0
                                                                  , inSummCardRecalc     := 0
                                                                  , inSummCardSecondRecalc := 0
                                                                  , inSummNalogRecalc    := 0
                                                                  , inSummMinus          := 0
                                                                  , inSummAdd            := 0
                                                                  , inSummHoliday        := 0
                                                                  , inSummSocialIn       := 0
                                                                  , inSummSocialAdd      := 0
                                                                  , inSummChildRecalc    := 0
                                                                  , inSummMinusExtRecalc := 0
                                                                  , inComment            := ''
                                                                  , inInfoMoneyId        := _tmpMI_Recalc.InfoMoneyId
                                                                  , inUnitId             := _tmpMI_Recalc.UnitId
                                                                  , inPositionId         := _tmpMI_Recalc.PositionId
                                                                  , inMemberId           := NULL
                                                                  , inPersonalServiceListId  := _tmpMI_Recalc.PersonalServiceListId_to
                                                                  , inUserId             := inUserId
                                                                   ) AS MovementItemId_to
                , _tmpMI_Recalc.MovementItemId_from
           FROM _tmpMI_Recalc
                LEFT JOIN MovementItemBoolean AS MIBoolean_Main
                                              ON MIBoolean_Main.MovementItemId = _tmpMI_Recalc.MovementItemId_from
                                             AND MIBoolean_Main.DescId = zc_MIBoolean_Main()
           WHERE _tmpMI_Recalc.MovementItemId_to = 0
             AND _tmpMI_Recalc.PersonalServiceListId_to <> 0 -- !!!�����, �.�. ���� ������� ���� ����������!!!
         ) AS tmp
     WHERE _tmpMI_Recalc.MovementItemId_from = tmp.MovementItemId_from;


     -- !!!����� ���� ��� <����� �� �������� (��) ��� �������������>!!!
     -- IF NOT EXISTS (SELECT MovementId_from FROM _tmpMI_Recalc)
     -- THEN RETURN;
     -- END IF;


     -- ������� ���������� � ���� �������� <zc_MIFloat_SummCard> + <zc_MIFloat_SummNalog>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalog(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalServiceList(), MovementItem.Id, CASE WHEN _tmpMovement_Recalc.PaidKindId = zc_Enum_PaidKind_FirstForm() THEN MILinkObject_PersonalServiceList.ObjectId ELSE NULL END)
     FROM _tmpMovement_Recalc
          INNER JOIN MovementItem ON MovementItem.MovementId = _tmpMovement_Recalc.MovementId AND MovementItem.DescId = zc_MI_Master()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                           ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                          AND MILinkObject_PersonalServiceList.DescId = zc_MILinkObject_PersonalServiceList();

     -- ��������� �������� <zc_MIFloat_SummCard> + <zc_MIFloat_SummNalog>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(), MovementItemId_to, SummCardRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalog(), MovementItemId_to, SummNalogRecalc)
           -- , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalServiceList(), MovementItemId_to, PersonalServiceListId_from)
     FROM (SELECT _tmpMI_Recalc.MovementItemId_to, /*_tmpMI_Recalc.PersonalServiceListId_from,*/ SUM (_tmpMI_Recalc.SummCardRecalc) AS SummCardRecalc, SUM (_tmpMI_Recalc.SummNalogRecalc) AS SummNalogRecalc FROM _tmpMI_Recalc GROUP BY _tmpMI_Recalc.MovementItemId_to /*, _tmpMI_Recalc.PersonalServiceListId_from*/) AS _tmpMI_Recalc
     WHERE MovementItemId_to <> 0;

     -- ��� ��������� ����������� � ������� MovementItemId
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(), MovementItemId_from, SummCardRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalog(), MovementItemId_from, SummNalogRecalc)
     FROM _tmpMI_Recalc
     WHERE MovementItemId_to = 0;

     -- ����������� � ���� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (tmp.MovementId)
     FROM (SELECT _tmpMovement_Recalc.MovementId FROM _tmpMovement_Recalc UNION SELECT DISTINCT _tmpMI_Recalc.MovementId_to FROM _tmpMI_Recalc WHERE _tmpMI_Recalc.isMovementComplete = TRUE) AS tmp;


     -- !!!����� - ��������!!!
     vbPersonalServiceListId_to_check:= (SELECT tmp.PersonalServiceListId_to
                                         FROM (SELECT DISTINCT _tmpMI_Recalc.PersonalServiceListId_to FROM _tmpMI_Recalc WHERE _tmpMI_Recalc.MovementItemId_to <> 0 AND _tmpMI_Recalc.PersonalServiceListId_to <> 0) AS tmp
                                              LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                                                   ON ObjectLink_PersonalServiceList_Member.ObjectId = tmp.PersonalServiceListId_to
                                                                  AND ObjectLink_PersonalServiceList_Member.DescId = zc_ObjectLink_PersonalServiceList_Member()
                                              LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                                   ON ObjectLink_User_Member.ChildObjectId = ObjectLink_PersonalServiceList_Member.ChildObjectId 
                                                                  AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                         WHERE ObjectLink_User_Member.ObjectId IS NULL
                                         LIMIT 1
                                        );
     IF vbPersonalServiceListId_to_check <> 0
     THEN
         RAISE EXCEPTION '������.��� ��������� <%> �� ����������� <���.���� (������������)>.', lfGet_Object_ValueData (vbPersonalServiceListId_to_check);
     END IF;

     -- !!!����� - ������!!!
     UPDATE Movement SET AccessKeyId = lpGetAccessKey (ObjectLink_User_Member.ObjectId, zc_Enum_Process_InsertUpdate_Movement_PersonalService())
     FROM (SELECT DISTINCT _tmpMI_Recalc.MovementId_to, _tmpMI_Recalc.PersonalServiceListId_to FROM _tmpMI_Recalc WHERE _tmpMI_Recalc.MovementItemId_to <> 0 AND _tmpMI_Recalc.PersonalServiceListId_to <> 0) AS tmp
          LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                               ON ObjectLink_PersonalServiceList_Member.ObjectId = tmp.PersonalServiceListId_to
                              AND ObjectLink_PersonalServiceList_Member.DescId = zc_ObjectLink_PersonalServiceList_Member()
          LEFT JOIN ObjectLink AS ObjectLink_User_Member
                               ON ObjectLink_User_Member.ChildObjectId = ObjectLink_PersonalServiceList_Member.ChildObjectId 
                              AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
     WHERE Movement.Id = tmp.MovementId_to;


     -- ���������� ����� ���-���  + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := tmp.MovementId_to
                                , inDescId     := zc_Movement_PersonalService()
                                , inUserId     := inUserId
                                 )
     FROM (SELECT DISTINCT _tmpMI_Recalc.MovementId_to FROM _tmpMI_Recalc WHERE _tmpMI_Recalc.isMovementComplete = TRUE) AS tmp;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.02.17         *
 22.05.15                                        * all
 04.01.15                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_PersonalService_Recalc (inMovementId:= 429713, inUserId:= zfCalc_UserAdmin() :: Integer)
