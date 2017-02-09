-- Function: gpUpdate_Status_Send()

DROP FUNCTION IF EXISTS gpUpdate_Status_Send (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_Send(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_Send (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_Send (inMovementId, FALSE,inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_Send (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.05.14                                                       *
 05.05.14                                                       *
 29.10.13                                        *
 06.10.13                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_Send (ioId:= 0, inSession:= zfCalc_UserAdmin())