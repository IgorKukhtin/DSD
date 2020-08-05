-- Function: gpUpdate_OrderExternal_Status_wms()

DROP FUNCTION IF EXISTS gpUpdate_OrderExternal_Status_wms (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_OrderExternal_Status_wms(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode_wms      Integer   , -- ������ ���. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_OrderExternal_StatusWMS());
     --
     CASE inStatusCode_wms
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Status_wms(), inMovementId, zc_Enum_Status_UnComplete());
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Status_wms(), inMovementId, zc_Enum_Status_Complete());
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Status_wms(), inMovementId, zc_Enum_Status_Erased()); 
         ELSE
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Status_wms(), inMovementId, NULL);
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.08.20         *
*/

-- ����
-- SELECT * FROM gpUpdate_OrderExternal_Status_wms (inMovementId:= 17370654, inStatusCode_wms:=1,  inSession:= zfCalc_UserAdmin())
