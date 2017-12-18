-- Function: gpInsertUpdate_MovementItem_PromoCode()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoCode_Checked (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoCode_Checked(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inIsChecked           Boolean   , -- �������
    IN inSession             TVarChar    -- ������ ������������
)

RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (inId, 0) = 0;
    
    -- ��������� <������� ���������>
    inId := lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, (CASE WHEN inIsChecked = TRUE THEN 1 ELSE 0 END) ::TFloat, NULL);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, vbIsInsert);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 13.12.17         *
*/