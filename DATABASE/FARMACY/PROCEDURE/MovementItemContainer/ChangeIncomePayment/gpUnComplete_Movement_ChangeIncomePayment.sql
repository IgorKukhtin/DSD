-- Function: gpUnComplete_Movement_ChangeIncomePayment (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_ChangeIncomePayment (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_ChangeIncomePayment(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDate    TDateTime;
  DECLARE vbUnit        Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight(inSession, zc_Enum_Process_UnComplete_ChangeIncomePayment());
    vbUserId := inSession::Integer; 
    
    -- ����������� ��������
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 21.12.15                                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_ChangeIncomePayment (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
