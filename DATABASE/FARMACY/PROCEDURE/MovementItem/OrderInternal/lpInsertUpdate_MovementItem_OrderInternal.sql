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

    -- ����������, ������������� �������
    IF inAmountManual IS NULL 
    THEN
        -- MinimumLot
        SELECT Object_Goods_View.MinimumLot
               INTO vbMinimumLot
        FROM Object_Goods_View 
        WHERE Object_Goods_View.Id = inGoodsId
          AND Object_Goods_View.MinimumLot <> 0;

        -- �������� inAmountManual
        SELECT -- ��������� ����� AllLot
               CEIL((-- ��������� + ���������� ��������������                        -- ���-�� �������
                     CASE WHEN (COALESCE (inAmount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)) >= 
                               (COALESCE (MIFloat_ListDiff.ValueData, 0) + COALESCE (MIFloat_SupplierFailures.ValueData, 0) + COALESCE (MIFloat_AmountSUA.ValueData, 0))
                          THEN (COALESCE (inAmount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))         -- ��������� + ���������� ��������������
                          ELSE (COALESCE (MIFloat_ListDiff.ValueData, 0) + COALESCE (MIFloat_SupplierFailures.ValueData, 0) + COALESCE (MIFloat_AmountSUA.ValueData, 0))     -- ���-�� ������� + ���
                     END-- ���������
                    ) / COALESCE (vbMinimumLot, 1)
                   ) * COALESCE (vbMinimumLot, 1)
        INTO
            inAmountManual
        FROM
            MovementItem
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                              ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_ListDiff
                                              ON MIFloat_ListDiff.MovementItemId = MovementItem.Id
                                             AND MIFloat_ListDiff.DescId         = zc_MIFloat_ListDiff()
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_SupplierFailures
                                              ON MIFloat_SupplierFailures.MovementItemId = MovementItem.Id
                                             AND MIFloat_SupplierFailures.DescId         = zc_MIFloat_SupplierFailures()
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSUA
                                              ON MIFloat_AmountSUA.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountSUA.DescId         = zc_MIFloat_AmountSUA()
        WHERE MovementItem.Id = ioId;

    END IF;

    -- ��������� �������� <����������, ������������� �������>
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 22.03.21                                                                     *
 23.10.14                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderInternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')