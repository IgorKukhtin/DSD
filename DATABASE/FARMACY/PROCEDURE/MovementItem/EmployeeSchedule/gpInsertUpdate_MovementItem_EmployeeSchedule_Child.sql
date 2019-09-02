-- Function: gpInsertUpdate_MovementItem_EmployeeSchedule_Child ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_EmployeeSchedule_Child (Integer, Integer, Integer, Integer, TFloat, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_EmployeeSchedule_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inParentId            Integer   , -- ������� ������
    IN inUnitId              Integer   , -- �������������
    IN inAmount              TFloat    , -- ����� ���������
    IN inPayrollTypeID       Integer   , -- ��� ����������
    IN inDateStart           TDateTime , -- ���� ����� ������ �����
    IN inDateEnd             TDateTime , -- ���� ����� ����� �����
    IN inSession             TVarChar   -- ������������
 )
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN

    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    -- ���� ��������� zc_MI_Child() 
    IF COALESCE (ioId, 0) = 0
    THEN
      IF EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.DescId = zc_MI_Child()
                  AND MovementItem.ParentId = inParentId
                  AND MovementItem.Amount = inAmount)
      THEN
        SELECT MIN(MovementItem.ID)
        INTO ioId
        FROM MovementItem
        WHERE MovementItem.MovementID = inMovementId
          AND MovementItem.DescId = zc_MI_Child()
          AND MovementItem.ParentId = inParentId
          AND MovementItem.Amount = inAmount;
      END IF;
    END IF;

    -- ���������
    ioId := lpInsertUpdate_MovementItem_EmployeeSchedule_Child (ioId                  := ioId                  -- ���� ������� <������� ���������>
                                                              , inMovementId          := inMovementId          -- ���� ���������
                                                              , inParentId            := inParentId
                                                              , inUnitId              := inUnitId
                                                              , inAmount              := inAmount
                                                              , inPayrollTypeID       := inPayrollTypeID
                                                              , inDateStart           := inDateStart
                                                              , inDateEnd             := inDateEnd
                                                              , inUserId              := vbUserId              -- ������������
                                                               );

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 31.09.19                                                        *
*/

-- ����
-- 