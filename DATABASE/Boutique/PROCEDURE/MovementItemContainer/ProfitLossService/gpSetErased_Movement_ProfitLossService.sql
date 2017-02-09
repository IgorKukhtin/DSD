-- Function: gpSetErased_Movement_ProfitLossService (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ProfitLossService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ProfitLossService(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_ProfitLossService());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.03.14                                        * add lpCheckRight
 17.02.14				                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_ProfitLossService (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
