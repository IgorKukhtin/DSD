-- Function: gpMovementItem_OrderExternal_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_OrderExternal_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_OrderExternal_SetErased(
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
  vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_OrderExternal());

  -- ������������� ����� ��������
  outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_OrderExternal_SetErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 06.06.14                                                       *
*/

-- ����
-- SELECT * FROM gpMovementItem_OrderExternal_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
