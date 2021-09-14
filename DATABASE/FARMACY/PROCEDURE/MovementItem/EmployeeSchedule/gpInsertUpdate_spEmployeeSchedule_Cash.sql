-- Function: gpInsertUpdate_spEmployeeSchedule_Cash()

DROP FUNCTION IF EXISTS gpInsertUpdate_spEmployeeSchedule_Cash(Integer, TDateTime, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_spEmployeeSchedule_Cash(
    IN inUserId              Integer,    -- ���������
    IN inOperDate            TDateTime,  -- ����
    IN inDateStart           TDateTime,  -- ���� �������
    IN inDateEnd             TDateTime,  -- ���� �����
    IN inServiceExit         Boolean,    -- ��������� �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbMovementID Integer;
   DECLARE vbMovementItemID Integer;
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    -- �������� ������� �������
    IF NOT EXISTS(SELECT 1 FROM Movement
              WHERE Movement.OperDate = date_trunc('month', inOperDate)
              AND Movement.DescId = zc_Movement_EmployeeSchedule())
    THEN
      RAISE EXCEPTION '������. ������ ������ ����������� �� ������. ���������� � ��������� �.�.';
    END IF;

    SELECT Movement.ID
    INTO vbMovementID
    FROM Movement
    WHERE Movement.OperDate = date_trunc('month', inOperDate)
      AND Movement.DescId = zc_Movement_EmployeeSchedule();

    IF EXISTS(SELECT 1 FROM MovementItem
              WHERE MovementItem.MovementId = vbMovementID
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.ObjectId = inUserId)
    THEN
      SELECT MovementItem.ID
      INTO vbMovementItemID
      FROM MovementItem
      WHERE MovementItem.MovementId = vbMovementID
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.ObjectId = inUserId;
    ELSE
      -- ���������
      vbMovementItemID := lpInsertUpdate_MovementItem_EmployeeSchedule (ioId                  := 0                 -- ���� ������� <������� ���������>
                                                                      , inMovementId          := vbMovementID      -- ���� ���������
                                                                      , inPersonId            := inUserId          -- ���������
                                                                      , inComingValueDay      := ''::TVarChar      -- ������� �� ������ �� ����
                                                                      , inComingValueDayUser  := ''::TVarChar      -- ������� �� ������ �� ����
                                                                      , inUserId              := vbUserId          -- ������������
                                                                       );

    END IF;

    IF EXISTS(SELECT *
              FROM ObjectBoolean AS ObjectBoolean_WorkingMultiple
              WHERE ObjectBoolean_WorkingMultiple.ObjectId = vbUserId
                AND ObjectBoolean_WorkingMultiple.DescId = zc_ObjectBoolean_User_WorkingMultiple()
                AND ObjectBoolean_WorkingMultiple.ValueData = TRUE)
       AND vbUnitId <> 0
    THEN
        -- ������� ������ �� ���
      IF NOT EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementId = vbMovementID
                  AND MovementItem.DescId = zc_MI_Child()
                  AND MovementItem.ParentId = vbMovementItemID
                  AND MovementItem.ObjectId = vbUserId
                  AND MovementItem.Amount = date_part('DAY', inOperDate)::Integer)
      THEN

        PERFORM gpInsertUpdate_MovementItem_EmployeeSchedule_Child(ioId             := 0, -- ���� ������� <������� ���������>
                                                                   inMovementId     := vbMovementID, -- ���� ���������
                                                                   inParentId       := vbMovementItemID, -- ������� ������
                                                                   inUnitId         := vbUnitId, -- �������������
                                                                   inAmount         := date_part('DAY',  inOperDate)::Integer, -- ���� ������
                                                                   inPayrollTypeID  := -1,
                                                                   inDateStart      := inDateStart, -- ���� ����� ������ �����
                                                                   inDateEnd        := inDateEnd, -- ���� ����� ����� �����
                                                                   inServiceExit    := inServiceExit,  -- ��������� �����
                                                                   inSession        := inSession);
      ELSE
      
        SELECT MovementItem.id
             , MIDate_Start.ValueData
        INTO vbId, inDateStart
        FROM MovementItem
             LEFT JOIN MovementItemDate AS MIDate_Start
                                        ON MIDate_Start.MovementItemId = MovementItem.Id
                                       AND MIDate_Start.DescId = zc_MIDate_Start()
        WHERE MovementItem.MovementId = vbMovementID
          AND MovementItem.DescId = zc_MI_Child()
          AND MovementItem.ParentId = vbMovementItemID
          AND MovementItem.ObjectId = vbUserId
          AND MovementItem.Amount = date_part('DAY', inOperDate)::Integer;

        PERFORM gpInsertUpdate_MovementItem_EmployeeSchedule_Child(ioId             := vbId, -- ���� ������� <������� ���������>
                                                                   inMovementId     := vbMovementID, -- ���� ���������
                                                                   inParentId       := vbMovementItemID, -- ������� ������
                                                                   inUnitId         := vbUnitId, -- �������������
                                                                   inAmount         := date_part('DAY',  inOperDate)::Integer, -- ���� ������
                                                                   inPayrollTypeID  := -1,
                                                                   inDateStart      := inDateStart, -- ���� ����� ������ �����
                                                                   inDateEnd        := inDateEnd, -- ���� ����� ����� �����
                                                                   inServiceExit    := inServiceExit,  -- ��������� �����
                                                                   inSession        := inSession);
      END IF;    
    ELSE  
        -- ������� ������ �� ���
      IF NOT EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementId = vbMovementID
                  AND MovementItem.DescId = zc_MI_Child()
                  AND MovementItem.ParentId = vbMovementItemID
                  AND MovementItem.Amount = date_part('DAY', inOperDate)::Integer)
      THEN

        PERFORM gpInsertUpdate_MovementItem_EmployeeSchedule_Child(ioId             := 0, -- ���� ������� <������� ���������>
                                                                   inMovementId     := vbMovementID, -- ���� ���������
                                                                   inParentId       := vbMovementItemID, -- ������� ������
                                                                   inUnitId         := vbUnitId, -- �������������
                                                                   inAmount         := date_part('DAY',  inOperDate)::Integer, -- ���� ������
                                                                   inPayrollTypeID  := -1,
                                                                   inDateStart      := inDateStart, -- ���� ����� ������ �����
                                                                   inDateEnd        := inDateEnd, -- ���� ����� ����� �����
                                                                   inServiceExit    := inServiceExit,  -- ��������� �����
                                                                   inSession        := inSession);
      ELSE
      
        SELECT MovementItem.id
             , MIDate_Start.ValueData
        INTO vbId, inDateStart
        FROM MovementItem
             LEFT JOIN MovementItemDate AS MIDate_Start
                                        ON MIDate_Start.MovementItemId = MovementItem.Id
                                       AND MIDate_Start.DescId = zc_MIDate_Start()
        WHERE MovementItem.MovementId = vbMovementID
          AND MovementItem.DescId = zc_MI_Child()
          AND MovementItem.ParentId = vbMovementItemID
          AND MovementItem.Amount = date_part('DAY', inOperDate)::Integer;

        PERFORM gpInsertUpdate_MovementItem_EmployeeSchedule_Child(ioId             := vbId, -- ���� ������� <������� ���������>
                                                                   inMovementId     := vbMovementID, -- ���� ���������
                                                                   inParentId       := vbMovementItemID, -- ������� ������
                                                                   inUnitId         := vbUnitId, -- �������������
                                                                   inAmount         := date_part('DAY',  inOperDate)::Integer, -- ���� ������
                                                                   inPayrollTypeID  := -1,
                                                                   inDateStart      := inDateStart, -- ���� ����� ������ �����
                                                                   inDateEnd        := inDateEnd, -- ���� ����� ����� �����
                                                                   inServiceExit    := inServiceExit,  -- ��������� �����
                                                                   inSession        := inSession);
      END IF;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
06.10.19                                                        *

*/