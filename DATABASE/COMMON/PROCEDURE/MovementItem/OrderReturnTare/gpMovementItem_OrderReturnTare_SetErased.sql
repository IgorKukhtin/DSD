-- Function: gpMovementItem_OrderReturnTare_SetErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_OrderReturnTare_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_OrderReturnTare_SetErased(
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
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_OrderReturnTare());

  -- ������������� ����� ��������
  outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.01.22         *
*/

-- ����
--