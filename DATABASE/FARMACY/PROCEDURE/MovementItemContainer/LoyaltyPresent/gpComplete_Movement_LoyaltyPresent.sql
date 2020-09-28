-- Function: gpComplete_Movement_LoyaltyPresent()

DROP FUNCTION IF EXISTS gpComplete_Movement_LoyaltyPresent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_LoyaltyPresent(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  
BEGIN
    vbUserId:= inSession;


    -- ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_LoyaltyPresent()
                               , inUserId     := vbUserId
                                );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.09.20                                                       *
 */