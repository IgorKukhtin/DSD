-- Function: gpMovementItem_AsinoPharmaSP_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_AsinoPharmaSP_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_AsinoPharmaSP_SetErased(
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
  outIsErased := TRUE;

  -- ����������� ������
  UPDATE MovementItem SET isErased = TRUE WHERE Id = inMovementItemId
         RETURNING MovementId INTO vbMovementId;

  vbQueue := (SELECT MovementItem.Amount
              FROM MovementItem
              WHERE MovementItem.DescId = zc_MI_Master()
                AND MovementItem.MovementId = vbMovementId
                AND MovementItem.Id = inMovementItemId)::Integer;

  -- ���������� <������>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
  -- �������� - �����������/��������� ��������� �������� ������
  IF vbStatusId <> zc_Enum_Status_UnComplete() AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
  THEN
      RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
  END IF;
  
  -- ���� ���� ����������������
  IF EXISTS(SELECT 1
            FROM MovementItem
            WHERE MovementItem.DescId = zc_MI_Master()
              AND MovementItem.MovementId = vbMovementId
              AND MovementItem.Amount > vbQueue
              AND MovementItem.isErased = FALSE) 
  THEN
    
    PERFORM lpInsertUpdate_MovementItem_AsinoPharmaSP (ioId                  := MovementItem.Id
                                                     , inMovementId          := vbMovementId
                                                     , inQueue               := (MovementItem.Amount - 1)::Integer
                                                     , inUserId              := vbUserId)
    FROM MovementItem
    WHERE MovementItem.DescId = zc_MI_Master()
      AND MovementItem.MovementId = vbMovementId
      AND MovementItem.Amount > vbQueue
      AND MovementItem.isErased = FALSE;
  END IF;  

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
-- SELECT * FROM gpMovementItem_AsinoPharmaSP_SetErased (inMovementItemId:= 55, inSession:= '3')