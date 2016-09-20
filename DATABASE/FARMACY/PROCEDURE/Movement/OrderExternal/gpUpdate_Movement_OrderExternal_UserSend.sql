-- Function: gpUpdate_Movement_OrderExternal_UserSend()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_UserSend (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderExternal_UserSend(
    IN inId                  Integer   , -- ���� ������� <�������� �����������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN

    vbUserId := inSession;

    -- ��������� �������� <���� �������������>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), inId, CURRENT_TIMESTAMP);
    -- ��������� �������� <������������ (�������������)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), inId, vbUserId);
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 20.09.16         *
 */

-- ����
-- SELECT * FROM gpUpdate_Movement_OrderExternal_UserSend (inId:= 0, inSession:= '2')
