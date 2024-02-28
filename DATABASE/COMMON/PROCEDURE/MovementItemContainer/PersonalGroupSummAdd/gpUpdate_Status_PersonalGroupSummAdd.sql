-- Function: gpUpdate_Status_PersonalGroupSummAdd()

DROP FUNCTION IF EXISTS gpUpdate_Status_PersonalGroupSummAdd (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_PersonalGroupSummAdd(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
BEGIN

     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_PersonalGroupSummAdd (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_PersonalGroupSummAdd (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_PersonalGroupSummAdd (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.02.24         *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_PersonalGroupSummAdd (ioId:= 0, inSession:= zfCalc_UserAdmin())
