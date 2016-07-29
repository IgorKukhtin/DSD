-- Function: lpInsertUpdate_MovementItem_IncomeAsset()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_IncomeAsset (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_IncomeAsset(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inAssetId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inCountForPrice       TFloat    , -- ���� �� ����������
    IN inMIId_Invoice        TFloat    , --
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� - ��������� ��������� �������� ������
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= '���������');


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inAssetId, inMovementId, inAmount, NULL);
   
     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- ��������� �������� <���� �� ����������>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inMIId_Invoice);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.07.16         * 
*/

-- ����
--