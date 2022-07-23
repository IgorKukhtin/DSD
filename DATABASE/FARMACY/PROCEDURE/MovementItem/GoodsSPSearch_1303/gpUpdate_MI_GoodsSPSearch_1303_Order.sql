-- Function: gpUpdate_MI_GoodsSPSearch_1303_Order()

DROP FUNCTION IF EXISTS gpUpdate_MI_GoodsSPSearch_1303_Order (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_GoodsSPSearch_1303_Order(
    IN inId                  Integer   ,    -- ���� ������� <������� ���������>
    IN inOrderNumberSP       Integer   ,    -- � �����, � ����� ������� ��(���. ������)(12)
    IN inOrderDateSP         TDateTime ,    -- ���� ������, � ����� ������� ��(���. ������)(12)
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    
    IF COALESCE (inId, 0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';    
    END IF;
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OrderNumberSP(), inId, inOrderNumberSP);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OrderDateSP(), inId, inOrderDateSP);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.07.22                                                       *
*/
-- select * from gpUpdate_MI_GoodsSPSearch_1303_Order(inId := 523696543 , inMovementId := 28341113 , inGoodsID := 12006218 , inCol := 6995 ,  inSession := '3');