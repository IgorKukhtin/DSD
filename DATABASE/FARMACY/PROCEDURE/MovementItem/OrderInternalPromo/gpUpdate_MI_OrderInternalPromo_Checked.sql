-- Function: gpUpdate_MI_OrderInternalPromo_Checked()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternalPromo_Checked (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternalPromo_Checked(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inisChecked           Boolean   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS 
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
      
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), inId, inisChecked);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 17.07.20                                                      *
*/