-- Function: lpInsertUpdate_MovementItem_WagesVIP_Calc()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_WagesVIP_Calc (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_WagesVIP_Calc(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUserWagesId         Integer   , -- ���������
    IN inAmountAccrued       TFloat    , -- ����������� �/� ����������	
    IN inApplicationAward    TFloat    , -- ������ �� ����������
    IN inHoursWork           TFloat    , -- ���������� �����
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
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inUserWagesId, inMovementId, inAmountAccrued, NULL);

    -- ��������� �������� <���������� �����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HoursWork(), ioId, inHoursWork);    

    -- ��������� �������� <������ �� ����������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ApplicationAward(), ioId, inApplicationAward);    

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.09.21                                                        *
*/