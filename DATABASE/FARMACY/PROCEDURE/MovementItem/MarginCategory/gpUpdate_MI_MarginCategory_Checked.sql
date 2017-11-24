-- Function: gpUpdate_MI_MarginCategory_Checked()

DROP FUNCTION IF EXISTS gpUpdate_MI_MarginCategory_Checked (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_MarginCategory_Checked(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inisChecked           Boolean  , -- 
   OUT outisChecked          Boolean   ,
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
     outisChecked:= NOT inisChecked;


     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), inId, outisChecked);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 24.11.17         *
*/

-- ����