-- Function: lpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������������>
    IN inGoodsId             Integer   , -- �����
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inSumm                TFloat    , -- �����
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- ��������� �������� <�����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);

     -- ��������� �������� <����������>
     IF COALESCE(inComment,'') <> COALESCE((SELECT ValueData FROM MovementItemString Where MovementItemId = ioId AND DescId = zc_MIString_Comment()),'')
     THEN
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�
 11.07.15                                                                     *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_Inventory (ioId:= 0, inMovementId:= 0, inGoodsId:= 1, inAmount:= 0, inPrice:= 1, inSumm:= 0, inSession:= '3')
