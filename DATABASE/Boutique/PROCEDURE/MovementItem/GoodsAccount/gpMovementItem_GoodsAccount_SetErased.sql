-- Function: gpMovementItem_GoodsAccount_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_GoodsAccount_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_GoodsAccount_SetErased(
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
  -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_GoodsAccount());
  vbUserId:= lpGetUserBySession (inSession);


  -- ������������� ����� ��������
  outIsErased := lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 18.05.17         *
*/

-- ����
-- SELECT * FROM gpMovementItem_GoodsAccount_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
