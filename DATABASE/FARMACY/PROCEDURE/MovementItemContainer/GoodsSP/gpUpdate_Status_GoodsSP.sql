-- Function: gpUpdate_Status_GoodsSP()

DROP FUNCTION IF EXISTS gpUpdate_Status_GoodsSP (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_GoodsSP(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_GoodsSP (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_GoodsSP (inMovementId, TRUE, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_GoodsSP (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.08.18         *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_GoodsSP (ioId:= 0, inSession:= zfCalc_UserAdmin())