-- Function: gpUpdate_Status_PromoBonus()

DROP FUNCTION IF EXISTS gpUpdate_Status_PromoBonus (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_PromoBonus(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_PromoBonus (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_PromoBonus (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_PromoBonus (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.02.21                                                       * 
*/

-- ����
-- SELECT * FROM gpUpdate_Status_PromoBonus (ioId:= 0, inSession:= zfCalc_UserAdmin())