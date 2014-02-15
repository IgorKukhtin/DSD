-- Function: gpInsertUpdate_MI_ProductionUnion_Child()

-- DROP FUNCTION gpInsertUpdate_MI_ProductionUnion_Child();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������������ - ����������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inParentId            Integer   , -- ������� ������� ���������
    IN inAmountReceipt       TFloat    , -- ���������� �� ��������� �� 1 ����� 
    IN inPartionGoodsDate    TDateTime , -- ������ ������	
    IN inPartionGoods        TVarChar  , -- ������ ������        
    IN inComment             TVarChar  , -- �����������
    IN inGoodsKindId         Integer   , -- ���� �������            
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
   vbUserId := inSession;

   -- ��������� <������� ���������>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId);

   -- ��������� �������� <�����������>
   PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
   -- ��������� �������� <���������� �� ��������� �� 1 �����>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReceipt(), ioId, inAmountReceipt);
   
   -- ��������� �������� <������ ������>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
   -- ��������� �������� <������ ������>
   PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);
   
   -- ��������� ����� � <���� �������>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
   
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.07.13                                        * ����� ������� �����
 15.07.13         *     
 30.06.13                                        *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ProductionUnion_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
