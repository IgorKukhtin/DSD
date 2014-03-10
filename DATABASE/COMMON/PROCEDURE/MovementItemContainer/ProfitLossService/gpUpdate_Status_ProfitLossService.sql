-- Function: gpUpdate_Status_ProfitLossService()

DROP FUNCTION IF EXISTS gpUpdate_Status_ProfitLossService (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_ProfitLossService(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN

     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_ProfitLossService (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_ProfitLossService (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_ProfitLossService (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.03.14                                        * 
 17.02.14                                        	        *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_ProfitLossService (ioId:= 0, inSession:= zfCalc_UserAdmin())