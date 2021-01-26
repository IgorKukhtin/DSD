-- Function: lpInsertUpdate_MovementItem_TestingUser()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_TestingUser (Integer, Integer, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_TestingUser(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inUserId              Integer   , -- ���������
    IN inResult              TFloat    , -- ��������� �����
    IN inDateTest            TDateTime , -- ���� �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
  DECLARE vbAttempts Integer = 0;
  DECLARE vbResult TFloat = 0;
  DECLARE vbMovement Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbDateTest TDateTime;
BEGIN

  -- �������� ���� � ������� ����� ������
  vbOperDate := date_trunc('month', inDateTest);

  IF NOT EXISTS(SELECT Id FROM Movement WHERE DescId = zc_Movement_TestingUser() AND OperDate = vbOperDate)
  THEN
    vbMovement := lpInsertUpdate_Movement_TestingUser(ioId          := 0,
                                                      inOperDate    := vbOperDate, -- ���� ���������
                                                      inVersion     := 0,          -- ������ ������
                                                      inQuestion    := 0,          -- ���������� ��������
                                                      inMaxAttempts := 0,          -- ���������� �������
                                                      inSession     := inSession); -- ������ ������������
  ELSE 
     SELECT Id
     INTO vbMovement
     FROM Movement
     WHERE DescId = zc_Movement_TestingUser()
       AND OperDate = vbOperDate;
  END IF;

  IF COALESCE (vbMovement, 0) = 0
  THEN
    RAISE EXCEPTION '������. �� ������ �������� �� �����';
  END IF;

   -- ��������� ���� ��� ���� �� ������ ����������
  IF COALESCE (ioId, 0) = 0 AND EXISTS(SELECT Id FROM MovementItem WHERE MovementId = vbMovement AND ObjectId = inUserId)
  THEN
    SELECT Id, Amount, COALESCE(MovementItemFloat.ValueData, 0), COALESCE(MovementItemDate.ValueData, vbOperDate)
    INTO ioId, vbResult, vbAttempts, vbDateTest
    FROM MovementItem
         LEFT OUTER JOIN MovementItemFloat ON MovementItemFloat.DescId = zc_MIFloat_TestingUser_Attempts()
                                          AND MovementItemFloat.MovementItemId = MovementItem.Id
         LEFT JOIN MovementItemDate ON MovementItemDate.MovementItemId = MovementItem.Id
                                    AND MovementItemDate.DescId = zc_MIDate_TestingUser()
    WHERE MovementItem.MovementId = vbMovement
      AND MovementItem.ObjectId = inUserId;
  ELSE
    IF COALESCE (ioId, 0) <> 0
    THEN
      SELECT Amount, COALESCE(MovementItemFloat.ValueData, 0), COALESCE(MovementItemDate.ValueData, vbOperDate)
      INTO vbResult, vbAttempts, vbDateTest
      FROM MovementItem
           LEFT OUTER JOIN MovementItemFloat ON MovementItemFloat.DescId = zc_MIFloat_TestingUser_Attempts()
                                            AND MovementItemFloat.MovementItemId = MovementItem.Id
           LEFT JOIN MovementItemDate ON MovementItemDate.MovementItemId = MovementItem.Id
                                     AND MovementItemDate.DescId = zc_MIDate_TestingUser()
      WHERE MovementItem.Id = ioId;
    ELSE
      vbResult := 0;
      vbAttempts := 0;
      vbDateTest := vbOperDate;
    END IF;
  END IF;

  if COALESCE (ioId, 0) = 0 OR (inResult >= 85 OR vbResult < 85) AND vbDateTest < inDateTest
  THEN

     -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inUserId, vbMovement, CASE WHEN inResult > vbResult THEN inResult ELSE vbResult END, NULL);

     -- ��������� �������� <���� �����>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_TestingUser(), ioId, inDateTest);

     -- ��������� �������� <���������� �������>
    IF vbAttempts = 0 OR vbResult < 85
    THEN 
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TestingUser_Attempts(), ioId, vbAttempts + 1);
    END IF;
      
  END IF;

   -- ��������� ��������
  -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������ �.�.
 26.01.21        *
 25.06.19        *
 15.10.18        *
 11.09.18        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_TestingUser (ioId:= 0, inUserId:= 6002014, inResult:= 102, inDateTest:= '20180901', inSession:= '3')