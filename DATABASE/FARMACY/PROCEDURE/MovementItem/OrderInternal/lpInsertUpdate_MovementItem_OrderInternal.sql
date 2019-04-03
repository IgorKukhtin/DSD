-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderInternal(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountManual        TFloat    , -- ���������� ������
    IN inPrice               TFloat    , -- ����� ������
    IN inUserId              Integer    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
    DECLARE vbMinimumLot TFloat;
BEGIN
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- �������� ��� � ������ �������� �� ���� (����� ������� ��������� - �.�. ������ ����)
     IF vbIsInsert = TRUE AND EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = inGoodsId AND MovementItem.isErased = FALSE)
     THEN
         RAISE EXCEPTION '������.%��� ������ <%> ��� ������������ ���-�� ������ = <%>.%�������� � ���� ������ �� <F5>.', CHR (13), lfGet_Object_ValueData (inGoodsId), (SELECT SUM (MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = inGoodsId AND MovementItem.isErased = FALSE), CHR (13);
     END IF;


    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

    IF inAmountManual IS NULL 
    THEN
        SELECT MinimumLot INTO vbMinimumLot
        FROM Object_Goods_View 
        WHERE Id = inGoodsId
        and MinimumLot <> 0;
    
        SELECT
            (CEIL((inAmount + COALESCE(MIFloat_AmountSecond.ValueData,0) + COALESCE(MIFloat_ListDiff.ValueData,0)) / COALESCE(vbMinimumLot, 1)) * COALESCE(vbMinimumLot, 1))
        INTO
            inAmountManual
        FROM
            MovementItem
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                              ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_ListDiff
                                              ON MIFloat_ListDiff.MovementItemId = MovementItem.Id
                                             AND MIFloat_ListDiff.DescId = zc_MIFloat_ListDiff()
        WHERE
            Id = ioId;
    END IF;
    -- ��������� �������� <������ ����������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), ioId, COALESCE(inAmountManual, 0));

    
    -- ��������� �������� <����� ������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, COALESCE(inPrice, 0));

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.10.14                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderInternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
