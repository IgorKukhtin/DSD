-- Function: lpInsertUpdate_MovementItem_RepriceChange()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_RepriceChange (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_RepriceChange (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_RepriceChange(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inJuridicalId         Integer   , -- ���������
    IN inContractId          Integer   , -- �������
    IN inExpirationDate      TDateTime , -- ���� ��������
    IN inMinExpirationDate   TDateTime , -- ���� �������� �������
    IN inAmount              TFloat    , -- ����������
    IN inPriceOld            TFloat    , -- ����
    IN inPriceNew            TFloat    , -- ����� ����
    IN inJuridical_Price     TFloat    , -- ���� ����������
    IN inJuridical_Percent   TFloat    , -- % ������������� ������� ����������
    IN inContract_Percent    TFloat    , -- % ������������� ������� ��������
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

    -- ��������� <���� ����������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_JuridicalPrice(), ioId, inJuridical_Price);
    -- ��������� <% ������������� ������� ����������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_JuridicalPercent(), ioId, inJuridical_Percent);
    -- ��������� <% ������������� ������� ��������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContractPercent(), ioId, inContract_Percent);

    -- ��������� <���� ��������>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDate(), ioId, inExpirationDate);
    -- ��������� <���� �������� �������>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_MinExpirationDate(), ioId, inMinExpirationDate);
    -- ��������� ����� � <���������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), ioId, inJuridicalId);
    -- ��������� ����� � <�������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);


    -- ����������� �������� ����� �� ���������
    PERFORM lpInsertUpdate_MovementFloat_TotalSummRepriceChange (inMovementId);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.08.18         *
 */