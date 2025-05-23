-- Function: gpUpdate_Movement_VIP()

DROP FUNCTION IF EXISTS gpUpdate_Movement_VIP(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_VIP(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inManagerId           Integer   , -- � ���������
    IN inBayerName           TVarChar  , -- ��� ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  
  IF COALESCE(inManagerId,0) <> 0 THEN
  -- ����������� ���������
    Perform lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CheckMember(), inMovementId, inManagerId);
  --����������� ��� ����������
    Perform lpInsertUpdate_MovementString(zc_MovementString_Bayer(), inMovementId, inBayerName);
  END IF;
  --�������� �������� ��� ����������
  Perform lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), inMovementId, True);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 03.07.15                                                                       *
*/

-- ����
--Select Max(Id) from Object Where DescId = zc_Object_Member()
-- SELECT * FROM gpUpdate_Movement_VIP (inMovementId:= 12810, inManagerId:=396592, inBayerName:= 'Test', inSession:= '3')

