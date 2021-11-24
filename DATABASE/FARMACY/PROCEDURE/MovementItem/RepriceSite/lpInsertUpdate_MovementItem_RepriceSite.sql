-- Function: lpInsertUpdate_MovementItem_RepriceSite()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_RepriceSite (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, Boolean, Integer, Integer, TFloat, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_RepriceSite(
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
    IN inisJuridicalTwo      Boolean   , -- ������ �� 2 �����������  
    IN inJuridicalTwoId      Integer   , -- ���������
    IN inContractTwoId       Integer   , -- �������
    IN inJuridical_PriceTwo  TFloat    , -- ���� ����������
    IN inExpirationDateTwo   TDateTime , -- ���� ��������
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

    -- ��������� <���� ��������>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDate(), ioId, inExpirationDate);
    -- ��������� <���� �������� �������>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_MinExpirationDate(), ioId, inMinExpirationDate);
    -- ��������� ����� � <���������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), ioId, inJuridicalId);
    -- ��������� ����� � <�������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);

    IF COALESCE (inisJuridicalTwo, False) = True
    THEN
      -- ��������� <������� ��� ���������>
      PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_JuridicalTwo(), ioId, inisJuridicalTwo);
      
      IF COALESCE (inJuridicalTwoId, 0) <> 0
      THEN
        -- ��������� ����� � <���������>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_JuridicalTwo(), ioId, inJuridicalTwoId);
        -- ��������� ����� � <�������>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractTwo(), ioId, inContractTwoId);
        -- ��������� <���� ����������>
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_JuridicalPriceTwo(), ioId, inJuridical_PriceTwo);      
        -- ��������� <���� ��������>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDateTwo(), ioId, inExpirationDateTwo);
      END IF;    
    END IF;

    -- ����������� �������� ����� �� ���������
    PERFORM lpInsertUpdate_MovementFloat_TotalSummRepriceSite (inMovementId);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 10.06.21                                                      *  
 */