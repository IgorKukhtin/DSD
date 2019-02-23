-- Function: gpUpdateMovement_isMail()

DROP FUNCTION IF EXISTS gpUpdateMovement_isMail (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_isMail(
    IN inId                  Integer   , -- ���� ������� <��������>
 INOUT inIsMail              Boolean   , -- ��������� �� ����� (��/���)
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- ��������
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= inSession;  --  lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

     -- ���������� �������
     -- inIsMail:= NOT inIsMail;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isMail(), inId, inIsMail);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.03.19                                        *
*/


-- ����
-- SELECT * FROM gpUpdateMovement_isMail (inId:= 275079, inIsMail:= FALSE, inSession:= zfCalc_UserAdmin())
