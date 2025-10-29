-- Function: gpMovementItem_Inventory_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Inventory_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Inventory_SetErased(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_Inventory());


  -- !!!�������� - �������������� - ������ �� ��������� (��������� ������ ����������)!!!
  IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11109744)
  THEN
       RAISE EXCEPTION '������.��� ����.';
  END IF;


  -- ������������� ����� ��������
  outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 01.09.14                                                       *
*/

-- ����
-- SELECT * FROM gpMovementItem_Inventory_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
