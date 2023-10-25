-- Function: gpUpdate_Status_ConvertRemains()

DROP FUNCTION IF EXISTS gpUpdate_Status_ConvertRemains (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_ConvertRemains(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_ConvertRemains (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_ConvertRemains (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_ConvertRemains (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.10.2023                                                     *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_ConvertRemains (ioId:= 0, inSession:= zfCalc_UserAdmin())