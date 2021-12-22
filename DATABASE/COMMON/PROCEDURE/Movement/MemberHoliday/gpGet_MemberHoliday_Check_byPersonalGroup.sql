-- Function: gpGet_MemberHoliday_Check_byPersonalGroup()

DROP FUNCTION IF EXISTS gpGet_MemberHoliday_Check_byPersonalGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MemberHoliday_Check_byPersonalGroup(
    IN inMovementId       Integer  ,   -- ���� ���������
   OUT outMovementId_check Integer ,
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
   DECLARE vbMemberId   Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ���� ��� � ��������� �������
     vbStartDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_BeginDateStart());
     vbEndDate  := (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_BeginDateEnd());
     vbMemberId := (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_Member());

     -- �������� ��� ��������� �� ������ � ���.������ �������
     outMovementId_check:= (WITH tmpOperDate_all AS (SELECT GENERATE_SERIES (vbStartDate, vbEndDate, '1 DAY' :: INTERVAL) AS OperDate)
                              --��� ���������� �� ���.����
                              , tmpPersonal AS (SELECT ObjectLink_Personal_Member.ObjectId  AS PersonalId
                                                FROM ObjectLink AS ObjectLink_Personal_Member
                                                WHERE ObjectLink_Personal_Member.ChildObjectId = vbMemberId
                                                  AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                                )
                              --���������  PersonalGroup
                              , tmpMovement AS (SELECT Movement.*
                                                FROM tmpOperDate_all
                                                     INNER JOIN Movement ON Movement.OperDate = tmpOperDate_all.OperDate
                                                                        AND Movement.DescId = zc_Movement_PersonalGroup()
                                                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                               )
                          
                          SELECT MIN (tmpMovement.Id) AS Id -- ������� ��� ���� ����� ��������� ����������
                          FROM tmpMovement
                               INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                      AND MovementItem.DescId = zc_MI_Master()
                                                      AND MovementItem.isErased = FALSE
                               INNER JOIN tmpPersonal ON tmpPersonal.PersonalId = MovementItem.ObjectId
                          );

     IF COALESCE (outMovementId_check,0) <> 0
     THEN
          RAISE EXCEPTION '������.��������� <%> ������ � �������� ������ ������� � <%>'
                          , lfGet_Object_ValueData (vbMemberId)
                          , (SELECT Movement.Invnumber||' �� '||zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = outMovementId_check)
                          ;
     END IF;



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.12.21         *
*/

-- ����
--SELECT gpGet_MemberHoliday_Check_byPersonalGroup (21587945 , '5');