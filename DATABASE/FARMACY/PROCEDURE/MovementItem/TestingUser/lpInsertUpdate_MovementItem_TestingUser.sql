-- Function: lpInsertUpdate_MovementItem_TestingUser()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_TestingUser (Integer, Integer, Integer, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_TestingUser(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUserId              Integer   , -- ���������
    IN inResult              TFloat    , -- ��������� �����
    IN inDateTest            TDateTime , -- ���� �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
BEGIN

     -- ��������� ���� ��� ���� �� ������ ����������
     IF COALESCE (inMovementId, 0) = 0
     THEN
       inMovementId := lpInsertUpdate_Movement_TestingUser(inMovementId, inDateTest, inSession);
     END IF;

     -- ��������� ���� ��� ���� �� ������ ����������
     IF COALESCE (ioId, 0) = 0 AND EXISTS(SELECT Id FROM MovementItem WHERE MovementId = inMovementId AND ObjectId = inUserId)
     THEN
       SELECT Id
       INTO ioId
       FROM MovementItem
       WHERE MovementId = inMovementId
         AND ObjectId = inUserId;
     END IF;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inUserId, inMovementId, inResult, NULL);

     -- ��������� �������� <���� �����>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inDateTest);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������ �.�.
 11.09.18        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_TestingUser (ioId:= 0, inMovementId:= 0, inUserId:= 6002014, inResult:= 102, inDateTest:= '20180901', inSession:= '3')