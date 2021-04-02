-- Function: lpInsertUpdate_MovementItem_WagesAdditionalExpenses_SP ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_WagesAdditionalExpenses_SP (Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_WagesAdditionalExpenses_SP(
 INOUT ioId                       Integer   , -- ���� ������� <������� ���������>
    IN inMovementId               Integer   , -- ���� ������� <��������>
    IN inUnitID                   Integer   , -- �������������
    IN inSummaSP                  TFloat    , -- ��
    IN inUserId                   Integer   -- ������������
 )
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
        
    IF vbIsInsert = TRUE
    THEN
       -- ������� <������� ���������>
      ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), inUnitId, inMovementId, 0, 0);
    END IF;
    
     -- ��������� �������� <��>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaSP(), ioId, inSummaSP);

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), inUnitId, inMovementId, lpGet_MovementItem_WagesAE_TotalSum (ioId, inUserId), 0);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.03.21                                                        *
*/

-- ����
-- 