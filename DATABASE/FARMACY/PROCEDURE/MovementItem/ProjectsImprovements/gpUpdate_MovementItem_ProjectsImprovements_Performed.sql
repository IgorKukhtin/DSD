-- Function: gpUpdate_MovementItem_ProjectsImprovements_Performed 

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_ProjectsImprovements_Performed (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_ProjectsImprovements_Performed(
    IN inId                  Integer              , -- ���� ������� <���������� ��������>
    IN inMovementId          Integer              , -- ���� ������� <��������>
    IN inisPerformed         Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)
  RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbUserId Integer;
BEGIN

  -- �������� ���� ������������ �� ����� ���������
  vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProjectsImprovements());
  
  IF COALESCE (inId, 0) = 0 OR COALESCE (inMovementId, 0) = 0 OR
     NOT EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.Id = inId AND MovementItem.MovementId = inMovementId)
  THEN
    RAISE EXCEPTION '�������� �� �������.';  
  END IF;
  
  IF  NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
  THEN
    RAISE EXCEPTION '� ��� ��� ���� ��������� <���������>.';    
  END IF;

  -- ���������� <������>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);

  -- �������� - �����������/��������� ��������� �������� ������
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  THEN
      RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- �������� - �����������/��������� ��������� �������� ������
  IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.Id = inId AND MovementItem.isErased = True)
  THEN
      RAISE EXCEPTION '������.��������� ��������� ��������� �� ��������.';
  END IF;

  -- �������� - �����������/��������� ��������� �������� ������
  IF COALESCE((SELECT MovementItemBoolean.ValueData FROM MovementItemBoolean 
               WHERE MovementItemBoolean.MovementItemId = inId AND MovementItemBoolean.DescId = zc_MIBoolean_ApprovedBy()), False) = False
  THEN
      RAISE EXCEPTION '������. ��������� �� ����������.';
  END IF;

  -- ����������� ������
  UPDATE MovementItem SET Amount = CASE WHEN inisPerformed THEN 0 ELSE 1 END WHERE Id = inId;

  -- ��������� ��������
  PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_MovementItem_ProjectsImprovements_Performed (Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.5.20                                                        *  
*/

-- ����
-- SELECT * FROM gpUpdate_MovementItem_ProjectsImprovements_Performed (inMovementId:= 55, inSession:= '2')
