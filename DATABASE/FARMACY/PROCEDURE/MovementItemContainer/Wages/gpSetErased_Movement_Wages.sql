-- Function: gpSetErased_Movement_Wages (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Wages (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Wages(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.09.19                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_Wages (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
