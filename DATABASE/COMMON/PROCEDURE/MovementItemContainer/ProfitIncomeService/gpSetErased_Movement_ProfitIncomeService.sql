-- Function: gpSetErased_Movement_ProfitIncomeService (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ProfitIncomeService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ProfitIncomeService(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_ProfitIncomeService());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.07.20         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_ProfitIncomeService (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
