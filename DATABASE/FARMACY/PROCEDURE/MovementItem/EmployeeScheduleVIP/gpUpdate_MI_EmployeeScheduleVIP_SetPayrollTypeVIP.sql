-- Function: gpUpdate_MI_EmployeeScheduleVIP_SetPayrollTypeVIP()

DROP FUNCTION IF EXISTS gpUpdate_MI_EmployeeScheduleVIP_SetPayrollTypeVIP (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_EmployeeScheduleVIP_SetPayrollTypeVIP(
    IN inMovementId            Integer    , -- ���� ������� <�������� �������>
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EmployeeScheduleVIP());
    vbUserId := inSession;

    -- �������� ���� ������������ �� ����� ���������
    IF vbUserId NOT IN (3, 4183126, 235009)
    THEN
      RAISE EXCEPTION '��������� <������ ������ VIP ����������> ��� ���������.';
    END IF;

    PERFORM  lpInsertUpdate_MovementItem_EmployeeScheduleVIP_Child (ioId                  := MovementItem.Id
                                                                  , inMovementId          := MovementItem.MovementId
                                                                  , inParentId            := MovementItem.ParentId 
                                                                  , inAmount              := MovementItem.Amount  
                                                                  , inPayrollTypeVIPID    := CASE WHEN (date_part('HOURS', MIDate_End.ValueData) - date_part('HOURS', MIDate_Start.ValueData)) >= 10
                                                                                                  THEN zc_Enum_PayrollTypeVIP_WorkCS()
                                                                                                  ELSE zc_Enum_PayrollTypeVIP_WorkAS() END
                                                                  , inDateStart           := MIDate_Start.ValueData
                                                                  , inDateEnd             := MIDate_End.ValueData
                                                                  , inUserId              := vbUserId)
    FROM MovementItem

         LEFT JOIN ObjectString AS PayrollTypeVIP_ShortName
                                ON PayrollTypeVIP_ShortName.ObjectId = MovementItem.ObjectId
                               AND PayrollTypeVIP_ShortName.DescId = zc_ObjectString_PayrollTypeVIP_ShortName()

         LEFT JOIN MovementItemDate AS MIDate_Start
                                    ON MIDate_Start.MovementItemId = MovementItem.Id
                                   AND MIDate_Start.DescId = zc_MIDate_Start()

         LEFT JOIN MovementItemDate AS MIDate_End
                                    ON MIDate_End.MovementItemId = MovementItem.Id
                                   AND MIDate_End.DescId = zc_MIDate_End()
                                                            
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId = zc_MI_Child()
      AND COALESCE (PayrollTypeVIP_ShortName.ObjectId, 0) = 0
      AND COALESCE (MIDate_Start.MovementItemId, 0) <> 0
      AND COALESCE (MIDate_End.MovementItemId, 0) <> 0
      AND MIDate_Start.ValueData IS NOT NULL
      AND MIDate_End.ValueData IS NOT NULL
      AND date_trunc('DAY', MIDate_End.ValueData) = date_trunc('DAY', MIDate_Start.ValueData);
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.09.21                                                        *
*/

-- select * from gpUpdate_MI_EmployeeScheduleVIP_SetPayrollTypeVIP(inMovementId := 24861838 ,  inSession := '3');