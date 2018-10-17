-- Function: lpInsertUpdate_MovementItem_TestingUser()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_TestingUser (Integer, Integer, Integer, TFloat, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_TestingUser (Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_TestingUser(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUserId              Integer   , -- ���������
    IN inResult              Integer   , -- ��������� �����
    IN inAttempts            Integer   , -- ���������� �������
    IN inDateTest            TDateTime , -- ���� �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
BEGIN

  IF COALESCE (inMovementId, 0) = 0
  THEN
    RAISE EXCEPTION '������. �� ������ �������� �� �����';
  END IF;

  IF COALESCE (inResult, -1) < 0 OR COALESCE (inAttempts, 0) < 1
  THEN
    RAISE EXCEPTION '������. �� ������� ���������� ������� ��� ���������� �������';
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

   -- ��������� �������� <���������� �������>
  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TestingUser_Attempts(), ioId, inAttempts);

   -- ��������� �������� <���� �����>
  PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_TestingUser(), ioId, inDateTest);

   -- ��������� ��������
  -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������ �.�.
 15.10.18        *
 11.09.18        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_TestingUser (ioId:= 0, inMovementId:= 0, inUserId:= 6002014, inResult:= 102, inDateTest:= '20180901', inSession:= '3')