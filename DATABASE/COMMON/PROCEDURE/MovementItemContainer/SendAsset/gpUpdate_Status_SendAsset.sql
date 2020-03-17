-- Function: gpUpdate_Status_SendAsset()

DROP FUNCTION IF EXISTS gpUpdate_Status_SendAsset (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_SendAsset(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_SendAsset (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_SendAsset (inMovementId, FALSE,inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_SendAsset (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.03.20         *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_SendAsset (ioId:= 0, inSession:= zfCalc_UserAdmin())