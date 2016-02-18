-- Function: lpInsertUpdate_MovementItem_Reprice()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Reprice (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Reprice (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Reprice (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Reprice(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inJuridicalId         Integer   , -- ���������
    IN inExpirationDate      TDateTime , -- ���� ��������
    IN inMinExpirationDate   TDateTime , -- ���� �������� �������
    IN inAmount              TFloat    , -- ����������
    IN inPriceOld            TFloat    , -- ����
    IN inPriceNew            TFloat    , -- �����
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
    
    -- ��������� <���� ������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPriceOld);

    -- ��������� <���� �����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, inPriceNew);

    -- ��������� <���� ��������>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDate(), ioId, inExpirationDate);
    -- ��������� <���� �������� �������>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_MinExpirationDate(), ioId, inMinExpirationDate);
    -- ��������� ����� � <���������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), ioId, inJuridicalId);


    -- ����������� �������� ����� �� ���������
    PERFORM lpInsertUpdate_MovementFloat_TotalSummReprice (inMovementId);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�,
 27.11.15                                                                       *
 */