-- Function: lpInsertUpdate_MI_OrderInternal_ListDiff()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternal_ListDiff(Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternal_ListDiff(Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderInternal_ListDiff(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmountManual        TFloat    , -- ���������� ������
    IN inListDiffAmount      TFloat    , -- ���������� �����
    IN inComment             TVarChar  , --
    IN inUserId              Integer    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (inId, 0) = 0;


     -- ���� ���� = 0
     IF vbIsInsert = TRUE 
     THEN
          IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = inGoodsId AND MovementItem.isErased = FALSE)
          THEN
              RAISE EXCEPTION '������.%��� ������ <%> ��� ������������ ���-�� ������ = <%>.%�������� � ���� ������ �� <F5>.', CHR (13), lfGet_Object_ValueData (inGoodsId), (SELECT SUM (MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = inGoodsId AND MovementItem.isErased = FALSE), CHR (13);
          ELSE
              -- ��������� <������� ���������>
              inId := lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL); 
          END IF;
     END IF;

     -- ��������� �������� ���-�� �����
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ListDiff(), inId, inListDiffAmount);
     -- ��������� �������� <������ ����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), inId, inAmountManual);
     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), inId, inComment);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.11.18         *
*/

-- ����
--