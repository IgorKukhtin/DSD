-- Function: gpUpdate_Status_HospitalDoc_1C()

DROP FUNCTION IF EXISTS gpUpdate_Status_HospitalDoc_1C (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_HospitalDoc_1C(
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
            PERFORM gpComplete_Movement_HospitalDoc_1C (inMovementId, inSession);
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
 23.07.25         *
*/

-- ����
--