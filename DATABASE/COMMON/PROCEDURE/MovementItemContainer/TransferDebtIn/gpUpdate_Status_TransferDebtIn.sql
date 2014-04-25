-- Function: gpUpdate_Status_TransferDebtIn()

DROP FUNCTION IF EXISTS gpUpdate_Status_TransferDebtIn (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_TransferDebtIn(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_TransferDebtIn (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_TransferDebtIn (inMovementId, FALSE,inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_TransferDebtIn (inMovementId, inSession);
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
-- SELECT * FROM gpUpdate_Status_TransferDebtIn (ioId:= 0, inSession:= zfCalc_UserAdmin())
