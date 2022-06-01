-- Function: gpMovementItem_ServiceItem_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_ServiceItem_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_ServiceItem_SetUnErased(
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
  vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetUnErased_MI_ServiceItem());

  -- ������������� ����� ��������
  outIsErased := lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.06.22         *
*/

-- ����
-- SELECT * FROM gpMovementItem_ServiceItem_SetUnErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
