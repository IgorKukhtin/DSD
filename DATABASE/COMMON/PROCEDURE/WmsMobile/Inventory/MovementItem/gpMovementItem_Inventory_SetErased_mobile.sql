-- Function: gpMovementItem_Inventory_SetErased_mobile (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Inventory_SetErased_mobile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Inventory_SetErased_mobile(
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
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_ChoiceCell());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������������� ����� ��������
     outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�. 
 22.02.25                                        *
*/

-- ����
-- SELECT * FROM gpMovementItem_Inventory_SetErased_mobile (inMovementItemId:= 55, inSession:= '2')
