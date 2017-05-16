-- Function: gpMovementItem_Sale_SetErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Sale_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Sale_SetErased(
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
  vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_Sale());

  -- ������������� ����� ��������
  outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_PersonalAccount_SetErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 09.10.14                                        * add lpSetErased_MovementItem
 02.04.14                                        * add zc_Enum_Role_Admin
 03.02.14                                                       *
*/

-- ����
-- SELECT * FROM gpMovementItem_Sale_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
