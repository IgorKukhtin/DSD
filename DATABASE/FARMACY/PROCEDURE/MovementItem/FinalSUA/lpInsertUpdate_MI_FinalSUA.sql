-- Function: lpInsertUpdate_MI_FinalSUA()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_FinalSUA (Integer, Integer, Integer, Integer, TFloat, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_FinalSUA(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inUnitId              Integer   , -- �������������
    IN inAmount              TFloat    , -- ����������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     
     IF COALESCE (ioId, 0) = 0 
        AND EXISTS(SELECT 1
                   FROM MovementItem

                       INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                         ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId = zc_MI_Master()
                     AND MovementItem.ObjectId= inGoodsId
                     AND MILinkObject_Unit.ObjectId = inUnitId)
     THEN
        RAISE EXCEPTION '������. �� ������ � ������������� ������ ���� ���� ������.';     
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;
          
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� <�������������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
       
     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_FinalSUA_TotalSumm (inMovementId);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 11.02.21                                                                      * 
 */

-- ����
-- SELECT * FROM lpInsertUpdate_MI_FinalSUA (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inSession:= '3')