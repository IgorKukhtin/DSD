-- Function: gpInsertUpdate_MovementItem_Wages_Child ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Wages_Child (Integer, Integer, Integer, Boolean, Integer, TFloat, TDateTime, TFloat, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Wages_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inParentId            Integer   , -- ������� ������
    IN inAuto                Boolean   , -- ���� ������
    IN inUnitId              Integer   , -- �������������
    IN inAmount              TFloat    , -- ����� ���������
    IN inDateCalculation     TDateTime , -- ���� �������
    IN inSummaBase           TFloat    , -- ����� ����
    IN inPayrollTypeID       Integer   , -- ��� ����������
    IN inComment             TVarChar  , -- ��������
    IN inSession             TVarChar   -- ������������
 )
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    -- ���� ��������� zc_MI_Child() 
    IF COALESCE (ioId, 0) = 0
    THEN
      IF EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.DescId = zc_MI_Child()
                  AND MovementItem.ParentId = inParentId
                  AND MovementItem.isErased = TRUE)
      THEN
        SELECT MIN(MovementItem.ID)
        INTO ioId
        FROM MovementItem
        WHERE MovementItem.MovementID = inMovementId
          AND MovementItem.DescId = zc_MI_Child()
          AND MovementItem.ParentId = inParentId
          AND MovementItem.isErased = TRUE;
          
        UPDATE MovementItem SET isErased = FALSE WHERE ID = ioId;
      END IF;
    END IF;

    -- ���������
    ioId := lpInsertUpdate_MovementItem_Wages_Child (ioId                  := ioId                  -- ���� ������� <������� ���������>
                                                   , inMovementId          := inMovementId          -- ���� ���������
                                                   , inParentId            := inParentId
                                                   , inAuto                := inAuto
                                                   , inUnitId              := inUnitId
                                                   , inAmount              := inAmount
                                                   , inDateCalculation     := inDateCalculation
                                                   , inSummaBase           := inSummaBase
                                                   , inPayrollTypeID       := inPayrollTypeID
                                                   , inComment             := inComment              
                                                   , inUserId              := vbUserId              -- ������������
                                                    );

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.08.19                                                        *
*/

-- ����
-- 