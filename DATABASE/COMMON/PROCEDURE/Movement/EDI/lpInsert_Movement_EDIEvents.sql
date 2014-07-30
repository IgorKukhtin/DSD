-- Function: gpInsertUpdate_MI_EDI()

DROP FUNCTION IF EXISTS lpInsert_Movement_EDIEvents(Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_EDIEvents(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inEDIEvent            TVarChar  , -- �������� �������
    IN inUserId              Integer     -- ������������
)                              
RETURNS VOID AS
$BODY$
DECLARE
  vbXML TVarChar;
BEGIN

  vbXML := '<XML><EDIEvent Value = "' || replace(inEDIEvent, '"', '&quot;') || '"/></XML>';

  -- ���������
  INSERT INTO MovementProtocol (MovementId, OperDate, UserId, ProtocolData, isInsert)
                       VALUES (inMovementId, current_timestamp, inUserId, vbXML, null);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.06.14                         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_EDI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
