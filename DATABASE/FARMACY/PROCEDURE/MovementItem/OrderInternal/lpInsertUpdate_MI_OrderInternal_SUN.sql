-- Function: lpInsertUpdate_MI_OrderInternal_SUN()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternal_SUN(Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternal_SUN(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderInternal_SUN(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ���������
    IN inAmountReal          TFloat    , -- �������������� ����� ��� ����� ���
    IN inRemainsSUN          TFloat    , -- ������� � ���. ������ ��������
    IN inSendSUN             TFloat    , -- ����������� �� ���
    IN inSendDefSUN          TFloat    , -- ���������� ����������� �� ���
    IN inUserId              Integer     -- ������ ������������
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
              -- ��������� <������� ���������> - �����
              inId := lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL); 
          END IF;
          RAISE EXCEPTION '������.%��� ������ <%> �� ������ ������� ���-�� ������ = <%>.', CHR (13), lfGet_Object_ValueData (inGoodsId), inAmount;
     END IF;

     -- ��������� <������� ���������>
     -- inId := lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
     -- UPDATE MovementItem SET Amount = inAmount WHERE Id = inId;


     -- ��������� �������� <���������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), inId, inAmount);

     -- ��������� �������� <�������������� ��������� ��� ����� ���>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReal(),   inId, inAmountReal);
     -- ��������� �������� <������� � ���. ������ ��������>               
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RemainsSUN(),   inId, inRemainsSUN);

     -- ��������� �������� <����������� �� ���>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SendSUN(),      inId, inSendSUN);
     -- ��������� �������� <���������� ����������� �� ���>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SendDefSUN(),   inId, inSendDefSUN);


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.07.19         *
*/

-- ����
--