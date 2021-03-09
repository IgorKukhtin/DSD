-- Function: lpInsertUpdate_MovementItem_ProfitLossResult()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ProfitLossResult (Integer, Integer, Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ProfitLossResult(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inAccountId           Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inContainerId         TFloat   , -- ������ ��
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
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inAccountId, inMovementId, inAmount, null);

     -- ��������� �������� <������ ��>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, inContainerId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.03.21         *
*/

-- ����