-- Function: gpInsertUpdate_MovementItem_MarginCategory_Master()

DROP FUNCTION IF EXISTS gpUpdate_MI_MarginCategory_Master (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_MarginCategory_Master (Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_MarginCategory_Master(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inisChecked           Boolean   , -- 
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

     -- ��������� �������� <��� ����>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), inId, inisChecked);
     
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