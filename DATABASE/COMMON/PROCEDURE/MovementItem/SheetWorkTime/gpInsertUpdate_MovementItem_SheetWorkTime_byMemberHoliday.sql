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
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDAte   TDateTime;
   DECLARE vbMemberId   Integer;
   DECLARE vbWorkTimeKindId Integer;
   DECLARE vbMovementId_check Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
    IF zfConvert_StringToNumber (inSession) < 0
    THEN vbUserId := lpGetUserBySession ((ABS (inSession :: Integer)) :: TVarChar);
    ELSE vbUserId := lpGetUserBySession (inSession);
    END IF;


     -- ���� ��� � ��������� �������
     vbStartDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId_mh AND MovementDate.DescId = zc_MovementDate_BeginDateStart());
     vbEndDAte  := (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId_mh AND MovementDate.DescId = zc_MovementDate_BeginDateEnd());
     vbMemberId := (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId_mh AND MovementLinkObject.DescId = zc_MovementLinkObject_Member());
     vbWorkTimeKindId := (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId_mh AND MovementLinkObject.DescId = zc_MovementLinkObject_WorkTimeKind());


     -- �������� ��� �� �� ���������
     vbMovementId_check:= (WITH tmpOperDate_all AS (SELECT GENERATE_SERIES (vbStartDate, vbEndDate, '1 DAY' :: INTERVAL) AS OperDate)
                                  , tmpOperDate AS (SELECT DISTINCT DATE_TRUNC ('MONTH', tmpOperDate_all.OperDate) AS OperDate FROM tmpOperDate_all)
                                  , tmpMovement AS (SELECT MovementLinkObject_Member.ObjectId   AS MemberId
                                                         , ObjectLink_Personal_Member.ObjectId  AS PersonalId
                                                    FROM Movement
                                                         LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                                                                      ON MovementLinkObject_Member.MovementId = Movement.Id
                                                                                     AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                                              ON ObjectLink_Personal_Member.ChildObjectId = MovementLinkObject_Member.ObjectId
                                                                             AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                                    WHERE Movement.Id = inMovementId_mh
                                                   )
                                  , tmpContainer AS (SELECT CLO_Personal.ContainerId
                                                     FROM tmpMovement
                                                          INNER JOIN ContainerLinkObject AS CLO_Personal
                                                                                         ON CLO_Personal.ObjectId = tmpMovement.PersonalId
                                                                                        AND CLO_Personal.DescId   = zc_ContainerLinkObject_Personal()
                                                          INNER JOIN Container ON Container.Id     = CLO_Personal.ContainerId
                                                                              AND Container.DescId = zc_Container_Summ()
                                                        --INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                        --                               ON CLO_InfoMoney.ContainerId = Container.Id
                                                        --                              AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                                          INNER JOIN ContainerLinkObject AS CLO_ServiceDate
                                                                                         ON CLO_ServiceDate.ContainerId = CLO_Personal.ContainerId
                                                                                        AND CLO_ServiceDate.DescId      = zc_ContainerLinkObject_ServiceDate()
                                                          INNER JOIN ObjectDate AS ObjectDate_Service
                                                                                ON ObjectDate_Service.ObjectId  = CLO_ServiceDate.ObjectId
                                                                               AND ObjectDate_Service.DescId    = zc_ObjectDate_ServiceDate_Value()
                                                                               AND ObjectDate_Service.ValueData IN (SELECT DISTINCT tmpOperDate.OperDate FROM tmpOperDate)
                                                    )
                             SELECT MIContainer.MovementId
                             FROM tmpContainer
                                  INNER JOIN MovementItemContainer AS MIContainer
                                                                   ON MIContainer.ContainerId    = tmpContainer.ContainerId
                                                                  AND MIContainer.MovementDescId = zc_Movement_PersonalService()
                                                                  AND MIContainer.Amount         <> 0
                                                                  AND MIContainer.AnalyzerId     <> zc_Enum_AnalyzerId_PersonalService_SummDiff()
                             LIMIT 1
                          );

     -- �������� ��� �� �� ���������
     IF vbMovementId_check > 0 AND zfConvert_StringToNumber (inSession) <> -5
     THEN
         RAISE EXCEPTION '������ ������������.%���������� � ����������.%������� ��������� ���������� <%>%� <%> �� <%>.'
                        , CHR (13)
                        , CHR (13)
                        , lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbMovementId_check AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList()))
                        , CHR (13)
                        , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_check)
                        , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_check))
                         ;
     END IF;
     


     -- ��������� ����������� � zc_Movement_SheetWorkTime ���������� �� ������ �������������� WorkTimeKind - ��� ������������� ��� �������� - � ������ ��������� WorkTimeKind
     PERFORM gpInsertUpdate_MovementItem_SheetWorkTime(inMemberId            := tmp.MemberId           :: Integer    -- ���� ���. ����
                                                     , inPositionId          := tmp.PositionId         :: Integer    -- ���������
                                                     , inPositionLevelId     := tmp.PositionLevelId    :: Integer    -- ������
                                                     , inUnitId              := tmp.UnitId             :: Integer    -- �������������
                                                     , inPersonalGroupId     := tmp.PersonalGroupId    :: Integer    -- ����������� ����������
                                                     , inStorageLineId       := tmp.StorageLineId      :: Integer    -- ����� �����-��
                                                     , inOperDate            := tmp.OperDate           :: TDateTime  -- ����
                                                     , ioValue               := COALESCE (tmp.Value,NULL)              :: TVarChar   -- ����
                                                     , ioTypeId              := COALESCE (tmp.WorkTimeKindId,NULL)     :: Integer    
                                                     , ioWorkTimeKindId_key  := NULL
                                                     , inIsPersonalGroup     := FALSE                  :: Boolean    -- ������������ ��� ���������� �� ������ ������
                                                     , inSession             := inSession              :: TVarChar
                                                      )
     FROM (WITH
           tmpMember AS (SELECT lfSelect.MemberId
                              , lfSelect.PersonalId
                              , lfSelect.UnitId
                              , lfSelect.PositionId
                              , lfSelect.BranchId
                         FROM lfSelect_Object_Member_findPersonal (CASE WHEN zfConvert_StringToNumber (inSession) < 0 THEN (ABS (inSession :: Integer)) :: TVarChar ELSE inSession END) AS lfSelect
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
              , CASE WHEN inisDel = FALSE OR zfConvert_StringToNumber (inSession) < 0 THEN vbWorkTimeKindId ELSE 0 END ::Integer AS WorkTimeKindId
              , zfCalc_ViewWorkHour (0, ObjectString_ShortName.ValueData) ::TVarChar AS Value
         FROM tmpOperDate
             LEFT JOIN tmpMember ON 1=1
             LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = tmpMember.PersonalId
             LEFT JOIN ObjectString AS ObjectString_ShortName
                                    ON ObjectString_ShortName.ObjectId = CASE WHEN inisDel = FALSE THEN vbWorkTimeKindId ELSE 0 END
                                   AND ObjectString_ShortName.DescId = zc_objectString_WorkTimeKind_ShortName()
     ) AS tmp
     ;

-- !!! �������� !!!
IF vbUserId = 5 AND 1=1 THEN
    RAISE EXCEPTION 'Admin - Test = OK';
END IF;


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