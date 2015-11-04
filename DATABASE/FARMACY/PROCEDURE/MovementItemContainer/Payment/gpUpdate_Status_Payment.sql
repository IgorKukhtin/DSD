-- Function: gpUpdate_Status_Payment()

DROP FUNCTION IF EXISTS gpUpdate_Status_Payment (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_Payment(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_Payment (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_Payment (inMovementId,inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_Payment (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 13.10.15                                                                      *
 */