-- Function: gpMovementItem_Send_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Send_SetUnErased_Child (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Send_SetUnErased_Child(
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
  --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_Send());
  vbUserId := lpGetUserBySession (inSession);

  -- ������������� ����� ��������
  outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.06.21         *
*/

-- ����
--