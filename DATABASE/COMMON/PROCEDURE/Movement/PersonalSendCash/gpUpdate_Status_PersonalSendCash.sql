-- Function: gpUpdate_Status_PersonalSendCash()

DROP FUNCTION IF EXISTS gpUpdate_Status_PersonalSendCash (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_PersonalSendCash(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
BEGIN

     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_PersonalSendCash (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.10.13                                        *
 04.10.13                        *
*/

-- ����
-- select  * from gpUpdate_Status_PersonalSendCash (inMovementId  := 149722, inStatusCode  := 2, inSession:= '2')
