-- Function: gpInsertUpdate_MovementItem_EmployeeScheduleVIP()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_EmployeeScheduleVIP(INTEGER, INTEGER, INTEGER, TVarChar, TVarChar, TVarChar, INTEGER, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_EmployeeScheduleVIP(
 INOUT ioId                  Integer   , -- ���� ������� <������� ��������� ������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUserId              Integer   , -- ���������
 INOUT ioValue               TVarChar  , -- ��� ���
 INOUT ioValueStart          TVarChar  , -- ����� �������
 INOUT ioValueEnd            TVarChar  , -- ����� �����
 INOUT ioTypeId              Integer   , -- ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbChildId Integer;

   DECLARE vbDate TDateTime;
   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
   DECLARE vbPayrollTypeVIP Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    -- �������� ���� ������������ �� ����� ���������
    IF vbUserId NOT IN (3, 4183126, 235009)
    THEN
      RAISE EXCEPTION '��������� <������ ������ �����������> ��� ���������.';
    END IF;

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������. ������ �� ��������.';
    ELSE
      SELECT date_trunc('MONTH', Movement.OperDate)
      INTO vbDate
      FROM Movement
      WHERE Movement.Id = inMovementId;
    END IF;
    
    IF COALESCE (ioId, 0) = 0 
       AND EXISTS(SELECT ID FROM MovementItem
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.ObjectId = inUserId
                    AND MovementItem.DescId = zc_MI_Master())
    THEN
      RAISE EXCEPTION '��������� �������� ������� �� ���������� ���������.';    
    END IF;

    IF ioValueStart <> ''
    THEN
      vbDateStart := date_trunc('DAY', vbDate)::Date + ((ioTypeId - 1)::TVarChar||' DAY')::interval + ioValueStart::Time;

      IF date_part('minute',  vbDateStart) not in (0, 30) 
      THEN
        RAISE EXCEPTION '������. ���� ������� � ����� ������ ���� ������ 30 ���.';
      END IF;
    ELSE
      vbDateStart := Null;
    END IF;

    IF ioValueEnd <> ''
    THEN
      vbDateEnd := date_trunc('DAY', vbDate)::Date + ((ioTypeId - 1)::TVarChar||' DAY')::interval + ioValueEnd::Time;

      IF date_part('minute',  vbDateEnd) not in (0, 30)
      THEN
        RAISE EXCEPTION '������. ���� ������� � ����� ������ ���� ������ 30 ���.';
      END IF;
    ELSE
      vbDateEnd := Null;
    END IF;
      
    IF ioValueStart <> '' and ioValueEnd <> '' and vbDateStart > vbDateEnd
    THEN
      RAISE EXCEPTION '������. ����� ������� ������ ���� ������ ���� �����.';
--      vbDateEnd := vbDateEnd + interval '1 day';
    END IF;
    
    -- ��������� ������ ���� ����
    IF COALESCE(ioId, 0) = 0 
    THEN
      ioId := lpInsertUpdate_MovementItem_EmployeeScheduleVIP (ioId                  := ioId                  -- ���� ������� <������� �������>
                                                             , inMovementId          := inMovementId          -- ���� ���������
                                                             , inPersonId            := inUserId              -- ���������
                                                             , inUserId              := vbUserId              -- ������������
                                                               );
    END IF;
    
    IF EXISTS(SELECT ID
              FROM MovementItem
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.ParentID = ioId
                AND MovementItem.Amount = ioTypeId
                AND MovementItem.DescId = zc_MI_Child())
    THEN
       SELECT ID
       INTO vbChildId
       FROM MovementItem
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.ParentID = ioId
         AND MovementItem.Amount = ioTypeId
         AND MovementItem.DescId = zc_MI_Child();
    END IF;

    IF ioValue <> '' AND 
       EXISTS(SELECT ValueData FROM ObjectString AS PayrollTypeVIP_ShortName
              WHERE PayrollTypeVIP_ShortName.ValueData = ioValue
                AND PayrollTypeVIP_ShortName.DescId = zc_ObjectString_PayrollTypeVIP_ShortName())
    THEN
      SELECT ObjectId 
      INTO vbPayrollTypeVIP
      FROM ObjectString AS PayrollTypeVIP_ShortName
      WHERE PayrollTypeVIP_ShortName.ValueData = ioValue
        AND PayrollTypeVIP_ShortName.DescId = zc_ObjectString_PayrollTypeVIP_ShortName();
    ELSE
      vbPayrollTypeVIP := 0;
    END IF;
            
    -- ���������
    vbChildId := lpInsertUpdate_MovementItem_EmployeeScheduleVIP_Child (ioId                  := vbChildId            -- ���� ������� <������� ���������>
                                                                      , inMovementId          := inMovementId          -- ���� ���������
                                                                      , inParentId            := ioId                  -- ������� ������
                                                                      , inAmount              := ioTypeId              -- ����
                                                                      , inPayrollTypeVIPID    := vbPayrollTypeVIP         -- ��� ���
                                                                      , inDateStart           := vbDateStart           -- ������� �� ������ �� ����
                                                                      , inDateEnd             := vbDateEnd             -- ������� �� ������ �� ����
                                                                      , inUserId              := vbUserId              -- ������������
                                                                       );

    --
    IF ioTypeId > 0
    THEN
       SELECT PayrollTypeVIP_ShortName.ValueData                     AS PThortName
            , TO_CHAR(MIDate_Start.ValueData, 'HH24:mi')             AS TimeStart
            , TO_CHAR(MIDate_End.ValueData, 'HH24:mi')               AS TimeEnd
       INTO ioValue, ioValueStart, ioValueEnd 

       FROM  MovementItem AS MIChild

            LEFT JOIN ObjectString AS PayrollTypeVIP_ShortName
                                   ON PayrollTypeVIP_ShortName.ObjectId = MIChild.ObjectId
                                  AND PayrollTypeVIP_ShortName.DescId = zc_ObjectString_PayrollTypeVIP_ShortName()

            LEFT JOIN MovementItemDate AS MIDate_Start
                                       ON MIDate_Start.MovementItemId = MIChild.Id
                                      AND MIDate_Start.DescId = zc_MIDate_Start()

            LEFT JOIN MovementItemDate AS MIDate_End
                                       ON MIDate_End.MovementItemId = MIChild.Id
                                      AND MIDate_End.DescId = zc_MIDate_End()

            LEFT JOIN MovementItemBoolean AS MIBoolean_ServiceExit
                                          ON MIBoolean_ServiceExit.MovementItemId = MIChild.Id
                                         AND MIBoolean_ServiceExit.DescId = zc_MIBoolean_ServiceExit()

       WHERE MIChild.ID = vbChildId;
    END IF;

    -- RAISE EXCEPTION '������. � ���������� % % % % %', vbChildId, ioTypeId, vbPayrollTypeVIP, vbDateStart, vbDateEnd;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
16.09.21                                                        *
*/

-- ����
-- select * from gpInsertUpdate_MovementItem_EmployeeScheduleVIP(ioId := 0 , inMovementId := 24861838 , inUserID := 2431210 , ioValue := '' , ioValueStart := '08:10:00' , ioValueEnd := '' , ioTypeId := 12 ,  inSession := '3');