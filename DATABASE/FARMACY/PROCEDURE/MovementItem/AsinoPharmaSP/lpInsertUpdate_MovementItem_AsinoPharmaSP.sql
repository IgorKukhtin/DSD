-- Function: lpInsertUpdate_MovementItem_AsinoPharmaSP()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_AsinoPharmaSP (Integer, Integer, Integer, TFloat, TFloat, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_AsinoPharmaSP(
 INOUT ioId                   Integer   , -- ���� ������� <������� ���������>
    IN inMovementId           Integer   ,
    IN inGoodsId              Integer   , -- ������
    IN inPriceOptSP           TFloat  ,
    IN inPriceSale            TFloat  ,
    IN inUserId               Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inPriceSale, NULL);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceOptSP(), ioId, inPriceOptSP);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.04.22                                                       *
 */