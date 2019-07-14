-- Function: gpMovementItem_SendOnPrice_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_SendOnPrice_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_SendOnPrice_SetUnErased(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_SendOnPrice());

  -- ������������� ����� ��������
  outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 05.05.14                                                       *
*/

-- ����
-- SELECT * FROM gpMovementItem_SendOnPrice_SetUnErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
