-- Function: gpMovementItem_OrderInternal_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_OrderInternal_SetUnErased_Detail (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_OrderInternal_SetUnErased_Detail(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_OrderInternal());
     vbUserId := lpGetUserBySession (inSession);

     -- ������������� ����� ��������
     outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.12.22         *
*/

-- ����
--