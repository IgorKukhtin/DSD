-- Function: gpUpdate_Status_LayoutFile()

DROP FUNCTION IF EXISTS gpUpdate_Status_LayoutFile (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_LayoutFile(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_LayoutFile (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_LayoutFile (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_LayoutFile (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.02.22                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_LayoutFile (ioId:= 0, inSession:= zfCalc_UserAdmin())