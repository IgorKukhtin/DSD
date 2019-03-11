-- Function: gpInsert_MovementItem_EmployeeSchedule_PreviousMonth()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_EmployeeSchedule_PreviousMonth(INTEGER, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_EmployeeSchedule_PreviousMonth(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbOperDate TDateTime;
   DECLARE vbPreviousId Integer;
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    -- �������� ���� ������������ �� ����� ���������
    IF 758920 <> inSession::Integer AND 4183126 <> inSession::Integer AND 9383066  <> inSession::Integer
    THEN
      RAISE EXCEPTION '��������� <������ ������ �����������> ��� ���������.';
    END IF;

    IF COALESCE(inMovementId, 0) = 0
    THEN
      RAISE EXCEPTION '�� �������� ������ ������ �����������.';
    END IF;

    SELECT Movement.OperDate
    INTO vbOperDate
    FROM Movement
    WHERE Movement.Id = inMovementId;

    IF EXISTS(SELECT 1 FROM Movement
              WHERE Movement.OperDate = vbOperDate - INTERVAL '1 MONTH'
                AND Movement.DescId = zc_Movement_EmployeeSchedule())
    THEN
      SELECT Movement.Id
      INTO vbPreviousId
      FROM Movement
      WHERE Movement.OperDate = vbOperDate - INTERVAL '1 MONTH'
         AND Movement.DescId = zc_Movement_EmployeeSchedule();
    ELSE
      RAISE EXCEPTION '�� ������ ������ ������ ����������� �� ���������� �����.';
    END IF;

    -- ���������
    PERFORM lpInsertUpdate_MovementItem_EmployeeSchedule (ioId                  := 0                                  -- ���� ������� <������� ���������>
                                                        , inMovementId          := inMovementId                       -- ���� ���������
                                                        , inPersonId            := MovementItem.ObjectId              -- ���������
                                                        , inComingValueDay      := MIString_ComingValueDay.ValueData  -- ������� �� ������ �� ����
                                                        , inUserId              := vbUserId                           -- ������������
                                                         )
    FROM Movement

         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                AND MovementItem.DescId = zc_MI_Master()

         INNER JOIN MovementItemString AS MIString_ComingValueDay
                                       ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                      AND MIString_ComingValueDay.MovementItemId = MovementItem.Id

    WHERE Movement.ID = vbPreviousId
      AND MovementItem.IsErased = FALSE
      AND MovementItem.ObjectId NOT IN (SELECT MovementItem.ObjectId 
                                        FROM MovementItem 
                                        WHERE MovementItem.MovementId = inMovementId
                                          AND MovementItem.DescId = zc_MI_Master())
    ORDER BY MovementItem.ObjectId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
28.02.19                                                        *

*/

-- ����
-- select * from gpInsert_MovementItem_EmployeeSchedule_PreviousMonth(inMovementId := 12604182 ,  inSession := '4183126');