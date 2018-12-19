-- Function: gpMovementItem_Send_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Send_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Send_SetErased(
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
   DECLARE vbUnitId Integer;
   DECLARE vbFromId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
BEGIN
  --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_Send());
  vbUserId := inSession;
  -- ������������� ����� ��������
  outIsErased := TRUE;

  -- ����������� ������
  UPDATE MovementItem SET isErased = TRUE WHERE Id = inMovementItemId
         RETURNING MovementId INTO vbMovementId;

  -- �������� - ��������� ��������� �������� ������
  -- PERFORM lfCheck_Movement_Parent (inMovementId:= vbMovementId, inComment:= '���������');

  IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
            WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- ��� ���� "������ ������"
  THEN
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
      vbUnitKey := '0';
    END IF;
    vbUserUnitId := vbUnitKey::Integer;
        
    IF COALESCE (vbUserUnitId, 0) = 0
    THEN 
      RAISE EXCEPTION '������. �� ������� ������������� ����������.';     
    END IF;     

    --���������� ������������� ����������
    SELECT MovementLinkObject_To.ObjectId AS UnitId
           INTO vbUnitId
    FROM MovementLinkObject AS MovementLinkObject_To
    WHERE MovementLinkObject_To.MovementId = vbMovementId
      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To();

    --���������� ������������� �����������
    SELECT MovementLinkObject_From.ObjectId AS vbFromId
           INTO vbFromId
    FROM MovementLinkObject AS MovementLinkObject_From
    WHERE MovementLinkObject_From.MovementId = vbMovementId
      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From();
       
    IF COALESCE (vbFromId, 0) <> COALESCE (vbUserUnitId, 0) AND COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0) 
    THEN 
      RAISE EXCEPTION '������. ��� ��������� �������� ������ � �������������� <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
    END IF;     
  END IF;     

  -- ���������� <������>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
  -- �������� - �����������/��������� ��������� �������� ������
  IF vbStatusId <> zc_Enum_Status_UnComplete() AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
  THEN
      RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- ����������� �������� ����� �� ���������
  PERFORM lpInsertUpdate_MovementFloat_TotalSummSend (vbMovementId);

  -- !!! �� ������� - ������ ���� ���������� ��������!!!
  -- outIsErased := FALSE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_Send_SetErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.  ��������� �.�.  ������ �.�.
 19.12.18                                                                                    *  
 29.07.15                                                                    *
*/

-- ����
-- SELECT * FROM gpMovementItem_Send_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
