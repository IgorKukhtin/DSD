-- Function: gpComplete_Movement_RelatedProduct()

DROP FUNCTION IF EXISTS gpComplete_Movement_RelatedProduct (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_RelatedProduct(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  
BEGIN
    vbUserId:= inSession;

    -- ���������� ��������
    PERFORM lpComplete_Movement_RelatedProduct(inMovementId, -- ���� ���������
                                          vbUserId);    -- ������������  

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.10.20                                                       *
 */