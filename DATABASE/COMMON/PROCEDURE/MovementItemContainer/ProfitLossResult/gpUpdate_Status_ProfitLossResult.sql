-- Function: gpUpdate_Status_ProfitLossResult()

DROP FUNCTION IF EXISTS gpUpdate_Status_ProfitLossResult (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_ProfitLossResult(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_ProfitLossResult (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_ProfitLossResult (inMovementId, FALSE,inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_ProfitLossResult (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.03.21         *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_ProfitLossResult (ioId:= 0, inSession:= zfCalc_UserAdmin())