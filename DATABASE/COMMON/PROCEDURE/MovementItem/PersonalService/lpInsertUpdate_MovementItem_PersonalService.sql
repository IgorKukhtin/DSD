-- Function: lpInsertUpdate_MovementItem_PersonalService()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PersonalService(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPersonalId          Integer   , -- ����������
    IN inSummService         TFloat    , -- ����� ���������
    IN inSummCard            TFloat    , -- ����� �� �������� (��)
    IN inSummMinus           TFloat    , -- ����� ���������
    IN inSummAdd             TFloat    , -- ����� ������
    IN inComment             TVarChar  , -- 
    IN inInfoMoneyId         Integer   , -- ������ ����������
    IN inUnitId              Integer   , -- �������������
    IN inPositionId          Integer   , -- ���������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbAmount TFloat;
BEGIN

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;
     
     -- ������������ ����� � �������
     vbAmount:= inSummService - inSummMinus + inSummAdd;
     
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonalId, inMovementId, vbAmount, NULL);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummService(), ioId, inSummService);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(), ioId, inSummCard);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMinus(), ioId, inSummMinus);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAdd (), ioId, inSummAdd );

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), ioId, inPositionId);

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
 11.09.14         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_PersonalService (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
