-- Function: gpSetErased_Movement_ComputerAccessoriesRegister (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ComputerAccessoriesRegister (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ComputerAccessoriesRegister(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbInvNumber Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION '��������� ������ ���������� ��������������';
    END IF;

    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.07.20                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_ComputerAccessoriesRegister (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
