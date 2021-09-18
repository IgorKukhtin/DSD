-- Function: gpUpdate_Status_WagesVIP()

DROP FUNCTION IF EXISTS gpUpdate_Status_WagesVIP (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_WagesVIP(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_WagesVIP (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_WagesVIP (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_WagesVIP (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.09.21                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_WagesVIP (ioId:= 0, inSession:= zfCalc_UserAdmin())