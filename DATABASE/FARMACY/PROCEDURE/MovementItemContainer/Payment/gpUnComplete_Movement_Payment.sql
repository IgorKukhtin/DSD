-- Function: gpUnComplete_Movement_Payment (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Payment (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Payment(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Payment());
    vbUserId := inSession::Integer;
    -- ����������� ������
    PERFORM
        lpUnComplete_Movement (inMovementId := MI_Payment.BankAccountId
                              , inUserId     := vbUserId)
    FROM
        MovementItem_Payment_View AS MI_Payment
    WHERE
        MI_Payment.MovementId = inMovementId
        AND
        MI_Payment.NeedPay = TRUE
        AND
        COALESCE(MI_Payment.BankAccountId,0) > 0;
    -- ����������� ��������
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�
 13.10.15                                                                       *
*/