-- Function: gpUpdate_Status_CompetitorMarkups()

DROP FUNCTION IF EXISTS gpUpdate_Status_CompetitorMarkups (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_CompetitorMarkups(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_CompetitorMarkups (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_CompetitorMarkups (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_CompetitorMarkups (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.05.22                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_CompetitorMarkups (ioId:= 0, inSession:= zfCalc_UserAdmin())