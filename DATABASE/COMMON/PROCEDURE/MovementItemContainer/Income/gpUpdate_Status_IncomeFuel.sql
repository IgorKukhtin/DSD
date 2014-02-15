-- Function: gpUpdate_Status_IncomeFuel()

DROP FUNCTION IF EXISTS gpUpdate_Status_IncomeFuel (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_IncomeFuel(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
BEGIN

     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_IncomeFuel (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_IncomeFuel (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_IncomeFuel (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.10.13         *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_IncomeFuel (ioId:= 0, inSession:= zfCalc_UserAdmin())
