-- Function: gpComplete_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnIn_User  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReturnIn_User(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ��� ��� ���� + ������������: � ��������� ���� = ������
     IF EXISTS (SELECT 1
                FROM Object_RoleAccessKey_View
                WHERE Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_AccessKey_Check()
                  AND Object_RoleAccessKey_View.UserId      = vbUserId
               )
     THEN
         -- �������� ���� ������������ �� ����� ��������� - ��������, �.�. ����� "�������"
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReturnIn());
     END IF;


     -- !!!������ ������ ��� �������������!!! - ���� ���. ������ ��������������� ���� ����������
     UPDATE Movement SET OperDate = CURRENT_DATE WHERE Movement.Id = inMovementId;
     -- ��������� �������� <���� ��������> - �� ���� ����������
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), inMovementId, CURRENT_TIMESTAMP);
     -- ��������� �������� <������������ (��������)> - �� ������������ ����������
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), inMovementId, vbUserId);


     -- ��������� ��������� ������� - ��� ������������ ������ �� ���������
     PERFORM lpComplete_Movement_ReturnIn_CreateTemp();

     -- ��������
     PERFORM lpComplete_Movement_ReturnIn (inMovementId  -- ��������
                                         , vbUserId);    -- ������������

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 26.02.18         *
 */

-- ����
-- SELECT * FROM gpComplete_Movement_ReturnIn_User (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
