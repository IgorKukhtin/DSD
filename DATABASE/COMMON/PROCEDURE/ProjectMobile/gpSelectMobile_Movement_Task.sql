-- Function: gpSelectMobile_Movement_Task()

DROP FUNCTION IF EXISTS gpSelectMobile_Movement_Task (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Movement_Task(
    IN inSyncDateIn TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
    IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id         Integer   -- ���������� �������������, ����������� � ������� ��, � ������������ ��� �������������
             , InvNumber  TVarChar  -- ����� ���������
             , OperDate   TDateTime -- ���� ���������
             , StatusId   Integer   -- ���� ��������
             , PersonalId Integer   -- ���������� (�������� �����)
             , isSync     Boolean   
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT tmpConst.PersonalId FROM gpGetMobile_Object_Const (inSession) AS tmpConst);

      -- ���������
      IF vbPersonalId IS NOT NULL 
      THEN
           RETURN QUERY
             SELECT Movement_Task.Id
                  , Movement_Task.InvNumber
                  , Movement_Task.Operdate
                  , Movement_Task.StatusId
                  , MovementLinkObject_PersonalTrade.ObjectId AS PersonalId
                  , true::Boolean                             AS isSync  
             FROM Movement AS Movement_Task
                  JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                          ON MovementLinkObject_PersonalTrade.MovementId = Movement_Task.Id
                                         AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
                                         AND MovementLinkObject_PersonalTrade.ObjectId = vbPersonalId
             WHERE Movement_Task.DescId = zc_Movement_Task()
               AND Movement_Task.StatusId = zc_Enum_Status_UnComplete();
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.   �������� �.�.
 30.03.17                                                                          *
*/

-- SELECT * FROM gpSelectMobile_Movement_Task (inSyncDateIn:= zc_DateStart(), inSession:= zfCalc_UserAdmin())
