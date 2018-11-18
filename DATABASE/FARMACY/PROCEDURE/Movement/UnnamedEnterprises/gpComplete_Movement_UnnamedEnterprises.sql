-- Function: gpComplete_Movement_UnnamedEnterprises()

DROP FUNCTION IF EXISTS gpComplete_Movement_UnnamedEnterprises  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_UnnamedEnterprises (
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
  vbUserId:= inSession;

  IF not EXISTS(SELECT 1 FROM MovementLinkMovement
            WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
              AND MovementLinkMovement.MovementId = inMovementId)
  THEN
    RAISE EXCEPTION '������. �� ������� �����������  �� ������� �������...';
  END IF;

  -- ����������� �������� ����� �� ���������
  PERFORM lpInsertUpdate_MovementFloat_TotalSummUnnamedEnterprisesExactly (inMovementId);
  
  -- �������� ������
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

  -- ��������� ��������
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.   ������ �.�.
 18.11.18                                                                        *
 */
 