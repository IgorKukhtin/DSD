-- Function: gpInsertUpdate_MovementItem_AsinoPharmaSP()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_AsinoPharmaSP (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_AsinoPharmaSP(
 INOUT ioId                   Integer   , -- ���� ������
    IN inMovementId           Integer   ,
 INOUT ioQueue                Integer   , -- �����������
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbQueue Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

    -- �������� - �����������/��������� ��������� �������� ������
    IF (SELECT StatusId FROM Movement WHERE Id = inMovementId) <> zc_Enum_Status_UnComplete()
    THEN
      RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;
  
    -- �������� - �����������/��������� ��������� �������� ������
    IF EXISTS(SELECT 1
              FROM MovementItem
              WHERE MovementItem.DescId = zc_MI_Master()
                AND MovementItem.MovementId = inMovementId
                AND MovementItem.Id = ioId
                AND MovementItem.isErased <> FALSE) 
    THEN
      RAISE EXCEPTION '������.��������� ��������� ����� �� ��������.';
    END IF;
      
    IF COALESCE(ioId, 0) = 0
    THEN
      IF COALESCE(ioQueue, 0) < 0
      THEN
        RAISE EXCEPTION '������� ������ ���� ������ ��� ����� 0';
      END IF;
      
      vbQueue := COALESCE((SELECT count(*)
                           FROM MovementItem
                           WHERE MovementItem.DescId = zc_MI_Master()
                             AND MovementItem.MovementId = inMovementId
                             AND MovementItem.isErased = FALSE), 0)::Integer + 1;
    ELSE
      IF COALESCE(ioQueue, 0) <= 0
      THEN
        RAISE EXCEPTION '������� ������ ���� ������ 0';
      END IF;    
      
      vbQueue := (SELECT MovementItem.Amount
                  FROM MovementItem
                  WHERE MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.MovementId = inMovementId
                    AND MovementItem.Id = ioId)::Integer;
    END IF;
    
    IF COALESCE(ioQueue, 0) = 0
    THEN
      ioQueue := COALESCE((SELECT count(*)
                           FROM MovementItem
                           WHERE MovementItem.DescId = zc_MI_Master()
                             AND MovementItem.MovementId = inMovementId
                             AND MovementItem.isErased = FALSE), 0)::Integer + 1;
    ELSEIF ioQueue > COALESCE((SELECT count(*)
                               FROM MovementItem
                               WHERE MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.MovementId = inMovementId
                                 AND MovementItem.isErased = FALSE), 0)::Integer + 1
    THEN
        ioQueue := COALESCE((SELECT count(*)
                             FROM MovementItem
                             WHERE MovementItem.DescId = zc_MI_Master()
                               AND MovementItem.MovementId = inMovementId
                               AND MovementItem.isErased = FALSE), 0)::Integer + 1;
    END IF;
        
    -- ���� ���� ����������������
    IF EXISTS(SELECT 1
              FROM MovementItem
              WHERE MovementItem.DescId = zc_MI_Master()
                AND MovementItem.MovementId = inMovementId
                AND MovementItem.Amount > vbQueue
                AND MovementItem.isErased = FALSE) 
    THEN
    
      PERFORM lpInsertUpdate_MovementItem_AsinoPharmaSP (ioId                  := MovementItem.Id
                                                       , inMovementId          := inMovementId
                                                       , inQueue               := (MovementItem.Amount - 1)::Integer
                                                       , inUserId              := vbUserId)
      FROM MovementItem
      WHERE MovementItem.DescId = zc_MI_Master()
        AND MovementItem.MovementId = inMovementId
        AND MovementItem.Amount > vbQueue
        AND MovementItem.isErased = FALSE;
    END IF;

    IF EXISTS(SELECT 1
              FROM MovementItem
              WHERE MovementItem.DescId = zc_MI_Master()
                AND MovementItem.MovementId = inMovementId
                AND MovementItem.Amount >= ioQueue
                AND MovementItem.isErased = FALSE) 
    THEN
    
      PERFORM lpInsertUpdate_MovementItem_AsinoPharmaSP (ioId                  := MovementItem.Id
                                                       , inMovementId          := inMovementId
                                                       , inQueue               := (MovementItem.Amount + 1)::Integer
                                                       , inUserId              := vbUserId)
      FROM MovementItem
      WHERE MovementItem.DescId = zc_MI_Master()
        AND MovementItem.MovementId = inMovementId
        AND MovementItem.Amount >= ioQueue
        AND MovementItem.isErased = FALSE;
    END IF;
    
    
    -- ��������� ������
    ioId := lpInsertUpdate_MovementItem_AsinoPharmaSP (ioId                  := COALESCE(ioId,0)
                                                     , inMovementId          := inMovementId
                                                     , inQueue               := ioQueue
                                                     , inUserId              := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.02.23                                                       *
*/
--