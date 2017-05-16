-- Function: gpMovementItem_ReturnIn_SetErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_ReturnIn_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_ReturnIn_SetErased(
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
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_ReturnIn());

  -- ������������� ����� ��������
  outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_ReturnIn_SetErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 02.04.14                                        * add zc_Enum_Role_Admin
 03.02.14                                                       *
*/

-- ����
-- SELECT * FROM gpMovementItem_ReturnIn_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
