-- Function: gpUpdate_Status_GoodsAccount()

DROP FUNCTION IF EXISTS gpUpdate_Status_GoodsAccount (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_GoodsAccount(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
BEGIN

     CASE inStatusCode

         WHEN zc_Enum_StatusCode_UnComplete() THEN PERFORM gpUnComplete_Movement_GoodsAccount (inMovementId, inSession);

         WHEN zc_Enum_StatusCode_Complete()   THEN PERFORM gpComplete_Movement_GoodsAccount (inMovementId,inSession);

         WHEN zc_Enum_StatusCode_Erased()     THEN PERFORM gpSetErased_Movement_GoodsAccount (inMovementId, inSession);

         ELSE RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;

     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 18.05.17         *
 */
 
-- ����
-- SELECT * FROM gpUpdate_Status_GoodsAccount (inMovementId:= 1100, inStatusCode:= zc_Enum_StatusCode_UnComplete(), inSession:= zfCalc_UserAdmin())
