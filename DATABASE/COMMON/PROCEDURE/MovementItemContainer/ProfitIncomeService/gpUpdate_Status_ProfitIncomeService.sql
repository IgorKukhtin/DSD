-- Function: gpUpdate_Status_ProfitIncomeService()

DROP FUNCTION IF EXISTS gpUpdate_Status_ProfitIncomeService (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_ProfitIncomeService(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN

     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_ProfitIncomeService (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_ProfitIncomeService (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_ProfitIncomeService (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.03.14         *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_ProfitIncomeService (ioId:= 0, inSession:= zfCalc_UserAdmin())