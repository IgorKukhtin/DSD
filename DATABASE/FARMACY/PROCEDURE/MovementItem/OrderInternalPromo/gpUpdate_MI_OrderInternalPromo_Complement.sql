-- Function: gpUpdate_MI_OrderInternalPromo_Complement()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternalPromo_Complement (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternalPromo_Complement(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inisComplement        Boolean   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS 
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
      
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Complement(), inId, inisComplement);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 13.11.20                                                      *
*/