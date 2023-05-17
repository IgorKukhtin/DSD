-- Function: gpInsertUpdate_MovementItem_SalePromoGoodsSign()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_SalePromoGoods_UnitChecked (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_SalePromoGoods_UnitChecked(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUnitId              Integer   , -- �������������
 INOUT ioIsChecked           Boolean   , -- �������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
  
     -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (inId, 0) = 0;

    IF COALESCE(inId, 0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;
    
    ioIsChecked := NOT ioIsChecked;

    -- ��������� <������� ���������>
    inId := lpInsertUpdate_MovementItem (inId, zc_MI_Sign(), inUnitId, inMovementId, (CASE WHEN ioIsChecked = TRUE THEN 1 ELSE 0 END) ::TFloat, NULL);
         
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.05.23                                                       *
*/

