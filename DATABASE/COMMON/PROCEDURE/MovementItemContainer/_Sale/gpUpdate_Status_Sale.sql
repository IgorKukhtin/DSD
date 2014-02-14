-- Function: gpUpdate_Status_Sale()

DROP FUNCTION IF EXISTS gpUpdate_Status_Sale (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_Sale(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_Sale (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_Sale (inMovementId, FALSE,inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_Sale (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.10.13                                        *
 06.10.13                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_Sale (ioId:= 0, inSession:= zfCalc_UserAdmin())
