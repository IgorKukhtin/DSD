-- Function: gpInsert_MovementItem_EmployeeScheduleAddUser_PayrollType ()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_EmployeeScheduleAddUser_PayrollType (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_EmployeeScheduleAddUser_PayrollType(
    IN inMovementId          Integer   , -- ���� ���������
    IN inParentId            Integer   , -- ������� ������
    IN inUserID              Integer   , -- ���������
    IN inUnitId              Integer   , -- �������������
    IN inPayrollTypeID       Integer   , -- ��� ����������
    IN inDateStart           TDateTime , -- ���� ����� ������ �����
    IN inDateEnd             TDateTime , -- ���� ����� ����� �����
    IN inSession             TVarChar   -- ������������
 )
RETURNS VOID AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbId       Integer;
   DECLARE vbAmount   Integer;
   DECLARE vbOperDate TDateTime;

BEGIN

    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION '��������� ������ ���������� ��������������';
    END IF;
   
    vbAmount := date_part('DAY', inDateStart);
    vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.ID = inMovementId);

    IF date_trunc('month', inDateStart) <> vbOperDate
    THEN
      RAISE EXCEPTION '������. ���� <%> �� ������ � ������ �������� ������� <%>.', inDateStart, vbOperDate;
    END IF;


    IF date_trunc('day', inDateStart) <> date_trunc('day', inDateEnd)
    THEN
      RAISE EXCEPTION '������. ���� ������� <%> � ����� <%> ������ ���� � ����� ���.', inDateStart, inDateEnd;
    END IF;

    -- ���� �� ������ ��� ���� zc_MI_Child()
    IF EXISTS(SELECT 1 FROM MovementItem
              WHERE MovementItem.MovementID = inMovementId
                AND MovementItem.DescId = zc_MI_Child()
                AND MovementItem.ObjectId = inUnitId
                AND MovementItem.ParentId = inParentId
                AND MovementItem.Amount = vbAmount)
    THEN
      RAISE EXCEPTION '������. � ��� �� ������������� ��� ���� ������.';
    END IF;

    -- ���������
    vbId := lpInsertUpdate_MovementItem_EmployeeSchedule_Child (ioId                  := 0                     -- ���� ������� <������� ���������>
                                                              , inMovementId          := inMovementId          -- ���� ���������
                                                              , inParentId            := inParentId
                                                              , inUnitId              := inUnitId
                                                              , inAmount              := vbAmount
                                                              , inPayrollTypeID       := inPayrollTypeID
                                                              , inDateStart           := inDateStart
                                                              , inDateEnd             := inDateEnd
                                                              , inServiceExit         := False
                                                              , inUserId              := vbUserId              -- ������������
                                                               );

--    RAISE EXCEPTION '������.';

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.09.19                                                        *
 31.09.19                                                        *
*/

-- ����
-- select * from gpInsert_MovementItem_EmployeeScheduleAddUser_PayrollType(inMovementId := 17692072 , inParentId := 363753684 , inUserID := 12198759 , inUnitID := 377574 , inPayrollTypeID := 14976313 , inDateStart := ('19.08.2020 15:00:00')::TDateTime , inDateEnd := ('19.08.2020 18:00:00')::TDateTime ,  inSession := '3');