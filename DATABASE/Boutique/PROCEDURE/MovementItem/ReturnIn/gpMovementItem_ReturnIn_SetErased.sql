-- Function: gpMovementItem_ReturnIn_SetErased (Integer, Integer, TVarChar)

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
  -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_ReturnIn());
  vbUserId:= lpGetUserBySession (inSession);


  -- ������������� ����� ��������
  outIsErased := lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 09.05.17         *
*/

-- ����
-- SELECT * FROM gpMovementItem_ReturnIn_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
