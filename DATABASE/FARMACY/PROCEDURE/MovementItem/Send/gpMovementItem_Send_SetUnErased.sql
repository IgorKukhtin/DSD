-- Function: gpMovementItem_Send_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Send_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Send_SetUnErased(
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
   DECLARE vbisSUN         Boolean;
BEGIN
  --vbUserId := lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_Send());
  vbUserId := inSession;
  -- ������������� ����� ��������
  outIsErased := FALSE;

  -- ����������� ������
  UPDATE MovementItem SET isErased = FALSE WHERE Id = inMovementItemId
         RETURNING MovementId INTO vbMovementId;

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
    SELECT MovementLinkObject_To.ObjectId                               AS UnitId
         , MovementLinkObject_From.ObjectId                             AS FromId
         , COALESCE (MovementBoolean_SUN.ValueData, FALSE)::Boolean     AS isSUN
    INTO vbUnitId, vbFromId, vbisSUN
    FROM Movement 
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
    
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
    
          LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()

    WHERE Movement.Id = inMovementId;
     
    IF vbisSUN = TRUE 
    THEN
      RAISE EXCEPTION '������. � ����������� �� ��� ������ �������� ������ ��� ���������.';    
    END IF;
       
    IF COALESCE (vbFromId, 0) <> COALESCE (vbUserUnitId, 0) AND COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0) 
    THEN 
      RAISE EXCEPTION '������. ��� ��������� �������� ������ � �������������� <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
    END IF;     
  END IF;     

  -- �������� - ��������� ��������� �������� ������
  -- PERFORM lfCheck_Movement_Parent (inMovementId:= vbMovementId, inComment:= '���������');

  -- ���������� <������>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
  -- �������� - �����������/��������� ��������� �������� ������
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  THEN
      RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- ����������� �������� ����� �� ���������
  PERFORM lpInsertUpdate_MovementFloat_TotalSummSend (vbMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_Send_SetUnErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.  ��������� �.�.  ������ �.�.
 19.12.18                                                                                    *  
 29.07.15                                                                      *
*/

-- ����
-- SELECT * FROM gpMovementItem_Send_SetUnErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
