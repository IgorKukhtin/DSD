-- Function: gpMovementItem_ReturnInChild_SetUnErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_ReturnInChild_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_ReturnInChild_SetUnErased(
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
  vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetUnErased_MI_ReturnIn());

     --��������
     IF TRUE = COALESCE ( (SELECT MIBoolean_Calculated.ValueData
                           FROM MovementItemBoolean AS MIBoolean_Calculated
                           WHERE MIBoolean_Calculated.MovementItemId = inMovementItemId
                             AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                           ), FALSE)
     THEN 
          RAISE EXCEPTION '������.��������/�������������� ��������� - ������ � ��������������� .';
     END IF;
     
  -- ������������� ����� ��������
  outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.06.25         *

*/

-- ����
-- 