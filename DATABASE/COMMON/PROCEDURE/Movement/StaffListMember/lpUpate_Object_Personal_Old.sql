-- Function: lpUpate_Object_Personal_Old ()

DROP FUNCTION IF EXISTS lpUpate_Object_Personal_Old (Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpUpate_Object_Personal_Old (
    IN inMovementId          Integer   , -- ���� ������� <��������, ������� ��������>
    IN inSession             TVarChar      -- ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMemberId   Integer;
           vbPersonalId Integer;
           vbMovementId Integer;
           vbMovementId_old  Integer;
           vbStaffListKindId Integer;
           vbOperDate   TDateTime;
           
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);
     
     --������ �� ��. ���������
     SELECT tmp.OperDate
          , tmp.Id 
          , tmp.PersonalId
          , tmp.MemberId
          , tmp.StaffListKindId
    INTO vbOperDate, vbMovementId, vbPersonalId, vbMemberId, vbStaffListKindId
     FROM gpGet_Movement_StaffListMember (inMovementId := inMovementId, inOperDate := CURRENT_DATE ::TDateTime, inSession := inSession ::TVarChar) AS tmp;
     
    --�������� ���������� ���������
    SELECT tmp.MovementId
        -- , tmp.StaffListKindId
   INTO vbMovementId_old 
    FROM (SELECT Movement.Id AS  MovementId
               --, MovementLinkObject_StaffListKind.ObjectId AS StaffListKindId
               , ROW_NUMBER() OVER (ORDER BY Movement.Id DESC, Movement.OperDate DESC) AS Ord
          FROM Movement 
               INNER JOIN MovementLinkObject AS MovementLinkObject_Member
                                             ON MovementLinkObject_Member.MovementId = Movement.Id
                                            AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                                            AND MovementLinkObject_Member.ObjectId = vbMemberId

               INNER JOIN MovementLinkObject AS MovementLinkObject_StaffListKind
                                             ON MovementLinkObject_StaffListKind.MovementId = Movement.Id
                                            AND MovementLinkObject_StaffListKind.DescId = zc_MovementLinkObject_StaffListKind()  --zc_Enum_StaffListKind_Send
                                            AND ((MovementLinkObject_StaffListKind.ObjectId = vbStaffListKindId AND vbStaffListKindId = zc_Enum_StaffListKind_Add()) 
                                                 OR (MovementLinkObject_StaffListKind.ObjectId <> zc_Enum_StaffListKind_Add() AND vbStaffListKindId <> zc_Enum_StaffListKind_Add()) 
                                                 ) 
          WHERE Movement.DescId = zc_Movement_StaffListMember()
            AND Movement.OperDate <= vbOperDate
            AND Movement.StatusId = zc_Enum_Status_Complete()
            AND Movement.Id <> inMovementId
          ) AS tmp
    WHERE  Ord = 1;
   
    --�������������� ������� �����������
    PERFORM gpInsertUpdate_Object_Personal(ioId                              := COALESCE (vbPersonalId,0)          ::Integer    -- ���� ������� <����������>
                                         , inMemberId                        := vbMemberId                         ::Integer    -- ������ �� ���.����
                                         , inPositionId                      := tmp.PositionId                      ::Integer    -- ������ �� ���������
                                         , inPositionLevelId                 := tmp.PositionLevelId                 ::Integer    -- ������ �� ������ ���������
                                         , inUnitId                          := tmp.UnitId                          ::Integer    -- ������ �� �������������
                                         , inPersonalGroupId                 := tmp.PersonalGroupId                 ::Integer    -- ����������� �����������
                                         , inPersonalServiceListId           := tmp.PersonalServiceListId           ::Integer    -- ��������� ����������(�������)
                                         , inPersonalServiceListOfficialId   := tmp.PersonalServiceListOfficialId   ::Integer    -- ��������� ����������(��)
                                         , inPersonalServiceListCardSecondId := tmp.ServiceListCardSecondId         ::Integer    -- ��������� ����������(����� �2) 
                                         , inPersonalServiceListId_AvanceF2  := tmp.ServiceListId_AvanceF2  ::Integer    --  ��������� ����������(����� ����� �2)
                                         , inSheetWorkTimeId                 := tmp.SheetWorkTimeId                 ::Integer    -- ����� ������ (������ ������ �.��.)
                                         , inStorageLineId                   := tmp.StorageLineId                   ::Integer    -- ������ �� ����� ������������
                                         
                                         , inMember_ReferId                  := tmp.Member_ReferId                  ::Integer    -- ������� �������������
                                         , inMember_MentorId                 := tmp.Member_MentorId                 ::Integer    -- ������� ���������� 	
                                         , inReasonOutId                     := tmp.ReasonOutId                     ::Integer    -- ������� ���������� 	
                                         
                                         , inDateIn                          := CASE WHEN tmp.StaffListKindId IN (zc_Enum_StaffListKind_Add(), zc_Enum_StaffListKind_In() ) THEN tmp.OperDate ELSE ObjectDate_DateIn.ValueData END ::TDateTime  -- ���� ��������
                                         , inDateOut                         := CASE WHEN tmp.StaffListKindId = zc_Enum_StaffListKind_Out() THEN tmp.OperDate ELSE NULL END  ::TDateTime  -- ���� ���������� 
                                         , inDateSend                        := CASE WHEN tmp.StaffListKindId = zc_Enum_StaffListKind_Send() THEN tmp.OperDate ELSE NULL END ::TDateTime  -- ���� ��������
                                         , inIsDateOut                       := CASE WHEN tmp.StaffListKindId = zc_Enum_StaffListKind_Out() THEN TRUE ELSE False END         ::Boolean    -- ������
                                         , inIsDateSend                      := CASE WHEN tmp.StaffListKindId = zc_Enum_StaffListKind_Send() THEN True ELSE False END        ::Boolean    -- ���������
                                         , inIsMain                          := tmp.IsMain                          ::Boolean    -- �������� ����� ������
                                         , inComment                         := tmp.Comment                         ::TVarChar  
                                         , inSession                         := inSession                           ::TVarChar   -- ������ ������������ 
                                         )
    FROM gpGet_Movement_StaffListMember (inMovementId := vbMovementId_old, inOperDate := CURRENT_DATE ::TDateTime, inSession := inSession ::TVarChar) AS tmp
       --LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = vbPersonalId --tmp.PersonalId
        LEFT JOIN ObjectDate AS ObjectDate_DateIn
                             ON ObjectDate_DateIn.ObjectId = vbPersonalId
                            AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()
    ;    
    
    IF  vbUserId = 9457 THEN RAISE EXCEPTION 'Admin - Test = OK'; END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.10.25         *
*/

-- ����
--