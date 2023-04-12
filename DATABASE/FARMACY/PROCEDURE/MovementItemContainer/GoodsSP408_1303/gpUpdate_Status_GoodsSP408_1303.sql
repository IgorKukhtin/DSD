-- Function: gpUpdate_Status_GoodsSP408_1303()

DROP FUNCTION IF EXISTS gpUpdate_Status_GoodsSP408_1303 (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_GoodsSP408_1303(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_GoodsSP408_1303 (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_GoodsSP408_1303 (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_GoodsSP408_1303 (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.04.23                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_GoodsSP408_1303 (ioId:= 0, inSession:= zfCalc_UserAdmin())