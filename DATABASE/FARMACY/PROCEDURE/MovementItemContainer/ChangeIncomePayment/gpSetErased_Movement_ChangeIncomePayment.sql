-- Function: gpSetErased_Movement_ChangeIncomePayment (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ChangeIncomePayment (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ChangeIncomePayment(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_ChangeIncomePayment());
    vbUserId := inSession::Integer;
    
    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 21.12.15                                                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_ChangeIncomePayment (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
