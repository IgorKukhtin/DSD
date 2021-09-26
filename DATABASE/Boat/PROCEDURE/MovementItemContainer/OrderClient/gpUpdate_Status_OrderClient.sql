-- Function: gpUpdate_Status_OrderClient()

DROP FUNCTION IF EXISTS gpUpdate_Status_OrderClient (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Status_OrderClient (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_OrderClient(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inIsChild_Recalc      Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_OrderClient (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_OrderClient (inMovementId:= inMovementId, inIsChild_Recalc:= inIsChild_Recalc, inSession:= inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_OrderClient (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.02.21         *
 */