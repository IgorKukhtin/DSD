-- Function: gpComplete_Movement_DistributionPromo()

DROP FUNCTION IF EXISTS gpComplete_Movement_DistributionPromo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_DistributionPromo(
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
                               , inDescId     := zc_Movement_DistributionPromo()
                               , inUserId     := vbUserId
                                );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.12.20                                                       *
 */