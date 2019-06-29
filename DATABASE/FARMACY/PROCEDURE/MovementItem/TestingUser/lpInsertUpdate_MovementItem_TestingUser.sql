-- Function: lpInsertUpdate_MovementItem_TestingUser()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_TestingUser (Integer, Integer, Integer, TFloat, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_TestingUser (Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_TestingUser (Integer, Integer, Integer, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_TestingUser(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUserId              Integer   , -- ���������
    IN inResult              TFloat   , -- ��������� �����
    IN inDateTest            TDateTime , -- ���� �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
  DECLARE vbAttempts Integer = 0;
  DECLARE vbResult TFloat = 0;
BEGIN

  IF COALESCE (inMovementId, 0) = 0
  THEN
    RAISE EXCEPTION '������. �� ������ �������� �� �����';
  END IF;

   -- ��������� ���� ��� ���� �� ������ ����������
  IF COALESCE (ioId, 0) = 0 AND EXISTS(SELECT Id FROM MovementItem WHERE MovementId = inMovementId AND ObjectId = inUserId)
  THEN
    SELECT Id, Amount, COALESCE(MovementItemFloat.ValueData, 0)
    INTO ioId, vbResult, vbAttempts
    FROM MovementItem
         LEFT OUTER JOIN MovementItemFloat ON MovementItemFloat.DescId = zc_MIFloat_TestingUser_Attempts()
                                          AND MovementItemFloat.MovementItemId = MovementItem.Id
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.ObjectId = inUserId;
  ELSE
    IF COALESCE (ioId, 0) <> 0
    THEN
      SELECT Amount, COALESCE(MovementItemFloat.ValueData, 0)
      INTO vbResult, vbAttempts
      FROM MovementItem
           LEFT OUTER JOIN MovementItemFloat ON MovementItemFloat.DescId = zc_MIFloat_TestingUser_Attempts()
                                            AND MovementItemFloat.MovementItemId = MovementItem.Id
      WHERE MovementItem.Id = ioId;
    END IF;
  END IF;

  if COALESCE (ioId, 0) = 0 OR inResult > vbResult
  THEN

     -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inUserId, inMovementId, inResult, NULL);

     -- ��������� �������� <���� �����>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_TestingUser(), ioId, inDateTest);
  END IF;

   -- ��������� �������� <���������� �������>
  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TestingUser_Attempts(), ioId, vbAttempts + 1);


   -- ��������� ��������
  -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������ �.�.
 25.06.19        *
 15.10.18        *
 11.09.18        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_TestingUser (ioId:= 0, inMovementId:= 0, inUserId:= 6002014, inResult:= 102, inDateTest:= '20180901', inSession:= '3')