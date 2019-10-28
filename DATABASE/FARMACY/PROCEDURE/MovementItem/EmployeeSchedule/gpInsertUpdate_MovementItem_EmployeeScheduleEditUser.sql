-- Function: gpInsertUpdate_MovementItem_EmployeeScheduleEditUser()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_EmployeeScheduleEditUser(INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_EmployeeScheduleEditUser(
 INOUT ioId                  Integer   , -- ���� ������� <������� ��������� �������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inParentID            Integer   , -- ���� ������� <������� ��������� ������>
    IN inDay                 Integer   , -- ����
    IN inUnitID              Integer   , -- �������������
    IN inPayrollTypeID       Integer   , -- ��� ���
    IN inTimeStart           TVarChar  , -- ����� �������
    IN inTimeEnd             TVarChar  , -- ����� �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbDate TDateTime;
   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
   DECLARE vbServiceExit Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    -- �������� ���� ������������ �� ����� ���������
    IF vbUserId NOT IN (3, 758920, 4183126, 9383066)
    THEN
      RAISE EXCEPTION '��������� <������ ������ �����������> ��� ���������.';
    END IF;

    IF COALESCE (inMovementId, 0) = 0 OR COALESCE (inParentID, 0) = 0
    THEN
        RAISE EXCEPTION '������. ������ �� ��������.';
    ELSE
      SELECT date_trunc('MONTH', Movement.OperDate)
      INTO vbDate
      FROM Movement
      WHERE Movement.Id = inMovementId;
    END IF;
    
    IF inPayrollTypeID >= 0 AND inTimeStart <> ''
    THEN
       vbDateStart := date_trunc('DAY', vbDate)::Date + ((inDay - 1)::TVarChar||' DAY')::interval + inTimeStart::Time;

      IF date_part('minute',  vbDateStart) not in (0, 30) 
      THEN
        RAISE EXCEPTION '������. ���� ������� � ����� ������ ���� ������ 30 ���.';
      END IF;
    ELSE
      vbDateStart := Null;
    END IF;

    IF inPayrollTypeID >= 0 AND inTimeEnd <> ''
    THEN
       vbDateEnd := date_trunc('DAY', vbDate)::Date + ((inDay - 1)::TVarChar||' DAY')::interval + inTimeEnd::Time;

      IF date_part('minute',  vbDateEnd) not in (0, 30)
      THEN
        RAISE EXCEPTION '������. ���� ������� � ����� ������ ���� ������ 30 ���.';
      END IF;
    ELSE
      vbDateEnd := Null;
    END IF;
      
    IF inPayrollTypeID >= 0 AND inTimeStart <> '' and inTimeEnd <> '' and vbDateStart > vbDateEnd
    THEN
      vbDateEnd := vbDateEnd + interval '1 day';
    END IF;
    
    IF inPayrollTypeID < 0
    THEN
      vbServiceExit := True;
      inPayrollTypeID := 0;
    ELSE
      vbServiceExit := False;    
    END IF;
    
    -- ���������
    ioId := lpInsertUpdate_MovementItem_EmployeeSchedule_Child (ioId                  := ioId                  -- ���� ������� <������� ���������>
                                                              , inMovementId          := inMovementId          -- ���� ���������
                                                              , inParentId            := inParentID            -- ������� ������
                                                              , inUnitID              := inUnitID              -- �������������
                                                              , inAmount              := inDay                 -- ����
                                                              , inPayrollTypeID       := inPayrollTypeID       -- ��� ���
                                                              , inDateStart           := vbDateStart           -- ������� �� ������ �� ����
                                                              , inDateEnd             := vbDateEnd             -- ������� �� ������ �� ����
                                                              , inServiceExit         := vbServiceExit         -- ��������� �����
                                                              , inUserId              := vbUserId              -- ������������
                                                                );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
05.09.19                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_EmployeeScheduleEditUser (, inSession:= '2')

