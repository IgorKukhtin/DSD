-- Function: gpUpdateMovementItem_Close()

DROP FUNCTION IF EXISTS gpUpdateMovementItem_Close (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovementItem_Close(
    IN inId                  Integer   , -- ���� ������� <>
 INOUT ioisClose             Boolean   , -- ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);  

     -- ���������� �������
     ioisClose:= NOT ioisClose;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Close(), inId, ioisClose);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 31.05.17         * 
*/


-- ����
-- select * from gpUpdateMovementItem_Close(inId := 76083510 , ioisClose := 'False' ,  inSession := '5');
