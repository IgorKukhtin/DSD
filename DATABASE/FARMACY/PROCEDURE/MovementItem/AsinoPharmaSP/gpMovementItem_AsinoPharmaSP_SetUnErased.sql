-- Function: gpMovementItem_AsinoPharmaSP_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_AsinoPharmaSP_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_AsinoPharmaSP_SetUnErased(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbQueue Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
  
  -- ������������� ����� ��������
  outIsErased := FALSE;

  -- ����������� ������
  UPDATE MovementItem SET isErased = FALSE WHERE Id = inMovementItemId
         RETURNING MovementId INTO vbMovementId;

  -- ���������� <������>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
  -- �������� - �����������/��������� ��������� �������� ������
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  THEN
      RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
  END IF;
  
  vbQueue := COALESCE((SELECT count(*)
                       FROM MovementItem
                       WHERE MovementItem.DescId = zc_MI_Master()
                         AND MovementItem.MovementId = vbMovementId
                         AND MovementItem.isErased = FALSE), 0)::Integer;  

  PERFORM lpInsertUpdate_MovementItem_AsinoPharmaSP (ioId                  := MovementItem.Id
                                                   , inMovementId          := vbMovementId
                                                   , inQueue               := vbQueue
                                                   , inUserId              := vbUserId)
  FROM MovementItem
  WHERE MovementItem.DescId = zc_MI_Master()
    AND MovementItem.MovementId = vbMovementId
    AND MovementItem.Id = inMovementItemId
    AND MovementItem.isErased = FALSE;

  -- ����������� �������� ����� �� ���������
  --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.02.23                                                       *
*/

-- ����
-- SELECT * FROM gpMovementItem_AsinoPharmaSP_SetUnErased (inMovementId:= 55, inSession:= '2')