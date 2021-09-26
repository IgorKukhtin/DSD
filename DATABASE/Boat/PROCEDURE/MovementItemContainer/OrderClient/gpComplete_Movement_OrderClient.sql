-- Function: gpComplete_Movement_OrderClient()

DROP FUNCTION IF EXISTS gpComplete_Movement_OrderClient  (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_OrderClient  (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_OrderClient(
    IN inMovementId        Integer               , -- ���� ���������
    IN inIsChild_Recalc    Boolean               , -- �������� �������������
    IN inSession           TVarChar                -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);
 
    -- ���������� ��������
    PERFORM lpComplete_Movement_OrderClient (inMovementId     -- ���� ���������
                                           , inIsChild_Recalc -- �������� �������������
                                           , vbUserId         -- ������������  
                                            );

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.02.21         *
 */