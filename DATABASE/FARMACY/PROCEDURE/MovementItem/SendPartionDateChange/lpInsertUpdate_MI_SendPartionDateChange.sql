-- Function: lpInsertUpdate_MI_SendPartionDateChange()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SendPartionDateChange (Integer, Integer, Integer, TFloat, TDateTime, Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_SendPartionDateChange(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inNewExpirationDate   TDateTime , -- ����� ���� ��������
    IN inContainerId         Integer   , -- ���������
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

     -- ��������� <���-�� ������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDate(), ioId, inNewExpirationDate);
 
    -- ��������� <���-�� ������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, inContainerId);
      
     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_SendPartionDateChange_TotalSumm (inMovementId);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 02.07.20                                                                      * 
 */

-- ����
-- SELECT * FROM lpInsertUpdate_MI_SendPartionDateChange (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inSession:= '3')
