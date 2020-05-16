-- Function: gpUpdate_Movement_ProjectsImprovements_ApprovedBy 

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProjectsImprovements_ApprovedBy (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProjectsImprovements_ApprovedBy(
    IN inId                  Integer              , -- ���� ������� <��������>
    IN inisApprovedBy        Boolean              , -- ����� ��������
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
  
  IF COALESCE (inId, 0) = 0
  THEN
    RAISE EXCEPTION '�������� �� �������.';  
  END IF;
  
  IF  vbUserId <> 948223 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
  THEN
    RAISE EXCEPTION '� ��� ��� ���� ��������� <����������>.';    
  END IF;

  -- ���������� <������>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inId);

  -- �������� - �����������/��������� ��������� �������� ������
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  THEN
      RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- ��������� <���������>
  PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_ApprovedBy(), inId, NOT inisApprovedBy);

  -- ��������� ��������
  PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Movement_ProjectsImprovements_ApprovedBy (Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.5.20                                                        *  
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_ProjectsImprovements_ApprovedBy (inMovementId:= 55, inSession:= '2')
