-- Function: gpUpdate_Status_TaxCorrective()

DROP FUNCTION IF EXISTS gpUpdate_Status_TaxCorrective (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_TaxCorrective(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_TaxCorrective (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_TaxCorrective (inMovementId, FALSE,inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_TaxCorrective (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 14.02.14                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_TaxCorrective (ioId:= 0, inSession:= zfCalc_UserAdmin())
