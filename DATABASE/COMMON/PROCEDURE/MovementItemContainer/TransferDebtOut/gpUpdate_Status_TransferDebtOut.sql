-- Function: gpUpdate_Status_TransferDebtOut()

DROP FUNCTION IF EXISTS gpUpdate_Status_TransferDebtOut (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_TransferDebtOut(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_TransferDebtOut (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_TransferDebtOut (inMovementId, FALSE,inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_TransferDebtOut (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.04.14         *

*/

-- ����
-- SELECT * FROM gpUpdate_Status_TransferDebtOut (ioId:= 0, inSession:= zfCalc_UserAdmin())
