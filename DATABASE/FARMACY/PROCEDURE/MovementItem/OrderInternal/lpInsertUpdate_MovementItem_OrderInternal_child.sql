-- Function: lpInsertUpdate_MovementItem_OrderInternal_child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderInternal_child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, TDateTime, TVarChar, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderInternal_child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, TDateTime, TVarChar, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderInternal_child(
 INOUT ioId                        Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                Integer   , -- ���� ������� <��������>
    IN inParentId                  Integer   , -- 
    IN inGoodsId                   Integer   , -- ����� ����������
    IN inAmount                    TFloat    , -- 
    IN inPrice                     TFloat    , -- 
    IN inJuridicalPrice            TFloat    , -- 
    IN inDefermentPrice            TFloat    , -- 
    IN inPriceListMovementItemId   Integer   , -- 
    IN inPartionGoods              TDateTime , -- 
    IN inMaker                     TVarChar  , -- 
    IN inJuridicalId               Integer   , --
    IN inContractId                Integer   , --
    IN inUserId                    Integer     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;


    -- ��������
    IF COALESCE (inParentId, 0) = 0
    THEN
        -- RETURN;
        RAISE EXCEPTION '������. � �������� child �������� ParentId �� ����� ���� 0.';
    END IF;


    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId);

    -- ��������� ��������
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
    -- ��������� ��������
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_JuridicalPrice(), ioId, inJuridicalPrice);
        -- ��������� ��������
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DefermentPrice(), ioId, inDefermentPrice);
    -- ��������� ��������
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inPriceListMovementItemId);

    -- ��������� ��������
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoods);
    -- ��������� ��������
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Maker(), ioId, inMaker);

     -- ��������� �����
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), ioId, inJuridicalId);
     -- ��������� �����
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.04.19         * inDefermentPrice
 23.10.14                         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_OrderInternal_child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
