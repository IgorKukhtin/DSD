-- Function: gpUpdate_Status_WeighingPartner()

DROP FUNCTION IF EXISTS gpUpdate_Status_WeighingPartner (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_WeighingPartner(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
BEGIN

     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_WeighingPartner (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_WeighingPartner (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_WeighingPartner (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.08.16                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_WeighingPartner (ioId:= 0, inSession:= zfCalc_UserAdmin())
