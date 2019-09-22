-- Function: gpSetErased_Movement_PersonalRate (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_PersonalRate (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_PersonalRate(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_PersonalRate());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.09.19         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_PersonalRate (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
