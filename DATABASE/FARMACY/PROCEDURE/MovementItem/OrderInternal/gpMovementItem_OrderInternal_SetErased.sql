-- Function: gpMovementItem_OrderInternal_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_OrderInternal_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_OrderInternal_SetErased(
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
BEGIN
--  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_OrderInternal());
vbUserId := inSession;
  -- ������������� ����� ��������
  outIsErased := TRUE;

  -- ����������� ������
  UPDATE MovementItem SET isErased = TRUE WHERE Id = inMovementItemId
         RETURNING MovementId INTO vbMovementId;

  -- �������� - ��������� ��������� �������� ������
  -- PERFORM lfCheck_Movement_Parent (inMovementId:= vbMovementId, inComment:= '���������');

  -- ���������� <������>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
  -- �������� - �����������/��������� ��������� �������� ������
  IF vbStatusId <> zc_Enum_Status_UnComplete() AND (NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     OR inSession = '3')
  THEN
      RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- ����������� �������� ����� �� ���������
  PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_OrderInternal_SetErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 03.07.14                                                       *
*/

-- ����
-- SELECT * FROM gpMovementItem_OrderInternal_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
