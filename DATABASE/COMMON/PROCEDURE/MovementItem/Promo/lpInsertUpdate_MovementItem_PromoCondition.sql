-- Function: lpInsertUpdate_MovementItem_PromoCondition()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoCondition (Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoCondition (Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoCondition(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inConditionPromoId    Integer   , -- ���� ������� <������� ������� � �����>
    IN inAmount              TFloat    , -- % ������ �� �����
    IN inComment             TVarChar  , -- �����������
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
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inConditionPromoId, inMovementId, inAmount, NULL);

    --��������� <�����������>
    PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioId, inComment);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�,
 05.11.15                                                                       *
 */