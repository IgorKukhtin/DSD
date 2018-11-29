-- Function: gpInsertUpdate_MovementItem_PromoCode()

DROP FUNCTION IF EXISTS gpUpdate_MI_Promo_Checked (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Promo_Checked(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inIsChecked           Boolean   , -- �������
   OUT outIsChecked          Boolean   ,
   OUT outIsReport           Boolean   ,
    IN inSession             TVarChar    -- ������ ������������
)

RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    
     -- ���������� �������
     outIsChecked := inIsChecked;
     outIsReport  := NOT outIsChecked;
     

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), inId, outIsChecked);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.11.18         *
*/