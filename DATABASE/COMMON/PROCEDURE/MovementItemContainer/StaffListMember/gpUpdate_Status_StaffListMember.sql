-- Function: gpUpdate_Status_StaffList()

DROP FUNCTION IF EXISTS gpUpdate_Status_StaffList (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_StaffList(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
BEGIN

     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            --
            PERFORM gpUnComplete_Movement (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            --
            PERFORM gpComplete_Movement_StaffList (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            --
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
 22.08.25         *
*/

-- ����
--