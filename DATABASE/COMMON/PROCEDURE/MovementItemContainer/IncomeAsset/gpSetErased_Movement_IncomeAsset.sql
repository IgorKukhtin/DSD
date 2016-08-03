-- Function: gpSetErased_Movement_IncomeAsset (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_IncomeAsset (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_IncomeAsset(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_IncomeAsset());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.08.16         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_IncomeAsset (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
