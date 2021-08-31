-- Function: gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(
    IN inMovementId_mh     Integer   , -- ID Movement_MemberHoliday
    IN inisDel             Boolean   , -- ���� �������� ������������� ��� ������ (FALSE), ���� �����������/������ ������������� NULL (TRUE)
    IN inSession           TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDAte   TDateTime;
   DECLARE vbMemberId   Integer;
   DECLARE vbWorkTimeKindId Integer;
BEGIN


     --��������� ����������� � zc_Movement_SheetWorkTime ���������� �� ������ �������������� WorkTimeKind - ��� ������������� ��� �������� - � ������ ��������� WorkTimeKind

     --���� ��� � ��������� �������
     vbStartDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId_mh AND MovementDate.DescId = zc_MovementDate_BeginDateStart());
     vbEndDAte  := (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId_mh AND MovementDate.DescId = zc_MovementDate_BeginDateEnd());
     vbMemberId := (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId_mh AND MovementLinkObject.DescId = zc_MovementLinkObject_Member());
     vbWorkTimeKindId := (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId_mh AND MovementLinkObject.DescId = zc_MovementLinkObject_WorkTimeKind());

     PERFORM gpInsertUpdate_MovementItem_SheetWorkTime(tmp.MemberId           :: Integer    -- ���� ���. ����
                                                     , tmp.PositionId         :: Integer    -- ���������
                                                     , tmp.PositionLevelId    :: Integer    -- ������
                                                     , tmp.UnitId             :: Integer    -- �������������
                                                     , tmp.PersonalGroupId    :: Integer    -- ����������� ����������
                                                     , tmp.StorageLineId      :: Integer    -- ����� �����-��
                                                     , tmp.OperDate           :: TDateTime  -- ����
                                                     , tmp.Value              :: TVarChar   -- ����
                                                     , tmp.WorkTimeKindId     :: Integer    
                                                     , inSession              :: TVarChar
                                                     )
     FROM (WITH
           tmpMember AS (SELECT lfSelect.MemberId
                              , lfSelect.PersonalId
                              , lfSelect.UnitId
                              , lfSelect.PositionId
                              , lfSelect.BranchId
                         FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                         WHERE lfSelect.MemberId = vbMemberId AND lfSelect.Ord = 1
                         )
         , tmpMovement AS (SELECT MovementLinkObject_Member.ObjectId AS MemberId
                                , tmpMember.PersonalId
                                , tmpMember.PositionId
                                , Object_Personal_View.PositionLevelId
                                , Object_Personal_View.PersonalGroupId
                                , Object_Personal_View.StorageLineId
                                , tmpMember.UnitId
                                , MovementLinkObject_WorkTimeKind.ObjectId AS WorkTimeKindId
                           FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_WorkTimeKind
                                                            ON MovementLinkObject_WorkTimeKind.MovementId = Movement.Id
                                                           AND MovementLinkObject_WorkTimeKind.DescId = zc_MovementLinkObject_WorkTimeKind()
                
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                                            ON MovementLinkObject_Member.MovementId = Movement.Id
                                                           AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                               LEFT JOIN tmpMember ON tmpMember.MemberId = MovementLinkObject_Member.ObjectId
                               LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = tmpMember.PersonalId
                           WHERE Movement.Id = inMovementId_mh
                           )
         , tmpOperDate AS (SELECT GENERATE_SERIES (vbStartDate, vbEndDate, '1 DAY' :: INTERVAL) AS OperDate)
         
         SELECT tmpOperDate.OperDate
              , vbMemberId AS MemberId
              , tmpMember.PersonalId
              , tmpMember.PositionId
              , Object_Personal_View.PositionLevelId
              , Object_Personal_View.PersonalGroupId
              , Object_Personal_View.StorageLineId
              , tmpMember.UnitId
              , CASE WHEN inisDel = FALSE THEN vbWorkTimeKindId ELSE 0 END ::Integer AS WorkTimeKindId
              , zfCalc_ViewWorkHour (0, ObjectString_ShortName.ValueData) ::TVarChar AS Value
         FROM tmpOperDate
             LEFT JOIN tmpMember ON 1=1
             LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = tmpMember.PersonalId
             LEFT JOIN ObjectString AS ObjectString_ShortName
                                    ON ObjectString_ShortName.ObjectId = CASE WHEN inisDel = FALSE THEN vbWorkTimeKindId ELSE 0 END
                                   AND ObjectString_ShortName.DescId = zc_objectString_WorkTimeKind_ShortName()
         LIMIT 1
     ) AS tmp
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.08.21         *
*/

-- ����
-- 