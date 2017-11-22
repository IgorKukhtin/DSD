-- Function: gpInsertUpdate_MovementItem_MarginCategory_Master()

DROP FUNCTION IF EXISTS gpUpdate_MI_MarginCategory_Master (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_MarginCategory_Master(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inComment             TVarChar  , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), inId, inComment);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 21.11.17         *
*/

-- ����