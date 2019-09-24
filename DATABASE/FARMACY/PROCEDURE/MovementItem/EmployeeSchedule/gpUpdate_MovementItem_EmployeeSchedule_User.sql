-- Function: gpUpdate_MovementItem_EmployeeSchedule_User()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_EmployeeSchedule_User(TDateTime, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MovementItem_EmployeeSchedule_User(TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MovementItem_EmployeeSchedule_User(TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_EmployeeSchedule_User(
    IN inOperDate            TDateTime,  -- ����
    IN inStartHour           TVarChar,   -- ��� �������
    IN inStartMin            TVarChar,   -- ������ �������
    IN inEndHour             TVarChar,   -- ��� �����
    IN inEndMin              TVarChar,   -- ������ �����
    IN inServiceExit         Boolean,    -- ������ �����
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

   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
   DECLARE vbDateStartOld TDateTime;
   DECLARE vbDateEndOld TDateTime;
   DECLARE vbServiceExitOld Boolean;
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

    IF inServiceExit = FALSE 
    THEN
      IF inStartHour  = '' OR inStartMin = '' OR inEndHour = '' OR inEndMin = ''
      THEN
        RAISE EXCEPTION '������. ������ ���� ��������� ����� ������� � �����.';
      END IF;
    ELSE 
      IF inStartHour <> '' OR inEndHour <> ''
      THEN
        RAISE EXCEPTION '������. ���� ������� � ����� ��� ���������� ������ ��������� ������.';
      END IF;
    END IF;

    SELECT Movement.ID
    INTO vbMovementID
    FROM Movement
    WHERE Movement.OperDate = date_trunc('month', inOperDate)
      AND Movement.DescId = zc_Movement_EmployeeSchedule();

    IF EXISTS(SELECT 1 FROM MovementItem
              WHERE MovementItem.MovementId = vbMovementID
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.ObjectId = vbUserId)
    THEN
      SELECT MovementItem.ID
      INTO vbMovementItemID
      FROM MovementItem
      WHERE MovementItem.MovementId = vbMovementID
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.ObjectId = vbUserId;
    ELSE
      -- ���������
      vbMovementItemID := lpInsertUpdate_MovementItem_EmployeeSchedule (ioId                  := 0                 -- ���� ������� <������� ���������>
                                                                      , inMovementId          := vbMovementID      -- ���� ���������
                                                                      , inPersonId            := vbUserId          -- ���������
                                                                      , inComingValueDay      := '0000000000000000000000000000000'::TVarChar      -- ������� �� ������ �� ����
                                                                      , inComingValueDayUser  := '0000000000000000000000000000000'::TVarChar      -- ������� �� ������ �� ����
                                                                      , inUserId              := vbUserId          -- ������������
                                                                       );

    END IF;
    
    IF inServiceExit = FALSE 
    THEN

      vbDateStart := date_trunc('DAY', inOperDate) + (inStartHour||':'||inStartMin)::Time;
      vbDateEnd := date_trunc('DAY', inOperDate) + (inEndHour||':'||inEndMin)::Time;
      
      IF vbDateStart > vbDateEnd
      THEN
        vbDateEnd := vbDateEnd + interval '1 day';
      END IF;
      
      IF date_part('minute',  vbDateStart) not in (0, 30) OR date_part('minute',  vbDateEnd) not in (0, 30)
      THEN
        RAISE EXCEPTION '������. ���� ������� � ����� ������ ���� ������ 30 ���.';
      END IF;
    ELSE
      vbDateStart := Null;
      vbDateEnd := Null;    
    END IF;
    
      -- ������� ������ �� ���
    IF EXISTS(SELECT 1 FROM MovementItem
              WHERE MovementItem.MovementId = vbMovementID
                AND MovementItem.DescId = zc_MI_Child()
                AND MovementItem.ParentId = vbMovementItemID
                AND MovementItem.Amount = date_part('DAY', inOperDate)::Integer)
    THEN
      SELECT MIDate_Start.ValueData
           , MIDate_End.ValueData
           , COALESCE(MIBoolean_ServiceExit.ValueData, FALSE)     
      INTO vbDateStartOld, vbDateEndOld, vbServiceExitOld
      FROM MovementItem

           LEFT JOIN MovementItemDate AS MIDate_Start
                                      ON MIDate_Start.MovementItemId = MovementItem.Id
                                     AND MIDate_Start.DescId = zc_MIDate_Start()

           LEFT JOIN MovementItemDate AS MIDate_End
                                      ON MIDate_End.MovementItemId = MovementItem.Id
                                     AND MIDate_End.DescId = zc_MIDate_End()

           LEFT JOIN MovementItemBoolean AS MIBoolean_ServiceExit
                                         ON MIBoolean_ServiceExit.MovementItemId = MovementItem.Id
                                        AND MIBoolean_ServiceExit.DescId = zc_MIBoolean_ServiceExit()

      WHERE MovementItem.MovementId = vbMovementID
        AND MovementItem.DescId = zc_MI_Child()
        AND MovementItem.ParentId = vbMovementItemID
        AND MovementItem.Amount = date_part('DAY',  inOperDate)::Integer;

      IF vbServiceExitOld = TRUE
      THEN
        RAISE EXCEPTION '������. ���� ������� ��� ��������� �����. ��������� ���������.';      
      ELSEIF vbDateStart <> vbDateStartOld
      THEN
        RAISE EXCEPTION '������. ��������� ������� ������� ���������.';
      END IF;

      PERFORM gpInsertUpdate_MovementItem_EmployeeSchedule_Child(ioId             := MovementItem.ID, -- ���� ������� <������� ���������>
                                                                 inMovementId     := vbMovementID, -- ���� ���������
                                                                 inParentId       := vbMovementItemID, -- ������� ������
                                                                 inUnitId         := vbUnitId, -- �������������
                                                                 inAmount         := date_part('DAY',  inOperDate)::Integer, -- ���� ������
                                                                 inPayrollTypeID  := -1,
                                                                 inDateStart      := vbDateStart,
                                                                 inDateEnd        := vbDateEnd,
                                                                 inServiceExit    := inServiceExit,
                                                                 inSession        := inSession)
      FROM MovementItem
      WHERE MovementItem.MovementId = vbMovementID
        AND MovementItem.DescId = zc_MI_Child()
        AND MovementItem.ParentId = vbMovementItemID
        AND MovementItem.Amount = date_part('DAY',  inOperDate)::Integer;
    ELSE
      PERFORM gpInsertUpdate_MovementItem_EmployeeSchedule_Child(ioId             := 0, -- ���� ������� <������� ���������>
                                                                 inMovementId     := vbMovementID, -- ���� ���������
                                                                 inParentId       := vbMovementItemID, -- ������� ������
                                                                 inUnitId         := vbUnitId, -- �������������
                                                                 inAmount         := date_part('DAY',  inOperDate)::Integer, -- ���� ������
                                                                 inPayrollTypeID  := -1,
                                                                 inDateStart      := vbDateStart, -- ���� ����� ������ �����
                                                                 inDateEnd        := vbDateEnd, -- ���� ����� ����� �����
                                                                 inServiceExit    := inServiceExit,  -- ��������� �����
                                                                 inSession        := inSession);

    END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (vbMovementItemID, vbUserId, False);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
23.09.19                                                        *
31.08.19                                                        *
22.05.19                                                        *
10.12.18                                                        *

*/
