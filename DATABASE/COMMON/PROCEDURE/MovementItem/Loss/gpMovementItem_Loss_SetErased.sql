-- Function: gpMovementItem_Loss_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Loss_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Loss_SetErased(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_Loss());

  -- ������������� ����� ��������
  outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 23.05.14                                                       *
*/

-- ����
-- SELECT * FROM gpMovementItem_Loss_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
