-- Function: gpMovementItem_GoodsAccount_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_GoodsAccount_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_GoodsAccount_SetUnErased(
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
  -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetUnErased_MI_GoodsAccount());
  vbUserId:= lpGetUserBySession (inSession);

  -- ������������� ����� ��������
  outIsErased := lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.05.17         *
*/

-- ����
-- SELECT * FROM gpMovementItem_GoodsAccount_SetUnErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
