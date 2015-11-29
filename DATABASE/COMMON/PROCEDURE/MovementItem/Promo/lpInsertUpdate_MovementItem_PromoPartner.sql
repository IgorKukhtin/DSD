-- Function: lpInsertUpdate_MovementItem_PromoPartner()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoPartner (Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoPartner(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPartnerId           Integer   , -- 
    IN inContractId          Integer   , -- 
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
BEGIN
    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPartnerId, inMovementId, 0, NULL);
    
    -- ��������� ����� � <��� ������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);

    -- ��������� ��������
    -- PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�,
 29.11.15                                        *
 */
