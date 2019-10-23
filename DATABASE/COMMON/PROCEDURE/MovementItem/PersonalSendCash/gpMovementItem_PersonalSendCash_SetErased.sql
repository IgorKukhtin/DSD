-- Function: gpMovementItem_PersonalSendCash_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_PersonalSendCash_SetErased (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_PersonalSendCash_SetErased(
    IN inMovementId          Integer              , -- ���� ���������
    IN inPersonalId          Integer              , -- ���������
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)                              
  RETURNS Boolean
AS
$BODY$
   DECLARE vbStatusId Integer;
   DECLARE vbUserId Integer;
BEGIN
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_PersonalSendCash());

  -- ���������� <������>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
  -- �������� - �����������/��������� ��������� �������� ������
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  THEN
      RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- �������� - ��������� ��������� �������� ������
  -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= '���������');

  -- ������������� ����� ��������
  outIsErased := TRUE;

  -- ����������� ������ 
  UPDATE MovementItem SET isErased = TRUE
  WHERE MovementItem.MovementId = inMovementId
    AND MovementItem.ObjectId = inPersonalId
    AND MovementItem.DescId = zc_MI_Master();

  -- ��������� ��������
  PERFORM lpInsert_MovementItemProtocol (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId, inIsInsert:= FALSE, inIsErased:= TRUE)
  FROM MovementItem
  WHERE MovementItem.MovementId = inMovementId
    AND MovementItem.ObjectId = inPersonalId
    AND MovementItem.DescId = zc_MI_Master();

  -- ����������� �������� ����� �� ���������
  PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

  -- !!! �� ������� - ������ ���� ���������� ��������!!!
  -- outIsErased := FALSE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_PersonalSendCash_SetErased (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.11.13                                        * add lpInsertUpdate_MovementFloat_TotalSumm
 07.10.13                                        * add vbStatusId
 06.10.13                                        *
*/

-- ����
-- SELECT * FROM gpMovementItem_PersonalSendCash_SetErased (inMovementId:= 55, inPersonalId = 1, inSession:= '2')
