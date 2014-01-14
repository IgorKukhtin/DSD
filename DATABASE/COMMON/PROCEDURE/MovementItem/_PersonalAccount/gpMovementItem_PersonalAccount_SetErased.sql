-- Function: gpMovementItem_PersonalAccount_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_PersonalAccount_SetErased (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_PersonalAccount_SetErased(
    IN inMovementId          Integer              , -- ���� ���������
    IN inJuridicalId         Integer              , -- ��.����
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)                              
  RETURNS Boolean
AS
$BODY$
  DECLARE vbStatusId Integer;
BEGIN
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_SetErased_MovementItem());

  -- ���������� <������>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
  -- �������� - �����������/��������� ��������� �������� ������
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  THEN
      RAISE EXCEPTION '������.��������� ��������� � ������� <"%"> �� ��������.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- �������� - ��������� ��������� �������� ������
  -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= '���������');

  -- ������������� ����� ��������
  outIsErased := TRUE;

  -- ����������� ������ 
  UPDATE MovementItem SET isErased = outIsErased
  WHERE MovementItem.MovementId = inMovementId
    AND MovementItem.ObjectId = inJuridicalId
    AND MovementItem.DescId = zc_MI_Master();

  -- ����������� �������� ����� �� ���������
  PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

  -- !!! �� ������� - ������ ���� ���������� ��������!!!
  -- outIsErased := FALSE;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_PersonalAccount_SetErased (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 19.12.13         *
*/

-- ����
-- SELECT * FROM gpMovementItem_PersonalAccount_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
